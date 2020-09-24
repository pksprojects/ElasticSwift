//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation
import NIOHTTP1

// MARK: -  Builders

// MARK: - Create Index Request Builder

public class CreateIndexRequestBuilder: RequestBuilder {
    public typealias RequestType = CreateIndexRequest

    private var _name: String?
    private var _settings: [String: CodableValue]?
    private var _mappings: [String: MappingMetaData]?
    private var _aliases: [IndexAlias]?

    public init() {}

    public func set(name: String) -> CreateIndexRequestBuilder {
        _name = name
        return self
    }

    public func set(settings: [String: CodableValue]) -> CreateIndexRequestBuilder {
        _settings = settings
        return self
    }

    public func set(mappings: [String: MappingMetaData]) -> CreateIndexRequestBuilder {
        _mappings = mappings
        return self
    }

    public func set(aliases: [IndexAlias]) -> CreateIndexRequestBuilder {
        _aliases = aliases
        return self
    }

    public var name: String? {
        return _name
    }

    public var settings: [String: CodableValue]? {
        return _settings
    }

    public var mappings: [String: MappingMetaData]? {
        return _mappings
    }

    public var aliases: [IndexAlias]? {
        return _aliases
    }

    public func build() throws -> CreateIndexRequest {
        return try CreateIndexRequest(withBuilder: self)
    }
}

// MARK: - Delete Index Request Builder

public class DeleteIndexRequestBuilder: RequestBuilder {
    public typealias RequestType = DeleteIndexRequest

    private var _name: String?

    public init() {}

    @discardableResult
    public func set(name: String) -> DeleteIndexRequestBuilder {
        _name = name
        return self
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> DeleteIndexRequest {
        return try DeleteIndexRequest(withBuilder: self)
    }
}

// MARK: - Get Index Request Builder

public class GetIndexRequestBuilder: RequestBuilder {
    public typealias RequestType = GetIndexRequest

    private var _name: String?

    public init() {}

    @discardableResult
    public func set(name: String) -> GetIndexRequestBuilder {
        _name = name
        return self
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> GetIndexRequest {
        return try GetIndexRequest(withBuilder: self)
    }
}

// MARK: - Index Exists Request Builder

public class IndexExistsRequestBuilder: RequestBuilder {
    public typealias RequestType = IndexExistsRequest

    private var _index: String?

    public init() {}

    @discardableResult
    public func set(index: String) -> IndexExistsRequestBuilder {
        _index = index
        return self
    }

    public var index: String? {
        return _index
    }

    public func build() throws -> IndexExistsRequest {
        return try IndexExistsRequest(withBuilder: self)
    }
}

// MARK: - Open Index Request Builder

public class OpenIndexRequestBuilder: RequestBuilder {
    public typealias RequestType = OpenIndexRequest

    private var _indices: [String] = []

    public init() {}

    @discardableResult
    public func set(indices: String...) -> OpenIndexRequestBuilder {
        _indices = indices
        return self
    }

    @discardableResult
    public func add(index: String) -> OpenIndexRequestBuilder {
        _indices.append(index)
        return self
    }

    public var indices: [String] {
        return _indices
    }

    public func build() throws -> OpenIndexRequest {
        return try OpenIndexRequest(withBuilder: self)
    }
}

// MARK: - Close Index Request Builder

public class CloseIndexRequestBuilder: RequestBuilder {
    public typealias RequestType = CloseIndexRequest

    private var _indices: [String] = []

    public init() {}

    @discardableResult
    public func set(indices: String...) -> CloseIndexRequestBuilder {
        _indices = indices
        return self
    }

    @discardableResult
    public func add(name: String) -> CloseIndexRequestBuilder {
        _indices.append(name)
        return self
    }

    public var indices: [String] {
        return _indices
    }

    public func build() throws -> CloseIndexRequest {
        return try CloseIndexRequest(withBuilder: self)
    }
}

// MARK: - Requests

// MARK: - Index Exists Request

public struct IndexExistsRequest: Request {
    public var headers = HTTPHeaders()

    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    internal init(withBuilder builder: IndexExistsRequestBuilder) throws {
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }

        self.init(builder.index!)
    }

    public var method: HTTPMethod {
        return .HEAD
    }

    public var endPoint: String {
        return name
    }

    public var queryParams: [URLQueryItem] {
        return []
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension IndexExistsRequest: Equatable {
    public static func == (lhs: IndexExistsRequest, rhs: IndexExistsRequest) -> Bool {
        return lhs.name == rhs.name
            && lhs.method == rhs.method
            && lhs.queryParams == rhs.queryParams
            && lhs.headers == rhs.headers
    }
}

// MARK: - Create Index Reqeust

public struct CreateIndexRequest: Request {
    public var headers = HTTPHeaders()

    public let name: String
    public let aliases: [IndexAlias]?
    public let mappings: [String: MappingMetaData]?
    public let settings: [String: CodableValue]?

    public var includeTypeName: Bool?

    public init(_ name: String, aliases: [IndexAlias]? = nil, mappings: [String: MappingMetaData]? = nil, settings: [String: CodableValue]? = nil) {
        self.name = name
        self.aliases = aliases
        self.mappings = mappings
        self.settings = settings
    }

    internal init(withBuilder builder: CreateIndexRequestBuilder) throws {
        guard builder.name != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }

        self.init(builder.name!, aliases: builder.aliases, mappings: builder.mappings, settings: builder.settings)
    }

    public var method: HTTPMethod {
        return .PUT
    }

    public var endPoint: String {
        return name
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let includeTypeName = self.includeTypeName {
            params.append(URLQueryItem(name: QueryParams.includeTypeName.rawValue, value: "\(includeTypeName)"))
        }
        return params
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        guard aliases != nil || mappings != nil || settings != nil else {
            return .failure(.noBodyForRequest)
        }
        let body = Body(aliases: aliases, mappings: mappings, settings: settings)
        return serializer.encode(body).mapError {
            error -> MakeBodyError in
            .wrapped(error)
        }
    }

    struct Body: Encodable {
        public let aliases: [IndexAlias]?
        public let mappings: [String: MappingMetaData]?
        public let settings: [String: CodableValue]?

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(mappings, forKey: .mappings)
            try container.encodeIfPresent(settings, forKey: .settings)
            if let aliases = self.aliases {
                let dic = Dictionary(uniqueKeysWithValues: aliases.map { ($0.name, $0.metaData) })
                try container.encode(dic, forKey: .aliases)
            }
        }

        enum CodingKeys: CodingKey {
            case aliases
            case mappings
            case settings
        }
    }
}

extension CreateIndexRequest: Equatable {
    public static func == (lhs: CreateIndexRequest, rhs: CreateIndexRequest) -> Bool {
        return lhs.name == rhs.name
            && lhs.aliases == rhs.aliases
            && lhs.method == rhs.method
            && lhs.mappings == rhs.mappings
            && lhs.settings == rhs.settings
            && lhs.includeTypeName == rhs.includeTypeName
    }
}

// MARK: - Get Index Request

public struct GetIndexRequest: Request {
    public var headers = HTTPHeaders()

    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    internal init(withBuilder builder: GetIndexRequestBuilder) throws {
        guard builder.name != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }

        self.init(builder.name!)
    }

    public var method: HTTPMethod {
        return .GET
    }

    public var endPoint: String {
        return name
    }

    public var queryParams: [URLQueryItem] {
        return []
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension GetIndexRequest: Equatable {
    public static func == (lhs: GetIndexRequest, rhs: GetIndexRequest) -> Bool {
        return lhs.name == rhs.name
            && lhs.headers == rhs.headers
            && lhs.method == rhs.method
            && lhs.queryParams == rhs.queryParams
    }
}

// MARK: - Delete Index Request

public struct DeleteIndexRequest: Request {
    public var headers = HTTPHeaders()

    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    internal init(withBuilder builder: DeleteIndexRequestBuilder) throws {
        guard builder.name != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }

        self.init(builder.name!)
    }

    public var method: HTTPMethod {
        return .DELETE
    }

    public var endPoint: String {
        return name
    }

    public var queryParams: [URLQueryItem] {
        return []
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension DeleteIndexRequest: Equatable {
    public static func == (lhs: DeleteIndexRequest, rhs: DeleteIndexRequest) -> Bool {
        return lhs.name == rhs.name
            && lhs.headers == rhs.headers
            && lhs.method == rhs.method
            && lhs.queryParams == rhs.queryParams
    }
}

// MARK: - Open Index Request

public struct OpenIndexRequest: Request {
    public var headers = HTTPHeaders()

    public let indices: [String]

    public init(_ indices: String...) {
        self.init(indices)
    }

    public init(_ indices: [String]) {
        self.indices = indices
    }

    internal init(withBuilder builder: OpenIndexRequestBuilder) throws {
        guard !builder.indices.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("indices")
        }

        self.init(builder.indices)
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        if indices.count == 1 {
            return indices[0] + "/_open"
        } else {
            return indices.joined(separator: ",") + "/_open"
        }
    }

    public var queryParams: [URLQueryItem] {
        return []
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension OpenIndexRequest: Equatable {
    public static func == (lhs: OpenIndexRequest, rhs: OpenIndexRequest) -> Bool {
        return lhs.indices == rhs.indices
            && lhs.method == rhs.method
            && lhs.queryParams == rhs.queryParams
            && lhs.endPoint == rhs.endPoint
    }
}

// MARK: - Close Index Request

public struct CloseIndexRequest: Request {
    public var headers = HTTPHeaders()

    public let indices: [String]

    public init(_ indices: String...) {
        self.init(indices)
    }

    public init(_ indices: [String]) {
        self.indices = indices
    }

    internal init(withBuilder builder: CloseIndexRequestBuilder) throws {
        guard !builder.indices.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("indices")
        }

        self.init(builder.indices)
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        return makeEndPoint()
    }

    public var queryParams: [URLQueryItem] {
        return []
    }

    func makeEndPoint() -> String {
        if indices.count == 1 {
            return indices[0] + "/_close"
        } else {
            return indices.joined(separator: ",") + "/_close"
        }
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension CloseIndexRequest: Equatable {
    public static func == (lhs: CloseIndexRequest, rhs: CloseIndexRequest) -> Bool {
        return lhs.indices == rhs.indices
            && lhs.method == rhs.method
            && lhs.queryParams == rhs.queryParams
            && lhs.endPoint == rhs.endPoint
    }
}
