//
//  StoredScriptRequests.swift
//
//
//  Created by Prafull Kumar Soni on 9/27/20.
//

import ElasticSwiftCore
import Foundation
import NIOHTTP1

// MARK: - Put StoredScript Request Builder

public class PutStoredScriptRequestBuilder: RequestBuilder {
    public typealias RequestType = PutStoredScriptRequest

    private var _id: String?
    private var _script: StoredScriptSource?
    private var _context: String?

    public init() {}

    @discardableResult
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(script: StoredScriptSource) -> Self {
        _script = script
        return self
    }

    @discardableResult
    public func set(context: String) -> Self {
        _context = context
        return self
    }

    public var id: String? {
        return _id
    }

    public var script: StoredScriptSource? {
        return _script
    }

    public var context: String? {
        return _context
    }

    public func build() throws -> PutStoredScriptRequest {
        return try PutStoredScriptRequest(withBuilder: self)
    }
}

// MARK: - Put StoredScript Request

public struct PutStoredScriptRequest: Request {
    public var headers = HTTPHeaders()

    public let id: String
    public let script: StoredScriptSource
    public let context: String?

    public var timeout: String?
    public var masterTimeout: String?

    public init(id: String, script: StoredScriptSource, context: String? = nil, timeout: String? = nil, masterTimeout: String? = nil) {
        self.id = id
        self.script = script
        self.context = context
        self.timeout = timeout
        self.masterTimeout = masterTimeout
    }

    internal init(withBuilder builder: PutStoredScriptRequestBuilder) throws {
        guard let id = builder.id else {
            throw RequestBuilderError.missingRequiredField("id")
        }

        guard let script = builder.script else {
            throw RequestBuilderError.missingRequiredField("script")
        }

        self.init(id: id, script: script, context: builder.context)
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let timeout = self.timeout {
            queryItems.append(.init(name: QueryParams.timeout, value: timeout))
        }
        if let masterTimeout = self.masterTimeout {
            queryItems.append(.init(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        return queryItems
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        var _endPoint = "_scripts/\(id)"
        if let context = self.context {
            _endPoint = "\(_endPoint)/\(context)"
        }
        return _endPoint
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(script: script)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            .wrapped(error)
        }
    }

    private struct Body: Encodable {
        public let script: StoredScriptSource
    }
}

extension PutStoredScriptRequest: Equatable {}

public struct StoredScriptSource {
    public let lang: String
    public let source: String
    public let options: [String: String]?

    public init(lang: String, source: String, options: [String: String]? = nil) {
        self.lang = lang
        self.source = source
        self.options = options
    }
}

extension StoredScriptSource: Codable {}

extension StoredScriptSource: Equatable {}

// MARK: - Get StoredScript Request Builder

public class GetStoredScriptRequestBuilder: RequestBuilder {
    public typealias RequestType = GetStoredScriptRequest

    private var _id: String?
    private var _masterTimeout: String?

    public init() {}

    @discardableResult
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(masterTimeout: String) -> Self {
        _masterTimeout = masterTimeout
        return self
    }

    public var id: String? {
        return _id
    }

    public var masterTimeout: String? {
        return _masterTimeout
    }

    public func build() throws -> GetStoredScriptRequest {
        return try GetStoredScriptRequest(withBuilder: self)
    }
}

// MARK: - Get StoredScript Request

public struct GetStoredScriptRequest: Request {
    public var headers = HTTPHeaders()

    public let id: String

    public var masterTimeout: String?

    public init(_ id: String, masterTimeout: String? = nil) {
        self.id = id
        self.masterTimeout = masterTimeout
    }

    internal init(withBuilder builder: GetStoredScriptRequestBuilder) throws {
        guard let id = builder.id else {
            throw RequestBuilderError.missingRequiredField("id")
        }

        self.init(id, masterTimeout: builder.masterTimeout)
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let masterTimeout = self.masterTimeout {
            queryItems.append(.init(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        return queryItems
    }

    public var method: HTTPMethod {
        return .GET
    }

    public var endPoint: String {
        return "_scripts/\(id)"
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension GetStoredScriptRequest: Equatable {}

// MARK: - Delete StoredScript Request Builder

public class DeleteStoredScriptRequestBuilder: RequestBuilder {
    public typealias RequestType = DeleteStoredScriptRequest

    private var _id: String?
    private var _masterTimeout: String?

    public init() {}

    @discardableResult
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(masterTimeout: String) -> Self {
        _masterTimeout = masterTimeout
        return self
    }

    public var id: String? {
        return _id
    }

    public var masterTimeout: String? {
        return _masterTimeout
    }

    public func build() throws -> DeleteStoredScriptRequest {
        return try DeleteStoredScriptRequest(withBuilder: self)
    }
}

// MARK: - Delete StoredScript Request

public struct DeleteStoredScriptRequest: Request {
    public var headers = HTTPHeaders()

    public let id: String

    public var masterTimeout: String?

    public init(_ id: String, masterTimeout: String? = nil) {
        self.id = id
        self.masterTimeout = masterTimeout
    }

    internal init(withBuilder builder: DeleteStoredScriptRequestBuilder) throws {
        guard let id = builder.id else {
            throw RequestBuilderError.missingRequiredField("id")
        }

        self.init(id, masterTimeout: builder.masterTimeout)
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let masterTimeout = self.masterTimeout {
            queryItems.append(.init(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        return queryItems
    }

    public var method: HTTPMethod {
        return .DELETE
    }

    public var endPoint: String {
        return "_scripts/\(id)"
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension DeleteStoredScriptRequest: Equatable {}
