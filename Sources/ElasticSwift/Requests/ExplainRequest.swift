//
//  ExplainRequest.swift
//  ElasticSwift
//
//
//  Created by Prafull Kumar Soni on 1/11/20.
//

import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

// MARK: - Explain Request Builder

public class ExplainRequestBuilder: RequestBuilder {
    public typealias RequestType = ExplainRequest

    private var _index: String?
    private var _type: String?
    private var _id: String?
    private var _query: Query?

    private var _storedFields: [String]?
    private var _parent: String?
    private var _preference: String?
    private var _routing: String?
    private var _q: String?
    private var _analyzer: String?
    private var _analyzeWildcard: Bool?
    private var _defaultOperator: QueryStringQueryOperator?
    private var _df: String?
    private var _lenient: String?
    private var _sourceFilter: SourceFilter?

    public init() {}

    @discardableResult
    public func set(index: String) -> Self {
        _index = index
        return self
    }

    @discardableResult
    public func set(type: String) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(query: Query) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(preference: String) -> Self {
        _preference = preference
        return self
    }

    @discardableResult
    public func set(routing: String) -> Self {
        _routing = routing
        return self
    }

    @discardableResult
    public func set(q: String) -> Self {
        _q = q
        return self
    }

    @discardableResult
    public func set(analyzer: String) -> Self {
        _analyzer = analyzer
        return self
    }

    @discardableResult
    public func set(analyzeWildcard: Bool) -> Self {
        _analyzeWildcard = analyzeWildcard
        return self
    }

    @discardableResult
    public func set(defaultOperator: QueryStringQueryOperator) -> Self {
        _defaultOperator = defaultOperator
        return self
    }

    @discardableResult
    public func set(df: String) -> Self {
        _df = df
        return self
    }

    @discardableResult
    public func set(lenient: String) -> Self {
        _lenient = lenient
        return self
    }

    @discardableResult
    public func set(parent: String) -> Self {
        _parent = parent
        return self
    }

    @discardableResult
    public func set(sourceFilter: SourceFilter) -> Self {
        _sourceFilter = sourceFilter
        return self
    }

    @discardableResult
    public func set(storedFields: [String]) -> Self {
        _storedFields = storedFields
        return self
    }

    @discardableResult
    public func add(storedField: String) -> Self {
        if _storedFields != nil {
            _storedFields?.append(storedField)
        } else {
            _storedFields = [storedField]
        }
        return self
    }

    public var index: String? {
        return _index
    }

    public var type: String? {
        return _type
    }

    public var id: String? {
        return _id
    }

    public var query: Query? {
        return _query
    }

    public var storedFields: [String]? {
        return _storedFields
    }

    public var parent: String? {
        return _parent
    }

    public var preference: String? {
        return _preference
    }

    public var routing: String? {
        return _routing
    }

    public var q: String? {
        return _q
    }

    public var analyzer: String? {
        return _analyzer
    }

    public var analyzeWildcard: Bool? {
        return _analyzeWildcard
    }

    public var defaultOperator: QueryStringQueryOperator? {
        return _defaultOperator
    }

    public var df: String? {
        return _df
    }

    public var lenient: String? {
        return _lenient
    }

    public var sourceFilter: SourceFilter? {
        return _sourceFilter
    }

    public func build() throws -> ExplainRequest {
        return try ExplainRequest(withBuilder: self)
    }
}

// MARK: - Explain Request

/// Explain request encapsulating the explain query and document identifier to get an explanation for.
public struct ExplainRequest: Request {
    /// The name of the index
    public let index: String
    /// The type of the document
    public let type: String
    /// The document ID
    public let id: String
    /// The query definition using the Query DSL
    public let query: Query?
    /// Query in the Lucene query string syntax
    public let q: String?
    /// Specify the node or shard the operation should be performed on (default: random)
    public var preference: String?
    /// A comma-separated list of specific routing values
    public var routing: String?
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
    /// Specify how to filter source body
    public var sourceFilter: SourceFilter?
    /// A comma-separated list of stored fields to return in the response
    public var storedFields: [String]?
    /// The ID of the parent document
    public var parent: String?

    public init(index: String, type: String, id: String, query: Query) {
        self.index = index
        self.type = type
        self.id = id
        self.query = query
        q = nil
    }

    public init(index: String, type: String, id: String, q: String) {
        self.index = index
        self.type = type
        self.id = id
        query = nil
        self.q = q
    }

    internal init(withBuilder builder: ExplainRequestBuilder) throws {
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }

        guard builder.type != nil else {
            throw RequestBuilderError.missingRequiredField("type")
        }

        guard builder.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }

        guard builder.query != nil || builder.q != nil else {
            throw RequestBuilderError.atleastOneFieldRequired(["query", "q"])
        }

        if let query = builder.query {
            self.init(index: builder.index!, type: builder.type!, id: builder.id!, query: query)
        } else {
            self.init(index: builder.index!, type: builder.type!, id: builder.id!, q: builder.q!)
        }

        preference = builder.preference
        routing = builder.routing
        analyzer = builder.analyzer
        analyzeWildcard = builder.analyzeWildcard
        defaultOperator = builder.defaultOperator
        df = builder.df
        lenient = builder.lenient
        sourceFilter = builder.sourceFilter
        storedFields = builder.storedFields
        parent = builder.parent
    }

    public var headers: HTTPHeaders {
        return HTTPHeaders()
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
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
        if let parent = self.parent {
            params.append(.init(name: .parent, value: parent))
        }
        if let storedFields = self.storedFields {
            params.append(.init(name: .storedFields, value: storedFields))
        }
        if let sourceFilter = self.sourceFilter {
            switch sourceFilter {
            case let .fetchSource(val):
                params.append(.init(name: .source, value: val))
            case let .filter(val):
                params.append(.init(name: .source, value: val))
            case let .filters(val):
                params.append(.init(name: .source, value: val))
            case let .source(includes, excludes):
                if !includes.isEmpty {
                    params.append(.init(name: .sourceIncludes, value: includes))
                }
                if !excludes.isEmpty {
                    params.append(.init(name: .sourceExcludes, value: excludes))
                }
            }
        }
        return params
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        return "\(index)/\(type)/\(id)/_explain"
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        if let query = self.query {
            let body = Body(query: query)
            return serializer.encode(body).mapError { error -> MakeBodyError in
                .wrapped(error)
            }
        }
        return .failure(.noBodyForRequest)
    }

    struct Body: Encodable {
        let query: Query

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(query, forKey: .query)
        }

        enum CodingKeys: String, CodingKey {
            case query
        }
    }
}

extension ExplainRequest: Equatable {
    public static func == (lhs: ExplainRequest, rhs: ExplainRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.type == rhs.type
            && lhs.id == rhs.id
            && isEqualQueries(lhs.query, rhs.query)
            && lhs.q == rhs.q
            && lhs.analyzeWildcard == rhs.analyzeWildcard
            && lhs.defaultOperator == rhs.defaultOperator
            && lhs.df == rhs.df
            && lhs.lenient == rhs.lenient
            && lhs.analyzer == rhs.analyzer
            && lhs.parent == rhs.parent
            && lhs.storedFields == rhs.storedFields
            && lhs.sourceFilter == rhs.sourceFilter
            && lhs.preference == rhs.preference
            && lhs.routing == rhs.routing
    }
}
