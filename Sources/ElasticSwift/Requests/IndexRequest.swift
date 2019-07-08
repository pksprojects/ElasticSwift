//
//  index.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

public class IndexRequestBuilder<T: Codable>: RequestBuilder {
    
    typealias BuilderClosure = (IndexRequestBuilder) -> Void
    
    public typealias RequestType = IndexRequest
    
    let client: ESClient
    var index: String
    var type: String?
    var id: String?
    var source: T
    var routing: String?
    var parent: String?
    var refresh: IndexRefresh?
    
    public var completionHandler: ((IndexResponse?,Error?) -> ())?
    
    init(withClient client: ESClient, index : String, source: T) {
        self.client = client
        self.index = index
        self.source = source
    }
    
    convenience init(withClient client: ESClient, index : String, source: T, builderClosure: BuilderClosure) {
        self.init(withClient: client, index: index, source: source)
        builderClosure(self)
    }
    
    public func set(index: String) -> Self {
        self.index = index
        return self
    }
    
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
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
    
    public func set(refresh: IndexRefresh) -> Self {
        self.refresh = refresh
        return self
    }
    
    public func set(completionHandler: @escaping (IndexResponse?,Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> IndexRequest<T> {
        return IndexRequest<T>(withBuilder: self)
    }
    
}

public class IndexRequest<T: Codable>: Request {
    
    public typealias ResponseType = IndexResponse
    
    public let completionHandler: ((IndexResponse?,Error?) -> ())?
    
    public let client: ESClient
    var index: String
    var type: String?
    var id: String?
    var source: T
    var routing: String?
    var parent: String?
    var refresh: IndexRefresh?
    
    init(withBuilder builder: IndexRequestBuilder<T>) {
        self.client = builder.client
        self.index = builder.index
        self.source = builder.source
        
        self.type = builder.type
        self.id = builder.id
        self.routing = builder.routing
        self.parent = builder.parent
        
        self.refresh = builder.refresh
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod  {
        get {
            if self.id == nil {
                return .POST
            }
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            var result = self.index + "/"
            
            if let type = self.type {
                result += type + "/"
            } else {
                result += "_doc/"
            }
            
            if let id = self.id {
                result += id
            }
            
            return result
        }
    }
    
    public func getBody() throws -> Data? {
        return try self.serializer.encode(self.source)
    }
    
    public var parameters: [QueryParams : String]? {
        get {
            if let refresh = self.refresh {
                var result = [QueryParams : String]()
                switch refresh {
                case .FALSE:
                    result[QueryParams.refresh] = "false"
                    break
                case .TRUE:
                    result[QueryParams.refresh] = "true"
                    break
                case .WAIT:
                    result[QueryParams.refresh] = "wait_for"
                    break
                }
                return result
            }
            return nil
        }
    }
    
}
