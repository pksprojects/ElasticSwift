import Foundation
import Logging
import NIO
import NIOHTTP1
import NIOTLS
#if canImport(NIOSSL)
import NIOSSL
#endif
import ElasticSwiftCore

//MARK:- Timeouts

public class Timeouts {
    
    public static let DEFAULT_TIMEOUTS: Timeouts = Timeouts(read: TimeAmount.milliseconds(1000), connect: TimeAmount.milliseconds(3000))
    
    public let read: TimeAmount?
    public let connect: TimeAmount?
    
    public init(read: TimeAmount? = nil, connect: TimeAmount? = nil) {
        self.read = read
        self.connect = connect
    }
    
}

//MARK:- HTTPAdaptorConfiguration

/// Class holding HTTPAdaptor Config
public class HTTPClientAdaptorConfiguration: HTTPAdaptorConfiguration {
    
    public let adaptor: ManagedHTTPClientAdaptor.Type
    
    public let timeouts: Timeouts?
    
    public let eventLoopProvider: EventLoopProvider
    
    #if canImport(NIOSSL)
    // ssl config for swift-nio-ssl based clients
    public let sslcontext: NIOSSLContext?

    public init(adaptor: ManagedHTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS, sslContext: NIOSSLContext? = nil) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
        self.sslcontext = sslContext
        self.adaptor = adaptor
    }
    
    #else
    
    public init(adaptor: ManagedHTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
        self.adaptor = adaptor
    }
    
    #endif
    
    public static var `default`: HTTPAdaptorConfiguration {
        get {
            return HTTPClientAdaptorConfiguration()
        }
    }
    
}

public class URLSessionAdaptorConfiguration: HTTPAdaptorConfiguration {
    
    public let adaptor: ManagedHTTPClientAdaptor.Type
    
    public let timeouts: Timeouts?
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    // URLSession basic SSL support for apple platform

    // ssl config for URLSession based clients
    public let sslConfig: SSLConfiguration?
    
    public init(adaptor: ManagedHTTPClientAdaptor.Type = URLSessionAdaptor.self, timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS, sslConfig: SSLConfiguration? = nil) {
        self.timeouts = timeouts
        self.sslConfig = sslConfig
        self.adaptor = adaptor
    }
    
    #else
    
    public init(adaptor: ManagedHTTPClientAdaptor.Type = URLSessionAdaptor.self, timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS) {
        self.timeouts = timeouts
        self.adaptor = adaptor
    }
    
    #endif
    
    public static var `default`: HTTPAdaptorConfiguration {
        get {
            return URLSessionAdaptorConfiguration()
        }
    }
    
}

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)

public class SSLConfiguration {
    
    let certPath: String
    let isSelfSigned: Bool
    
    public init(certPath: String, isSelf isSelfSigned: Bool) {
        self.certPath = certPath
        self.isSelfSigned = isSelfSigned
    }
}
#endif
