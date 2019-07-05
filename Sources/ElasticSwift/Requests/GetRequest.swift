//
//  GetRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import NIOHTTP1

//MARK:- Get Request Builder

public class GetRequestBuilder<T: Codable>: RequestBuilder {
    
    public typealias BuilderClosure = (GetRequestBuilder) -> Void
    public typealias RequestType = GetRequest<T>

    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var method: HTTPMethod = .GET
    
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
    
    public func build() throws -> GetRequest<T> {
        return try GetRequest<T>(withBuilder: self)
    }
    
    
}

//MARK:- Get Request

public class GetRequest<T: Codable>: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    
    public typealias ResponseType = GetResponse<T>
    
    var index: String
    var type: String
    var id: String
    
    public var method: HTTPMethod {
        get {
            return .GET
        }
    }
    
    public init(index: String, type: String, id: String) {
        self.index = index
        self.type = type
        self.id = id
    }
    
    init(withBuilder builder: GetRequestBuilder<T>) throws {
        self.index = builder.index!
        self.type = builder.type!
        self.id =  builder.id!
    }
    
    public var endPoint: String {
        get {
            return self.index + "/" + self.type + "/" + self.id
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}
