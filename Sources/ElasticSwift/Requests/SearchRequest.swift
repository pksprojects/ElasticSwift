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
    
    public func build() throws -> SearchRequest {
        return try SearchRequest(withBuilder: self)
    }
}

//MARK:- Search Request

public struct SearchRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public let index: String
    public let type: String?
    public let from: Int16?
    public let size: Int16?
    public let query: Query?
    public let sort: Sort?
    public let fetchSource: Bool?
    public let explain: Bool?
    public let minScore: Decimal?
    
    public init(index: String, type: String?, from: Int16?, size: Int16?, query: Query?, sort: Sort?, fetchSource: Bool?, explain: Bool?, minScore: Decimal?) {
        self.index = index
        self.type = type
        self.from = from
        self.size = size
        self.query = query
        self.sort = sort
        self.fetchSource = fetchSource
        self.explain = explain
        self.minScore = minScore
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
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        
        var dic = [String: Any]()
        if let query = self.query {
            dic["query"] = query.toDic()
        }
        if let sort = self.sort {
            dic["sort"] = sort.toDic()
        }
        if let size = self.size {
            dic["size"] = size
        }
        if let from = self.from {
            dic["from"] = from
        }
        if let fetchSource = self.fetchSource {
            dic["_source"] = fetchSource
        }
        if let explain = self.explain {
            dic["explain"] = explain
        }
        if let minSore = self.minScore {
            dic["min_score"] = minSore
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: [])
            return .success(data)
        } catch {
            return .failure(.wrapped(error))
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
