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

public class CreateIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = CreateIndexRequest
    public typealias BuilderClosure = (CreateIndexRequestBuilder) -> Void
    
    var name: String?
    var settings: [String: CodableValue]?
    var mappings: [String: MappingMetaData]?
    var aliases: [IndexAlias]?
    
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(settings: [String: CodableValue]) -> Self {
        self.settings = settings
        return self
    }
    
    public func set(mappings: [String: MappingMetaData]) -> Self {
        self.mappings = mappings
        return self
    }
    
    public func set(aliases: [IndexAlias]) -> Self {
        self.aliases = aliases
        return self
    }
    
    public func build() throws -> CreateIndexRequest {
        
        guard self.name != nil else {
            throw RequestBuilderError.missingRequiredField("name")
        }
        
        return CreateIndexRequest(withBuilder: self)
    }
}

public class DeleteIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = DeleteIndexRequest
    
    public typealias BuilderClosure = (DeleteIndexRequestBuilder) -> Void
    
    var name: String?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func build() throws -> DeleteIndexRequest {
        return DeleteIndexRequest(withBuilder: self)
    }
}

public class GetIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = GetIndexRequest
    
    public typealias BuilderClosure = (GetIndexRequestBuilder) -> Void
    
    var name: String?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func build() throws -> GetIndexRequest {
        return GetIndexRequest(withBuilder: self)
    }
}

// MARK: - Requests


//MARK:- Index Exists Request

public class IndexExistsRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public let name: String
    
    public init(name: String) {
        self.name = name
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
    
    public init(name: String, aliases: [IndexAlias]? = nil, mappings: [String: MappingMetaData]? = nil, settings: [String: CodableValue]? = nil) {
        self.name = name
        self.aliases = aliases
        self.mappings = mappings
        self.settings = settings
    }
    
    init(withBuilder builder: CreateIndexRequestBuilder) {
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
    
    public var queryParams: [URLQueryItem] = []
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    init(withBuilder builder: GetIndexRequestBuilder) {
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
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
    
}

//MARK:- Delete Index Request

public class DeleteIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    init(withBuilder builder: DeleteIndexRequestBuilder) {
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
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

//MARK:- Open Index Request

public class OpenIndexRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []

    
    public let names: [String]
    
    public init(_ name: String) {
        self.names = [name]
    }
    
    public init(_ names: [String]) {
        self.names = names
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            if self.names.count == 1 {
                return self.names[0] + "/_open"
            } else {
                return self.names.joined(separator: ",") + "/_open"
            }
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

//MARK:- Close Index Request

public class CloseIndexRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public let names: [String]
    
    public init(_ name: String) {
        self.names = [name]
    }
    
    public init(_ names: [String]) {
        self.names = names
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
    
    func makeEndPoint() -> String {
        if self.names.count == 1 {
            return self.names[0] + "/_close"
        } else {
            return self.names.joined(separator: ",") + "/_close"
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}
