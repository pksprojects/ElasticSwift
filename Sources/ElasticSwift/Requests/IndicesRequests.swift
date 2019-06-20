//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation

// MARK: -  Builders

public class CreateIndexRequestBuilder: RequestBuilder {
    
    typealias BuilderClosure = (CreateIndexRequestBuilder) -> Void

    public typealias RequestType = CreateIndexRequest
    
    let client: ESClient
    var name: String
    
    public var completionHandler: ((CreateIndexResponse?,Error?) -> ())?
    
    init(withClient client: ESClient, name : String) {
        self.client = client
        self.name = name
    }
    
    convenience init(withClient client: ESClient, name : String, builderClosure: BuilderClosure) {
        self.init(withClient: client, name: name)
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (CreateIndexResponse?,Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> CreateIndexRequest {
        return CreateIndexRequest(withBuilder: self)
    }
    
}

public class DeleteIndexRequestBuilder: RequestBuilder {
    
    typealias BuilderClosure = (DeleteIndexRequestBuilder) -> Void

    public typealias RequestType = DeleteIndexRequest
    
    public var completionHandler: ((DeleteIndexResponse?,Error?) -> ())?
    
    let client: ESClient
    var name: String
    
    init(withClient client: ESClient, name : String) {
        self.client = client
        self.name = name
    }
    
    convenience init(withClient client: ESClient, name : String, builderClosure: BuilderClosure) {
        self.init(withClient: client, name: name)
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (DeleteIndexResponse?,Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() throws -> DeleteIndexRequest {
        return DeleteIndexRequest(withBuilder: self)
    }

}

public class GetIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = GetIndexRequest
    
    typealias BuilderClosure = (GetIndexRequestBuilder) -> Void
    
    let client: ESClient
    var name: String
    public var completionHandler: ((GetIndexResponse?,Error?) -> ())?
    
    
    init(withClient client: ESClient, name : String) {
        self.client = client
        self.name = name
    }
    
    convenience init(withClient client: ESClient, name : String, builderClosure: BuilderClosure) {
        self.init(withClient: client, name: name)
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (GetIndexResponse?,Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() throws -> GetIndexRequest {
        return GetIndexRequest(withBuilder: self)
    }

}

public class CreateIndexRequest: Request {
    
    public typealias ResponseType = CreateIndexResponse
    
    public var completionHandler: ((CreateIndexResponse?,Error?) -> ())?
    
    public let client: ESClient
    let name: String
    
    init(withBuilder builder: CreateIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod = .PUT
    
    public var endPoint: String {
        get {
            return self.name
        }
    }

}

public class GetIndexRequest: Request {
    
    public typealias ResponseType = GetIndexResponse
    
    public var completionHandler: ((GetIndexResponse?,Error?) -> ())?
    
    public let client: ESClient
    let name: String
    
    init(withBuilder builder: GetIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod = .GET
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
}

public class DeleteIndexRequest: Request {
    
    public typealias ResponseType = DeleteIndexResponse
    
    public var completionHandler: ((DeleteIndexResponse?,Error?) -> ())?
    
    public let client: ESClient
    let name: String
    
    init(withBuilder builder: DeleteIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name
        self.completionHandler = builder.completionHandler
    }
    
   
    public var method: HTTPMethod = .DELETE
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
}
