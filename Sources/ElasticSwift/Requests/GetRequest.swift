//
//  GetRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class GetRequestBuilder<T: Codable>: RequestBuilder {

    public typealias RequestType = GetRequest<T>
    
    typealias BuilderClosure = (GetRequestBuilder) -> Void
    
    var client: ESClient
    var index: String
    var type: String?
    var id: String

    public var completionHandler: ((GetResponse<T>?,Error?) -> ())?
    
    init(withClient client: ESClient, index : String, id: String) {
        self.client = client
        self.index = index
        self.id = id
    }
    
    convenience init(withClient client: ESClient, index : String, id: String, builderClosure: BuilderClosure) {
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
    
    public func set(completionHandler: @escaping (GetResponse<T>?,Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() throws -> GetRequest<T> {
        return GetRequest<T>(withBuilder: self)
    }
    
    
}

public class GetRequest<T: Codable>: Request {

    public typealias ResponseType = GetResponse
    
    public let completionHandler: ((GetResponse<T>?,Error?) -> ())?
    
    public let client: ESClient
    var index: String
    var type: String?
    let id: String
    
    init(withBuilder builder: GetRequestBuilder<T>) {
        self.client = builder.client
        self.index = builder.index
        self.id =  builder.id
        
        self.type = builder.type
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod = .GET
    
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
