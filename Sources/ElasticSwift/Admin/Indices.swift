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
    
    public func createIndex(withName name: String) -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder(withClient: self.client, name: name)
    }
    
    public func getIndex(withName name: String) -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder(withClient: self.client, name: name)
    }
    
    public func deleteIndex(withName name: String) -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder(withClient: self.client, name: name)
    }
    
}



