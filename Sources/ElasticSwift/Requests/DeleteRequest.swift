//
//  DeleteRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import Logging
import NIOHTTP1

//MARK:- Delete Request Builder

public class DeleteRequestBuilder: RequestBuilder {
    
    public typealias BuilderClosure = (DeleteRequestBuilder) -> Void
    public typealias RequestType = DeleteRequest
    
    var index: String?
    var type: String?
    var id: String?
    var version: Int?
    
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
    
    public func set(version: Int) -> Self {
        self.version = version
        return self
    }
    
    public func build() throws -> RequestType {
        return try DeleteRequest(withBuilder: self)
    }
    
}

//MARK:- Delete Request

public class DeleteRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = DeleteResponse
    
    let index: String
    let type: String
    let id: String
    var version: Int?
    
    public init(index: String, type: String, id: String, version: Int?) {
        self.index = index
        self.type = type
        self.id = id
        self.version = version
    }
    
    init(withBuilder builder: DeleteRequestBuilder) throws {
        self.index = builder.index!
        self.type = builder.type!
        self.id = builder.id!
        self.version = builder.version
    }
    
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
        }
    }
    
    func makeEndPoint() -> String {
        return self.index + "/" + self.type + "/" + self.id
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
    
}
