//
//  Clusters.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import ElasticSwiftCore
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

    /// Asynchronously get cluster health using the Cluster Health API.
    ///
    /// [Cluster Health API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-health.html)
    /// - Parameters:
    ///   - clusterHealthReqeust: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func health(_ clusterHealthReqeust: ClusterHealthRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<ClusterHealthResponse, Error>) -> Void) {
        client.execute(request: clusterHealthReqeust, options: options, completionHandler: completionHandler)
    }
}
