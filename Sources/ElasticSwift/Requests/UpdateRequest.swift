//
//  UpdateRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import NIOHTTP1

//MARK:- Update Request Builder

public class UpdateRequestBuilder: RequestBuilder {
    
    public typealias RequestType = UpdateRequest
    
    public typealias BuilderClosure = (UpdateRequestBuilder) -> Void
    
    var index: String?
    var type: String?
    var id: String?
    
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
    
    public func build() -> UpdateRequest {
        return UpdateRequest(withBuilder: self)
    }
}

//MARK:- Update Request

public class UpdateRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = UpdateResponse
    
    let index: String
    let type: String
    let id: String
    
    init(withBuilder builder: UpdateRequestBuilder) {
        self.index = builder.index!
        self.type = builder.type!
        self.id = builder.id!
    }
    
    public var method: HTTPMethod {
        get {
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            return index + "/" + type + "/" + id + "/_update"
        }
    }
    
    public func data(_ serializer: Serializer) throws -> Data {
        return Data()
    }
}


// MARK:- UPDATE RESPONSE

public class UpdateResponse: Codable {
    
}
