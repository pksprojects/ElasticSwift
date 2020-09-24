//
//  SearchRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

// MARK: - Search Request Builder

public class SearchRequestBuilder: RequestBuilder {
    public typealias RequestType = SearchRequest

    private var _indices: [String]?
    private var _types: [String]?
    private var _searchSource = SearchSource()
    private var _sourceFilter: SourceFilter?
    private var _scroll: Scroll?
    private var _searchType: SearchType?
    private var _preference: String?

    public init() {}

    @discardableResult
    public func set(indices: String...) -> Self {
        _indices = indices
        return self
    }

    @discardableResult
    public func set(indices: [String]) -> Self {
        _indices = indices
        return self
    }

    @discardableResult
    public func set(types: String...) -> Self {
        _types = types
        return self
    }

    @discardableResult
    public func set(types: [String]) -> Self {
        _types = types
        return self
    }

    @discardableResult
    public func set(searchSource: SearchSource) -> Self {
        _searchSource = searchSource
        return self
    }

    @discardableResult
    public func set(from: Int16) -> Self {
        _searchSource.from = from
        return self
    }

    @discardableResult
    public func set(size: Int16) -> Self {
        _searchSource.size = size
        return self
    }

    @discardableResult
    public func set(query: Query) -> Self {
        _searchSource.query = query
        return self
    }

    @discardableResult
    public func set(postFilter: Query) -> Self {
        _searchSource.postFilter = postFilter
        return self
    }

    @discardableResult
    public func set(sorts: [Sort]) -> Self {
        _searchSource.sorts = sorts
        return self
    }

    @discardableResult
    public func set(sourceFilter: SourceFilter) -> Self {
        _searchSource.sourceFilter = sourceFilter
        return self
    }

    @discardableResult
    public func set(explain: Bool) -> Self {
        _searchSource.explain = explain
        return self
    }

    @discardableResult
    public func set(minScore: Decimal) -> Self {
        _searchSource.minScore = minScore
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
        _searchSource.trackScores = trackScores
        return self
    }

    @discardableResult
    public func set(indicesBoost: [IndexBoost]) -> Self {
        _searchSource.indicesBoost = indicesBoost
        return self
    }

    @discardableResult
    public func set(preference: String) -> Self {
        _preference = preference
        return self
    }

    @discardableResult
    public func set(version: Bool) -> Self {
        _searchSource.version = version
        return self
    }

    @discardableResult
    public func set(seqNoPrimaryTerm: Bool) -> Self {
        _searchSource.seqNoPrimaryTerm = seqNoPrimaryTerm
        return self
    }

    @discardableResult
    public func set(scriptFields: [ScriptField]) -> Self {
        _searchSource.scriptFields = scriptFields
        return self
    }

    @discardableResult
    public func set(docvalueFields: [DocValueField]) -> Self {
        _searchSource.docvalueFields = docvalueFields
        return self
    }

    @discardableResult
    public func set(rescore: [QueryRescorer]) -> Self {
        _searchSource.rescore = rescore
        return self
    }

    @discardableResult
    public func set(searchAfter: CodableValue) -> Self {
        _searchSource.searchAfter = searchAfter
        return self
    }

    @discardableResult
    public func add(sort: Sort) -> Self {
        if _searchSource.sorts != nil {
            _searchSource.sorts?.append(sort)
        } else {
            _searchSource.sorts = [sort]
        }
        return self
    }

    @discardableResult
    public func add(indexBoost: IndexBoost) -> Self {
        if _searchSource.indicesBoost != nil {
            _searchSource.indicesBoost?.append(indexBoost)
        } else {
            _searchSource.indicesBoost = [indexBoost]
        }
        return self
    }

    @discardableResult
    public func add(scriptField: ScriptField) -> Self {
        if _searchSource.scriptFields != nil {
            _searchSource.scriptFields?.append(scriptField)
        } else {
            _searchSource.scriptFields = [scriptField]
        }
        return self
    }

    @discardableResult
    public func add(docvalueField: DocValueField) -> Self {
        if _searchSource.docvalueFields != nil {
            _searchSource.docvalueFields?.append(docvalueField)
        } else {
            _searchSource.docvalueFields = [docvalueField]
        }
        return self
    }

    @discardableResult
    public func add(rescore: QueryRescorer) -> Self {
        if _searchSource.rescore != nil {
            _searchSource.rescore?.append(rescore)
        } else {
            _searchSource.rescore = [rescore]
        }
        return self
    }

    @discardableResult
    public func set(storedFields: String...) -> Self {
        _searchSource.storedFields = storedFields
        return self
    }

    @discardableResult
    public func set(storedFields: [String]) -> Self {
        _searchSource.storedFields = storedFields
        return self
    }

    @discardableResult
    public func set(highlight: Highlight) -> Self {
        _searchSource.highlight = highlight
        return self
    }

    @discardableResult
    public func add(index: String) -> Self {
        if _indices != nil {
            _indices?.append(index)
        } else {
            _indices = [index]
        }
        return self
    }

    @discardableResult
    public func add(type: String) -> Self {
        if _types != nil {
            _types?.append(type)
        } else {
            _types = [type]
        }
        return self
    }

    public var indices: [String]? {
        return _indices
    }

    public var types: [String]? {
        return _types
    }

    public var searchSource: SearchSource {
        return _searchSource
    }

    public var sourceFilter: SourceFilter? {
        return _sourceFilter
    }

    public var scroll: Scroll? {
        return _scroll
    }

    public var searchType: SearchType? {
        return _searchType
    }

    public var preference: String? {
        return _preference
    }

    public func build() throws -> SearchRequest {
        return try SearchRequest(withBuilder: self)
    }
}

// MARK: - Search Request

public struct SearchRequest: Request {
    public var headers = HTTPHeaders()

    public let indices: [String]?
    public let types: [String]?
    public let searchSource: SearchSource?

    public var scroll: Scroll?
    public var searchType: SearchType?
    public var preference: String?

    public init(indices: [String]?, types: [String]?, searchSource: SearchSource?, scroll: Scroll? = nil, searchType: SearchType? = nil, preference: String? = nil) {
        self.indices = indices
        self.types = types
        self.searchSource = searchSource
        self.scroll = scroll
        self.searchType = searchType
        self.preference = preference
    }

    public init(indices: [String]? = nil, types: [String]? = nil, query: Query? = nil, from: Int16? = nil, size: Int16? = nil, sorts: [Sort]? = nil, sourceFilter: SourceFilter? = nil, explain: Bool? = nil, minScore: Decimal? = nil, scroll: Scroll? = nil, trackScores: Bool? = nil, indicesBoost: [IndexBoost]? = nil, searchType: SearchType? = nil, seqNoPrimaryTerm: Bool? = nil, version: Bool? = nil, preference: String? = nil, scriptFields: [ScriptField]? = nil, storedFields: [String]? = nil, docvalueFields: [DocValueField]? = nil, postFilter: Query? = nil, highlight: Highlight? = nil, rescore: [QueryRescorer]? = nil, searchAfter: CodableValue? = nil) {
        var searchSource = SearchSource()
        searchSource.query = query
        searchSource.postFilter = postFilter
        searchSource.from = from
        searchSource.size = size
        searchSource.sorts = sorts
        searchSource.sourceFilter = sourceFilter
        searchSource.explain = explain
        searchSource.minScore = minScore
        searchSource.trackScores = trackScores
        searchSource.indicesBoost = indicesBoost
        searchSource.docvalueFields = docvalueFields
        searchSource.highlight = highlight
        searchSource.rescore = rescore
        searchSource.searchAfter = searchAfter
        searchSource.seqNoPrimaryTerm = seqNoPrimaryTerm
        searchSource.scriptFields = scriptFields
        searchSource.storedFields = storedFields
        searchSource.version = version
        self.init(indices: indices, types: types, searchSource: searchSource, scroll: scroll, searchType: searchType, preference: preference)
    }

    public init(indices: String..., types: [String]? = nil, query: Query? = nil, from: Int16? = nil, size: Int16? = nil, sorts: [Sort]? = nil, sourceFilter: SourceFilter? = nil, explain: Bool? = nil, minScore: Decimal? = nil, scroll: Scroll? = nil, trackScores: Bool? = nil, indicesBoost: [IndexBoost]? = nil, searchType: SearchType? = nil, seqNoPrimaryTerm: Bool? = nil, version: Bool? = nil, preference: String? = nil, scriptFields: [ScriptField]? = nil, storedFields: [String]? = nil, docvalueFields: [DocValueField]? = nil, postFilter: Query? = nil, highlight: Highlight? = nil, rescore: [QueryRescorer]? = nil, searchAfter: CodableValue? = nil) {
        self.init(indices: indices, types: types, query: query, from: from, size: size, sorts: sorts, sourceFilter: sourceFilter, explain: explain, minScore: minScore, scroll: scroll, trackScores: trackScores, indicesBoost: indicesBoost, searchType: searchType, seqNoPrimaryTerm: seqNoPrimaryTerm, version: version, preference: preference, scriptFields: scriptFields, storedFields: storedFields, docvalueFields: docvalueFields, postFilter: postFilter, highlight: highlight, rescore: rescore, searchAfter: searchAfter)
    }

    internal init(withBuilder builder: SearchRequestBuilder) throws {
        self.init(indices: builder.indices, types: builder.types, searchSource: builder.searchSource, scroll: builder.scroll, searchType: builder.searchType, preference: builder.preference)
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        var _endPoint = "_search"
        if let types = self.types, !types.isEmpty {
            _endPoint = types.joined(separator: ",") + "/" + _endPoint
        }
        if let indices = self.indices, !indices.isEmpty {
            _endPoint = indices.joined(separator: ",") + "/" + _endPoint
        }
        return _endPoint
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
        if let body = searchSource {
            return serializer.encode(body).mapError { error -> MakeBodyError in
                MakeBodyError.wrapped(error)
            }
        }
        return .failure(.noBodyForRequest)
    }
}

extension SearchRequest: Equatable {}

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
        if let totalHitsAsInt = restTotalHitsAsInt {
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
    /// Same as [queryThenFetch](x-source-tag://queryThenFetch), except for an initial scatter phase which goes and computes the distributed
    /// term frequencies for more accurate scoring.
    case dfsQueryThenFetch = "dfs_query_then_fetch"
    /// The query is executed against all shards, but only enough information is returned (not the document content).
    /// The results are then sorted and ranked, and based on it, only the relevant shards are asked for the actual
    /// document content. The return number of hits is exactly as specified in size, since they are the only ones that
    /// are fetched. This is very handy when the index has a lot of shards (not replicas, shard id groups).
    /// - Tag: `queryThenFetch`
    case queryThenFetch = "query_then_fetch"

    /// Only used for pre 5.3 request where this type is still needed
    @available(*, deprecated, message: "Only used for pre 5.3 request where this type is still needed")
    case queryAndFetch = "query_and_fetch"

    /// The default search type [queryThenFetch](x-source-tag://queryThenFetch)
    public static let DEFAULT = SearchType.queryThenFetch
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

// MARK: - Rescoring

/// Protocol that all rescorer conform to.
public protocol Rescorer: Codable {
    var rescorerType: RescorerType { get }
    var windowSize: Int? { get }

    func isEqualTo(_ other: Rescorer) -> Bool
}

extension Rescorer where Self: Equatable {
    public func isEqualTo(_ other: Rescorer) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

/// Protocol to wrap rescorer type information
public protocol RescorerType: Codable {
    var metaType: Rescorer.Type { get }

    var name: String { get }

    init?(_ name: String)

    func isEqualTo(_ other: RescorerType) -> Bool
}

extension RescorerType where Self: RawRepresentable, Self.RawValue == String {
    public var name: String {
        return rawValue
    }

    public init?(_ name: String) {
        if let v = Self(rawValue: name) {
            self = v
        } else {
            return nil
        }
    }
}

extension RescorerType where Self: Equatable {
    public func isEqualTo(_ other: RescorerType) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

public enum RescorerTypes: String, RescorerType, Codable {
    case query
}

extension RescorerTypes {
    public var metaType: Rescorer.Type {
        switch self {
        case .query:
            return QueryRescorer.self
        }
    }
}

/// `SearchRequest` rescorer based on a query.
public struct QueryRescorer: Rescorer {
    public let rescorerType: RescorerType = RescorerTypes.query
    public let windowSize: Int?
    public let rescoreQuery: Query
    public let queryWeight: Decimal?
    public let rescoreQueryWeight: Decimal?
    public let scoreMode: ScoreMode?

    public init(_ rescoreQuery: Query, scoreMode: ScoreMode? = nil, queryWeight: Decimal? = nil, rescoreQueryWeight: Decimal? = nil, windowSize: Int? = nil) {
        self.rescoreQuery = rescoreQuery
        self.scoreMode = scoreMode
        self.queryWeight = queryWeight
        self.rescoreQueryWeight = rescoreQueryWeight
        self.windowSize = windowSize
    }
}

extension QueryRescorer: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(windowSize, forKey: .windowSize)
        var queryContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .query)
        try queryContainer.encode(rescoreQuery, forKey: .rescoreQuery)
        try queryContainer.encodeIfPresent(scoreMode, forKey: .scoreMode)
        try queryContainer.encodeIfPresent(queryWeight, forKey: .queryWeight)
        try queryContainer.encodeIfPresent(rescoreQueryWeight, forKey: .rescoreQueryWeight)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        windowSize = try container.decodeIntIfPresent(forKey: .windowSize)
        let queryContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .query)
        rescoreQuery = try queryContainer.decodeQuery(forKey: .rescoreQuery)
        scoreMode = try queryContainer.decodeIfPresent(ScoreMode.self, forKey: .scoreMode)
        queryWeight = try queryContainer.decodeDecimalIfPresent(forKey: .queryWeight)
        rescoreQueryWeight = try queryContainer.decodeDecimalIfPresent(forKey: .rescoreQueryWeight)
    }

    enum CodingKeys: String, CodingKey {
        case windowSize = "window_size"
        case query
        case rescoreQuery = "rescore_query"
        case rescoreQueryWeight = "rescore_query_weight"
        case queryWeight = "query_weight"
        case scoreMode = "score_mode"
    }
}

extension QueryRescorer: Equatable {
    public static func == (lhs: QueryRescorer, rhs: QueryRescorer) -> Bool {
        return lhs.rescorerType.isEqualTo(rhs.rescorerType)
            && lhs.windowSize == rhs.windowSize
            && lhs.queryWeight == rhs.queryWeight
            && lhs.rescoreQueryWeight == rhs.rescoreQueryWeight
            && lhs.scoreMode == rhs.scoreMode
            && isEqualQueries(lhs.rescoreQuery, rhs.rescoreQuery)
    }
}

// MARK: - Search Source

public struct SearchSource {
    public var query: Query?
    public var sorts: [Sort]?
    public var size: Int16?
    public var from: Int16?
    public var sourceFilter: SourceFilter?
    public var explain: Bool?
    public var minScore: Decimal?
    public var trackScores: Bool?
    public var indicesBoost: [IndexBoost]?
    public var seqNoPrimaryTerm: Bool?
    public var version: Bool?
    public var scriptFields: [ScriptField]?
    public var storedFields: [String]?
    public var docvalueFields: [DocValueField]?
    public var postFilter: Query?
    public var highlight: Highlight?
    public var rescore: [Rescorer]?
    public var searchAfter: CodableValue?
}

extension SearchSource: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        query = try container.decodeQueryIfPresent(forKey: .query)
        sorts = try container.decodeArrayIfPresent(forKey: .sorts)
        size = try container.decodeInt16IfPresent(forKey: .size)
        from = try container.decodeInt16IfPresent(forKey: .from)
        sourceFilter = try container.decodeIfPresent(SourceFilter.self, forKey: .sourceFilter)
        explain = try container.decodeBoolIfPresent(forKey: .explain)
        minScore = try container.decodeDecimalIfPresent(forKey: .minScore)
        trackScores = try container.decodeBoolIfPresent(forKey: .trackScores)
        indicesBoost = try container.decodeArrayIfPresent(forKey: .indicesBoost)
        seqNoPrimaryTerm = try container.decodeBoolIfPresent(forKey: .seqNoPrimaryTerm)
        version = try container.decodeBoolIfPresent(forKey: .version)
        storedFields = try container.decodeArrayIfPresent(forKey: .storedFields)
        docvalueFields = try container.decodeArrayIfPresent(forKey: .docvalueFields)
        postFilter = try container.decodeQueryIfPresent(forKey: .postFilter)
        highlight = try container.decodeIfPresent(Highlight.self, forKey: .highlight)
        searchAfter = try container.decodeIfPresent(CodableValue.self, forKey: .searchAfter)

        do {
            scriptFields = try container.decodeArrayIfPresent(forKey: .scriptFields)
        } catch {
            let scriptField = try container.decode(ScriptField.self, forKey: .scriptFields)
            scriptFields = [scriptField]
        }

        do {
            rescore = try container.decodeRescorersIfPresent(forKey: .rescore)
        } catch {
            let rescorer = try container.decode(QueryRescorer.self, forKey: .rescore)
            rescore = [rescorer]
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(sorts, forKey: .sorts)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(sourceFilter, forKey: .sourceFilter)
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
        if let rescore = self.rescore, !rescore.isEmpty {
            if rescore.count == 1 {
                try container.encode(rescore[0], forKey: .rescore)
            } else {
                try container.encode(rescore, forKey: .rescore)
            }
        }
        try container.encodeIfPresent(searchAfter, forKey: .searchAfter)
    }

    enum CodingKeys: String, CodingKey {
        case query
        case sorts = "sort"
        case size
        case from
        case sourceFilter = "_source"
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
        case rescore
        case searchAfter = "search_after"
    }
}

extension SearchSource: Equatable {
    public static func == (lhs: SearchSource, rhs: SearchSource) -> Bool {
        return lhs.sorts == rhs.sorts
            && lhs.size == rhs.size
            && lhs.from == rhs.from
            && lhs.sourceFilter == rhs.sourceFilter
            && lhs.explain == rhs.explain
            && lhs.minScore == rhs.minScore
            && lhs.trackScores == rhs.trackScores
            && lhs.indicesBoost == rhs.indicesBoost
            && lhs.seqNoPrimaryTerm == rhs.seqNoPrimaryTerm
            && lhs.version == rhs.version
            && lhs.scriptFields == rhs.scriptFields
            && lhs.storedFields == rhs.storedFields
            && lhs.docvalueFields == rhs.docvalueFields
            && lhs.highlight == rhs.highlight
            && isEqualRescorers(lhs.rescore, rhs.rescore)
            && lhs.searchAfter == rhs.searchAfter
            && isEqualQueries(lhs.query, rhs.query)
            && isEqualQueries(lhs.postFilter, rhs.postFilter)
    }
}

public func isEqualRescorers(_ lhs: Rescorer?, _ rhs: Rescorer?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    if let lhs = lhs, let rhs = rhs {
        return lhs.isEqualTo(rhs)
    }
    return false
}

public func isEqualRescorers(_ lhs: [Rescorer]?, _ rhs: [Rescorer]?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    if let lhs = lhs, let rhs = rhs {
        if lhs.count == rhs.count {
            return !zip(lhs, rhs).contains { !$0.isEqualTo($1) }
        }
    }
    return false
}

extension KeyedEncodingContainer {
    public mutating func encode(_ value: Rescorer, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    public mutating func encode(_ value: [Rescorer], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let rescorersEncoder = superEncoder(forKey: key)
        var rescorersContainer = rescorersEncoder.unkeyedContainer()
        for rescorer in value {
            let rescorerEncoder = rescorersContainer.superEncoder()
            try rescorer.encode(to: rescorerEncoder)
        }
    }
}

extension KeyedDecodingContainer {
    public func decodeRescorer(forKey key: KeyedDecodingContainer<K>.Key) throws -> Rescorer {
        let qContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for rKey in qContainer.allKeys {
            if let rType = RescorerTypes(rKey.stringValue) {
                return try rType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(RescorerTypes.self, .init(codingPath: codingPath, debugDescription: "Unable to identify rescorer type from key(s) \(qContainer.allKeys)"))
    }

    public func decodeRescorerIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Rescorer? {
        guard contains(key) else {
            return nil
        }
        return try decodeRescorer(forKey: key)
    }

    public func decodeRescorers(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Rescorer] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [Rescorer]()
        if let count = arrayContainer.count {
            while !arrayContainer.isAtEnd {
                let query = try arrayContainer.decodeRescorer()
                result.append(query)
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all Rescorers expected: \(count) actual: \(result.count). Probable cause: Unable to determine RescorerType form key(s)"))
            }
        }
        return result
    }

    public func decodeRescorersIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Rescorer]? {
        guard contains(key) else {
            return nil
        }
        return try decodeRescorers(forKey: key)
    }
}

extension UnkeyedDecodingContainer {
    mutating func decodeRescorer() throws -> Rescorer {
        var copy = self
        let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
        for rKey in elementContainer.allKeys {
            if let rType = RescorerTypes(rKey.stringValue) {
                return try rType.metaType.init(from: superDecoder())
            }
        }
        throw Swift.DecodingError.typeMismatch(RescorerTypes.self, .init(codingPath: codingPath, debugDescription: "Unable to identify rescorer type from key(s) \(elementContainer.allKeys)"))
    }
}
