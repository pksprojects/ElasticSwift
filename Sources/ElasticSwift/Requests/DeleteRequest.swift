//
//  DeleteRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class DeleteRequestBuilder: RequestBuilder {
    
    typealias BuilderClosure = (DeleteRequestBuilder) -> Void

    public typealias RequestType = DeleteRequest
    
    let client: ESClient
    var index: String
    var type: String?
    var id: String
    var version: Int?
    public var completionHandler: ((DeleteResponse?, Error?) -> ())?
    
    init(withClient client: ESClient, index : String, id: String) {
        self.client = client
        self.index = index
        self.id = id
    }
    
    convenience init(withClient client: ESClient, index : String, id: String,  builderClosure: BuilderClosure) {
        self.init(withClient: client, index: index, id: id)
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
    
    public func set(completionHandler: @escaping (DeleteResponse?, Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> DeleteRequest {
        return DeleteRequest(withBuilder: self)
    }

}

public class DeleteRequest: Request {
   
    public typealias ResponseType = DeleteResponse
    
    public var completionHandler: ((DeleteResponse?, Error?) -> ())?
    
    public let client: ESClient
    let index: String
    let type: String?
    let id: String
    var version: Int?
    
    init(withBuilder builder: DeleteRequestBuilder) {
        self.client = builder.client
        self.index = builder.index
        self.id = builder.id
        
        self.type = builder.type
        self.version = builder.version
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod = .DELETE
    
    public var endPoint: String {
        get {
            var result = self.index + "/"
            
            if let type = self.type {
                result += type + "/"
            } else {
                result += "_doc/"
            }
            
            result += self.id
            
            return result
        }
    }
    
}


