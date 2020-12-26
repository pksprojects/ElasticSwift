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

    /// Asynchronously get the cluster wide settings using the Cluster Get Settings API.
    ///
    /// [Cluster Get Settings API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-get-settings.html)
    /// - Parameters:
    ///   - clusterGetSettingsRequest: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func getSettings(_ clusterGetSettingsRequest: ClusterGetSettingsRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<ClusterGetSettingsResponse, Error>) -> Void) {
        client.execute(request: clusterGetSettingsRequest, options: options, completionHandler: completionHandler)
    }

    /// Asynchronously updates cluster wide specific settings using the Cluster Update Settings API.
    ///
    /// [Cluster Update Settings API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)
    /// - Parameters:
    ///   - clusterUpdateSettingsRequest: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func putSettings(_ clusterUpdateSettingsRequest: ClusterUpdateSettingsRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<ClusterUpdateSettingsResponse, Error>) -> Void) {
        client.execute(request: clusterUpdateSettingsRequest, options: options, completionHandler: completionHandler)
    }
}
