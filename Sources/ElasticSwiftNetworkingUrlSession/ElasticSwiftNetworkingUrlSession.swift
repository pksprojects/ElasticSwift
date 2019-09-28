//
//  File.swift
//  
//
//  Created by Prafull Kumar Soni on 9/27/19.
//

import Foundation
import ElasticSwiftCore
import Logging
import NIOHTTP1

// MARK: - URLSessionAdaptor

/// Implementation of `ManagedHTTPClientAdaptor` backed by `URLSession`.
@available(iOS 10.0, macOS 10.10, tvOS 10, watchOS 3, *)
public final class URLSessionAdaptor: ManagedHTTPClientAdaptor {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Networking.URLSessionAdaptor")
    
    let sessionManager: SessionManager
    
    public required init(forHost host: URL, adaptorConfig: HTTPAdaptorConfiguration =  URLSessionAdaptorConfiguration.default) {
        let config = adaptorConfig as! URLSessionAdaptorConfiguration
        self.sessionManager = SessionManager(forHost: host, sslConfig: config.sslConfig)
    }
    
    public func performRequest(_ request: HTTPRequest, callback: @escaping (Result<HTTPResponse, Error>) -> Void) {
        let urlRequest = self.sessionManager.createReqeust(request)
        self.sessionManager.execute(urlRequest) { data, response, error in
            guard error == nil else {
                return callback(.failure(error!))
            }
            let responseBuilder =  HTTPResponseBuilder()
                .set(request: request)
            if let response = response as? HTTPURLResponse {
                
                responseBuilder.set(status: HTTPResponseStatus(statusCode: response.statusCode))
                
                let headerDic =  response.allHeaderFields as! [String: String]
                
                var headers = HTTPHeaders()
                
                for header in headerDic {
                    headers.add(name: header.key, value: header.value)
                }
                responseBuilder.set(headers: headers)
                
            }
            if let resData = data {
                responseBuilder.set(body: resData)
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

@available(iOS 10.0, macOS 10.10, tvOS 10, watchOS 3, *)
public class URLSessionAdaptorConfiguration: HTTPAdaptorConfiguration {
    
    public let adaptor: ManagedHTTPClientAdaptor.Type
    
    // URLSession basic SSL support for apple platform
    // ssl config for URLSession based clients
    public let sslConfig: SSLConfiguration?
    
    public init(adaptor: ManagedHTTPClientAdaptor.Type = URLSessionAdaptor.self, sslConfig: SSLConfiguration? = nil) {
        self.sslConfig = sslConfig
        self.adaptor = adaptor
    }
    
    public static var `default`: HTTPAdaptorConfiguration {
        get {
            return URLSessionAdaptorConfiguration()
        }
    }
    
}

@available(iOS 10.0, macOS 10.10, tvOS 10, watchOS 3, *)
public class SSLConfiguration {
    
    let certPath: String
    let isSelfSigned: Bool
    
    public init(certPath: String, isSelf isSelfSigned: Bool) {
        self.certPath = certPath
        self.isSelfSigned = isSelfSigned
    }
}

