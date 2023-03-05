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

// MARK: - Resize Request Builder

public class ResizeRequestBuilder: RequestBuilder {
    public typealias ElasticSwiftType = ResizeRequest

    private var _targetIndexRequest: CreateIndexRequest?
    private var _sourceIndex: String?
    private var _resizeType: ResizeType?
    private var _copySettings: Bool?
    private var _timeout: String?
    private var _masterTimeout: String?
    private var _waitForActiveShards: String?

    public init() {}

    @discardableResult
    public func set(targetIndexRequest: CreateIndexRequest) -> Self {
        _targetIndexRequest = targetIndexRequest
        return self
    }

    @discardableResult
    public func set(sourceIndex: String) -> Self {
        _sourceIndex = sourceIndex
        return self
    }

    @discardableResult
    public func set(resizeType: ResizeType) -> Self {
        _resizeType = resizeType
        return self
    }

    @discardableResult
    public func set(copySettings: Bool) -> Self {
        _copySettings = copySettings
        return self
    }

    @discardableResult
    public func set(timeout: String) -> Self {
        _timeout = timeout
        return self
    }

    @discardableResult
    public func set(masterTimeout: String) -> Self {
        _masterTimeout = masterTimeout
        return self
    }

    @discardableResult
    public func set(waitForActiveShards: String) -> Self {
        _waitForActiveShards = waitForActiveShards
        return self
    }

    public var targetIndexRequest: CreateIndexRequest? {
        return _targetIndexRequest
    }

    public var sourceIndex: String? {
        return _sourceIndex
    }

    public var resizeType: ResizeType? {
        return _resizeType
    }

    public var copySettings: Bool? {
        return _copySettings
    }

    public var timeout: String? {
        return _timeout
    }

    public var masterTimeout: String? {
        return _masterTimeout
    }

    public var waitForActiveShards: String? {
        return _waitForActiveShards
    }

    public func build() throws -> ResizeRequest {
        return try ResizeRequest(withBuilder: self)
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

// MARK: - Resize Request

public struct ResizeRequest: Request {
    public var headers = HTTPHeaders()

    public let targetIndexRequest: CreateIndexRequest
    public let sourceIndex: String
    public let resizeType: ResizeType
    public var copySettings: Bool?
    public var timeout: String?
    public var masterTimeout: String?
    public var waitForActiveShards: String?

    public init(sourceIndex: String, targetIndexRequest: CreateIndexRequest, resizeType: ResizeType, copySettings: Bool? = nil, timeout: String? = nil, masterTimeout: String? = nil, waitForActiveShards: String? = nil) {
        self.targetIndexRequest = targetIndexRequest
        self.sourceIndex = sourceIndex
        self.resizeType = resizeType
        self.copySettings = copySettings
        self.timeout = timeout
        self.masterTimeout = masterTimeout
        self.waitForActiveShards = waitForActiveShards
    }

    internal init(withBuilder builder: ResizeRequestBuilder) throws {
        guard let sourceIndex = builder.sourceIndex else {
            throw RequestBuilderError.missingRequiredField("sourceIndex")
        }

        guard let targetIndexRequest = builder.targetIndexRequest else {
            throw RequestBuilderError.missingRequiredField("targetIndexRequest")
        }

        guard let resizeType = builder.resizeType else {
            throw RequestBuilderError.missingRequiredField("resizeType")
        }

        self.init(sourceIndex: sourceIndex, targetIndexRequest: targetIndexRequest, resizeType: resizeType, copySettings: builder.copySettings, timeout: builder.timeout, masterTimeout: builder.masterTimeout, waitForActiveShards: builder.waitForActiveShards)
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        return "\(sourceIndex)/\(resizeType == ResizeType.shrink ? "_shrink" : "_split")/\(targetIndexRequest.name)"
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let copySettings = self.copySettings {
            queryItems.append(URLQueryItem(name: QueryParams.copySettings, value: copySettings))
        }
        if let timeout = self.timeout {
            queryItems.append(URLQueryItem(name: QueryParams.timeout, value: timeout))
        }
        if let masterTimeout = self.masterTimeout {
            queryItems.append(URLQueryItem(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        if let waitForActiveShards = self.waitForActiveShards {
            queryItems.append(URLQueryItem(name: QueryParams.waitForActiveShards, value: waitForActiveShards))
        }
        return queryItems
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        guard targetIndexRequest.aliases != nil || targetIndexRequest.settings != nil else {
            return .failure(.noBodyForRequest)
        }
        let body = Body(aliases: targetIndexRequest.aliases, settings: targetIndexRequest.settings)
        return serializer.encode(body).mapError {
            error -> MakeBodyError in
            .wrapped(error)
        }
    }

    struct Body: Encodable {
        public let aliases: [IndexAlias]?
        public let settings: [String: CodableValue]?

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(settings, forKey: .settings)
            if let aliases = self.aliases {
                let dic = Dictionary(uniqueKeysWithValues: aliases.map { ($0.name, $0.metaData) })
                try container.encode(dic, forKey: .aliases)
            }
        }

        enum CodingKeys: CodingKey {
            case aliases
            case settings
        }
    }
}

extension ResizeRequest: Equatable {}

public enum ResizeType: String, Codable {
    case shrink
    case split
}

// MARK: - Rollover Request

public struct RolloverRequest: Request {
    public var headers = HTTPHeaders()
    
    public let alias: String
    public let conditions: [String: CodableValue]
    public var newIndexName: String?
    public var dryRun: Bool?
    public var includeTypeName: Bool?
    public var timeout: String?
    public var masterTimeout: String?
    public var waitForActiveShards: String?
    
    
    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let includeTypeName = self.includeTypeName {
            queryItems.append(URLQueryItem(name: QueryParams.includeTypeName, value: includeTypeName))
        }
        if let dryRun = self.dryRun {
            queryItems.append(URLQueryItem(name: QueryParams.dryRun, value: dryRun))
        }
        if let timeout = self.timeout {
            queryItems.append(URLQueryItem(name: QueryParams.timeout, value: timeout))
        }
        if let masterTimeout = self.masterTimeout {
            queryItems.append(URLQueryItem(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        if let waitForActiveShards = self.waitForActiveShards {
            queryItems.append(URLQueryItem(name: QueryParams.waitForActiveShards, value: waitForActiveShards))
        }
        return queryItems
    }
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var endPoint: String {
        var _endPoint = "\(self.alias)/_rollover"
        if let newIndexName = self.newIndexName {
            _endPoint = _endPoint + "/\(newIndexName)"
        }
        return _endPoint
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return serializer.encode(Body(conditions: self.conditions)).mapError {
            error -> MakeBodyError in
            .wrapped(error)
        }
    }
    
    struct Body: Encodable {
        let conditions: [String: CodableValue]
    }
    
}

extension RolloverRequest: Equatable {}
