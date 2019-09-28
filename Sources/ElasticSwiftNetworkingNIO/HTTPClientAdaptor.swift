//
//  HTTPClientAdaptor.swift
//  ElasticSwiftNetworkingNIO
//
//  Created by Prafull Kumar Soni on 7/26/19.
//
//

import Foundation
import Logging
import NIOHTTP1
import NIO
#if canImport(NIOSSL)
import NIOSSL
#endif
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
            var responseBody: Data? = nil
            for part in parts {
                switch part {
                case .head(let head):
                    responseHead = head
                case .body(var buffer):
                    if let bytes = buffer.readBytes(length: buffer.readableBytes) {
                        responseBody = Data(bytes)
                    }
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
