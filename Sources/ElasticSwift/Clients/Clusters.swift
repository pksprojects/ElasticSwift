//
//  Clusters.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import Logging

///  A wrapper for the `ElasticClient` that provides methods for accessing the Cluster API.
///
/// [Cluster API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster.html)
public class ClusterClient {
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Clients.ClusterClient")

    /// the elasticsearch client
    let client: ElasticClient

    /// Initializes new indices client
    /// - Parameter withClient: the elasticsearch client
    init(withClient: ElasticClient) {
        client = withClient
    }
}
