//
//  HTTPRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/16/19.
//

import Foundation
import NIO
import NIOHTTP1
import Logging

//MARK:- HTTPRequest

/// Class representing HTTP request for Elasticsearch
public class HTTPRequest {
    
    public let version: HTTPVersion
    public let method: HTTPMethod
    public let headers: HTTPHeaders
    public let body: Data?
    public let path: String
    public let queryParams: [URLQueryItem]
    
    public init(path: String, method: HTTPMethod, queryParams: [URLQueryItem] = [], headers: HTTPHeaders = HTTPHeaders(), body: Data? = nil) {
        self.version = HTTPVersion(major: 1, minor: 1)
        self.method = method
        self.body = body
        self.headers = headers
        self.path = path
        self.queryParams = queryParams
    }
    
    init(withBuilder builder: HTTPRequestBuilder) {
        if let version = builder.version {
            self.version = version
        } else {
            self.version = HTTPVersion(major: 1, minor: 1)
        }
        if let queryParams = builder.queryParams {
            self.queryParams = queryParams
        } else {
            self.queryParams = []
        }
        if let headers = builder.headers {
            self.headers = headers
        } else {
            self.headers = HTTPHeaders()
        }
        self.body = builder.body
        self.method = builder.method!
        self.path = builder.path!
    }
    
    public var query: String {
        get {
            if self.queryParams.isEmpty {
                return ""
            } else {
                return "?" + queryParams.map { $0.name + "=" + ($0.value ?? "") }.joined(separator: "&")
            }
        }
    }
    
    public var pathWitQuery: String {
        get {
            return self.path + self.query
        }
    }
    
}

//MARK:- HTTPReqeustBuilder

/// Builder for `HTTPRequest`
public class HTTPRequestBuilder {
    
    public typealias BuilderClosure = (HTTPRequestBuilder) -> Void
    
    public var version: HTTPVersion?
    public var method: HTTPMethod?
    public var headers: HTTPHeaders?
    public var body: Data?
    public var path: String?
    public var queryParams: [URLQueryItem]?
    public var completionHandler: ((_ response: HTTPResponse)  -> Void)?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func build() throws -> HTTPRequest {
        
        guard self.method != nil else {
            throw HTTPRequestBuilderError("method can't be nil")
        }
        
        guard self.path != nil else {
            throw HTTPRequestBuilderError("url can't be nil")
        }
        
        return HTTPRequest(withBuilder: self)
    }
}
