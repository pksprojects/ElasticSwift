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
    
    init(withBuilder builder: HTTPResponseBuilder) {
        self.request = builder.request!
        self.status =  builder.status!
        self.headers = builder.headers!
        self.body = builder.body
    }
}

//MARK:- HTTPResponseBuilder

/// Builder for `HTTPResponse`
public class HTTPResponseBuilder {
    
    public typealias BuilderClosure = (HTTPResponseBuilder) -> Void
    
    public var request: HTTPRequest?
    public var status: HTTPResponseStatus?
    public var headers: HTTPHeaders?
    public var body: ByteBuffer?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func build() throws -> HTTPResponse {
        
        guard self.request != nil else {
            throw HTTPResponseBuilderError("request can't be nil")
        }
        
        guard self.headers != nil else {
            throw HTTPResponseBuilderError("headers can't be nil")
        }
        
        guard self.status != nil else {
            throw HTTPResponseBuilderError("status can't be nil")
        }
        
        return HTTPResponse(withBuilder: self)
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
