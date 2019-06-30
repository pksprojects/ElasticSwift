//
//  Indices.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import Logging

public class IndicesClient {
    
    let client: ESClient
    
    let logger = Logger(label: "org.pksprojects.ElasticSwfit.IndiciesAdmin")
    
    init(withClient: ESClient) {
        self.client = withClient
    }
    
    public func createIndex() -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder()
    }
    
    public func getIndex() -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder()
    }
    
    public func deleteIndex() -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder()
    }
    
}

extension IndicesClient {
    
    public func createIndex(name: String) -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder().set(name: name)
    }
    
    public func getIndex(name: String) -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder().set(name: name)
    }
    
    public func deleteIndex(name: String) -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder().set(name: name)
    }
}

