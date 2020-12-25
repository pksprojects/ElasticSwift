//
//  Response.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - Get Response

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

// MARK: - Index Response

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

// MARK: - Search Response

public struct SearchResponse<T: Codable>: Codable, Equatable where T: Equatable {
    public let took: Int
    public let timedOut: Bool
    public let shards: Shards
    public let hits: SearchHits<T>
    public let scrollId: String?
    public let profile: SearchProfileShardResults?
    public let suggest: [String: [SuggestEntry]]?

    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
        case scrollId = "_scroll_id"
        case profile
        case suggest
    }
}

public struct SuggestEntry: Codable, Equatable {
    public let text: String
    public let offset: Int
    public let length: Int
    public let options: [SuggestEntryOption]
}

public struct SuggestEntryOption: Codable, Equatable {
    public let text: String
    public let highlighted: String?
    public let score: Decimal?
    public let collateMatch: Bool?
    public let freq: Int?
    public let contexts: [String: [String]]?
    public let index: String?
    public let type: String?
    public let id: String?
    public let _score: Decimal?
    public let source: CodableValue?

    enum CodingKeys: String, CodingKey {
        case text
        case highlighted
        case score
        case collateMatch = "collate_match"
        case freq
        case contexts
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case _score
        case source = "_source"
    }
}

public struct Shards: Codable, Equatable {
    public let total: Int
    public let successful: Int
    public let skipped: Int?
    public let failed: Int
    public let failures: [ShardSearchFailure]?
}

public struct SearchProfileShardResults: Codable, Equatable {
    public let shards: [ProfileShardResult]
}

public struct ProfileShardResult: Codable, Equatable {
    public let id: String
    public let searches: [QueryProfileShardResult]
    public let aggregations: [ProfileResult]
}

public struct QueryProfileShardResult {
    public let queryProfileResults: [ProfileResult]
    public let rewriteTime: Int
    public let collector: [CollectorResult]
}

extension QueryProfileShardResult: Codable {
    enum CodingKeys: String, CodingKey {
        case queryProfileResults = "query"
        case rewriteTime = "rewrite_time"
        case collector
    }
}

extension QueryProfileShardResult: Equatable {}

public struct ProfileResult {
    public let type: String
    public let description: String
    public let nodeTime: Int
    public let timings: [String: Int]
    public let children: [ProfileResult]?
}

extension ProfileResult: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case description
        case nodeTime = "time_in_nanos"
        case timings = "breakdown"
        case children
    }
}

extension ProfileResult: Equatable {}

public struct CollectorResult {
    public let name: String
    public let reason: String
    public let time: Int
    public let children: [CollectorResult]?
}

extension CollectorResult: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case reason
        case time = "time_in_nanos"
        case children
    }
}

extension CollectorResult: Equatable {}

public struct SearchHits<T: Codable>: Codable, Equatable where T: Equatable {
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

public struct SearchHit<T: Codable> where T: Equatable {
    public let index: String
    public let type: String?
    public let id: String?
    public let score: Decimal?
    public let source: T?
    public let sort: [CodableValue]?
    public let version: Int?
    public let seqNo: Int?
    public let primaryTerm: Int?
    public let fields: [String: SearchHitField]?
    public let explanation: Explanation?
    public let matchedQueries: [String]?
    public let innerHits: [String: SearchHits<CodableValue>]?
    public let node: String?
    public let shard: String?
    public let highlightFields: [String: HighlightField]?
    public let nested: NestedIdentity?

    public var searchSearchTarget: SearchSearchTarget? {
        if let node = self.node, let shard = self.shard {
            return .init(nodeId: node, shardId: shard)
        }
        return nil
    }
}

extension SearchHit: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        index = try container.decodeString(forKey: .index)
        type = try container.decodeStringIfPresent(forKey: .type)
        id = try container.decodeStringIfPresent(forKey: .id)
        score = try container.decodeDecimalIfPresent(forKey: .score)
        version = try container.decodeIntIfPresent(forKey: .version)
        seqNo = try container.decodeIntIfPresent(forKey: .seqNo)
        primaryTerm = try container.decodeIntIfPresent(forKey: .primaryTerm)
        node = try container.decodeStringIfPresent(forKey: .node)
        shard = try container.decodeStringIfPresent(forKey: .shard)
        nested = try container.decodeIfPresent(NestedIdentity.self, forKey: .nested)
        matchedQueries = try container.decodeArrayIfPresent(forKey: .matchedQueries)
        sort = try container.decodeArrayIfPresent(forKey: .sort)
        source = try container.decodeIfPresent(T.self, forKey: .source)
        explanation = try container.decodeIfPresent(Explanation.self, forKey: .explanation)
        // self.innerHits = try container.decodeDicIfPresent(forKey: .innerHits)
//        let fieldsDic = try container.decodeIfPresent([String: [CodableValue]].self, forKey: .fields)
//        if let fieldsDic = fieldsDic {
//            var dic = [String: SearchHitField]()
//            fieldsDic.map { SearchHitField(name: $0.key, values: $0.value) }.forEach { dic[$0.name] = $0 }
//            self.fields = dic
//        } else {
//            self.fields = nil
//        }

        fields = try SearchHit.decodeDicOf([String: [CodableValue]].self, in: container, forKey: .fields, flattern: { SearchHitField(name: $0.key, values: $0.value) }, reduce: { $1[$0.name] = $0 })

        highlightFields = try SearchHit.decodeDicOf([String: [String]].self, in: container, forKey: .highlightFields, flattern: { HighlightField(name: $0.key, fragments: $0.value) }, reduce: { $1[$0.name] = $0 })

        innerHits = try SearchHit.decodeDicOf([String: InnerHitWrapper].self, in: container, forKey: .innerHits, flattern: { ($0.key, $0.value.hits) }, reduce: { $1[$0.0] = $0.1 })
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(index, forKey: .index)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(sort, forKey: .sort)
        try container.encodeIfPresent(version, forKey: .version)
        try container.encodeIfPresent(seqNo, forKey: .seqNo)
        try container.encodeIfPresent(primaryTerm, forKey: .primaryTerm)
        try container.encodeIfPresent(explanation, forKey: .explanation)
        try container.encodeIfPresent(matchedQueries, forKey: .matchedQueries)
        try container.encodeIfPresent(innerHits?.mapValues { InnerHitWrapper(hits: $0) }, forKey: .innerHits)
        try container.encodeIfPresent(shard, forKey: .shard)
        try container.encodeIfPresent(node, forKey: .node)
        try container.encodeIfPresent(nested, forKey: .nested)
        if let fields = self.fields {
            try container.encode(fields.mapValues { $0.values }, forKey: .fields)
        }
        if let highlight = highlightFields {
            try container.encode(highlight.mapValues { $0.fragments }, forKey: .highlightFields)
        }
    }

    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case score = "_score"
        case source = "_source"
        case sort
        case version = "_version"
        case seqNo = "_seq_no"
        case primaryTerm = "_primary_term"
        case fields
        case explanation = "_explanation"
        case matchedQueries = "matched_queries"
        case innerHits = "inner_hits"
        case shard = "_shard"
        case node = "_node"
        case highlightFields = "highlight"
        case nested = "_nested"
    }

    private static func decodeDicOf<K, V, R, X, Y>(_ decodeDic: [K: V].Type, in container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys, flattern mapper: ((key: K, value: V)) throws -> R, reduce reducer: (R, SharedDic<X, Y>) -> Void) throws -> [X: Y]? where K: Codable, V: Codable {
        let decodedDic: [K: V]? = try container.decodeDicIfPresent(forKey: key)
        if let decodeDic = decodedDic {
            let dic = SharedDic<X, Y>()
            try decodeDic.map(mapper).forEach { e in reducer(e, dic) }
            return dic.dict
        }
        return nil
    }

    private struct InnerHitWrapper: Codable, Equatable {
        public let hits: SearchHits<CodableValue>
    }
}

extension SearchHit: Equatable {}

public struct SearchHitField: Codable, Equatable {
    public let name: String
    public let values: [CodableValue]
}

public struct Explanation: Codable, Equatable {
    public let match: Bool?
    public let value: Decimal
    public let description: String
    public let details: [Explanation]
}

public struct SearchSearchTarget: Codable, Equatable {
    public let nodeId: String
    public let shardId: String

    enum CodingKeys: String, CodingKey {
        case nodeId = "_node"
        case shardId = "_shard"
    }
}

public struct HighlightField: Codable, Equatable {
    public let name: String
    public let fragments: [String]
}

public struct NestedIdentity {
    public let field: String
    public let offset: Int
    private let _nested: [NestedIdentity]?

    public init(field: String, offset: Int, nested: NestedIdentity?) {
        self.field = field
        self.offset = offset
        if let nested = nested {
            _nested = [nested]
        } else {
            _nested = nil
        }
    }

    public var child: NestedIdentity? {
        if let nested = _nested, !nested.isEmpty {
            return nested[0]
        }
        return nil
    }
}

extension NestedIdentity: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field, forKey: .field)
        try container.encode(offset, forKey: .offset)
        if let nested = _nested, !nested.isEmpty {
            try container.encode(nested[0], forKey: .nested)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        field = try container.decodeString(forKey: .field)
        offset = try container.decodeInt(forKey: .offset)
        let nested = try container.decodeIfPresent(NestedIdentity.self, forKey: .nested)
        if let nested = nested {
            _nested = [nested]
        } else {
            _nested = nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case field
        case offset
        case nested = "_nested"
    }
}

extension NestedIdentity: Equatable {
    public static func == (lhs: NestedIdentity, rhs: NestedIdentity) -> Bool {
        return lhs.field == rhs.field && lhs.offset == rhs.offset
            && lhs.child == rhs.child
    }
}

// MARK: - Delete Response

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

// MARK: - Delete By Query Response

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

// MARK: - Update By Query Response

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

// MARK: - Multi Get Response

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
            response = try container.decode(GetResponse<CodableValue>.self)
            failure = nil
        } catch {
            failure = try container.decode(MultiGetResponse.Failure.self)
            response = nil
        }
    }
}

// MARK: - UPDATE RESPONSE

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

// MARK: - ReIndex Response

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

// MARK: - TermVectors Response

public struct TermVectorsResponse: Codable, Equatable {
    public let id: String?
    public let index: String
    public let type: String
    public let version: Int?
    public let found: Bool
    public let took: Int
    public let termVerctors: [TermVector]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeStringIfPresent(forKey: .id)
        index = try container.decodeString(forKey: .index)
        type = try container.decodeString(forKey: .type)
        version = try container.decodeIntIfPresent(forKey: .version)
        found = try container.decodeBool(forKey: .found)
        took = try container.decodeInt(forKey: .took)
        do {
            let dic = try container.decode([String: TermVectorMetaData].self, forKey: .termVerctors)
            termVerctors = dic.map { key, value -> TermVector in
                TermVector(field: key, fieldStatistics: value.fieldStatistics, terms: value.terms)
            }
        } catch let Swift.DecodingError.keyNotFound(key, context) {
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
            let container = try decoder.container(keyedBy: CodingKeys.self)
            fieldStatistics = try container.decodeIfPresent(FieldStatistics.self, forKey: .fieldStatistics)
            let dic = try container.decode([String: TermStatistics].self, forKey: .terms)
            terms = dic.map { key, value -> Term in
                Term(term: key, termStatistics: value)
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
            docFreq = termStatistics.docFreq
            termFreq = termStatistics.termFreq
            tokens = termStatistics.tokens ?? []
            ttf = termStatistics.ttf
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

// MARK: - Multi Term Vectors Response

public struct MultiTermVectorsResponse: Codable {
    public let responses: [TermVectorsResponse]

    enum CodingKeys: String, CodingKey {
        case responses = "docs"
    }
}

extension MultiTermVectorsResponse: Equatable {}

// MARK: - Bulk Response

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
                response = try container.decode(SuccessResponse.self, forKey: opTypeKey)
                failure = nil
            } catch {
                response = nil
                failure = try container.decode(Failure.self, forKey: opTypeKey)
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

// MARK: - Clear Scroll Response

public struct ClearScrollResponse: Codable {
    public let succeeded: Bool
    public let numFreed: Int

    enum CodingKeys: String, CodingKey {
        case succeeded
        case numFreed = "num_freed"
    }
}

extension ClearScrollResponse: Equatable {}

// MARK: - Count Response

/// A response to _count API request.
public struct CountResponse: Codable {
    public let count: Int
    public let shards: Shards
    public let terminatedEarly: Bool?

    enum CodingKeys: String, CodingKey {
        case count
        case shards = "_shards"
        case terminatedEarly = "terminated_early"
    }
}

extension CountResponse: Equatable {}

// MARK: - Explain Response

public struct ExplainResponse: Codable {
    public let index: String
    public let type: String
    public let id: String
    public let matched: Bool
    public let explanation: Explanation

    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case matched
        case explanation
    }
}

extension ExplainResponse: Equatable {}

// MARK: - Field Capabilities Response

/// Response for FieldCapabilitiesIndexRequest requests.
public struct FieldCapabilitiesResponse {
    public let fields: [String: [String: FieldCapabilities]]
}

extension FieldCapabilitiesResponse: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fieldsResponse = try container.decode([String: [String: FieldCaps]].self, forKey: .fields)
        var fields = [String: [String: FieldCapabilities]]()
        for field in fieldsResponse.keys {
            for type in fieldsResponse[field]!.keys {
                let fieldCaps = fieldsResponse[field]![type]!
                if fields.keys.contains(field) {
                    fields[field]![type] = fieldCaps.toFieldCapabilities(field, type: type)
                } else {
                    fields[field] = [String: FieldCapabilities]()
                    fields[field]![type] = fieldCaps.toFieldCapabilities(field, type: type)
                }
            }
        }
        self.fields = fields
    }

    public func encode(to encoder: Encoder) throws {
        var fields = [String: [String: FieldCaps]]()
        for field in self.fields.keys {
            for type in self.fields[field]!.keys {
                let fieldCaps = self.fields[field]![type]!
                if fields.keys.contains(field) {
                    fields[field]![type] = FieldCaps.fromFieldCapabilities(fieldCaps)
                } else {
                    fields[field] = [String: FieldCaps]()
                    fields[field]![type] = FieldCaps.fromFieldCapabilities(fieldCaps)
                }
            }
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fields, forKey: .fields)
    }

    internal struct FieldCaps: Codable, Equatable {
        public let type: String?
        public let searchable: Bool
        public let aggregatable: Bool
        public let indices: [String]?
        public let nonSearchableIndices: [String]?
        public let nonAggregatableIndicies: [String]?

        func toFieldCapabilities(_ name: String, type: String) -> FieldCapabilities {
            return FieldCapabilities(name: name, type: type, isSearchable: searchable, isAggregatable: aggregatable, indices: indices, nonSearchableIndices: nonSearchableIndices, nonAggregatableIndicies: nonAggregatableIndicies)
        }

        static func fromFieldCapabilities(_ caps: FieldCapabilities) -> FieldCaps {
            return FieldCaps(type: caps.type, searchable: caps.isSearchable, aggregatable: caps.isAggregatable, indices: caps.indices, nonSearchableIndices: caps.nonSearchableIndices, nonAggregatableIndicies: caps.nonAggregatableIndicies)
        }

        enum CodingKeys: String, CodingKey {
            case type
            case searchable
            case aggregatable
            case indices
            case nonSearchableIndices = "non_searchable_indices"
            case nonAggregatableIndicies = "non_aggregatable_indices"
        }
    }

    enum CodingKeys: String, CodingKey {
        case fields
    }
}

extension FieldCapabilitiesResponse: Equatable {}

/// Describes the capabilities of a field optionally merged across multiple indices.
public struct FieldCapabilities: Codable {
    public let name: String
    public let type: String
    public let isSearchable: Bool
    public let isAggregatable: Bool
    public let indices: [String]?
    public let nonSearchableIndices: [String]?
    public let nonAggregatableIndicies: [String]?
}

extension FieldCapabilities: Equatable {}

// MARK: - RankEvalResponse

public struct RankEvalResponse: Codable {
    public let metricScore: Decimal
    public let details: [String: EvalQueryQuality]
    public let failures: [String: ElasticError]

    enum CodingKeys: String, CodingKey {
        case metricScore = "metric_score"
        case details
        case failures
    }
}

extension RankEvalResponse: Equatable {}

public struct EvalQueryQuality {
    public let queryId: String?
    public let metricScore: Decimal
    public let metricDetails: MetricDetail?
    public let ratedHits: [RatedSearchHit]
    public let unratedDocs: [UnratedDocument]
}

extension EvalQueryQuality: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        metricScore = try container.decodeDecimal(forKey: .metricScore)
        metricDetails = try container.decodeMetricDetailIfPresent(forKey: .metricDetails)
        ratedHits = try container.decodeArray(forKey: .ratedHits)
        unratedDocs = try container.decode([UnratedDocument].self, forKey: .unratedDocs)
        queryId = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(metricScore, forKey: .metricScore)
        try container.encodeIfPresent(metricDetails, forKey: .metricDetails)
        try container.encode(ratedHits, forKey: .ratedHits)
        try container.encode(unratedDocs, forKey: .unratedDocs)
    }

    enum CodingKeys: String, CodingKey {
        case metricScore = "metric_score"
        case unratedDocs = "unrated_docs"
        case metricDetails = "metric_details"
        case ratedHits = "hits"
    }
}

extension EvalQueryQuality: Equatable {
    public static func == (lhs: EvalQueryQuality, rhs: EvalQueryQuality) -> Bool {
        return lhs.queryId == rhs.queryId
            && lhs.metricScore == rhs.metricScore
            && lhs.ratedHits == rhs.ratedHits
            && isEqualMetricDetails(lhs.metricDetails, rhs.metricDetails)
            && lhs.unratedDocs == rhs.unratedDocs
    }
}

public struct RatedSearchHit {
    public let searchHit: SearchHit<CodableValue>
    public let rating: Int?
}

extension RatedSearchHit: Codable {
    enum CodingKeys: String, CodingKey {
        case searchHit = "hit"
        case rating
    }
}

extension RatedSearchHit: Equatable {}

public struct UnratedDocument {
    public let index: String
    public let id: String
}

extension UnratedDocument: Codable {
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case id = "_id"
    }
}

extension UnratedDocument: Equatable {}

// MARK: - Get StoredScript Response

public struct GetStoredScriptResponse {
    public let id: String
    public let found: Bool
    public let script: StoredScriptSource?
}

extension GetStoredScriptResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case found
        case script
    }
}

extension GetStoredScriptResponse: Equatable {}
