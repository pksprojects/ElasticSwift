//
//  HttpAdaptor.swift
//  ElasticSwiftCore
//
//  Created by Prafull Kumar Soni on 7/28/19.
//

import Foundation

// MARK: - HTTPClientAdaptor

public protocol HTTPClientAdaptor {
    func performRequest(_ request: HTTPRequest, callback: @escaping (_ result: Result<HTTPResponse, Error>) -> Void)
}

public protocol ManagedHTTPClientAdaptor: HTTPClientAdaptor {
    init(forHost host: URL, adaptorConfig: HTTPAdaptorConfiguration)
}

// MARK: - HTTPAdaptorConfiguration

public protocol HTTPAdaptorConfiguration {
    var adaptor: ManagedHTTPClientAdaptor.Type { get }
}
