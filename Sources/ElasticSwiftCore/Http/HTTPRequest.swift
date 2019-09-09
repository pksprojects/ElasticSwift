//
//  HTTPRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/16/19.
//

import Foundation
import NIOHTTP1
import Logging

//MARK:- HTTPRequest

/// Represents a HTTP request for Elasticsearch
public struct HTTPRequest {
    
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
    
    internal init(withBuilder builder: HTTPRequestBuilder) throws {
        
        guard builder.method != nil else {
            throw HTTPRequestBuilderError("method can't be nil")
        }
        
        guard builder.path != nil else {
            throw HTTPRequestBuilderError("url can't be nil")
        }
        
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

extension HTTPRequest: Equatable {}

//MARK:- HTTPReqeustBuilder

/// Builder for `HTTPRequest`
public class HTTPRequestBuilder {
    
    private var _version: HTTPVersion?
    private var _method: HTTPMethod?
    private var _headers: HTTPHeaders?
    private var _body: Data?
    private var _path: String?
    private var _queryParams: [URLQueryItem]?
    private var _completionHandler: ((_ response: HTTPResponse)  -> Void)?
    
    public init() {}
    
    @discardableResult
    public func set(version: HTTPVersion) -> HTTPRequestBuilder {
        self._version = version
        return self
    }
    
    @discardableResult
    public func set(method: HTTPMethod) -> HTTPRequestBuilder {
        self._method = method
        return self
    }
    
    @discardableResult
    public func set(headers: HTTPHeaders) -> HTTPRequestBuilder {
        self._headers = headers
        return self
    }
    
    @discardableResult
    public func set(body: Data) -> HTTPRequestBuilder {
        self._body = body
        return self
    }
    
    @discardableResult
    public func set(path: String) -> HTTPRequestBuilder {
        self._path = path
        return self
    }
    
    @discardableResult
    public func set(queryParams: [URLQueryItem]) -> HTTPRequestBuilder {
        self._queryParams = queryParams
        return self
    }
    
    @discardableResult
    public func set(completionHandler: @escaping ((_ response: HTTPResponse)  -> Void)) -> HTTPRequestBuilder {
        self._completionHandler = completionHandler
        return self
    }
    
    public var version: HTTPVersion? {
        return self._version
    }
    public var method: HTTPMethod? {
        return self._method
    }
    public var headers: HTTPHeaders? {
        return self._headers
    }
    public var body: Data? {
        return self._body
    }
    public var path: String? {
        return self._path
    }
    public var queryParams: [URLQueryItem]? {
        return self._queryParams
    }
    public var completionHandler: ((_ response: HTTPResponse)  -> Void)? {
        return self._completionHandler
    }
    
    public func build() throws -> HTTPRequest {
        return try HTTPRequest(withBuilder: self)
    }
}
