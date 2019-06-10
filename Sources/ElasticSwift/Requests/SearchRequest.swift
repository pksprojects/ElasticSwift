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
    
    let client: ESClient
    var index: String?
    var type: String?
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?
    var minScore: Decimal?
    var completionHandler: ((_ response: SearchResponse<T>?, _ error: Error?) -> Void)?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    convenience init(withClient client: ESClient, builderClosure: BuilderClosure) {
        self.init(withClient: client)
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
    
    public func set(completionHandler: @escaping (_ response: SearchResponse<T>?, _ error: Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() throws -> Request {
        return try SearchRequest<T>(withBuilder: self)
    }
}

public class SearchRequest<T: Codable>: Request {
    
    let client: ESClient
    var index: String?
    var type: String?
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?
    var minScore: Decimal?
    var _builtBody: Data?
    var completionHandler: ((_ response: SearchResponse<T>?, _ error: Error?) -> Void)
    
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
        self.completionHandler = builder.completionHandler!
        self._builtBody = try makeBody()
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
        }
    }
    
    public var body: Data {
        get {
            return self._builtBody!
        }
    }
    
    public func execute() {
        self.client.execute(request: self, completionHandler: responseHandler)
    }
    
    func makeEndPoint() -> String {
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
    
    func makeBody() throws -> Data {
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
    
    func responseHandler(_ response: ESResponse) -> Void {
        if let error = response.error {
            return completionHandler(nil, error)
        }
        do {
            debugPrint(String(data: response.data!, encoding: .utf8)!)
            let decoded: SearchResponse<T>? = try Serializers.decode(data: response.data!)
            if decoded?.took != nil {
                return completionHandler(decoded, nil)
            } else {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            }
        } catch {
            do {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            } catch {
                return completionHandler(nil, error)
            }
        }
    }
}
