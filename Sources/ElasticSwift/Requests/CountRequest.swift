//
//  CountRequest.swift
//  ElasticSwift
//  
//
//  Created by Prafull Kumar Soni on 1/11/20.
//

import NIOHTTP1
import Foundation
import ElasticSwiftCore
import ElasticSwiftQueryDSL

// MARK:- Count Request Builder

public class CountRequestBuilder: RequestBuilder {
    public typealias RequestType = CountRequest
    
    private var _indices: [String]?
    private var _types: [String]?
    private var _query: Query?
    
    private var _ignoreUnavailable: Bool?
    private var _ignoreThrottled: Bool?
    private var _allowNoIndices: Bool?
    private var _expandWildcards: ExpandWildcards?
    private var _minScore: Decimal?
    private var _preference: String?
    private var _routing: String?
    private var _q: String?
    private var _analyzer: String?
    private var _analyzeWildcard: Bool?
    private var _defaultOperator: QueryStringQueryOperator?
    private var _df: String?
    private var _lenient: String?
    private var _terminateAfter: Int?
    
    public init() {}
    
    @discardableResult
    public func set(indices: String...) -> Self {
        self._indices = indices
        return self
    }

    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    @discardableResult
    public func set(types: String...) -> Self {
        self._types = types
        return self
    }
    
    @discardableResult
    public func add(index: String) -> Self {
        if self._indices != nil {
            self._indices?.append(index)
        } else {
            self._indices = [index]
        }
        return self
    }
    
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    @discardableResult
    public func add(type: String) -> Self {
        if self._types != nil {
            self._types?.append(type)
        } else {
            self._types = [type]
        }
        return self
    }
    
    @discardableResult
    public func set(query: Query) -> Self {
        self._query = query
        return self
    }
    
    @discardableResult
    public func set(ignoreUnavailable: Bool) -> Self {
        self._ignoreUnavailable = ignoreUnavailable
        return self
    }
    
    @discardableResult
    public func set(ignoreThrottled: Bool) -> Self {
        self._ignoreThrottled = ignoreThrottled
        return self
    }
    
    @discardableResult
    public func set(allowNoIndices: Bool) -> Self {
        self._allowNoIndices = allowNoIndices
        return self
    }
    
    @discardableResult
    public func set(expandWildcards: ExpandWildcards) -> Self {
        self._expandWildcards = expandWildcards
        return self
    }
    
    @discardableResult
    public func set(minScore: Decimal) -> Self {
        self._minScore = minScore
        return self
    }
    
    @discardableResult
    public func set(preference: String) -> Self {
        self._preference = preference
        return self
    }
    
    @discardableResult
    public func set(routing: String) -> Self {
        self._routing = routing
        return self
    }
    
    @discardableResult
    public func set(q: String) -> Self {
        self._q = q
        return self
    }
    
    @discardableResult
    public func set(analyzer: String) -> Self {
        self._analyzer = analyzer
        return self
    }
    
    @discardableResult
    public func set(analyzeWildcard: Bool) -> Self {
        self._analyzeWildcard = analyzeWildcard
        return self
    }
    
    @discardableResult
    public func set(defaultOperator: QueryStringQueryOperator) -> Self {
        self._defaultOperator = defaultOperator
        return self
    }
    
    @discardableResult
    public func set(df: String) -> Self {
        self._df = df
        return self
    }
    
    @discardableResult
    public func set(lenient: String) -> Self {
        self._lenient = lenient
        return self
    }
    
    @discardableResult
    public func set(terminateAfter: Int) -> Self {
        self._terminateAfter = terminateAfter
        return self
    }
    
    public var indices: [String]? {
        return self._indices
    }
    public var types: [String]? {
        return self._types
    }
    public var query: Query? {
        return self._query
    }
    public var ignoreUnavailable: Bool? {
        return self._ignoreUnavailable
    }
    public var ignoreThrottled: Bool? {
        return self._ignoreThrottled
    }
    public var allowNoIndices: Bool? {
        return self._allowNoIndices
    }
    public var expandWildcards: ExpandWildcards? {
        return self._expandWildcards
    }
    public var minScore: Decimal? {
        return self._minScore
    }
    public var preference: String? {
        return self._preference
    }
    public var routing: String? {
        return self._routing
    }
    public var q: String? {
        return self._q
    }
    public var analyzer: String? {
        return self._analyzer
    }
    public var analyzeWildcard: Bool? {
        return self._analyzeWildcard
    }
    public var defaultOperator: QueryStringQueryOperator? {
        return self._defaultOperator
    }
    public var df: String? {
        return self._df
    }
    public var lenient: String? {
        return self._lenient
    }
    public var terminateAfter: Int? {
        return self._terminateAfter
    }
    
    public func build() throws -> CountRequest {
        return try CountRequest(withBuilder: self)
    }
}

// MARK:- Count Request

/// Encapsulates a request to _count API against one, several or all indices.
public struct CountRequest: Request {
    
    /// A comma-separated list of indices to restrict the results
    public let indices: [String]?
    /// A comma-separated list of types to restrict the results
    public let types: [String]?
    /// A query to restrict the results specified with the Query DSL (optional)
    public let query: Query?
    
    /// Whether specified concrete indices should be ignored when unavailable (missing or closed)
    public var ignoreUnavailable: Bool?
    /// Whether specified concrete, expanded or aliased indices should be ignored when throttled
    public var ignoreThrottled: Bool?
    /// Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
    public var allowNoIndices: Bool?
    /// Whether to expand wildcard expression to concrete indices that are open, closed or both.
    public var expandWildcards: ExpandWildcards?
    /// Include only documents with a specific `_score` value in the result
    public var minScore: Decimal?
    /// Specify the node or shard the operation should be performed on (default: random)
    public var preference: String?
    /// A comma-separated list of specific routing values
    public var routing: String?
    /// Query in the Lucene query string syntax
    public var q: String?
    /// The analyzer to use for the query string
    public var analyzer: String?
    /// Specify whether wildcard and prefix queries should be analyzed (default: false)
    public var analyzeWildcard: Bool?
    /// The default operator for query string query (AND or OR)
    public var defaultOperator: QueryStringQueryOperator?
    /// The field to use as default where no field prefix is given in the query string
    public var df: String?
    /// Specify whether format-based query failures (such as providing text to a numeric field) should be ignored
    public var lenient: String?
    /// The maximum count for each shard, upon reaching which the query execution will terminate early
    public var terminateAfter: Int?
    
    public init(indices: [String]? = nil, types: [String]? = nil, query: Query? = nil) {
        self.indices = indices
        self.types = types
        self.query = query
    }
    
    public init(indices: String..., types: [String]? = nil, query: Query? = nil) {
        self.init(indices: indices, types: types, query: query)
    }
    
    internal init(withBuilder builder: CountRequestBuilder) throws {
        self.init(indices: builder.indices, types: builder.types, query: builder.query)
        
        self.ignoreUnavailable = builder.ignoreUnavailable
        self.ignoreThrottled = builder.ignoreThrottled
        self.allowNoIndices = builder.allowNoIndices
        self.expandWildcards = builder.expandWildcards
        self.minScore = builder.minScore
        self.preference = builder.preference
        self.routing = builder.routing
        self.q = builder.q
        self.analyzer = builder.analyzer
        self.analyzeWildcard = builder.analyzeWildcard
        self.defaultOperator = builder.defaultOperator
        self.df = builder.df
        self.lenient = builder.lenient
        self.terminateAfter = builder.terminateAfter
    }
    
    public var headers: HTTPHeaders {
        return HTTPHeaders()
    }
    
    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let ignoreUnavailable = self.ignoreUnavailable {
            params.append(.init(name: .ignoreUnavailable, value: ignoreUnavailable))
        }
        if let ignoreThrottled = self.ignoreThrottled {
            params.append(.init(name: .ignoreThrottled, value: ignoreThrottled))
        }
        if let allowNoIndices = self.allowNoIndices {
            params.append(.init(name: .allowNoIndices, value: allowNoIndices))
        }
        if let expandWildcards = self.expandWildcards {
            params.append(.init(name: .expandWildcards, value: expandWildcards.rawValue))
        }
        if let minScore = self.minScore {
            params.append(.init(name: .minScore, value: minScore))
        }
        if let preference = self.preference {
            params.append(.init(name: .preference, value: preference))
        }
        if let routing = self.routing {
            params.append(.init(name: .routing, value: routing))
        }
        if let q = self.q {
            params.append(.init(name: .q, value: q))
        }
        if let analyzer = self.analyzer {
            params.append(.init(name: .analyzer, value: analyzer))
        }
        if let analyzeWildcard = self.analyzeWildcard {
            params.append(.init(name: .analyzeWildcard, value: analyzeWildcard))
        }
        if let defaultOperator = self.defaultOperator {
            params.append(.init(name: .defaultOperator, value: defaultOperator.rawValue))
        }
        if let df = self.df {
            params.append(.init(name: .df, value: df))
        }
        if let lenient = self.lenient {
            params.append(.init(name: .lenient, value: lenient))
        }
        if let terminateAfter = self.terminateAfter {
            params.append(.init(name: .terminateAfter, value: terminateAfter))
        }
        return params
    }
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var endPoint: String {
        var _endPoint = "_count"
        if let types = self.types, !types.isEmpty {
            _endPoint = types.compactMap { $0 }.joined(separator: ",") + "/" + _endPoint
        }
        if let indices = self.indices, !indices.isEmpty {
            _endPoint = indices.compactMap { $0 }.joined(separator: ",") + "/" + _endPoint
        }
        return _endPoint
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        if let query = self.query {
            let body = Body(query: query)
            return serializer.encode(body).mapError { error -> MakeBodyError in
                return .wrapped(error)
            }
        }
        return .failure(.noBodyForRequest)
    }
    
    struct Body: Encodable {
        let query: Query
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.query, forKey: .query)
        }
        
        enum CodingKeys: String, CodingKey {
            case query
        }
    }
    
}

extension CountRequest: Equatable {
    public static func == (lhs: CountRequest, rhs: CountRequest) -> Bool {
        return lhs.indices == rhs.indices
            && lhs.types == rhs.types
            && isEqualQueries(lhs.query, rhs.query)
            && lhs.ignoreUnavailable == rhs.ignoreUnavailable
            && lhs.ignoreThrottled == rhs.ignoreThrottled
            && lhs.allowNoIndices == rhs.allowNoIndices
            && lhs.expandWildcards == rhs.expandWildcards
            && lhs.minScore == rhs.minScore
            && lhs.preference == rhs.preference
            && lhs.routing == rhs.routing
            && lhs.q == rhs.q
            && lhs.analyzer == rhs.analyzer
            && lhs.analyzeWildcard == rhs.analyzeWildcard
            && lhs.defaultOperator == rhs.defaultOperator
            && lhs.df == rhs.df
            && lhs.lenient == rhs.lenient
            && lhs.terminateAfter == rhs.terminateAfter
    }
}


