//
//  index.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import NIOHTTP1

//MARK:- Index Requet Builder

public class IndexRequestBuilder<T: Codable>: RequestBuilder {
    
    public typealias RequestType = IndexRequest<T>
    public typealias BuilderClosure = (IndexRequestBuilder) -> Void
    
    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var routing: String?
    var parent: String?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
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
    
    public func build() throws -> IndexRequest<T> {
        return try IndexRequest<T>(withBuilder: self)
    }
    
}

//MARK:- Index Request

public class IndexRequest<T: Codable>: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = IndexResponse
    
    public var method: HTTPMethod  {
        get {
            if self.id == nil {
                return .POST
            }
            return .PUT
        }
    }
    
    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var routing: String?
    var parent: String?
    
    
    init(withBuilder builder: IndexRequestBuilder<T>) throws {
        self.index = builder.index
        self.type = builder.type
        self.id = builder.id
        self.source = builder.source
        self.routing = builder.routing
        self.parent = builder.parent
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
    
    public func data(_ serializer: Serializer) throws -> Data {
        return try serializer.encode(self.source!)!
    }
    
}


enum OpType {
    case INDEX
    case CREATE
}

