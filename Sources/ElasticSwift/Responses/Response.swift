//
//  Response.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

public class ESResponse {
    
    public let data: Data?
    public let httpResponse: URLResponse?
    public let error: Error?
    //TODO: add completion handler
    
    init(data: Data? ,httpResponse: URLResponse?, error: Error?) {
        self.data = data
        self.httpResponse = httpResponse
        self.error = error
    }
}

struct ResponseConstants {
    struct Errors {
        enum ResponseError : Error {
            case NoDataReturned
        }
    }
}

public protocol Response : Codable {
    
    static func create(fromESResponse response: ESResponse, withSerializer serializer: Serializer) throws -> Self
}

extension Response {
    
    public static func create(fromESResponse response: ESResponse, withSerializer serializer: Serializer) throws -> Self {
        
        if let error = response.error {
            throw error
        }
        
        guard let data = response.data else {
            throw ResponseConstants.Errors.ResponseError.NoDataReturned
        }
        
        
        var decodingError : Error? = nil
        do {
            let decoded = try serializer.decode(data: data) as Self
            return decoded
        } catch {
            decodingError = error
        }
        
        do {
            let esError = try ElasticsearchError.create(fromESResponse: response, withSerializer: serializer)
            throw esError
        } catch {
            let message = "Error decoding response with data: " + (String(bytes: data, encoding: .utf8) ?? "nil") + " Underlying error: " + (decodingError?.localizedDescription ?? "nil")
            throw RequestConstants.Errors.Response.Deserialization(content: message)
        }
    }
    
}

public class GetResponse<T: Codable>: Response {
  
    public var index: String
    public var type: String?
    public var id: String
    public var version: Int
    public var found: Bool
    
    public var source: T?
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case source = "_source"
        
        case found
    }
    
}

public class IndexResponse: Response {
    
    public var shards: Shards
    public var index: String
    public var type: String?
    public var id: String
    public var version: Int?
    public var seqNumber: Int?
    public var primaryTerm: Int?
    public var result: String
    
    enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case seqNumber = "_seq_no"
        case primaryTerm = "_primary_term"
        case result
    }
}

public class SearchResponse<T: Codable>: Response {
    
    public var took: Int
    public var timedOut: Bool
    public var shards: Shards
    public var hits: Hits<T>?
    
    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
    }
}

public class Shards: Codable {
    
    public var total: Int
    public var successful: Int
    public var skipped: Int?
    public var failed: Int
    
}


public class Hits<T: Codable>: Response {
    
    public var total: Total?
    public var maxScore: Decimal?

    public var hits: [SearchHit<T>] = []
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case total
        case maxScore = "max_score"
        case hits
    }
    
}


public class SearchHit<T: Codable>: Response {
    
    public var index: String?
    public var type: String?
    public var id: String?
    public var score: Decimal?
    public var source: T?
    
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case score = "_score"
        case source = "_source"
    }
}

public class Total : Response {
    
    public var value: Int?
    public var relation: String?
    
    init() {
    
    }
}

public class DeleteResponse: Response {
    
    public var shards: Shards
    public var index: String
    public var type: String?
    public var id: String
    public var version: Int?
    public var seqNumber: Int?
    public var primaryTerm: Int?
    public var result: String
    
    enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case seqNumber = "_seq_no"
        case primaryTerm = "_primary_term"
        case result
    }
}

public class UpdateResponse : Response {
    
}

//MARK: - Indexes

public class CreateIndexResponse: Response {
    
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

public class GetIndexResponse: Response {
    
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
                self.mappings = dic.values.first!
            }
        }
    }
    
    private struct Properties: Codable {
        let properties: [String: MappingMetaData]
    }
    
    private struct Settings: Codable {
        public let index: IndexSettings
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let dic = try container.decode(Dictionary<String, GI>.self)
        let val = dic.values.first!
        self.aliases = val.aliases
        self.mappings = val.mappings.properties
        self.settings = val.settings.index
    }
}

public class DeleteIndexResponse: Response {
    
    public let acknowledged: Bool
    
    init(acknowledged: Bool) {
        self.acknowledged = acknowledged
    }
}

public class MappingMetaData: Codable {
    
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

public class AliasMetaData: Codable {
    
    public let indexRouting: String?
    public let searchRouting: String?
    
    enum CodingKeys: String, CodingKey {
        case indexRouting = "index_routing"
        case searchRouting = "search_routing"
    }
}

public class IndexSettings: Codable {
    
    public let creationDate: Date
    public let numberOfShards: String
    public let numberOfReplicas: String
    public let uuid: String
    public let providedName: String
    public let version: IndexVersion
    
    init(creationDate: Date, numberOfShards: String, numberOfReplicas: String, uuid: String, providedName: String, version: IndexVersion) {
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

public class IndexVersion: Codable {
    public let created: String
    
    init(created: String) {
        self.created = created
    }
}
