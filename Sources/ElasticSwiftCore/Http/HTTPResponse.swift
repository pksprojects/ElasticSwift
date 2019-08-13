//
//  HTTPResponse.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/16/19.
//

import Foundation
import NIO
import NIOHTTP1
import Logging

//MARK:- HTTPResponse

/// Represents a HTTPResponse returned from Elasticsearch
public class HTTPResponse {
    
    public let request: HTTPRequest
    
    public let status: HTTPResponseStatus
    public let headers: HTTPHeaders
    public var body: ByteBuffer?
    
    public init(request: HTTPRequest, status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer?) {
        self.status = status
        self.headers = headers
        self.body = body
        self.request = request
    }
    
    internal init(withBuilder builder: HTTPResponseBuilder) throws {
        
        guard builder.request != nil else {
            throw HTTPResponseBuilderError("request can't be nil")
        }
        
        guard builder.headers != nil else {
            throw HTTPResponseBuilderError("headers can't be nil")
        }
        
        guard builder.status != nil else {
            throw HTTPResponseBuilderError("status can't be nil")
        }
        
        self.request = builder.request!
        self.status =  builder.status!
        self.headers = builder.headers!
        self.body = builder.body
    }
}

//MARK:- HTTPResponseBuilder

/// Builder for `HTTPResponse`
public class HTTPResponseBuilder {
    
    private var _request: HTTPRequest?
    private var _status: HTTPResponseStatus?
    private var _headers: HTTPHeaders?
    private var _body: ByteBuffer?
    
    public init() {}
    
    @discardableResult
    public func set(headers: HTTPHeaders) -> HTTPResponseBuilder {
        self._headers = headers
        return self
    }
    
    @discardableResult
    public func set(request: HTTPRequest) -> HTTPResponseBuilder {
        self._request = request
        return self
    }
    
    @discardableResult
    public func set(status: HTTPResponseStatus) -> HTTPResponseBuilder {
        self._status = status
        return self
    }
    
    @discardableResult
    public func set(body: ByteBuffer) -> HTTPResponseBuilder {
        self._body = body
        return self
    }
    
    public var request: HTTPRequest? {
        return self._request
    }
    public var status: HTTPResponseStatus? {
        return self._status
    }
    public var headers: HTTPHeaders? {
        return self._headers
    }
    public var body: ByteBuffer? {
        return self._body
    }
    
    public func build() throws -> HTTPResponse {
        return try HTTPResponse(withBuilder: self)
    }
}

//MARK:- HTTPResponseStatus

/// Helper extention for HTTPResponseStatus
extension HTTPResponseStatus {
    
    public func is1xxInformational() -> Bool {
        return self.code >= 100 && self.code < 200
    }
    
    public func is2xxSuccessful() -> Bool {
        return self.code >= 200 && self.code < 300
    }
    
    public func is3xxRedirection() -> Bool {
        return self.code >= 300 && self.code < 400
    }
    
    public func is4xxClientError() -> Bool {
        return self.code >= 400 && self.code < 500
    }
    
    public func is5xxServerError() -> Bool {
        return self.code >= 500 && self.code < 600
    }
    
    public func isError() -> Bool {
        return self.is4xxClientError() || self.is5xxServerError()
    }
    
}
