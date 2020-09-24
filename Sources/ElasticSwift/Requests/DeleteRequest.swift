//
//  DeleteRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import ElasticSwiftCore
import Foundation
import NIOHTTP1

// MARK: - Delete Request Builder

public class DeleteRequestBuilder: RequestBuilder {
    public typealias RequestType = DeleteRequest

    private var _index: String?
    private var _type: String?
    private var _id: String?
    private var _version: String?
    private var _versionType: VersionType?
    private var _refresh: IndexRefresh?

    public init() {}

    @discardableResult
    public func set(index: String) -> Self {
        _index = index
        return self
    }

    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(version: String) -> Self {
        _version = version
        return self
    }

    @discardableResult
    public func set(versionType: VersionType) -> Self {
        _versionType = versionType
        return self
    }

    @discardableResult
    public func set(refresh: IndexRefresh) -> Self {
        _refresh = refresh
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

    public var version: String? {
        return _version
    }

    public var versionType: VersionType? {
        return _versionType
    }

    public var refresh: IndexRefresh? {
        return _refresh
    }

    public func build() throws -> RequestType {
        return try DeleteRequest(withBuilder: self)
    }
}

// MARK: - Delete Request

public struct DeleteRequest: Request, BulkableRequest {
    public var headers = HTTPHeaders()

    public let index: String
    public let type: String
    public let id: String
    public var version: String?
    public var versionType: VersionType?
    public var refresh: IndexRefresh?

    public init(index: String, type: String = "_doc", id: String) {
        self.index = index
        self.type = type
        self.id = id
    }

    internal init(withBuilder builder: DeleteRequestBuilder) throws {
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }

        guard builder.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }

        self.init(index: builder.index!, type: builder.type ?? "_doc", id: builder.id!)
        version = builder.version
        versionType = builder.versionType
        refresh = builder.refresh
    }

    public var method: HTTPMethod {
        return .DELETE
    }

    public var endPoint: String {
        return index + "/" + type + "/" + id
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let version = self.version, let versionType = self.versionType {
            params.append(URLQueryItem(name: QueryParams.version.rawValue, value: version))
            params.append(URLQueryItem(name: QueryParams.versionType.rawValue, value: versionType.rawValue))
        }
        if let refresh = self.refresh {
            params.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: refresh.rawValue))
        }
        return params
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }

    public var opType: OpType {
        return .delete
    }
}

extension DeleteRequest: Equatable {}
