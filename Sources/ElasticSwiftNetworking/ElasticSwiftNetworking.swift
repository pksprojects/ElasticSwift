import Foundation
import Logging
import NIO
import NIOHTTP1
import NIOTLS
#if canImport(NIOSSL)
import NIOSSL
#endif

public class HTTPAdaptorConfiguration {
    
    public let timeouts: Timeouts?
    
    public let eventLoopProvider: EventLoopProvider
    
    // ssl config for URLSession based clients
    public let sslConfig: SSLConfiguration?
    
    #if canImport(NIOSSL)
    // ssl config for swift-nio-ssl based clients
    public let sslcontext: NIOSSLContext?

    public init(eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS, sslConfig: SSLConfiguration? = nil, sslContext: NIOSSLContext? = nil) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
        self.sslConfig = sslConfig
        self.sslcontext = sslContext
    }
    
    #else
    
    public init(eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS, sslConfig: SSLConfiguration? = nil) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
        self.sslConfig = sslConfig
    }
    
    #endif
    
    public static var `default`: HTTPAdaptorConfiguration {
        get {
            return HTTPAdaptorConfiguration()
        }
    }
    
}

public class SSLConfiguration {
    
    let certPath: String
    let isSelfSigned: Bool
    
    public init(certPath: String, isSelf isSelfSigned: Bool) {
        self.certPath = certPath
        self.isSelfSigned = isSelfSigned
    }
}
