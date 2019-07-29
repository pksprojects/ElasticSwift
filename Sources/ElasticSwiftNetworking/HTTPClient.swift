//
//  File.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/16/19.
//

import Foundation
import NIO
import NIOHTTP1
#if canImport(NIOSSL)
import NIOSSL
#endif
import Logging
import ElasticSwiftCore

// MARK:- HTTPCLIENT

public class HTTPClient {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwift.Networking.HTTPClient")
    
    private let eventLoopGroup: EventLoopGroup
    private let hostURL: URL
    private let configuration: HTTPClientConfiguration
    #if canImport(NIOSSL)
    private let sslContext: NIOSSLContext?
    #endif
    private let timeouts: Timeouts?
    
    init(forHost host: URL, configuration: HTTPClientConfiguration) {
        
        switch configuration.eventLoopProvider {
            case .create(let threads):
                self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: threads)
            case .share(let eventLoopGroup):
                self.eventLoopGroup = eventLoopGroup
        }
        self.hostURL = host
        self.configuration = configuration
        #if canImport(NIOSSL)
        self.sslContext = configuration.sslContext
        #endif
        self.timeouts = configuration.timeouts
    }
    
    public func execute(request: HTTPRequest) -> EventLoopFuture<[HTTPClientResponsePart]> {
        let promise = self.eventLoopGroup.next().makePromise(of: [HTTPClientResponsePart].self)
        #if canImport(NIOSSL)
        let bootstrap: ClientBootstrap
        if let sslContext = self.sslContext {
            bootstrap = ClientBootstrap(group: eventLoopGroup)
                .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
                .channelInitializer { channel in
                    let openSslHandler = try! NIOSSLClientHandler(context: sslContext, serverHostname: self.hostURL.host)
                    return channel.pipeline.addHandler(openSslHandler).flatMap {
                        channel.pipeline.addHTTPClientHandlers()
                        }.flatMap {
                            channel.pipeline.addHandler(HTTPChannelHandler(for: request, promise: promise))
                    }
            }
        } else {
            bootstrap = ClientBootstrap(group: self.eventLoopGroup)
                .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
                .channelInitializer { channel in
                    channel.pipeline.addHTTPClientHandlers()
                        .flatMap {
                            channel.pipeline.addHandler(HTTPChannelHandler(for: request, promise: promise))
                        }.flatMap {
                            if let readTimeout = self.timeouts?.read {
                                return channel.pipeline.addHandler(IdleStateHandler(readTimeout: readTimeout))
                            } else {
                                return channel.eventLoop.makeSucceededFuture(())
                            }
                    }
            }
        }
        #else
        let bootstrap = ClientBootstrap(group: self.eventLoopGroup)
            .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .channelInitializer { channel in
                channel.pipeline.addHTTPClientHandlers()
                    .flatMap {
                        channel.pipeline.addHandler(HTTPChannelHandler(for: request, promise: promise))
                }.flatMap {
                    if let readTimeout = self.timeouts?.read {
                        return channel.pipeline.addHandler(IdleStateHandler(readTimeout: readTimeout))
                    } else {
                        return channel.eventLoop.makeSucceededFuture(())
                    }
                }
        }
        #endif
        if let connectTimeout = self.timeouts?.connect {
            _ = bootstrap.connectTimeout(connectTimeout)
        }
        
        
        return bootstrap.connect(host: self.hostURL.host!, port: self.hostURL.port!)
            .flatMap{ channel in return promise.futureResult}
    }
    
    deinit {
        try! self.eventLoopGroup.syncShutdownGracefully()
    }
    
}


// MARK: - HTTPClientConfiguration

public class HTTPClientConfiguration {
    
    public let timeouts: Timeouts?
    
    public let eventLoopProvider: EventLoopProvider
    
    #if canImport(NIOSSL)
    public let sslContext: NIOSSLContext?
    
    public init(eventLoopProvider: EventLoopProvider = .create(threads: 1), sslContext: NIOSSLContext? = nil, timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS) {
        self.eventLoopProvider = eventLoopProvider
        self.sslContext = sslContext
        self.timeouts = timeouts
    }
    #else
    public init(eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
    }
    #endif
    
}

public enum EventLoopProvider {
    case create(threads: Int)
    case share(EventLoopGroup)
}


// MARK:- HTTPChannelHandler

private final class HTTPChannelHandler: ChannelInboundHandler {
    public typealias InboundIn = HTTPClientResponsePart
    public typealias OutboundOut = HTTPClientRequestPart
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwift.Networking.HTTPClient.HTTPCHannelHandler")
    
    let request: HTTPRequest
    let responsePromise: EventLoopPromise<[HTTPClientResponsePart]>
    var responseAccumulator: [HTTPClientResponsePart] = []
    
    init(for request: HTTPRequest, promise: EventLoopPromise<[HTTPClientResponsePart]>) {
        self.request = request
        self.responsePromise = promise
    }
    
    public func channelActive(context: ChannelHandlerContext) {
        let body = request.body ?? Data()
        var buffer = context.channel.allocator.buffer(capacity: body.count)
        buffer.writeBytes(body)
        
        var headers = HTTPHeaders()
        headers.add(contentsOf: request.headers)
        if buffer.readableBytes > 0 {
            headers.add(name: "Content-Length", value: "\(buffer.readableBytes)")
        }
        
        let requestHead = HTTPRequestHead(version: request.version,
                                          method: request.method,
                                          uri: request.pathWitQuery,
                                          headers: headers)
        
        context.write(self.wrapOutboundOut(.head(requestHead)), promise: nil)
        if buffer.readableBytes > 0 {
            context.write(self.wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        }
        context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let responsePart = self.unwrapInboundIn(data)
        
        self.responseAccumulator.append(responsePart)
        if case .end = responsePart {
            self.responsePromise.succeed(self.responseAccumulator)
        }
        context.close(promise: nil)
    }
    
    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        // As we are not really interested getting notified on success or failure we just pass nil as promise to
        // reduce allocations.
        if responseAccumulator.isEmpty {
            self.responsePromise.fail(error)
        }
        context.close(promise: nil)
    }
}
