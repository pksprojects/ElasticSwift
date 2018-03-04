//
//  Clusters.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation

public class ClusterAdmin {
    
    let client: ESClient
    
    init(withClient: ESClient) {
        self.client = withClient
    }
}
