//
//  UpdateRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class UpdateRequestBuilder: RequestBuilder {
    
    let client: ESClient
    var index: String?
    var type: String?
    var id: String?
    
    init(withClient client: RestClient) {
        self.client = client
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
    
    public func build() -> Request {
        return UpdateRequest(withBuilder: self)
    }
}

public class UpdateRequest: Request {
    
    let client: ESClient
    let index: String
    let type: String
    let id: String
    
    init(withBuilder builder: UpdateRequestBuilder) {
        self.client = builder.client
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
    
    public var body: Data {
        get {
            return Data()
        }
    }
    
    public func execute() {
        self.client.execute(request: self, completionHandler: responseHandler)
    }
    
    func responseHandler(_ response: ESResponse) -> Void {
        
    }
}
