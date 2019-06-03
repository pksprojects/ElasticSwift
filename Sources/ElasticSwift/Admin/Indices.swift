//
//  Indices.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation

public class IndiciesAdmin {
    
    let client: ESClient
    
    init(withClient: ESClient) {
        self.client = withClient
    }
    
    func create(withName name: String) -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder(withClient: self.client, name: name)
    }
    
    func get(withName name: String) -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder(withClient: self.client, name: name)
    }
    
    func delete(withName name: String) -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder(withClient: self.client, name: name)
    }
}

