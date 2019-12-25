//
//  SearchRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

// MARK: - Search Request Builder

public class SearchRequestBuilder: RequestBuilder {
    public typealias RequestType = SearchRequest

    private var _index: String?
    private var _type: String?
    private var _from: Int16?
    private var _size: Int16?
    private var _query: Query?
    private var _sorts: [Sort]?
    private var _sourceFilter: SourceFilter?
    private var _explain: Bool?
    private var _minScore: Decimal?
    private var _scroll: Scroll?
    private var _searchType: SearchType?
    private var _trackScores: Bool?
    private var _indicesBoost: [IndexBoost]?
    private var _seqNoPrimaryTerm: Bool?
    private var _version: Bool?
    private var _preference: String?
    private var _scriptFields: [ScriptField]?
    private var _storedFields: [String]?
    private var _docvalueFields: [DocValueField]?
    private var _postFilter: Query?

    public init() {}

    @discardableResult
    public func set(indices: String...) -> Self {
        _index = indices.compactMap { $0 }.joined(separator: ",")
        return self
    }

    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    @discardableResult
    public func set(types: String...) -> Self {
        _type = types.compactMap { $0 }.joined(separator: ",")
        return self
    }

    @discardableResult
    public func set(from: Int16) -> Self {
        _from = from
        return self
    }

    @discardableResult
    public func set(size: Int16) -> Self {
        _size = size
        return self
    }

    @discardableResult
    public func set(query: Query) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(postFilter: Query) -> Self {
        _postFilter = postFilter
        return self
    }

    @discardableResult
    public func set(sorts: [Sort]) -> Self {
        _sorts = sorts
        return self
    }

    @discardableResult
    public func set(sourceFilter: SourceFilter) -> Self {
        _sourceFilter = sourceFilter
        return self
    }

    @discardableResult
    public func set(explain: Bool) -> Self {
        _explain = explain
        return self
    }

    @discardableResult
    public func set(minScore: Decimal) -> Self {
        _minScore = minScore
        return self
    }

    @discardableResult
    public func set(scroll: Scroll) -> Self {
        _scroll = scroll
        return self
    }

    @discardableResult
    public func set(searchType: SearchType) -> Self {
        _searchType = searchType
        return self
    }

    @discardableResult
    public func set(trackScores: Bool) -> Self {
        _trackScores = trackScores
        return self
    }

    @discardableResult
    public func set(indicesBoost: [IndexBoost]) -> Self {
        _indicesBoost = indicesBoost
        return self
    }

    @discardableResult
    public func set(preference: String) -> Self {
        _preference = preference
        return self
    }

    @discardableResult
    public func set(version: Bool) -> Self {
        _version = version
        return self
    }

    @discardableResult
    public func set(seqNoPrimaryTerm: Bool) -> Self {
        _seqNoPrimaryTerm = seqNoPrimaryTerm
        return self
    }

    @discardableResult
    public func set(scriptFields: [ScriptField]) -> Self {
        _scriptFields = scriptFields
        return self
    }

    @discardableResult
    public func set(docvalueFields: [DocValueField]) -> Self {
        _docvalueFields = docvalueFields
        return self
    }

    @discardableResult
    public func add(sort: Sort) -> Self {
        if _sorts != nil {
            _sorts?.append(sort)
        } else {
            _sorts = [sort]
        }
        return self
    }

    @discardableResult
    public func add(indexBoost: IndexBoost) -> Self {
        if _indicesBoost != nil {
            _indicesBoost?.append(indexBoost)
        } else {
            _indicesBoost = [indexBoost]
        }
        return self
    }

    @discardableResult
    public func add(scriptField: ScriptField) -> Self {
        if _scriptFields != nil {
            _scriptFields?.append(scriptField)
        } else {
            _scriptFields = [scriptField]
        }
        return self
    }

    @discardableResult
    public func add(docvalueField: DocValueField) -> Self {
        if _docvalueFields != nil {
            _docvalueFields?.append(docvalueField)
        } else {
            _docvalueFields = [docvalueField]
        }
        return self
    }

    @discardableResult
    public func set(storedFields: String...) -> Self {
        _storedFields = storedFields
        return self
    }

    @discardableResult
    public func set(storedFields: [String]) -> Self {
        _storedFields = storedFields
        return self
    }

    public var index: String? {
        return _index
    }

    public var type: String? {
        return _type
    }

    public var from: Int16? {
        return _from
    }

    public var size: Int16? {
        return _size
    }

    public var query: Query? {
        return _query
    }

    public var sorts: [Sort]? {
        return _sorts
    }

    public var sourceFilter: SourceFilter? {
        return _sourceFilter
    }

    public var explain: Bool? {
        return _explain
    }

    public var minScore: Decimal? {
        return _minScore
    }

    public var scroll: Scroll? {
        return _scroll
    }

    public var searchType: SearchType? {
        return _searchType
    }

    public var trackScores: Bool? {
        return _trackScores
    }

    public var indicesBoost: [IndexBoost]? {
        return _indicesBoost
    }

    public var seqNoPrimaryTerm: Bool? {
        return _seqNoPrimaryTerm
    }

    public var version: Bool? {
        return _version
    }

    public var preference: String? {
        return _preference
    }

    public var scriptFields: [ScriptField]? {
        return _scriptFields
    }

    public var storedFields: [String]? {
        return _storedFields
    }

    public var docvalueFields: [DocValueField]? {
        return _docvalueFields
    }

    public var postFilter: Query? {
        return _postFilter
    }

    public func build() throws -> SearchRequest {
        return try SearchRequest(withBuilder: self)
    }
}

// MARK: - Search Request

public struct SearchRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()

    public let index: String
    public let type: String?
    public let from: Int16?
    public let size: Int16?
    public let query: Query?
    public let sorts: [Sort]?
    public let sourceFilter: SourceFilter?
    public let explain: Bool?
    public let minScore: Decimal?
    public let trackScores: Bool?
    public let indicesBoost: [IndexBoost]?
    public let seqNoPrimaryTerm: Bool?
    public let version: Bool?
    public let scriptFields: [ScriptField]?
    public let storedFields: [String]?
    public let docvalueFields: [DocValueField]?
    public let postFilter: Query?

    public var scroll: Scroll?
    public var searchType: SearchType?
    public var preference: String?

    public init(index: String, type: String?, from: Int16?, size: Int16?, query: Query?, sorts: [Sort]?, sourceFilter: SourceFilter?, explain: Bool?, minScore: Decimal?, scroll: Scroll?, trackScores: Bool? = nil, indicesBoost: [IndexBoost]? = nil, seqNoPrimaryTerm: Bool? = nil, version: Bool?, preference: String? = nil, scriptFields: [ScriptField]? = nil, storedFields: [String]? = nil, docvalueFields: [DocValueField]?, postFilter: Query? = nil) {
        self.index = index
        self.type = type
        self.from = from
        self.size = size
        self.query = query
        self.sorts = sorts
        self.sourceFilter = sourceFilter
        self.explain = explain
        self.minScore = minScore
        self.scroll = scroll
        self.trackScores = trackScores
        self.indicesBoost = indicesBoost
        self.seqNoPrimaryTerm = seqNoPrimaryTerm
        self.version = version
        self.preference = preference
        self.scriptFields = scriptFields
        self.storedFields = storedFields
        self.docvalueFields = docvalueFields
        self.postFilter = postFilter
    }

    internal init(withBuilder builder: SearchRequestBuilder) throws {
        index = builder.index ?? "_all"
        type = builder.type
        query = builder.query
        from = builder.from
        size = builder.size
        sorts = builder.sorts
        sourceFilter = builder.sourceFilter
        explain = builder.explain
        minScore = builder.minScore
        scroll = builder.scroll
        searchType = builder.searchType
        trackScores = builder.trackScores
        indicesBoost = builder.indicesBoost
        seqNoPrimaryTerm = builder.seqNoPrimaryTerm
        version = builder.version
        preference = builder.preference
        scriptFields = builder.scriptFields
        storedFields = builder.storedFields
        docvalueFields = builder.docvalueFields
        postFilter = builder.postFilter
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        var path = index
        if let type = self.type {
            path += "/" + type
        }
        return path + "/_search"
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let scroll = self.scroll {
            queryItems.append(URLQueryItem(name: QueryParams.scroll, value: scroll.keepAlive))
        }
        if let searchType = self.searchType {
            queryItems.append(URLQueryItem(name: QueryParams.searchType, value: searchType.rawValue))
        }
        if let preference = self.preference {
            queryItems.append(URLQueryItem(name: QueryParams.preference, value: preference))
        }
        return queryItems
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(query: query, sort: sorts, size: size, from: from, source: sourceFilter, explain: explain, minScore: minScore, trackScores: trackScores, indicesBoost: indicesBoost, seqNoPrimaryTerm: seqNoPrimaryTerm, version: version, scriptFields: scriptFields, storedFields: storedFields, docvalueFields: docvalueFields, postFilter: postFilter)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            MakeBodyError.wrapped(error)
        }
    }

    struct Body: Encodable {
        public let query: Query?
        public let sort: [Sort]?
        public let size: Int16?
        public let from: Int16?
        public let source: SourceFilter?
        public let explain: Bool?
        public let minScore: Decimal?
        public let trackScores: Bool?
        public let indicesBoost: [IndexBoost]?
        public let seqNoPrimaryTerm: Bool?
        public let version: Bool?
        public let scriptFields: [ScriptField]?
        public let storedFields: [String]?
        public let docvalueFields: [DocValueField]?
        public let postFilter: Query?

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(query, forKey: .query)
            try container.encodeIfPresent(sort, forKey: .sort)
            try container.encodeIfPresent(size, forKey: .size)
            try container.encodeIfPresent(from, forKey: .from)
            try container.encodeIfPresent(source, forKey: .source)
            try container.encodeIfPresent(explain, forKey: .explain)
            try container.encodeIfPresent(minScore, forKey: .minScore)
            try container.encodeIfPresent(trackScores, forKey: .trackScores)
            try container.encodeIfPresent(indicesBoost, forKey: .indicesBoost)
            try container.encodeIfPresent(seqNoPrimaryTerm, forKey: .seqNoPrimaryTerm)
            try container.encodeIfPresent(version, forKey: .version)
            try container.encodeIfPresent(storedFields, forKey: .storedFields)
            try container.encodeIfPresent(docvalueFields, forKey: .docvalueFields)
            try container.encodeIfPresent(postFilter, forKey: .postFilter)
            if let scriptFields = self.scriptFields, !scriptFields.isEmpty {
                if scriptFields.count == 1 {
                    try container.encode(scriptFields[0], forKey: .scriptFields)
                } else {
                    var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .scriptFields)
                    for scriptField in scriptFields {
                        var scriptContainer = nested.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: scriptField.field))
                        try scriptContainer.encode(scriptField.script, forKey: .key(named: "script"))
                    }
                }
            }
        }

        enum CodingKeys: String, CodingKey {
            case query
            case sort
            case size
            case from
            case source = "_source"
            case explain
            case minScore = "min_score"
            case trackScores = "track_scores"
            case indicesBoost = "indices_boost"
            case seqNoPrimaryTerm = "seq_no_primary_term"
            case version
            case scriptFields = "script_fields"
            case storedFields = "stored_fields"
            case docvalueFields = "docvalue_fields"
            case postFilter = "post_filter"
        }
    }
}

extension SearchRequest: Equatable {
    public static func == (lhs: SearchRequest, rhs: SearchRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.explain == rhs.explain
            && lhs.sourceFilter == rhs.sourceFilter
            && lhs.from == rhs.from
            && lhs.endPoint == rhs.endPoint
            && lhs.headers == rhs.headers
            && lhs.method == rhs.method
            && lhs.minScore == rhs.minScore
            && lhs.queryParams == rhs.queryParams
            && lhs.size == rhs.size
            && lhs.sorts == rhs.sorts
            && lhs.type == rhs.type
            && lhs.indicesBoost == rhs.indicesBoost
            && lhs.trackScores == rhs.trackScores
            && lhs.scroll == rhs.scroll
            && lhs.searchType == rhs.searchType
            && lhs.seqNoPrimaryTerm == rhs.seqNoPrimaryTerm
            && lhs.version == rhs.version
            && lhs.preference == rhs.preference
            && lhs.scriptFields == rhs.scriptFields
            && lhs.storedFields == rhs.storedFields
            && lhs.docvalueFields == rhs.docvalueFields
            && SearchRequest.matchQueries(lhs.query, rhs.query)
            && SearchRequest.matchQueries(lhs.postFilter, rhs.postFilter)
    }

    private static func matchQueries(_ lhs: Query?, _ rhs: Query?) -> Bool {
        if lhs == nil, rhs == nil {
            return true
        }
        if let lhs = lhs, let rhs = rhs {
            return lhs.isEqualTo(rhs)
        }
        return false
    }
}

public struct ScriptField {
    public let field: String
    public let script: Script
}

extension ScriptField: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try nested.encode(script, forKey: .script)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(ScriptField.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        field = container.allKeys.first!.stringValue
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        script = try nested.decode(Script.self, forKey: .script)
    }

    enum CodingKeys: String, CodingKey {
        case script
    }
}

extension ScriptField: Equatable {}

public struct DocValueField: Codable {
    public let field: String
    public let format: String
}

extension DocValueField: Equatable {}

/// Struct representing Index boost
public struct IndexBoost {
    public let index: String
    public let boost: Decimal
}

extension IndexBoost: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encode(boost, forKey: .key(named: index))
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dic = try container.decode([String: Decimal].self)
        if dic.isEmpty || dic.count > 1 {
            throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "Unexpected data found \(dic)")
        }
        index = dic.first!.key
        boost = dic.first!.value
    }
}

extension IndexBoost: Equatable {}

// MARK: - Scroll

public struct Scroll: Codable {
    public let keepAlive: String

    public init(keepAlive: String) {
        self.keepAlive = keepAlive
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keepAlive)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        keepAlive = try container.decodeString()
    }

    public static var ONE_MINUTE: Scroll {
        return Scroll(keepAlive: "1m")
    }
}

extension Scroll: Equatable {}

// MARK: - Search Scroll Request Builder

public class SearchScrollRequestBuilder: RequestBuilder {
    public typealias RequestType = SearchScrollRequest

    private var _scrollId: String?
    private var _scroll: Scroll?
    private var _restTotalHitsAsInt: Bool?

    public init() {}

    @discardableResult
    public func set(scrollId: String) -> Self {
        _scrollId = scrollId
        return self
    }

    @discardableResult
    public func set(scroll: Scroll) -> Self {
        _scroll = scroll
        return self
    }

    @discardableResult
    public func set(restTotalHitsAsInt: Bool) -> Self {
        _restTotalHitsAsInt = restTotalHitsAsInt
        return self
    }

    public var scrollId: String? {
        return _scrollId
    }

    public var scroll: Scroll? {
        return _scroll
    }

    public var restTotalHitsAsInt: Bool? {
        return _restTotalHitsAsInt
    }

    public func build() throws -> SearchScrollRequest {
        return try SearchScrollRequest(withBuilder: self)
    }
}

// MARK: - Search Scroll Request

public struct SearchScrollRequest: Request {
    public let scrollId: String
    public let scroll: Scroll?

    public var restTotalHitsAsInt: Bool?

    public init(scrollId: String, scroll: Scroll?) {
        self.scrollId = scrollId
        self.scroll = scroll
    }

    internal init(withBuilder builder: SearchScrollRequestBuilder) throws {
        guard builder.scrollId != nil else {
            throw RequestBuilderError.missingRequiredField("scrollId")
        }

        scrollId = builder.scrollId!
        scroll = builder.scroll
        restTotalHitsAsInt = builder.restTotalHitsAsInt
    }

    public var headers: HTTPHeaders {
        return HTTPHeaders()
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let totalHitsAsInt = self.restTotalHitsAsInt {
            params.append(URLQueryItem(name: QueryParams.restTotalHitsAsInt, value: totalHitsAsInt))
        }
        return params
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        return "_search/scroll"
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(scroll: scroll, scrollId: scrollId)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            .wrapped(error)
        }
    }

    private struct Body: Encodable {
        public let scroll: Scroll?
        public let scrollId: String

        enum CodingKeys: String, CodingKey {
            case scroll
            case scrollId = "scroll_id"
        }
    }
}

extension SearchScrollRequest: Equatable {}

// MARK: - Clear Scroll Request Builder

public class ClearScrollRequestBuilder: RequestBuilder {
    public typealias RequestType = ClearScrollRequest

    private var _scrollIds: [String] = []

    public init() {}

    @discardableResult
    public func set(scrollIds: String...) -> Self {
        _scrollIds = scrollIds
        return self
    }

    public var scrollIds: [String] {
        return _scrollIds
    }

    public func build() throws -> ClearScrollRequest {
        return try ClearScrollRequest(withBuilder: self)
    }
}

// MARK: - Clear Scroll Request

public struct ClearScrollRequest: Request {
    public let scrollIds: [String]

    public init(scrollId: String) {
        self.init(scrollIds: [scrollId])
    }

    public init(scrollIds: [String]) {
        self.scrollIds = scrollIds
    }

    internal init(withBuilder builder: ClearScrollRequestBuilder) throws {
        guard !builder.scrollIds.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("scrollIds")
        }

        if builder.scrollIds.contains("_all") {
            scrollIds = ["_all"]
        } else {
            scrollIds = builder.scrollIds
        }
    }

    public var headers: HTTPHeaders {
        return HTTPHeaders()
    }

    public var queryParams: [URLQueryItem] {
        return []
    }

    public var method: HTTPMethod {
        return .DELETE
    }

    public var endPoint: String {
        if scrollIds.contains("_all") {
            return "_search/scroll/_all"
        } else {
            return "_search/scroll"
        }
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        if scrollIds.contains("_all") {
            return .failure(.noBodyForRequest)
        } else {
            let body = Body(scrollId: scrollIds)
            return serializer.encode(body).mapError { error -> MakeBodyError in
                MakeBodyError.wrapped(error)
            }
        }
    }

    private struct Body: Codable, Equatable {
        public let scrollId: [String]

        public init(scrollId: [String]) {
            self.scrollId = scrollId
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            do {
                let id = try container.decodeString(forKey: .scrollId)
                scrollId = [id]
            } catch Swift.DecodingError.typeMismatch {
                scrollId = try container.decodeArray(forKey: .scrollId)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if scrollId.count == 1 {
                try container.encode(scrollId.first!, forKey: .scrollId)
            } else {
                try container.encode(scrollId, forKey: .scrollId)
            }
        }

        enum CodingKeys: String, CodingKey {
            case scrollId = "scroll_id"
        }
    }
}

extension ClearScrollRequest: Equatable {}

// MARK: - Search Type

/// Search type represent the manner at which the search operation is executed.
public enum SearchType: String, Codable {
    /// Same as [query_then_fetch](x-source-tag://query_then_fetch), except for an initial scatter phase which goes and computes the distributed
    /// term frequencies for more accurate scoring.
    case dfs_query_then_fetch
    /// The query is executed against all shards, but only enough information is returned (not the document content).
    /// The results are then sorted and ranked, and based on it, only the relevant shards are asked for the actual
    /// document content. The return number of hits is exactly as specified in size, since they are the only ones that
    /// are fetched. This is very handy when the index has a lot of shards (not replicas, shard id groups).
    /// - Tag: `query_then_fetch`
    case query_then_fetch

    /// Only used for pre 5.3 request where this type is still needed
    @available(*, deprecated, message: "Only used for pre 5.3 request where this type is still needed")
    case query_and_fetch

    /// The default search type [query_then_fetch](x-source-tag://query_then_fetch)
    public static let DEFAULT = SearchType.query_then_fetch
}

// MARK: - Source Filtering

public enum SourceFilter {
    case fetchSource(Bool)
    case filter(String)
    case filters([String])
    case source(includes: [String], excludes: [String])
}

extension SourceFilter: Codable {
    enum CodingKeys: String, CodingKey {
        case includes
        case excludes
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .fetchSource(value):
            var contianer = encoder.singleValueContainer()
            try contianer.encode(value)
        case let .filter(value):
            var contianer = encoder.singleValueContainer()
            try contianer.encode(value)
        case let .filters(values):
            var contianer = encoder.unkeyedContainer()
            try contianer.encode(contentsOf: values)
        case let .source(includes, excludes):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(includes, forKey: .includes)
            try container.encode(excludes, forKey: .excludes)
        }
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            let includes: [String] = try container.decodeArray(forKey: .includes)
            let excludes: [String] = try container.decodeArray(forKey: .excludes)
            self = .source(includes: includes, excludes: excludes)
        } else if var contianer = try? decoder.unkeyedContainer() {
            let values: [String] = try contianer.decodeArray()
            self = .filters(values)
        } else {
            let container = try decoder.singleValueContainer()
            if let value = try? container.decodeString() {
                self = .filter(value)
            } else {
                let value = try container.decodeBool()
                self = .fetchSource(value)
            }
        }
    }
}

extension SourceFilter: Equatable {}
