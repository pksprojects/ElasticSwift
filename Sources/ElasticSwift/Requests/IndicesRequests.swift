//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore
import ElasticSwiftCodableUtils

// MARK: -  Builders

// MARK:- Create Index Request Builder

public class CreateIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = CreateIndexRequest
    
    private var _name: String?
    private var _settings: [String: CodableValue]?
    private var _mappings: [String: MappingMetaData]?
    private var _aliases: [IndexAlias]?
    
    public init() {}
    
    public func set(name: String) -> CreateIndexRequestBuilder {
        self._name = name
        return self
    }
    
    public func set(settings: [String: CodableValue]) -> CreateIndexRequestBuilder {
        self._settings = settings
        return self
    }
    
    public func set(mappings: [String: MappingMetaData]) -> CreateIndexRequestBuilder {
        self._mappings = mappings
        return self
    }
    
    public func set(aliases: [IndexAlias]) -> CreateIndexRequestBuilder {
        self._aliases = aliases
        return self
    }
    
    public var name: String? {
        return self._name
    }
    public var settings: [String: CodableValue]? {
        return self._settings
    }
    public var mappings: [String: MappingMetaData]? {
        return self._mappings
    }
    public var aliases: [IndexAlias]? {
        return self._aliases
    }
    
    public func build() throws -> CreateIndexRequest {
        return try CreateIndexRequest(withBuilder: self)
    }
}

// MARK:- Delete Index Request Builder

public class DeleteIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = DeleteIndexRequest
    
    private var _name: String?
    
    public init() {}
    
    @discardableResult
    public func set(name: String) -> DeleteIndexRequestBuilder {
        self._name = name
        return self
    }
    
    public var name: String? {
        return self._name
    }
    
    public func build() throws -> DeleteIndexRequest {
        return try DeleteIndexRequest(withBuilder: self)
    }
}

// MARK:- Get Index Request Builder

public class GetIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = GetIndexRequest
    
    private var _name: String?
    
    public init() {}
    
    @discardableResult
    public func set(name: String) -> GetIndexRequestBuilder {
        self._name = name
        return self
    }
    
    public var name: String? {
        return self._name
    }
    
    public func build() throws -> GetIndexRequest {
        return try GetIndexRequest(withBuilder: self)
    }
}

// MARK:- Index Exists Request Builder

public class IndexExistsRequestBuilder: RequestBuilder {
    
    public typealias RequestType = IndexExistsRequest
    
    private var _index: String?
    
    public init() {}
    
    @discardableResult
    public func set(index: String) -> IndexExistsRequestBuilder {
        self._index = index
        return self
    }
    
    public var index: String? {
        return self._index
    }
    
    public func build() throws -> IndexExistsRequest {
        return try IndexExistsRequest(withBuilder: self)
    }
}

// MARK:- Open Index Request Builder

public class OpenIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = OpenIndexRequest
    
    private var _indices: [String] = []
    
    public init() {}
    
    @discardableResult
    public func set(indices: String...) -> OpenIndexRequestBuilder {
        self._indices = indices
        return self
    }
    
    @discardableResult
    public func add(index: String) -> OpenIndexRequestBuilder {
        self._indices.append(index)
        return self
    }
    
    public var indices: [String] {
        return self._indices
    }
    
    public func build() throws -> OpenIndexRequest {
        return try OpenIndexRequest(withBuilder: self)
    }
}

// MARK:- Close Index Request Builder

public class CloseIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = CloseIndexRequest
    
    private var _indices: [String] = []
    
    public init() {}
    
    @discardableResult
    public func set(indices: String...) -> CloseIndexRequestBuilder {
        self._indices = indices
        return self
    }
    
    @discardableResult
    public func add(name: String) -> CloseIndexRequestBuilder {
        self._indices.append(name)
        return self
    }
    
    public var indices: [String] {
        return self._indices
    }
    
    public func build() throws -> CloseIndexRequest {
        return try CloseIndexRequest(withBuilder: self)
    }
}

// MARK: - Requests


//MARK:- Index Exists Request

public class IndexExistsRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    internal init(withBuilder builder:  IndexExistsRequestBuilder) throws {
        
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }
        
        self.name = builder.index!
    }
    
    public var method: HTTPMethod {
        get {
            return .HEAD
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public var queryParams: [URLQueryItem] {
        return []
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}


//MARK:- Create Index Reqeust

public class CreateIndexRequest: Request, Encodable {
    public var headers: HTTPHeaders = HTTPHeaders()
    
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
        
        self.name = builder.name!
        self.aliases = builder.aliases
        self.mappings = builder.mappings
        self.settings = builder.settings
    }
    
    public var method: HTTPMethod {
        get {
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var params = [URLQueryItem]()
            if let includeTypeName = self.includeTypeName {
                params.append(URLQueryItem(name: QueryParams.includeTypeName.rawValue, value: "\(includeTypeName)"))
            }
            return params
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        guard self.aliases != nil || self.mappings != nil || self.settings != nil else {
            return .failure(.noBodyForRequest)
        }
        return serializer.encode(self).mapError {
            error -> MakeBodyError in
            return .wrapped(error)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.mappings, forKey: .mappings)
        try container.encodeIfPresent(self.settings, forKey: .settings)
        if let aliases = self.aliases {
            let dic = Dictionary(uniqueKeysWithValues: aliases.map{ ($0.name, $0.metaData)})
            try container.encode(dic, forKey: .aliases)
        }
    }
    
    enum CodingKeys: CodingKey {
        case aliases
        case mappings
        case settings
    }
}

//MARK:- Get Index Request

public class GetIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    internal init(withBuilder builder: GetIndexRequestBuilder) throws {
        
        guard builder.name != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }
        
        self.name = builder.name!
    }
    
    public var method: HTTPMethod {
        get {
            return .GET
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public var queryParams: [URLQueryItem] {
        return []
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
    
}

//MARK:- Delete Index Request

public class DeleteIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    internal init(withBuilder builder: DeleteIndexRequestBuilder) throws {
        
        guard builder.name != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }
        
        self.name = builder.name!
    }
    
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public var queryParams: [URLQueryItem] {
        return []
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

//MARK:- Open Index Request

public class OpenIndexRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let indices: [String]
    
    public init(_ indices: String...) {
        self.indices = indices
    }
    
    public init(_ indices: [String]) {
        self.indices = indices
    }
    
    internal convenience init(withBuilder builder: OpenIndexRequestBuilder) throws {
        
        guard !builder.indices.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("indices")
        }
        
        self.init(builder.indices)
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            if self.indices.count == 1 {
                return self.indices[0] + "/_open"
            } else {
                return self.indices.joined(separator: ",") + "/_open"
            }
        }
    }
    
    public var queryParams: [URLQueryItem] {
        return []
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

//MARK:- Close Index Request

public class CloseIndexRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let indices: [String]
    
    public init(_ indices: String...) {
        self.indices = indices
    }
    
    public init(_ indices: [String]) {
        self.indices = indices
    }
    
    internal convenience init(withBuilder builder: CloseIndexRequestBuilder) throws {
        
        guard !builder.indices.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("indices")
        }
        
        self.init(builder.indices)
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
        }
    }
    
    public var queryParams: [URLQueryItem] {
        return []
    }
    
    func makeEndPoint() -> String {
        if self.indices.count == 1 {
            return self.indices[0] + "/_close"
        } else {
            return self.indices.joined(separator: ",") + "/_close"
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}
