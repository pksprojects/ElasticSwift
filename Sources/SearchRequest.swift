//
//  SearchRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class SearchRequestBuilder: ESRequestBuilder {
    
    init(client: RestClient) {
        super.init(SearchRequest(), withClient: client)
    }
    
    func set(index: String) -> SearchRequestBuilder {
        if let request = self.request as? SearchRequest {
            request.set(index: index)
        }
        return self
    }
    
    func set(type: String) -> SearchRequestBuilder {
        if let request = self.request as? SearchRequest {
            request.set(type: type)
        }
        return self
    }
    
    func set(query: String) -> SearchRequestBuilder {
        if let request = self.request as? SearchRequest {
            request.set(type: query)
        }
        return self
    }
    
    func set(builder: QueryBuilder) -> SearchRequestBuilder {
        if let request = self.request as? SearchRequest {
            request.query = builder.query
        }
        return self
    }
    
}

public class SearchRequest: ESRequest {
    
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?
    var minScore: Float?
    
    init() {
        super.init(method: .POST)
    }
    
    func set(indices: String...) -> Void {
        self.index = indices.flatMap({$0}).joined(separator: ",")
    }
    
    func set(types: String...) -> Void {
        self.index = types.flatMap({$0}).joined(separator: ",")
    }
    
    func set(from: Int16) -> Void {
        self.from = from
    }
    
    func set(size: Int16) -> Void {
        self.size = size
    }
    
    func set(query: Query) -> Void {
        self.query = query
    }
    
    func set(sort: Sort) -> Void {
        self.sort = sort
    }
    
    func fetchSource(_ source: Bool) -> Void {
        self.fetchSource = source
    }
    
    func explain(_ explain: Bool) -> Void {
        self.explain = explain
    }
    
    func set(minScore: Float) -> Void {
        self.minScore = minScore
    }
    
    override func makeEndPoint() -> String {
        var path: String = ""
        if let index = self.index {
            path += index + "/"
        }
        if let type = self.type {
            path += type + "/"
        }
        path += "_search"
        return path
    }
    
    override func makeBody() -> [String: Any] {
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
        return dic
    }
}
