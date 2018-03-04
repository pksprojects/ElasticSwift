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
    
    func create() -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder(withClient: self.client)
    }
    
    func get() -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder(withClient: self.client)
    }
    
    func delete() -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder(withClient: self.client)
    }
}

