//
//  FieldCaps.swift
//  ElasticSwift
//
//
//  Created by Prafull Kumar Soni on 1/12/20.
//

import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

// MARK: - FieldCaps Request Builder

public class FieldCapabilitiesRequestBuilder: RequestBuilder {
    public typealias RequestType = FieldCapabilitiesRequest

    private var _indices: [String]?
    private var _fields: [String]?

    private var _ignoreUnavailable: Bool?
    private var _allowNoIndices: Bool?
    private var _expandWildcards: ExpandWildcards?

    public init() {}

    @discardableResult
    public func set(indices: String...) -> Self {
        _indices = indices
        return self
    }

    @discardableResult
    public func set(indices: [String]) -> Self {
        _indices = indices
        return self
    }

    @discardableResult
    public func set(fields: String...) -> Self {
        _fields = fields
        return self
    }

    @discardableResult
    public func set(fields: [String]) -> Self {
        _fields = fields
        return self
    }

    @discardableResult
    public func add(index: String) -> Self {
        if _indices != nil {
            _indices?.append(index)
        } else {
            _indices = [index]
        }
        return self
    }

    @discardableResult
    public func add(field: String) -> Self {
        if _fields != nil {
            _fields?.append(field)
        } else {
            _fields = [field]
        }
        return self
    }

    @discardableResult
    public func set(ignoreUnavailable: Bool) -> Self {
        _ignoreUnavailable = ignoreUnavailable
        return self
    }

    @discardableResult
    public func set(allowNoIndices: Bool) -> Self {
        _allowNoIndices = allowNoIndices
        return self
    }

    @discardableResult
    public func set(expandWildcards: ExpandWildcards) -> Self {
        _expandWildcards = expandWildcards
        return self
    }

    public var indices: [String]? {
        return _indices
    }

    public var fields: [String]? {
        return _fields
    }

    public var ignoreUnavailable: Bool? {
        return _ignoreUnavailable
    }

    public var allowNoIndices: Bool? {
        return _allowNoIndices
    }

    public var expandWildcards: ExpandWildcards? {
        return _expandWildcards
    }

    public func build() throws -> FieldCapabilitiesRequest {
        return try FieldCapabilitiesRequest(withBuilder: self)
    }
}

// MARK: - FieldCaps Request

public struct FieldCapabilitiesRequest: Request {
    /// A list of index names; use `_all` or empty array to perform the operation on all indices
    public let indices: [String]?
    /// A list of field names
    public let fields: [String]
    /// Whether specified concrete indices should be ignored when unavailable (missing or closed)
    public var ignoreUnavailable: Bool?
    /// Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
    public var allowNoIndices: Bool?
    /// Whether to expand wildcard expression to concrete indices that are open, closed or both.
    public var expandWildcards: ExpandWildcards?

    public init(indices: [String]? = nil, fields: [String]) {
        self.indices = indices
        self.fields = fields
    }

    public init(indices: [String]? = nil, fields: String...) {
        self.init(indices: indices, fields: fields)
    }

    internal init(withBuilder builder: FieldCapabilitiesRequestBuilder) throws {
        guard builder.fields != nil else {
            throw RequestBuilderError.missingRequiredField("fields")
        }

        guard !builder.fields!.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("fields")
        }

        self.init(indices: builder.indices, fields: builder.fields!)

        ignoreUnavailable = builder.ignoreUnavailable
        allowNoIndices = builder.allowNoIndices
        expandWildcards = builder.expandWildcards
    }

    public var headers: HTTPHeaders {
        return HTTPHeaders()
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let ignoreUnavailable = self.ignoreUnavailable {
            params.append(.init(name: .ignoreUnavailable, value: ignoreUnavailable))
        }
        if let allowNoIndices = self.allowNoIndices {
            params.append(.init(name: .allowNoIndices, value: allowNoIndices))
        }
        if let expandWildcards = self.expandWildcards {
            params.append(.init(name: .expandWildcards, value: expandWildcards.rawValue))
        }

        params.append(.init(name: .fields, value: fields))

        return params
    }

    public var method: HTTPMethod {
        return .GET
    }

    public var endPoint: String {
        var _endPoint = "_field_caps"
        if let indices = self.indices, !indices.isEmpty {
            _endPoint = indices.joined(separator: ",") + "/" + _endPoint
        }
        return _endPoint
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension FieldCapabilitiesRequest: Equatable {}
