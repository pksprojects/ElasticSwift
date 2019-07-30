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
    
    public typealias BuilderClosure = (SearchRequestBuilder) -> Void
    
    var index: String?
    var type: String?
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?
    var minScore: Decimal?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(indices: String...) -> Self {
        self.index = indices.compactMap({$0}).joined(separator: ",")
        return self
    }
    
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(types: String...) -> Self {
        self.type = types.compactMap({$0}).joined(separator: ",")
        return self
    }
    
    public func set(from: Int16) -> Self {
        self.from = from
        return self
    }
    
    public func set(size: Int16) -> Self {
        self.size = size
        return self
    }
    
    public func set(query: Query) -> Self {
        self.query = query
        return self
    }
    
    public func set(sort: Sort) -> Self {
        self.sort = sort
        return self
    }
    
    public func fetchSource(_ fetchSource: Bool) -> Self {
        self.fetchSource = fetchSource
        return self
    }
    
    public func explain(_ explain: Bool) -> Self {
        self.explain = explain
        return self
    }
    
    public func set(minScore: Decimal) -> Self {
        self.minScore = minScore
        return self
    }
    
    public func build() throws -> SearchRequest {
        return try SearchRequest(withBuilder: self)
    }
}

//MARK:- Search Request

public class SearchRequest: Request {
    
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
    
    init(withBuilder builder: SearchRequestBuilder) throws {
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
