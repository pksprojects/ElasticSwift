//
//  SearchRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class SearchRequestBuilder<T: Codable>: RequestBuilder {
    
    let client: ESClient
    var index: String?
    var type: String?
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?
    var minScore: Float?
    var completionHandler: ((_ response: SearchResponse<T>?,_ error: Error?) -> ())?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(indices: String...) -> Self {
        self.index = indices.compactMap({$0}).joined(separator: ",")
        return self
    }
    
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
    
    public func set(minScore: Float) -> Self {
        self.minScore = minScore
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: SearchResponse<T>?, _ error: Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() throws -> Request {
        return try SearchRequest<T>(withBuilder: self)
    }
    
    public func validate() throws {
        if index == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"index")
        }
    }
}

public class SearchRequest<T: Codable>: NSObject, Request {
    
    let client: ESClient
    var index: String
    var type: String?
    var from: Int16?
    var size: Int16?
    var query: Query?
    var sort: Sort?
    var fetchSource: Bool?
    var explain: Bool?
    var minScore: Float?
    var _builtBody: Data?
    var completionHandler: ((_ response: SearchResponse<T>?, _ error: Error?) -> ())?
    
    init(withBuilder builder: SearchRequestBuilder<T>) throws {
        self.client = builder.client
        self.index = builder.index!
        super.init()
        self.completionHandler = builder.completionHandler
        self.type = builder.type
        self.from = builder.from
        self.size = builder.size
        self.query = builder.query
        self.sort = builder.sort
        self.fetchSource = builder.fetchSource
        self.explain = builder.explain
        self.minScore = builder.minScore
        self._builtBody = try makeBody()
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
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
    
    public var body: Data {
        get {
            return self._builtBody!
        }
    }
    
    public func execute() {
        self.client.execute(request: self, completionHandler: responseHandler)
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
    
    func responseHandler(_ response: ESResponse) -> () {
        if let error = response.error {
            completionHandler?(nil, error)
            return
        }
        
        guard let data = response.data else {
            completionHandler?(nil,nil)
            return
        }
        
        var decodingError : Error? = nil
        do {
            let decoded = try Serializers.decode(data: data) as SearchResponse<T>
            completionHandler?(decoded, nil)
            return
        } catch {
            decodingError = error
        }
        
        do {
            let esError = try Serializers.decode(data: data) as ElasticsearchError
            completionHandler?(nil, esError)
            return
        } catch {
            let message = "Error decoding response with data: " + (String(bytes: data, encoding: .utf8) ?? "nil") + " Underlying error: " + (decodingError?.localizedDescription ?? "nil")
            let error = RequestConstants.Errors.Response.Deserialization(content: message)
            completionHandler?(nil, error)
            return
        }
    }
    
    public override var debugDescription: String {
        get {
            var result = "POST " + self.endPoint + " " + (String(bytes: self.body, encoding: .utf8) ?? "")
            result += " Params: \(String(describing: self.parameters))"
            return result
        }
    }
}
