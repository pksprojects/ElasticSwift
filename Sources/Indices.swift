//
//  Indices.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation

class IndiciesAdmin {
    
    let client: ESClient
    
    init(withClient: ESClient) {
        self.client = withClient
    }
    
    func create() -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder(client: self.client)
    }
    
    func get() -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder(client: self.client)
    }
    
    func delete() -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder(client: self.client)
    }
}

