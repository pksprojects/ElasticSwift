//
//  GetRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore

//MARK:- Get Request Builder

public class GetRequestBuilder: RequestBuilder {
    
    public typealias BuilderClosure = (GetRequestBuilder) -> Void
    public typealias RequestType = GetRequest

    var index: String?
    var type: String?
    var id: String?
    var method: HTTPMethod = .GET
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    @discardableResult
    public func set(index: String) -> Self {
        self.index = index
        return self
    }
    
    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> Self {
        self.type = type
        return self
    }
    
    @discardableResult
    public func set(id: String) -> Self {
        self.id = id
        return self
    }
    
    public func build() throws -> GetRequest {
        
        guard self.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard self.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }
        
        return try GetRequest(withBuilder: self)
    }
    
    
}

//MARK:- Get Request

public class GetRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public let index: String
    public let type: String
    public let id: String
    
    public var method: HTTPMethod {
        get {
            return .GET
        }
    }
    
    public init(index: String, type: String = "_doc", id: String) {
        self.index = index
        self.type = type
        self.id = id
    }
    
    init(withBuilder builder: GetRequestBuilder) throws {
        self.index = builder.index!
        self.type = builder.type ?? "_doc"
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
