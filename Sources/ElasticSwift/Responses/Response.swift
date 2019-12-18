//
//  Response.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import ElasticSwiftCore
import ElasticSwiftCodableUtils

//MARK:- Get Response

/// A response for get request
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
    public let scrollId: String?
    
    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
        case scrollId = "_scroll_id"
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

// MARK:- TermVectors Response

public struct TermVectorsResponse: Codable, Equatable {
    
    public let id: String?
    public let index: String
    public let type: String
    public let version: Int?
    public let found: Bool
    public let took: Int
    public let termVerctors: [TermVector]
    
    public init(from decoder: Decoder) throws {
        let container =  try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeStringIfPresent(forKey: .id)
        self.index =  try container.decodeString(forKey: .index)
        self.type = try container.decodeString(forKey: .type)
        self.version = try container.decodeIntIfPresent(forKey: .version)
        self.found = try container.decodeBool(forKey: .found)
        self.took = try container.decodeInt(forKey: .took)
        do {
            let dic = try container.decode([String: TermVectorMetaData].self, forKey: .termVerctors)
            self.termVerctors = dic.map { key, value -> TermVector in
                return TermVector(field: key, fieldStatistics: value.fieldStatistics, terms: value.terms)
            }
        } catch Swift.DecodingError.keyNotFound(let key, let context) {
            if key.stringValue == CodingKeys.termVerctors.stringValue {
                self.termVerctors = []
            } else {
                throw Swift.DecodingError.keyNotFound(key, context)
            }
            
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case index = "_index"
        case type = "_type"
        case version
        case found
        case took
        case termVerctors = "term_vectors"
    }
    
    public struct TermVector: Codable, Equatable {
        public let field: String
        public let fieldStatistics: FieldStatistics?
        public let terms: [Term]
        
        enum CodingKeys: String, CodingKey {
            case field
            case fieldStatistics = "field_statistics"
            case terms
        }
    }
    
    public struct TermVectorMetaData: Codable, Equatable {
        public let fieldStatistics: FieldStatistics?
        public let terms: [Term]
        
        public init(from decoder: Decoder) throws {
            let container =  try decoder.container(keyedBy: CodingKeys.self)
            self.fieldStatistics = try container.decodeIfPresent(FieldStatistics.self, forKey: .fieldStatistics)
            let dic =  try container.decode([String: TermStatistics].self, forKey: .terms)
            self.terms = dic.map { key, value -> Term in
                return Term(term: key, termStatistics: value)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case fieldStatistics = "field_statistics"
            case terms
        }
    }
    
    
    public struct FieldStatistics: Codable, Equatable {
        
        public let docCount: Int
        public let sumDocFreq: Int
        public let sumTtf: Int
        
        enum CodingKeys: String, CodingKey {
            case docCount = "doc_count"
            case sumDocFreq = "sum_doc_freq"
            case sumTtf = "sum_ttf"
        }
    }
    
    public struct Term: Codable, Equatable {
        public let term: String
        public let docFreq: Int?
        public let termFreq: Int
        public let tokens: [Token]
        public let ttf: Int?
        
        public init(term: String, termStatistics: TermStatistics) {
            self.term = term
            self.docFreq = termStatistics.docFreq
            self.termFreq =  termStatistics.termFreq
            self.tokens = termStatistics.tokens ?? []
            self.ttf = termStatistics.ttf
        }
        
    }
    
    public struct TermStatistics: Codable, Equatable {
        
        public let docFreq: Int?
        public let termFreq: Int
        public let tokens: [Token]?
        public let ttf: Int?
        
        enum CodingKeys: String, CodingKey {
            case docFreq = "doc_freq"
            case termFreq = "term_freq"
            case tokens
            case ttf
        }
    }
    
    public struct Token: Codable, Equatable {
        public let payload: String?
        public let position: Int
        public let startOffset: Int
        public let endOffset: Int
        
        enum CodingKeys: String, CodingKey {
            case payload
            case position
            case startOffset = "start_offset"
            case endOffset = "end_offset"
        }
    }
}

// MARK:- Multi Term Vectors Response

public struct MultiTermVectorsResponse: Codable {
    
    public let responses: [TermVectorsResponse]
    
    enum CodingKeys: String, CodingKey {
        case responses = "docs"
    }
    
}

extension MultiTermVectorsResponse: Equatable {}

// MARK:- Bulk Response

public struct BulkResponse: Codable {
    public let took: Int
    public let errors: Bool
    public let items: [BulkResponseItem]
    
    public struct BulkResponseItem: Codable, Equatable {
        public let opType: OpType
        public let response: SuccessResponse?
        public let failure: Failure?
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
            
            guard container.allKeys.first != nil else {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unable to Determine OpType CodingKey in \(container.allKeys)"))
            }
            
            let opTypeKey = container.allKeys.first!
            if let opType = OpType(rawValue: opTypeKey.stringValue) {
                self.opType = opType
            } else {
                throw Swift.DecodingError.dataCorruptedError(forKey: container.allKeys.first!, in: container, debugDescription: "Unable to determine OpType from value: \(opTypeKey.stringValue)")
            }
            do {
                self.response = try container.decode(SuccessResponse.self, forKey: opTypeKey)
                self.failure = nil
            } catch {
                self.response = nil
                self.failure = try container.decode(Failure.self, forKey: opTypeKey)
            }
        }
    }
    
    public struct SuccessResponse: Codable, Equatable {
        public let index: String
        public let type: String
        public let id: String
        public let status: Int
        public let result: Result
        public let shards: Shards
        public let version: Int
        public let seqNo: Int
        public let primaryTerm: Int
        
        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case type = "_type"
            case id = "_id"
            case status
            case result
            case shards = "_shards"
            case seqNo = "_seq_no"
            case primaryTerm = "_primary_term"
            case version = "_version"
        }
    }
    
    public struct Failure: Codable, Equatable {
        public let index: String
        public let type: String
        public let id: String
        public let cause: ElasticError
        public let status: Int
        public let aborted: Bool?
        
        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case type = "_type"
            case id = "_id"
            case cause = "error"
            case status
            case aborted
        }
    }
    
    public enum Result: String, Codable {
        case created
        case updated
        case deleted
        case notFount = "not_found"
        case noop
    }
}

extension BulkResponse: Equatable {}

// MARK:- Clear Scroll Response

public struct ClearScrollResponse: Codable {
    
    public let succeeded: Bool
    public let numFreed: Int
    
    enum CodingKeys: String, CodingKey {
        case succeeded
        case numFreed = "num_freed"
    }
    
}

extension ClearScrollResponse: Equatable {}
