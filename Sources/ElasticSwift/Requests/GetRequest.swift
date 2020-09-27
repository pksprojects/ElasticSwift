//
//  GetRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import ElasticSwiftCore
import Foundation
import NIOHTTP1

// MARK: - Get Request Builder

public class GetRequestBuilder: RequestBuilder {
    public typealias RequestType = GetRequest

    private var _index: String?
    private var _type: String?
    private var _id: String?

    public init() {}

    @discardableResult
    public func set(index: String) -> GetRequestBuilder {
        _index = index
        return self
    }

    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> GetRequestBuilder {
        _type = type
        return self
    }

    @discardableResult
    public func set(id: String) -> GetRequestBuilder {
        _id = id
        return self
    }

    public var index: String? {
        return _index
    }

    public var type: String? {
        return _type
    }

    public var id: String? {
        return _id
    }

    public func build() throws -> GetRequest {
        return try GetRequest(withBuilder: self)
    }
}

// MARK: - Get Request

public struct GetRequest: Request {
    public var headers = HTTPHeaders()

    public var queryParams: [URLQueryItem] = []

    public let index: String
    public let type: String
    public let id: String

    public var method: HTTPMethod {
        return .GET
    }

    public init(index: String, type: String = "_doc", id: String) {
        self.index = index
        self.type = type
        self.id = id
    }

    internal init(withBuilder builder: GetRequestBuilder) throws {
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }

        guard builder.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }

        self.init(index: builder.index!, type: builder.type ?? "_doc", id: builder.id!)
    }

    public var endPoint: String {
        return index + "/" + type + "/" + id
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension GetRequest: Equatable {}
