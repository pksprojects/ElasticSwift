//
//  SearchRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class SearchRequestBuilder<T: Codable>: RequestBuilder {
    
    typealias BuilderClosure = (SearchRequestBuilder) -> Void
    
    public typealias RequestType = SearchRequest<T>
    
    let client: ESClient
    var index: String
    var type: String?
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?

    var minScore: Decimal?
    public var completionHandler: ((SearchResponse<T>?,Error?) -> ())?
    
    init(withClient client: ESClient, index: String) {
        self.client = client
        self.index = index
    }
    
    init(withClient client: ESClient, indices: String...) {
        self.client = client
         self.index = indices.compactMap({$0}).joined(separator: ",")
    }
    
    init(withClient client: ESClient, indices: [String]) {
        self.client = client
        self.index = indices.compactMap({$0}).joined(separator: ",")
    }
    
    convenience init(withClient client: ESClient, index: String, builderClosure: BuilderClosure) {
        self.init(withClient: client, index: index)
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
    
    public func set(completionHandler: @escaping (_ response: SearchResponse<T>?, _ error: Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() throws -> SearchRequest<T> {
        return try SearchRequest<T>(withBuilder: self)
    }
}

public class SearchRequest<T: Codable>: Request {
    
    public typealias ResponseType = SearchResponse<T>
    
    public var completionHandler: ((SearchResponse<T>?,Error?) -> ())?
    
    public let client: ESClient
    var index: String
    var type: String?
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?
    var minScore: Decimal?
    
    init(withBuilder builder: SearchRequestBuilder<T>) throws {
        self.client = builder.client
        self.index = builder.index
        
        self.type = builder.type
        self.from = builder.from
        self.size = builder.size
        self.query = builder.query
        self.sort = builder.sort
        self.fetchSource = builder.fetchSource
        self.explain = builder.explain
        self.minScore = builder.minScore
        self.completionHandler = builder.completionHandler
    }
    
    public func getBody() throws -> Data? {
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
        return try JSONSerialization.data(withJSONObject: dic, options: [])
    }
    
    public var method: HTTPMethod = .POST
    
    public var endPoint: String {
        get {
            var path: String = self.index + "/"
            
            if let type = self.type {
                path += type + "/"
            }
            path += "_search"
            return path
        }
    }
    
}
