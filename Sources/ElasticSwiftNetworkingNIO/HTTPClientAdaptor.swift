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
import ElasticSwiftCore
import AsyncHTTPClient

// MARK: - DefaultHTTPClientAdaptor

public final class AsyncHTTPClientAdaptor: ManagedHTTPClientAdaptor {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Networking.AsyncHTTPClientAdaptor")
    
    let client: HTTPClient
    let host: URL
    
    public required init(forHost host: URL, adaptorConfig: HTTPAdaptorConfiguration =  AsyncHTTPClientAdaptorConfiguration.default) {
        self.host = host
        let config = adaptorConfig as! AsyncHTTPClientAdaptorConfiguration
        self.client = HTTPClient.init(eventLoopGroupProvider: config.eventLoopProvider, configuration: config.clientConfig)
    }
    
    public func performRequest(_ request: HTTPRequest, callback: @escaping (_ result: Result<HTTPResponse, Error>) -> Void ) {
        let result = self.buildRequest(request)
        switch result {
        case .failure(let error):
            return callback(.failure(error))
        case .success(let clientRequest):
            self.client.execute(request: clientRequest).map { response -> HTTPResponse in
                var responseBody: Data?
                if var buffer = response.body {
                    if let bytes = buffer.readBytes(length: buffer.readableBytes) {
                        responseBody = Data(bytes)
                    }
                }
                return HTTPResponse.init(request: request, status: response.status, headers: response.headers, body: responseBody)
            }.whenComplete { result in
                switch result {
                case .failure(let error):
                    return callback(.failure(error))
                case .success(let response):
                    return callback(.success(response))
                }
            }
        }
    }
    
    private func buildRequest(_ httpRequest: HTTPRequest) -> Result<HTTPClient.Request, Error> {
        do {
            let url = URL(string: self.host.absoluteString + "/" + httpRequest.pathWitQuery)
            guard url != nil else { return .failure(HTTPClientError.invalidURL) }
            var body: HTTPClient.Body? = nil
            if let data = httpRequest.body {
                body = .data(data)
            }
            let request = try HTTPClient.Request(url: url!, method: httpRequest.method, headers: httpRequest.headers, body: body)
            return .success(request)
        } catch {
            return .failure(error)
        }
    }
    
    deinit {
        try? self.client.syncShutdown()
    }
    
}
