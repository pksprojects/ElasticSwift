//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import Logging
import NIOHTTP1

// MARK: -  Builders

public class CreateIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = CreateIndexRequest
    public typealias BuilderClosure = (CreateIndexRequestBuilder) -> Void
    
    var name: String?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func build() -> CreateIndexRequest {
        return CreateIndexRequest(withBuilder: self)
    }
}

public class DeleteIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = DeleteIndexRequest
    
    public typealias BuilderClosure = (DeleteIndexRequestBuilder) -> Void
    
    var name: String?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func build() throws -> DeleteIndexRequest {
        return DeleteIndexRequest(withBuilder: self)
    }
}

public class GetIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = GetIndexRequest
    
    public typealias BuilderClosure = (GetIndexRequestBuilder) -> Void
    
    var name: String?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func build() throws -> GetIndexRequest {
        return GetIndexRequest(withBuilder: self)
    }
}

// MARK: - Requests

//MARK:- Create Index Reqeust

public class CreateIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = CreateIndexResponse
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    init(withBuilder builder: CreateIndexRequestBuilder) {
        self.name = builder.name!
    }
    
    public var method: HTTPMethod {
        get {
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, Error> {
        return .success(Data())
    }
}

//MARK:- Get Index Request

public class GetIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = GetIndexResponse
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    init(withBuilder builder: GetIndexRequestBuilder) {
        self.name = builder.name!
    }
    
    public var method: HTTPMethod {
        get {
            return .GET
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, Error> {
        return .success(Data())
    }
    
}

//MARK:- Delete Index Request

public class DeleteIndexRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = AcknowledgedResponse
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    init(withBuilder builder: DeleteIndexRequestBuilder) {
        self.name = builder.name!
    }
    
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, Error> {
        return .success(Data())
    }
}

//MARK:- Open Index Request

public class OpenIndexRequest: Request {
    
    public typealias ResponseType = AcknowledgedResponse
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []

    
    public let names: [String]
    
    public init(_ name: String) {
        self.names = [name]
    }
    
    public init(_ names: [String]) {
        self.names = names
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            if self.names.count == 1 {
                return self.names[0] + "/_open"
            } else {
                return self.names.joined(separator: ",") + "/_open"
            }
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, Error> {
        return .success(Data())
    }
}

//MARK:- Close Index Request

public class CloseIndexRequest: Request {
    
    public typealias ResponseType = AcknowledgedResponse
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public let names: [String]
    
    public init(_ name: String) {
        self.names = [name]
    }
    
    public init(_ names: [String]) {
        self.names = names
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
    
    func makeEndPoint() -> String {
        if self.names.count == 1 {
            return self.names[0] + "/_close"
        } else {
            return self.names.joined(separator: ",") + "/_close"
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, Error> {
        return .success(Data())
    }
}
