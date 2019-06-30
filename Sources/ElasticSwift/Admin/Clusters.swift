//
//  Clusters.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import Logging

public class ClusterClient {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwfit.ClusterAdmin")
    
    let client: ESClient
    
    init(withClient: ESClient) {
        self.client = withClient
    }
}
