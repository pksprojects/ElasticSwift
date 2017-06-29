//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation


public class CreateIndexRequest: ESRequest {
    override func makeEndPoint() -> String {
        return self.index!
    }
}

class GetIndexRequest: ESRequest {
    override func makeEndPoint() -> String {
        return self.index!
    }
}

class DeleteIndexRequest: ESRequest {
    override func makeEndPoint() -> String {
        return self.index!
    }
}


public class CreateIndexRequestBuilder: ESRequestBuilder {
    
    init(client: ESClient) {
        super.init(CreateIndexRequest(method: .PUT) , withClient: client)
    }
    
    func set(name: String) -> Self {
        self.request.set(index: name)
        return self
    }
}

public class DeleteIndexRequestBuilder: ESRequestBuilder {
    
    init(client: ESClient) {
        super.init(DeleteIndexRequest(method: .DELETE) , withClient: client)
    }
    
    func set(name: String) -> Self {
        self.request.set(index: name)
        return self
    }
}

public class GetIndexRequestBuilder: ESRequestBuilder {
    
    init(client: ESClient) {
        super.init(DeleteIndexRequest(method: .GET) , withClient: client)
    }
    
    func set(name: String) -> Self {
        self.request.set(index: name)
        return self
    }
}
