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
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Clients.ClusterClient")
    
    let client: ElasticClient
    
    init(withClient: ElasticClient) {
        self.client = withClient
    }
}
