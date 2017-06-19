//
//  index.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

class IndexRequestBuilder: ESRequestBuilder {
    
    init(client: RestClient) {
        super.init(IndexRequest(), withClient: client)
    }
    
    func set(index: String) -> IndexRequestBuilder {
        if let request = self.request as? IndexRequest {
            request.set(index: index)
        }
        return self
    }
    
    func set(type: String) -> IndexRequestBuilder {
        if let request = self.request as? IndexRequest {
            request.set(type: type)
        }
        return self
    }
    
    func set(id: String) -> IndexRequestBuilder {
        if let request = self.request as? IndexRequest {
            request.set(id: id)
        }
        return self
    }
    
    func set(source: String) -> IndexRequestBuilder {
        if let request = self.request as? IndexRequest {
            request.set(source: source)
        }
        return self
    }

    
    func set(routing: String) -> IndexRequestBuilder {
        if let request = self.request as? IndexRequest {
            request.set(routing: routing)
        }
        return self
    }
    
    func set(parent: String) -> IndexRequestBuilder {
        if let request = self.request as? IndexRequest {
            request.set(parent: parent)
        }
        return self
    }
}

class IndexRequest: ESRequest {
    
    var routing: String?
    var parent: String?
    
    init() {
        super.init(method: .PUT)
    }
    
    convenience init(index: String) {
        self.init()
        self.index = index
    }
    
    convenience init(index: String, type: String) {
        self.init(index: index)
        self.type = type
    }
    
    convenience init(index: String, type: String, id: String) {
        self.init(index: index, type: type)
        self.id = id
    }
    
    func set(routing: String) -> Void {
        self.routing = routing
    }
    
    func set(parent: String) -> Void {
        self.parent = parent
    }
    
    override func makeEndPoint() -> String {
        return self.index! + "/" + self.type! + "/" + self.id!
    }
    
}

enum OpType {
    case INDEX
    case CREATE
}

