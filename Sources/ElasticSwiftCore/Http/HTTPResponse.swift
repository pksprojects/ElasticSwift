//
//  HTTPResponse.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/16/19.
//

import Foundation
import Logging
import NIOHTTP1

// MARK: - HTTPResponse

/// Represents a HTTPResponse returned from Elasticsearch
public struct HTTPResponse {
    public let request: HTTPRequest

    public let status: HTTPResponseStatus
    public let headers: HTTPHeaders
    public var body: Data?

    public init(request: HTTPRequest, status: HTTPResponseStatus, headers: HTTPHeaders, body: Data?) {
        self.status = status
        self.headers = headers
        self.body = body
        self.request = request
    }

    internal init(withBuilder builder: HTTPResponseBuilder) throws {
        guard builder.request != nil else {
            throw HTTPResponseBuilderError.missingRequiredField("request")
        }

        guard builder.headers != nil else {
            throw HTTPResponseBuilderError.missingRequiredField("headers")
        }

        guard builder.status != nil else {
            throw HTTPResponseBuilderError.missingRequiredField("status")
        }

        self.init(request: builder.request!, status: builder.status!, headers: builder.headers!, body: builder.body)
    }
}

extension HTTPResponse: Equatable {}

// MARK: - HTTPResponseBuilder

/// Builder for `HTTPResponse`
public class HTTPResponseBuilder {
    private var _request: HTTPRequest?
    private var _status: HTTPResponseStatus?
    private var _headers: HTTPHeaders?
    private var _body: Data?

    public init() {}

    @discardableResult
    public func set(headers: HTTPHeaders) -> HTTPResponseBuilder {
        _headers = headers
        return self
    }

    @discardableResult
    public func set(request: HTTPRequest) -> HTTPResponseBuilder {
        _request = request
        return self
    }

    @discardableResult
    public func set(status: HTTPResponseStatus) -> HTTPResponseBuilder {
        _status = status
        return self
    }

    @discardableResult
    public func set(body: Data) -> HTTPResponseBuilder {
        _body = body
        return self
    }

    public var request: HTTPRequest? {
        return _request
    }

    public var status: HTTPResponseStatus? {
        return _status
    }

    public var headers: HTTPHeaders? {
        return _headers
    }

    public var body: Data? {
        return _body
    }

    public func build() throws -> HTTPResponse {
        return try HTTPResponse(withBuilder: self)
    }
}

// MARK: - HTTPResponseStatus

/// Helper extention for HTTPResponseStatus
extension HTTPResponseStatus {
    public func is1xxInformational() -> Bool {
        return code >= 100 && code < 200
    }

    public func is2xxSuccessful() -> Bool {
        return code >= 200 && code < 300
    }

    public func is3xxRedirection() -> Bool {
        return code >= 300 && code < 400
    }

    public func is4xxClientError() -> Bool {
        return code >= 400 && code < 500
    }

    public func is5xxServerError() -> Bool {
        return code >= 500 && code < 600
    }

    public func isError() -> Bool {
        return is4xxClientError() || is5xxServerError()
    }
}
