//
//  GetRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class GetRequestBuilder: ESRequestBuilder {
    
    init(client: RestClient) {
        super.init(GetRequest(), withClient: client)
    }
    
    func set(index: String) -> GetRequestBuilder {
        if let request = self.request as? GetRequest {
            request.set(index: index)
        }
        return self
    }
    
    func set(type: String) -> GetRequestBuilder {
        if let request = self.request as? GetRequest {
            request.set(type: type)
        }
        return self
    }
    
    func set(id: String) -> GetRequestBuilder {
        if let request = self.request as? GetRequest {
            request.set(id: id)
        }
        return self
    }
}

public class GetRequest: ESRequest {
    
    init() {
        super.init(method: .GET)
    }
    
    override func makeEndPoint() -> String {
        return self.index! + "/" + self.type! + "/" + self.id!
    }
}
