//
//  Response.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import ElasticSwiftCodableUtils

//MARK:- Get Response

public struct GetResponse<T: Codable>: Codable, Equatable where T: Equatable {
    
    public let index: String
    public let type: String?
    public let id: String
    public let version: Int?
    public let found: Bool
    public let source: T?
    public let seqNumber: Int?
    public let primaryTerm: Int?
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case source = "_source"
        case found
        case seqNumber = "_seq_no"
        case primaryTerm = "_primary_term"
    }
}

//MARK:- Index Response

public struct IndexResponse: Codable, Equatable {
    
    public let shards: Shards
    public let index: String
    public let type: String
    public let id: String
    public let version: Int
    public let seqNumber: Int
    public let primaryTerm: Int
    public let result: String
    
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

//MARK:- Search Response

public struct SearchResponse<T: Codable>: Codable, Equatable where T: Equatable {
    
    public let took: Int
    public let timedOut: Bool
    public let shards: Shards
    public let hits: Hits<T>
    
    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
    }
}

public struct Shards: Codable, Equatable {
    
    public let total: Int
    public let successful: Int
    public let skipped: Int?
    public let failed: Int
    
}


public struct Hits<T: Codable>: Codable, Equatable where T: Equatable {
    
    public let total: Int
    public let maxScore: Decimal?
    public let hits: [SearchHit<T>]
    
    public init(total: Int, maxScore: Decimal?, hits: [SearchHit<T>] = []) {
        self.total = total
        self.maxScore = maxScore
        self.hits = hits
    }
    
    enum CodingKeys: String, CodingKey {
        case total
        case maxScore = "max_score"
        case hits
    }
    
}


public struct SearchHit<T: Codable>: Codable, Equatable where T: Equatable {
    
    public let index: String
    public let type: String
    public let id: String
    public let score: Decimal?
    public let source: T?
    public let sort: [CodableValue]?
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case score = "_score"
        case source = "_source"
        case sort
    }
}

//MARK:- Delete Response

public struct DeleteResponse: Codable, Equatable {
    
    public let shards: Shards
    public let index: String
    public let type: String
    public let id: String
    public let version: Int
    public let seqNumber: Int
    public let primaryTerm: Int
    public let result: String
    
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

// MARK:- Delete By Query Response

public struct DeleteByQueryResponse: Codable, Equatable {
    
    public let took: Int
    public let timedOut: Bool
    public let total: Int
    public let deleted: Int
    public let batches: Int
    public let versionConflicts: Int
    public let noops: Int
    public let retries: Retires
    public let throlledMillis: Int
    public let requestsPerSecond: Int
    public let throlledUntilMillis: Int
    public let failures: [CodableValue]
    
    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case total
        case deleted
        case batches
        case versionConflicts = "version_conflicts"
        case noops
        case retries
        case throlledMillis = "throttled_millis"
        case requestsPerSecond = "requests_per_second"
        case throlledUntilMillis = "throttled_until_millis"
        case failures
    }
    
}

public struct Retires: Codable, Equatable {
    
    public let bulk: Int
    public let search: Int
}

// MARK:- Update By Query Response

public struct UpdateByQueryResponse: Codable, Equatable {
    
    public let took: Int
    public let timedOut: Bool
    public let total: Int
    public let updated: Int
    public let deleted: Int
    public let batches: Int
    public let versionConflicts: Int
    public let noops: Int
    public let retries: Retires
    public let throlledMillis: Int
    public let requestsPerSecond: Int
    public let throlledUntilMillis: Int
    public let failures: [CodableValue]
    
    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case total
        case deleted
        case updated
        case batches
        case versionConflicts = "version_conflicts"
        case noops
        case retries
        case throlledMillis = "throttled_millis"
        case requestsPerSecond = "requests_per_second"
        case throlledUntilMillis = "throttled_until_millis"
        case failures
    }
    
}

// MARK:- Multi Get Response

public struct MultiGetResponse: Codable, Equatable {
    
    public let responses: [MultiGetItemResponse]
    
    public struct Failure: Codable, Equatable {
        public let index: String
        public let id: String
        public let type: String?
        public let error: ElasticError
        
        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case id = "_id"
            case type = "_type"
            case error
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case responses = "docs"
    }
    
}

public struct MultiGetItemResponse: Codable, Equatable {
    
    public let response: GetResponse<CodableValue>?
    public let failure: MultiGetResponse.Failure?
    
    public func encode(to encoder: Encoder) throws {
        if let response = self.response {
            try response.encode(to: encoder)
        } else {
            try failure.encode(to: encoder)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.response = try container.decode(GetResponse<CodableValue>.self)
            self.failure = nil
        } catch {
            self.failure = try container.decode(MultiGetResponse.Failure.self)
            self.response = nil
        }
    }
}

// MARK:- UPDATE RESPONSE

public struct UpdateResponse: Codable, Equatable {
    
    public let shards: Shards
    public let index: String
    public let type: String
    public let id: String
    public let version: Int
    public let result: String
    
    
    private enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case result
    }
}

// MARK:- ReIndex Response

public struct ReIndexResponse: Codable, Equatable {
    
    public let took: Int
    public let timeout: Bool
    public let created: Int
    public let updated: Int
    public let deleted: Int
    public let batches: Int
    public let versionConflicts: Int
    public let noops: Int
    public let retries: Retries
    public let throttledMillis: Int
    public let requestsPerSecond: Int
    public let throttledUntilMillis: Int
    public let total: Int
    public let failures: [CodableValue]
    
    public struct Retries: Codable, Equatable {
        public let bulk: Int
        public let search: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case took
        case timeout = "timed_out"
        case created
        case updated
        case deleted
        case batches
        case versionConflicts = "version_conflicts"
        case noops
        case retries
        case throttledMillis = "throttled_millis"
        case requestsPerSecond = "requests_per_second"
        case throttledUntilMillis = "throttled_until_millis"
        case total
        case failures
    }
}
