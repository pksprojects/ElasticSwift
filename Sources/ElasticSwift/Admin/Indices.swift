//
//  Indices.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import Logging

public class IndiciesAdmin {
    
    let client: ESClient
    
    let logger = Logger(label: "org.pksprojects.ElasticSwfit.IndiciesAdmin")
    
    init(withClient: ESClient) {
        self.client = withClient
    }
    
    public func createIndex() -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder(withClient: self.client)
    }
    
    public func getIndex() -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder(withClient: self.client)
    }
    
    public func deleteIndex() -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder(withClient: self.client)
    }
    
}

extension IndiciesAdmin {
    
    public func createIndex(name: String) -> CreateIndexRequestBuilder {
        return CreateIndexRequestBuilder(withClient: self.client).set(name: name)
    }
    
    public func getIndex(name: String) -> GetIndexRequestBuilder {
        return GetIndexRequestBuilder(withClient: self.client).set(name: name)
    }
    
    public func deleteIndex(name: String) -> DeleteIndexRequestBuilder {
        return DeleteIndexRequestBuilder(withClient: self.client).set(name: name)
    }
}

