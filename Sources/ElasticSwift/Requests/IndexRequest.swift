//
//  index.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

public class IndexRequestBuilder<T: Codable>: RequestBuilder {
    
    let client: ESClient
    var completionHandler: ((_ response: IndexResponse?, _ error: Error?) -> Void)?
    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var routing: String?
    var parent: String?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(index: String) -> Self {
        self.index = index
        return self
    }
    
    public func set(type: String) -> Self {
        self.type = type
        return self
    }
    
    public func set(id: String) -> Self {
        self.id = id
        return self
    }
    
    public func set(routing: String) -> Self {
        self.routing = routing
        return self
    }
    
    public func set(parent: String) -> Self {
        self.parent = parent
        return self
    }
    
    public func set(source: T) -> Self {
        self.source = source
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: IndexResponse?, _ error: Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() throws -> Request {
        return try IndexRequest(withBuilder: self)
    }
    
}

public class IndexRequest<T: Codable>: Request {
    
    let client: ESClient
    let completionHandler: ((_ response: IndexResponse?, _ error: Error?) -> Void)
    public var method: HTTPMethod  {
        get {
            if self.id == nil {
                return .POST
            }
            return .PUT
        }
    }
    
    var _builtBody: Data?
    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var routing: String?
    var parent: String?
    
    
    init(withBuilder builder: IndexRequestBuilder<T>) throws {
        self.client = builder.client
        self.completionHandler = builder.completionHandler!
        self.index = builder.index
        self.type = builder.type
        self.id = builder.id
        self.source = builder.source
        self.routing = builder.routing
        self.parent = builder.parent
        self._builtBody = try makeBody()
    }
    
    func makeEndPoint() -> String {
        var _endPoint = self.index! + "/" + self.type!
        if let id = self.id {
            _endPoint = _endPoint + "/" + id
        }
        return _endPoint
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
        }
    }
    
    public var body: Data {
        get {
            return _builtBody!
        }
    }
    
    public func makeBody() throws -> Data {
       return try Serializers.encode(self.source!)!
    }
    
    public func execute() {
        self.client.execute(request: self, completionHandler: responseHandler)
    }
    
    func responseHandler(_ response: ESResponse) -> Void {
        if let error = response.error {
            return completionHandler(nil, error)
        }
        do {
            let decoded: IndexResponse? = try Serializers.decode(data: response.data!)
            if decoded?.id == nil {
                return completionHandler(decoded, nil)
            } else {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            }
        } catch {
            return completionHandler(nil, error)
        }
        
    }
    
}


enum OpType {
    case INDEX
    case CREATE
}

