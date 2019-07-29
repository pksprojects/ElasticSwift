//
//  HTTPClientAdaptor.swift
//  ElasticSwiftNetworking
//
//  Created by Prafull Kumar Soni on 7/26/19.
//
//

import Foundation
import Logging
import NIOHTTP1
import NIO
import ElasticSwiftCore

// MARK: - DefaultHTTPClientAdaptor

public final class DefaultHTTPClientAdaptor: ManagedHTTPClientAdaptor {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Networking.DefaultHTTPClientAdaptor")
    
    let client: HTTPClient
    
    public required init(forHost host: URL, adaptorConfig: HTTPAdaptorConfiguration =  HTTPClientAdaptorConfiguration.default) {
        let httpClientConfig = DefaultHTTPClientAdaptor.createHttpClientConfig(from: adaptorConfig)
        self.client = HTTPClient(forHost: host, configuration: httpClientConfig)
    }
    
    public func performRequest(_ request: HTTPRequest, callback: @escaping (_ result: Result<HTTPResponse, Error>) -> Void ) {
        self.client.execute(request: request).map { parts in
            var responseHead: HTTPResponseHead? = nil
            var responseBody: ByteBuffer? = nil
            for part in parts {
                switch part {
                case .head(let head):
                    responseHead = head
                case .body(let buffer):
                    responseBody = buffer
                case .end(_):
                    let response = HTTPResponse(request: request, status: responseHead!.status, headers: responseHead!.headers, body: responseBody)
                    return callback(.success(response))
                }
            }
            
        }.recover { error  in
            return callback(.failure(error))
        }.whenSuccess({})
    }
    
    private static func createHttpClientConfig(from adaptorConfig: HTTPAdaptorConfiguration) -> HTTPClientConfiguration {
        
        let config = adaptorConfig as! HTTPClientAdaptorConfiguration
        #if canImport(NIOSSL)
        return HTTPClientConfiguration(eventLoopProvider: config.eventLoopProvider, sslContext: config.sslcontext, timeouts: config.timeouts)
        #else
        return HTTPClientConfiguration(eventLoopProvider: config.eventLoopProvider, timeouts: config.timeouts)
        #endif
    }
    
}

// MARK: - URLSessionAdaptor

public final class URLSessionAdaptor: ManagedHTTPClientAdaptor {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Networking.URLSessionAdaptor")
    
    let sessionManager: SessionManager
    
    let allocator: ByteBufferAllocator
    
    public required init(forHost host: URL, adaptorConfig: HTTPAdaptorConfiguration =  URLSessionAdaptorConfiguration.default) {
        let config = adaptorConfig as! URLSessionAdaptorConfiguration
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        // URLSession basic SSL support for apple platform
        self.sessionManager = SessionManager(forHost: host, sslConfig: config.sslConfig)
        #else
        self.sessionManager = SessionManager(forHost: host)
        #endif
        self.allocator = ByteBufferAllocator()
    }
    
    public func performRequest(_ request: HTTPRequest, callback: @escaping (Result<HTTPResponse, Error>) -> Void) {
        let urlRequest = self.sessionManager.createReqeust(request)
        self.sessionManager.execute(urlRequest) { data, response, error in
            guard error == nil else {
                return callback(.failure(error!))
            }
            let responseBuilder =  HTTPResponseBuilder { builder in
                builder.request = request
                if let response = response as? HTTPURLResponse {
                    
                    builder.status = HTTPResponseStatus.init(statusCode: response.statusCode)
                    
                    let headerDic =  response.allHeaderFields as! [String: String]
                    
                    var headers = HTTPHeaders()
                    
                    for header in headerDic {
                        headers.add(name: header.key, value: header.value)
                    }
                    builder.headers = headers
                    
                }
                if let resData = data {
                    var buff = self.allocator.buffer(capacity: resData.count)
                    buff.writeBytes(resData)
                    builder.body = buff
                }
            }
            
            do {
                let httpResponse = try responseBuilder.build()
                return callback(.success(httpResponse))
            } catch {
                return callback(.failure(error))
            }
            
        }
    }
    
}
