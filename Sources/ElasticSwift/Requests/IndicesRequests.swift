//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import Logging
import NIOHTTP1

// MARK: -  Builders

public class CreateIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = CreateIndexRequest
    public typealias BuilderClosure = (CreateIndexRequestBuilder) -> Void
    
    var name: String?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func build() -> CreateIndexRequest {
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

public class CreateIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = CreateIndexResponse
    
    let name: String
    
    init(withBuilder builder: CreateIndexRequestBuilder) {
        self.name = builder.name!
    }
    
    func makeEndPoint() -> String {
        return self.name
    }
    
    public var method: HTTPMethod {
        get {
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
        }
    }
    
    public var body: Data {
        get {
            return Data()
        }
    }
}

public class GetIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = GetIndexResponse
    
    let name: String
    
    init(withBuilder builder: GetIndexRequestBuilder) {
        self.name = builder.name!
    }
    
    func makeEndPoint() -> String {
        return self.name
    }
    
    public var method: HTTPMethod {
        get {
            return .GET
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
        }
    }
    
    public var body: Data {
        get {
            return Data()
        }
    }
}

public class DeleteIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = AcknowledgedResponse
    
    let name: String
    
    init(withBuilder builder: DeleteIndexRequestBuilder) {
        self.name = builder.name!
    }
    
    func makeEndPoint() -> String {
        return self.name
    }
    
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
        }
    }
    
    public var body: Data {
        get {
            return Data()
        }
    }
}

// MARK: - Response

public struct CreateIndexResponse: Codable {
    
    public let acknowledged: Bool
    public let shardsAcknowledged: Bool
    public let index: String
    
    init(acknowledged: Bool, shardsAcknowledged: Bool, index: String) {
        self.acknowledged = acknowledged
        self.shardsAcknowledged = shardsAcknowledged
        self.index = index
    }
    
    enum CodingKeys: String, CodingKey {
        case acknowledged
        case shardsAcknowledged = "shards_acknowledged"
        case index
    }
    
}

public struct GetIndexResponse: Codable {
    
    public let aliases: [String: AliasMetaData]
    public let mappings: [String: MappingMetaData]
    public let settings: IndexSettings
    
    init(aliases: [String: AliasMetaData]=[:], mappings: [String: MappingMetaData]=[:], settings: IndexSettings) {
        self.aliases = aliases
        self.mappings = mappings
        self.settings = settings
    }
    
    private struct CK : CodingKey {
        
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    private struct GI: Codable {
        public let aliases: [String: AliasMetaData]
        public let mappings: Properties
        public let settings: Settings
        
        public init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.aliases = try container.decode([String: AliasMetaData].self, forKey: .aliases)
            self.settings = try container.decode(Settings.self, forKey: .settings)
            do {
                self.mappings = try container.decode(Properties.self, forKey: .mappings)
            } catch {
                let dic = try container.decode(Dictionary<String, Properties>.self, forKey: .mappings)
                if let val = dic.values.first {
                    self.mappings = val
                } else {
                    self.mappings = Properties(properties: [:])
                }
            }
        }
    }
    
    private struct Properties: Codable {
        let properties: [String: MappingMetaData]
    }
    
    private struct Settings: Codable {
        public let index: IndexSettings
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let dic = try container.decode(Dictionary<String, GI>.self)
        let val = dic.values.first!
        self.aliases = val.aliases
        self.mappings = val.mappings.properties
        self.settings = val.settings.index
    }
}

public struct AcknowledgedResponse: Codable {
    
    public let acknowledged: Bool
    
    init(acknowledged: Bool) {
        self.acknowledged = acknowledged
    }
}

public struct MappingMetaData: Codable {
    
    public let type: String?
    public let fields: Fields?
    
    public struct Fields: Codable {
        public let keyword: Keyword
        
        public struct Keyword: Codable {
            public let type: String
            public let ignoreAbove: Int?
            
            enum CodingKeys: String, CodingKey {
                case type
                case ignoreAbove = "ignore_above"
            }
        }
    }
    
}

public struct AliasMetaData: Codable {
    
    public let indexRouting: String?
    public let searchRouting: String?
    
    enum CodingKeys: String, CodingKey {
        case indexRouting = "index_routing"
        case searchRouting = "search_routing"
    }
}

public struct IndexSettings: Codable {
    
    public let creationDate: String
    public let numberOfShards: String
    public let numberOfReplicas: String
    public let uuid: String
    public let providedName: String
    public let version: IndexVersion
    
    init(creationDate: String, numberOfShards: String, numberOfReplicas: String, uuid: String, providedName: String, version: IndexVersion) {
        self.creationDate = creationDate
        self.numberOfShards = numberOfShards
        self.numberOfReplicas = numberOfReplicas
        self.uuid = uuid
        self.providedName = providedName
        self.version = version
    }
    
    enum CodingKeys: String, CodingKey {
        case creationDate = "creation_date"
        case numberOfShards = "number_of_shards"
        case numberOfReplicas = "number_of_replicas"
        case uuid
        case providedName = "provided_name"
        case version
    }
    
}

public struct IndexVersion: Codable {
    public let created: String
    
    init(created: String) {
        self.created = created
    }
}
