//
//  UpdateRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class UpdateRequestBuilder<T: Codable> : RequestBuilder {
    
    public typealias RequestType = UpdateRequest<T>
    
    let client: ESClient
    var index: String
    var type: String?
    var id: String
    
    public var completionHandler: ((UpdateResponse?,Error?) -> ())?
    
    init(withClient client: RestClient, index : String, id : String) {
        self.client = client
        self.index = index
        self.id = id
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
    
    public func set(completionHandler: @escaping (_ response: UpdateResponse?, _ error: Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() throws -> UpdateRequest<T> {
        return UpdateRequest<T>(withBuilder: self)
    }
}

public class UpdateRequest<T : Codable> : Request {
    
    public typealias ResponseType = UpdateResponse
    
    public var completionHandler: ((UpdateResponse?,Error?) -> ())?
    
    public let client: ESClient
    let index: String
    let type: String?
    let id: String
    
    init(withBuilder builder: UpdateRequestBuilder<T>) {
        self.client = builder.client
        self.index = builder.index
        self.id = builder.id
        self.type = builder.type
    }
    
    public var method: HTTPMethod = .PUT
    
    public var endPoint: String {
        get {
            var result = self.index + "/"
            
            if let type = self.type {
                result += type + "/"
            } else {
                result += "_doc/"
            }
            
            result += self.id
            result += "/_update"
            
            return result
        }
    }
    
}
