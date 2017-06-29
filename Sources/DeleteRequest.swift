//
//  DeleteRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class DeleteRequestbuilder: ESRequestBuilder {
    
    init(client: RestClient) {
        super.init(DeleteRequest(), withClient: client)
    }
    
    func set(index: String) -> DeleteRequestbuilder {
        if let request = self.request as? DeleteRequest {
            request.set(index: index)
        }
        return self
    }
    
    func set(type: String) -> DeleteRequestbuilder {
        if let request = self.request as? DeleteRequest {
            request.set(type: type)
        }
        return self
    }
    
    func set(id: String) -> DeleteRequestbuilder {
        if let request = self.request as? DeleteRequest {
            request.set(id: id)
        }
        return self
    }
}

public class DeleteRequest: ESRequest {
    
    init() {
        super.init(method: .DELETE)
    }
    
    override func makeEndPoint() -> String {
        return self.index! + "/" + self.type! + "/" + self.id!
    }
}
