//
//  SearchRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import ElasticSwiftCore
import ElasticSwiftQueryDSL
import ElasticSwiftCodableUtils
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
    private var _highlight: Highlight?

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
    
    @discardableResult
    public func set(highlight: Highlight) -> Self {
        _highlight = highlight
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
    
    public var highlight: Highlight? {
        return _highlight
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
    public let highlight: Highlight?

    public var scroll: Scroll?
    public var searchType: SearchType?
    public var preference: String?

    public init(index: String, type: String?, from: Int16?, size: Int16?, query: Query?, sorts: [Sort]?, sourceFilter: SourceFilter?, explain: Bool?, minScore: Decimal?, scroll: Scroll?, trackScores: Bool? = nil, indicesBoost: [IndexBoost]? = nil, seqNoPrimaryTerm: Bool? = nil, version: Bool?, preference: String? = nil, scriptFields: [ScriptField]? = nil, storedFields: [String]? = nil, docvalueFields: [DocValueField]?, postFilter: Query? = nil, highlight: Highlight? = nil) {
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
        self.highlight = highlight
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
        highlight = builder.highlight
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
        let body = Body(query: query, sort: sorts, size: size, from: from, source: sourceFilter, explain: explain, minScore: minScore, trackScores: trackScores, indicesBoost: indicesBoost, seqNoPrimaryTerm: seqNoPrimaryTerm, version: version, scriptFields: scriptFields, storedFields: storedFields, docvalueFields: docvalueFields, postFilter: postFilter, highlight: highlight)
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
        public let highlight: Highlight?

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
            try container.encodeIfPresent(highlight, forKey: .highlight)
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
            case highlight
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

    fileprivate static func matchQueries(_ lhs: Query?, _ rhs: Query?) -> Bool {
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

// MARK:- Highlighting

public class HighlightBuilder {
    
    private var _fields: [Highlight.Field]?
    private var _globalOptions: Highlight.FieldOptions?
    
    @discardableResult
    public func set(fields: [Highlight.Field]) -> Self {
        self._fields = fields
        return self
    }
    
    @discardableResult
    public func set(globalOptions: Highlight.FieldOptions) -> Self {
        self._globalOptions = globalOptions
        return self
    }
    
    @discardableResult
    public func add(field: Highlight.Field) -> Self {
        if self._fields != nil {
            self._fields?.append(field)
        } else {
            self._fields = [field]
        }
        return self
    }
    
    
    public var fields: [Highlight.Field]? {
        return self._fields
    }
    
    public var globalOptions: Highlight.FieldOptions? {
        return self._globalOptions
    }
    
    public func build() throws -> Highlight {
        return try Highlight(withBuilder: self)
    }
}

public class FieldOptionsBuilder {
    
    private var _fragmentSize: Int?
    private var _numberOfFragments: Int?
    private var _fragmentOffset: Int?
    private var _encoder: Highlight.EncoderType?
    private var _preTags: [String]?
    private var _postTags: [String]?
    private var _scoreOrdered: Bool?
    private var _requireFieldMatch: Bool?
    private var _highlighterType: Highlight.HighlighterType?
    private var _forceSource: Bool?
    private var _fragmenter: String?
    private var _boundaryScannerType: Highlight.BoundaryScannerType?
    private var _boundaryMaxScan: Int?
    private var _boundaryChars: [Character]?
    private var _boundaryScannerLocale: String?
    private var _highlightQuery: Query?
    private var _noMatchSize: Int?
    private var _matchedFields: [String]?
    private var _phraseLimit: Int?
    private var _tagScheme: String?
    private var _termVector: String?
    private var _indexOptions: String?
    
    public init() {}
    
    @discardableResult
    public func set(fragmentSize: Int) -> Self {
        self._fragmentSize = fragmentSize
        return self
    }
    @discardableResult
    public func set(numberOfFragments: Int) -> Self {
        self._numberOfFragments = numberOfFragments
        return self
    }
    @discardableResult
    public func set(fragmentOffset: Int) -> Self {
        self._fragmentOffset = fragmentOffset
        return self
    }
    @discardableResult
    public func set(encoder: Highlight.EncoderType) -> Self {
        self._encoder = encoder
        return self
    }
    @discardableResult
    public func set(preTags: [String]) -> Self {
        self._preTags = preTags
        return self
    }
    @discardableResult
    public func set(postTags: [String]) -> Self {
        self._postTags = postTags
        return self
    }
    @discardableResult
    public func set(scoreOrdered: Bool) -> Self {
        self._scoreOrdered = scoreOrdered
        return self
    }
    @discardableResult
    public func set(requireFieldMatch: Bool) -> Self {
        self._requireFieldMatch = requireFieldMatch
        return self
    }
    @discardableResult
    public func set(highlighterType: Highlight.HighlighterType) -> Self {
        self._highlighterType = highlighterType
        return self
    }
    @discardableResult
    public func set(forceSource: Bool) -> Self {
        self._forceSource = forceSource
        return self
    }
    @discardableResult
    public func set(fragmenter: String) -> Self {
        self._fragmenter = fragmenter
        return self
    }
    @discardableResult
    public func set(boundaryScannerType: Highlight.BoundaryScannerType) -> Self {
        self._boundaryScannerType = boundaryScannerType
        return self
    }
    @discardableResult
    public func set(boundaryMaxScan: Int) -> Self {
        self._boundaryMaxScan = boundaryMaxScan
        return self
    }
    @discardableResult
    public func set(boundaryChars: [Character]) -> Self {
        self._boundaryChars = boundaryChars
        return self
    }
    @discardableResult
    public func set(boundaryScannerLocale: String) -> Self {
        self._boundaryScannerLocale = boundaryScannerLocale
        return self
    }
    @discardableResult
    public func set(highlightQuery: Query) -> Self {
        self._highlightQuery = highlightQuery
        return self
    }
    @discardableResult
    public func set(noMatchSize: Int) -> Self {
        self._noMatchSize = noMatchSize
        return self
    }
    @discardableResult
    public func set(matchedFields: [String]) -> Self {
        self._matchedFields = matchedFields
        return self
    }
    @discardableResult
    public func set(phraseLimit: Int) -> Self {
        self._phraseLimit = phraseLimit
        return self
    }
    @discardableResult
    public func set(tagScheme: String) -> Self {
        self._tagScheme = tagScheme
        return self
    }
    @discardableResult
    public func set(termVector: String) -> Self {
        self._termVector = termVector
        return self
    }
    @discardableResult
    public func set(indexOptions: String) -> Self {
        self._indexOptions = indexOptions
        return self
    }
    
    
    public var fragmentSize: Int? {
        return self._fragmentSize
    }
    public var numberOfFragments: Int? {
        return self._numberOfFragments
    }
    public var fragmentOffset: Int? {
        return self._fragmentOffset
    }
    public var encoder: Highlight.EncoderType? {
        return self._encoder
    }
    public var preTags: [String]? {
        return self._preTags
    }
    public var postTags: [String]? {
        return self._postTags
    }
    public var scoreOrdered: Bool? {
        return self._scoreOrdered
    }
    public var requireFieldMatch: Bool? {
        return self._requireFieldMatch
    }
    public var highlighterType: Highlight.HighlighterType? {
        return self._highlighterType
    }
    public var forceSource: Bool? {
        return self._forceSource
    }
    public var fragmenter: String? {
        return self._fragmenter
    }
    public var boundaryScannerType: Highlight.BoundaryScannerType? {
        return self._boundaryScannerType
    }
    public var boundaryMaxScan: Int? {
        return self._boundaryMaxScan
    }
    public var boundaryChars: [Character]? {
        return self._boundaryChars
    }
    public var boundaryScannerLocale: String? {
        return self._boundaryScannerLocale
    }
    public var highlightQuery: Query? {
        return self._highlightQuery
    }
    public var noMatchSize: Int? {
        return self._noMatchSize
    }
    public var matchedFields: [String]? {
        return self._matchedFields
    }
    public var phraseLimit: Int? {
        return self._phraseLimit
    }
    public var tagScheme: String? {
        return self._tagScheme
    }
    public var termVector: String? {
        return self._termVector
    }
    public var indexOptions: String? {
        return self._indexOptions
    }
    
    public func build() -> Highlight.FieldOptions {
        return Highlight.FieldOptions(withBuilder: self)
    }
}

public struct Highlight {
    
    public let fields: [Field]
    public let globalOptions: FieldOptions
    
    public init(fields: [Field], globalOptions: FieldOptions = FieldOptions()) {
        self.fields = fields
        self.globalOptions = globalOptions
    }
    
    internal init(withBuilder builder: HighlightBuilder) throws {
        
        guard builder.fields != nil && !builder.fields!.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("fields")
        }
        
        self.init(fields: builder.fields!, globalOptions: builder.globalOptions ?? FieldOptions())
    }
}

extension Highlight: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.fields, forKey: .fields)
        try container.encodeIfPresent(self.globalOptions.boundaryChars?.map { String($0) }, forKey: .boundaryChars)
        try container.encodeIfPresent(self.globalOptions.boundaryMaxScan, forKey: .boundaryMaxScan)
        try container.encodeIfPresent(self.globalOptions.boundaryScannerType, forKey: .boundaryScannerType)
        try container.encodeIfPresent(self.globalOptions.boundaryScannerLocale, forKey: .boundaryScannerLocale)
        try container.encodeIfPresent(self.globalOptions.encoder, forKey: .encoder)
        try container.encodeIfPresent(self.globalOptions.forceSource, forKey: .forceSource)
        try container.encodeIfPresent(self.globalOptions.fragmenter, forKey: .fragmenter)
        try container.encodeIfPresent(self.globalOptions.fragmentOffset, forKey: .fragmentOffset)
        try container.encodeIfPresent(self.globalOptions.fragmentSize, forKey: .fragmentSize)
        try container.encodeIfPresent(self.globalOptions.highlightQuery, forKey: .highlightQuery)
        try container.encodeIfPresent(self.globalOptions.matchedFields, forKey: .matchedFields)
        try container.encodeIfPresent(self.globalOptions.numberOfFragments, forKey: .numberOfFragments)
        try container.encodeIfPresent((self.globalOptions.scoreOrdered ?? false) ? Highlight.FieldOptions.SCORE_ORDERER_VALUE: nil, forKey: .order)
        try container.encodeIfPresent(self.globalOptions.phraseLimit, forKey: .phraseLimit)
        try container.encodeIfPresent(self.globalOptions.preTags, forKey: .preTags)
        try container.encodeIfPresent(self.globalOptions.postTags, forKey: .postTags)
        try container.encodeIfPresent(self.globalOptions.requireFieldMatch, forKey: .requireFieldMatch)
        try container.encodeIfPresent(self.globalOptions.tagScheme, forKey: .tagsSchema)
        try container.encodeIfPresent(self.globalOptions.highlighterType, forKey: .type)
        try container.encodeIfPresent(self.globalOptions.termVector, forKey: .termVector)
        try container.encodeIfPresent(self.globalOptions.indexOptions, forKey: .indexOptions)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fields = try container.decodeArray(forKey: .fields)
        var options = FieldOptions()
        let chars: [String]? = try container.decodeArrayIfPresent(forKey: .boundaryChars)
        if let chars = chars {
            var charArr = [Character]()
            for char in chars {
                charArr.append(contentsOf: [Character](char))
            }
            options.boundaryChars = charArr
        } else {
            options.boundaryChars = nil
        }
        options.boundaryMaxScan = try container.decodeIntIfPresent(forKey: .boundaryMaxScan)
        options.boundaryScannerType = try container.decodeIfPresent(Highlight.BoundaryScannerType.self, forKey: .boundaryScannerType)
        options.boundaryScannerLocale = try container.decodeStringIfPresent(forKey: .boundaryScannerLocale)
        options.encoder = try container.decodeIfPresent(Highlight.EncoderType.self, forKey: .encoder)
        options.forceSource = try container.decodeBoolIfPresent(forKey: .forceSource)
        options.fragmenter = try container.decodeStringIfPresent(forKey: .fragmenter)
        options.fragmentOffset = try container.decodeIntIfPresent(forKey: .fragmentOffset)
        options.fragmentSize = try container.decodeIntIfPresent(forKey: .fragmentSize)
        options.highlightQuery = try container.decodeQueryIfPresent(forKey: .highlightQuery)
        options.matchedFields = try container.decodeArray(forKey: .matchedFields)
        options.noMatchSize = try container.decodeIntIfPresent(forKey: .noMatchSize)
        options.numberOfFragments = try container.decodeIntIfPresent(forKey: .numberOfFragments)
        let order = try container.decodeStringIfPresent(forKey: .order)
        if let order = order {
            switch order {
            case Highlight.FieldOptions.SCORE_ORDERER_VALUE:
                options.scoreOrdered = true
            default:
                options.scoreOrdered = false
            }
        } else {
            options.scoreOrdered = nil
        }
        options.phraseLimit = try container.decodeIntIfPresent(forKey: .phraseLimit)
        options.preTags = try container.decodeArray(forKey: .preTags)
        options.postTags = try container.decodeArray(forKey: .postTags)
        options.requireFieldMatch = try container.decodeBoolIfPresent(forKey: .requireFieldMatch)
        options.tagScheme = try container.decodeStringIfPresent(forKey: .tagsSchema)
        options.highlighterType = try container.decodeIfPresent(Highlight.HighlighterType.self, forKey: .type)
        options.termVector = try container.decodeStringIfPresent(forKey: .termVector)
        options.indexOptions = try container.decodeStringIfPresent(forKey: .indexOptions)
        self.globalOptions = options
    }
    
    
    enum CodingKeys: String, CodingKey {
        case fields
        case boundaryChars = "boundary_chars"
        case boundaryMaxScan = "boundary_max_scan"
        case boundaryScannerType = "boundary_scanner"
        case boundaryScannerLocale = "boundary_scanner_locale"
        case encoder
        case forceSource = "force_source"
        case fragmenter
        case fragmentOffset = "fragment_offset"
        case fragmentSize = "fragment_size"
        case highlightQuery = "highlight_query"
        case matchedFields = "matched_fields"
        case noMatchSize = "no_match_size"
        case numberOfFragments = "number_of_fragments"
        case order
        case phraseLimit = "phrase_limit"
        case preTags = "pre_tags"
        case postTags = "post_tags"
        case requireFieldMatch = "require_field_match"
        case tagsSchema = "tags_schema"
        case type
        case termVector = "term_vector"
        case indexOptions = "index_options"
    }
}

extension Highlight: Equatable {}

extension Highlight {
    public struct Field {
        public let name: String
        public let options: FieldOptions
        
        public init(_ name: String, options: FieldOptions = FieldOptions()) {
            self.name = name
            self.options = options
        }
    }
    
    public struct FieldOptions {
        
        fileprivate static let SCORE_ORDERER_VALUE = "score"
        
        public var fragmentSize: Int?
        public var numberOfFragments: Int?
        public var fragmentOffset: Int?
        public var encoder: EncoderType?
        public var preTags: [String]?
        public var postTags: [String]?
        public var scoreOrdered: Bool?
        public var requireFieldMatch: Bool?
        public var highlighterType: HighlighterType?
        public var forceSource: Bool?
        public var fragmenter: String?
        public var boundaryScannerType: BoundaryScannerType?
        public var boundaryMaxScan: Int?
        public var boundaryChars: [Character]?
        public var boundaryScannerLocale: String?
        public var highlightQuery: Query?
        public var noMatchSize: Int?
        public var matchedFields: [String]?
        public var phraseLimit: Int?
        public var tagScheme: String?
        public var termVector: String?
        public var indexOptions: String?
        
        public init() {}
        
        internal init(withBuilder builder: FieldOptionsBuilder) {
            self.fragmentSize = builder.fragmentSize
            self.numberOfFragments = builder.numberOfFragments
            self.fragmentOffset = builder.fragmentOffset
            self.encoder = builder.encoder
            self.preTags = builder.preTags
            self.postTags = builder.postTags
            self.scoreOrdered = builder.scoreOrdered
            self.requireFieldMatch = builder.requireFieldMatch
            self.highlighterType = builder.highlighterType
            self.forceSource = builder.forceSource
            self.fragmenter = builder.fragmenter
            self.boundaryScannerType = builder.boundaryScannerType
            self.boundaryMaxScan = builder.boundaryMaxScan
            self.boundaryChars = builder.boundaryChars
            self.boundaryScannerLocale = builder.boundaryScannerLocale
            self.highlightQuery = builder.highlightQuery
            self.noMatchSize = builder.noMatchSize
            self.matchedFields = builder.matchedFields
            self.phraseLimit = builder.phraseLimit
            self.tagScheme = builder.tagScheme
            self.termVector = builder.termVector
            self.indexOptions = builder.indexOptions
        }
    }
    
    public enum BoundaryScannerType: String, Codable {
        case chars
        case word
        case sentence
    }
    
    public enum EncoderType: String, Codable {
        case `default`
        case html
    }
    
    public enum HighlighterType: String, Codable {
        case unified
        case plain
        case fvh
    }
}

extension Highlight.Field: Codable {
    public func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encodeIfPresent(self.options, forKey: .key(named: self.name))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(Highlight.Field.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        let field = container.allKeys.first!.stringValue
        
        self.options = try container.decode(Highlight.FieldOptions.self, forKey: .key(named: field))
        self.name = field
        
    }
}

extension Highlight.Field: Equatable{}

extension Highlight.FieldOptions: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.boundaryChars?.map { String($0) }, forKey: .boundaryChars)
        try container.encodeIfPresent(self.boundaryMaxScan, forKey: .boundaryMaxScan)
        try container.encodeIfPresent(self.boundaryScannerType, forKey: .boundaryScannerType)
        try container.encodeIfPresent(self.boundaryScannerLocale, forKey: .boundaryScannerLocale)
        try container.encodeIfPresent(self.encoder, forKey: .encoder)
        try container.encodeIfPresent(self.forceSource, forKey: .forceSource)
        try container.encodeIfPresent(self.fragmenter, forKey: .fragmenter)
        try container.encodeIfPresent(self.fragmentOffset, forKey: .fragmentOffset)
        try container.encodeIfPresent(self.fragmentSize, forKey: .fragmentSize)
        try container.encodeIfPresent(self.highlightQuery, forKey: .highlightQuery)
        try container.encodeIfPresent(self.matchedFields, forKey: .matchedFields)
        try container.encodeIfPresent(self.numberOfFragments, forKey: .numberOfFragments)
        try container.encodeIfPresent((self.scoreOrdered ?? false) ? Highlight.FieldOptions.SCORE_ORDERER_VALUE: nil, forKey: .order)
        try container.encodeIfPresent(self.phraseLimit, forKey: .phraseLimit)
        try container.encodeIfPresent(self.preTags, forKey: .preTags)
        try container.encodeIfPresent(self.postTags, forKey: .postTags)
        try container.encodeIfPresent(self.requireFieldMatch, forKey: .requireFieldMatch)
        try container.encodeIfPresent(self.tagScheme, forKey: .tagsSchema)
        try container.encodeIfPresent(self.highlighterType, forKey: .type)
        try container.encodeIfPresent(self.termVector, forKey: .termVector)
        try container.encodeIfPresent(self.indexOptions, forKey: .indexOptions)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let chars: [String]? = try container.decodeArrayIfPresent(forKey: .boundaryChars)
        if let chars = chars {
            var charArr = [Character]()
            for char in chars {
                charArr.append(contentsOf: [Character](char))
            }
            self.boundaryChars = charArr
        } else {
            self.boundaryChars = nil
        }
        self.boundaryMaxScan = try container.decodeIntIfPresent(forKey: .boundaryMaxScan)
        self.boundaryScannerType = try container.decodeIfPresent(Highlight.BoundaryScannerType.self, forKey: .boundaryScannerType)
        self.boundaryScannerLocale = try container.decodeStringIfPresent(forKey: .boundaryScannerLocale)
        self.encoder = try container.decodeIfPresent(Highlight.EncoderType.self, forKey: .encoder)
        self.forceSource = try container.decodeBoolIfPresent(forKey: .forceSource)
        self.fragmenter = try container.decodeStringIfPresent(forKey: .fragmenter)
        self.fragmentOffset = try container.decodeIntIfPresent(forKey: .fragmentOffset)
        self.fragmentSize = try container.decodeIntIfPresent(forKey: .fragmentSize)
        self.highlightQuery = try container.decodeQueryIfPresent(forKey: .highlightQuery)
        self.matchedFields = try container.decodeArray(forKey: .matchedFields)
        self.noMatchSize = try container.decodeIntIfPresent(forKey: .noMatchSize)
        self.numberOfFragments = try container.decodeIntIfPresent(forKey: .numberOfFragments)
        let order = try container.decodeStringIfPresent(forKey: .order)
        if let order = order {
            switch order {
            case Highlight.FieldOptions.SCORE_ORDERER_VALUE:
                self.scoreOrdered = true
            default:
                self.scoreOrdered = false
            }
        } else {
            self.scoreOrdered = nil
        }
        self.phraseLimit = try container.decodeIntIfPresent(forKey: .phraseLimit)
        self.preTags = try container.decodeArray(forKey: .preTags)
        self.postTags = try container.decodeArray(forKey: .postTags)
        self.requireFieldMatch = try container.decodeBoolIfPresent(forKey: .requireFieldMatch)
        self.tagScheme = try container.decodeStringIfPresent(forKey: .tagsSchema)
        self.highlighterType = try container.decodeIfPresent(Highlight.HighlighterType.self, forKey: .type)
        self.termVector = try container.decodeStringIfPresent(forKey: .termVector)
        self.indexOptions = try container.decodeStringIfPresent(forKey: .indexOptions)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case boundaryChars = "boundary_chars"
        case boundaryMaxScan = "boundary_max_scan"
        case boundaryScannerType = "boundary_scanner"
        case boundaryScannerLocale = "boundary_scanner_locale"
        case encoder
        case forceSource = "force_source"
        case fragmenter
        case fragmentOffset = "fragment_offset"
        case fragmentSize = "fragment_size"
        case highlightQuery = "highlight_query"
        case matchedFields = "matched_fields"
        case noMatchSize = "no_match_size"
        case numberOfFragments = "number_of_fragments"
        case order
        case phraseLimit = "phrase_limit"
        case preTags = "pre_tags"
        case postTags = "post_tags"
        case requireFieldMatch = "require_field_match"
        case tagsSchema = "tags_schema"
        case type
        case termVector = "term_vector"
        case indexOptions = "index_options"
    }
}

extension Highlight.FieldOptions: Equatable {
    public static func == (lhs: Highlight.FieldOptions, rhs: Highlight.FieldOptions) -> Bool {
        return lhs.boundaryChars == rhs.boundaryChars
            && lhs.boundaryMaxScan == rhs.boundaryMaxScan
            && lhs.boundaryScannerType == rhs.boundaryScannerType
            && lhs.boundaryScannerLocale == rhs.boundaryScannerLocale
            && lhs.encoder == rhs.encoder
            && lhs.forceSource == rhs.forceSource
            && lhs.fragmenter == rhs.fragmenter
            && lhs.fragmentOffset == rhs.fragmentOffset
            && lhs.fragmentSize == rhs.fragmentSize
            && lhs.matchedFields == rhs.matchedFields
            && lhs.noMatchSize == rhs.noMatchSize
            && lhs.numberOfFragments == rhs.numberOfFragments
            && lhs.scoreOrdered == rhs.scoreOrdered
            && lhs.phraseLimit == rhs.phraseLimit
            && lhs.preTags == rhs.preTags
            && lhs.requireFieldMatch == rhs.requireFieldMatch
            && lhs.tagScheme == rhs.tagScheme
            && lhs.highlighterType == rhs.highlighterType
            && SearchRequest.matchQueries(lhs.highlightQuery, rhs.highlightQuery)
    }
    
    
}
