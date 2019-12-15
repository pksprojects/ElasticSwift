//
//  SearchRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore
import ElasticSwiftQueryDSL

//MARK:- Search Request Builder

public class SearchRequestBuilder: RequestBuilder {
    
    public typealias RequestType = SearchRequest
    
    private var _index: String?
    private var _type: String?
    private var _from: Int16?
    private var _size: Int16?
    private var _query: Query?
    private var _sort: Sort?
    private var _fetchSource: Bool?
    private var _explain: Bool?
    private var _minScore: Decimal?
    private var _scroll: Scroll?
    
    public init() {}
    
    @discardableResult
    public func set(indices: String...) -> Self {
        self._index = indices.compactMap({$0}).joined(separator: ",")
        return self
    }
    
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    @discardableResult
    public func set(types: String...) -> Self {
        self._type = types.compactMap({$0}).joined(separator: ",")
        return self
    }
    
    @discardableResult
    public func set(from: Int16) -> Self {
        self._from = from
        return self
    }
    
    @discardableResult
    public func set(size: Int16) -> Self {
        self._size = size
        return self
    }
    
    @discardableResult
    public func set(query: Query) -> Self {
        self._query = query
        return self
    }
    
    @discardableResult
    public func set(sort: Sort) -> Self {
        self._sort = sort
        return self
    }
    
    @discardableResult
    public func fetchSource(_ fetchSource: Bool) -> Self {
        self._fetchSource = fetchSource
        return self
    }
    
    @discardableResult
    public func explain(_ explain: Bool) -> Self {
        self._explain = explain
        return self
    }
    
    @discardableResult
    public func set(minScore: Decimal) -> Self {
        self._minScore = minScore
        return self
    }
    
    @discardableResult
    public func set(scroll: Scroll) -> Self {
        self._scroll = scroll
        return self
    }
    
    public var index: String? {
        return self._index
    }
    public var type: String? {
        return self._type
    }
    public var from: Int16? {
        return self._from
    }
    public var size: Int16? {
        return self._size
    }
    public var query: Query? {
        return self._query
    }
    public var sort: Sort? {
        return self._sort
    }
    public var fetchSource: Bool? {
        return self._fetchSource
    }
    public var explain: Bool? {
        return self._explain
    }
    public var minScore: Decimal? {
        return self._minScore
    }
    public var scroll: Scroll? {
        return self._scroll
    }
    
    public func build() throws -> SearchRequest {
        return try SearchRequest(withBuilder: self)
    }
}

//MARK:- Search Request

public struct SearchRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let index: String
    public let type: String?
    public let from: Int16?
    public let size: Int16?
    public let query: Query?
    public let sort: Sort?
    public let fetchSource: Bool?
    public let explain: Bool?
    public let minScore: Decimal?
    
    public var scroll: Scroll?
    
    public init(index: String, type: String?, from: Int16?, size: Int16?, query: Query?, sort: Sort?, fetchSource: Bool?, explain: Bool?, minScore: Decimal?, scroll: Scroll?) {
        self.index = index
        self.type = type
        self.from = from
        self.size = size
        self.query = query
        self.sort = sort
        self.fetchSource = fetchSource
        self.explain = explain
        self.minScore = minScore
        self.scroll = scroll
    }
    
    internal init(withBuilder builder: SearchRequestBuilder) throws {
        self.index = builder.index ?? "_all"
        self.type = builder.type
        self.query = builder.query
        self.from = builder.from
        self.size = builder.size
        self.sort = builder.sort
        self.fetchSource = builder.fetchSource
        self.explain = builder.explain
        self.minScore = builder.minScore
        self.scroll = builder.scroll
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            var path = self.index
            if let type = self.type {
                path += "/" + type
            }
            return  path + "/_search"
        }
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var queryItems = [URLQueryItem]()
            if let scroll = self.scroll {
                queryItems.append(URLQueryItem(name: QueryParams.scroll, value: scroll.keepAlive))
            }
            return queryItems
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(query: self.query, sort: self.sort, size: self.size, from: self.from, source: self.fetchSource, explain: self.explain, minScore: self.minScore)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            return MakeBodyError.wrapped(error)
        }
    }
    
    struct Body: Encodable {
        public let query: Query?
        public let sort: Sort?
        public let size: Int16?
        public let from: Int16?
        public let source: Bool?
        public let explain: Bool?
        public let minScore: Decimal?
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.query, forKey: .query)
            try container.encodeIfPresent(self.sort, forKey: .sort)
            try container.encodeIfPresent(self.size, forKey: .size)
            try container.encodeIfPresent(self.from, forKey: .from)
            try container.encodeIfPresent(self.source, forKey: .source)
            try container.encodeIfPresent(self.explain, forKey: .explain)
            try container.encodeIfPresent(self.minScore, forKey: .minScore)
        }
        
        enum CodingKeys: String, CodingKey {
            case query
            case sort
            case size
            case from
            case source = "_source"
            case explain
            case minScore = "min_score"
        }
    }
}

extension SearchRequest: Equatable {
    public static func == (lhs: SearchRequest, rhs: SearchRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.explain == rhs.explain
            && lhs.fetchSource == rhs.fetchSource
            && lhs.from == rhs.from
            && lhs.endPoint == rhs.endPoint
            && lhs.headers == rhs.headers
            && lhs.method == rhs.method
            && lhs.minScore == rhs.minScore
            && lhs.queryParams == rhs.queryParams
            && lhs.size == rhs.size
            && lhs.sort == rhs.sort
            && lhs.type == rhs.type
            && SearchRequest.matchQueries(lhs.query, rhs.query)
    }
    
    private static func matchQueries(_ lhs: Query? , _ rhs: Query?) -> Bool {
        if lhs == nil && rhs == nil {
            return true
        }
        if let lhs = lhs, let rhs = rhs {
            return lhs.isEqualTo(rhs)
        }
        return false
    }
}

// MARK:- Scroll

public struct Scroll: Codable {
    
    public let keepAlive: String
    
    public init(keepAlive: String) {
        self.keepAlive = keepAlive
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.keepAlive)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.keepAlive = try container.decodeString()
    }
    
    public static var ONE_MINUTE: Scroll {
        return Scroll(keepAlive: "1m")
    }
}

extension Scroll: Equatable {}


// MARK:- Search Scroll Request Builder

public class SearchScrollRequestBuilder: RequestBuilder {
    
    public typealias RequestType = SearchScrollRequest
    
    private var _scrollId: String?
    private var _scroll: Scroll?
    private var _restTotalHitsAsInt: Bool?
    
    public init() {}
    
    @discardableResult
    public func set(scrollId: String) -> Self {
        self._scrollId = scrollId
        return self
    }
    
    @discardableResult
    public func set(scroll: Scroll) -> Self {
        self._scroll = scroll
        return self
    }
    
    @discardableResult
    public func set(restTotalHitsAsInt: Bool) -> Self {
        self._restTotalHitsAsInt = restTotalHitsAsInt
        return self
    }
    
    public var scrollId: String? {
        return self._scrollId
    }
    public var scroll: Scroll? {
        return self._scroll
    }
    public var restTotalHitsAsInt: Bool? {
        return self._restTotalHitsAsInt
    }
    
    public func build() throws -> SearchScrollRequest {
        return try SearchScrollRequest(withBuilder: self)
    }
}

// MARK:- Search Scroll Request

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
        
        self.scrollId = builder.scrollId!
        self.scroll = builder.scroll
        self.restTotalHitsAsInt = builder.restTotalHitsAsInt
    }
    
    public var headers: HTTPHeaders {
        return HTTPHeaders()
    }
    
    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let totalHitsAsInt = self.restTotalHitsAsInt {
            params.append(URLQueryItem.init(name: QueryParams.restTotalHitsAsInt, value: totalHitsAsInt))
        }
        return params
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        return "_search/scroll"
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return.failure(.noBodyForRequest)
    }
    
    
    private struct Body: Encodable {
        
        public let scroll: Scroll
        public let scrollId: String
        
        enum CodingKeys: String, CodingKey {
            case scroll
            case scrollId = "scroll_id"
        }
        
    }
    
}

extension SearchScrollRequest: Equatable {}


// MARK:- Clear Scroll Request Builder

public class ClearScrollRequestBuilder: RequestBuilder {
    
    public typealias RequestType = ClearScrollRequest
    
    private var _scrollIds: [String] = []
    
    public init() {}
    
    @discardableResult
    public func set(scrollIds: String...) -> Self {
        self._scrollIds = scrollIds
        return self
    }
    
    public var scrollIds: [String] {
        return self._scrollIds
    }
    
    public func build() throws -> ClearScrollRequest {
        return try ClearScrollRequest(withBuilder: self)
    }
}


// MARK:- Clear Scroll Request

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
            self.scrollIds = ["_all"]
        } else {
            self.scrollIds = builder.scrollIds
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
        if self.scrollIds.contains("_all") {
            return "_search/scroll/_all"
        } else {
            return "_search/scroll"
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        if self.scrollIds.contains("_all") {
            return .failure(.noBodyForRequest)
        } else {
            let body = Body(scrollId: self.scrollIds)
            return serializer.encode(body).mapError { error -> MakeBodyError in
                return MakeBodyError.wrapped(error)
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
                self.scrollId = [id]
            } catch Swift.DecodingError.typeMismatch {
                self.scrollId = try container.decodeArray(forKey: .scrollId)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container =  encoder.container(keyedBy: CodingKeys.self)
            if self.scrollId.count == 1 {
                try container.encode(self.scrollId.first!, forKey: .scrollId)
            } else {
                try container.encode(self.scrollId, forKey: .scrollId)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case scrollId = "scroll_id"
        }
    }
    
}

extension ClearScrollRequest: Equatable {}
