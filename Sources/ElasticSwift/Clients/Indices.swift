//
//  Indices.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import ElasticSwiftCore
import Foundation
import Logging

/// A wrapper for the `ElasticClient` that provides methods for accessing the Indices API.
///
/// [Indices API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices.html)
public class IndicesClient {
    /// the elasticsearch client
    let client: ElasticClient

    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Clients.IndicesClient")

    /// Initializes new indices client
    /// - Parameter withClient: the elasticsearch client
    init(withClient: ElasticClient) {
        client = withClient
    }
}

public extension IndicesClient {
    /// Asynchronously creates an index using the Create Index API.
    ///
    /// [Create Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
    /// - Parameters:
    ///   - createRequest: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func create(_ createRequest: CreateIndexRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<CreateIndexResponse, Error>) -> Void) {
        client.execute(request: createRequest, options: options, completionHandler: completionHandler)
    }

    /// Retrieve information about one or more indexes
    ///
    /// [Indices Get Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-index.html)
    /// - Parameters:
    ///   - getReqeust: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func get(_ getReqeust: GetIndexRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<GetIndexResponse, Error>) -> Void) {
        client.execute(request: getReqeust, options: options, completionHandler: completionHandler)
    }

    /// Asynchronously checks if the index (indices) exists or not.
    ///
    /// [Indices Exists API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html)
    /// - Parameters:
    ///   - getReqeust: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func exists(_ getReqeust: GetIndexRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) {
        client.execute(request: getReqeust, options: options, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }

    /// Asynchronously checks if the index (indices) exists or not.
    ///
    /// [Indices Exists API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html)
    /// - Parameters:
    ///   - existsReqeust: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func exists(_ existsReqeust: IndexExistsRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) {
        client.execute(request: existsReqeust, options: options, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }

    /// Asynchronously deletes an index using the Delete Index API.
    ///
    /// [Delete Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html)
    /// - Parameters:
    ///   - deleteReqeust: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func delete(_ deleteReqeust: DeleteIndexRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) {
        client.execute(request: deleteReqeust, options: options, completionHandler: completionHandler)
    }

    /// Asynchronously opens an index using the Open Index API.
    ///
    /// [Open Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)
    /// - Parameters:
    ///   - openReqeust: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func open(_ openReqeust: OpenIndexRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) {
        client.execute(request: openReqeust, options: options, completionHandler: completionHandler)
    }

    /// Asynchronously closes an index using the Close Index API.
    ///
    /// [Close Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)
    /// - Parameters:
    ///   - closeReqeust: the request
    ///   - options: the request options (e.g. headers), defaults to `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    func close(_ closeReqeust: CloseIndexRequest, with options: RequestOptions = .default, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) {
        client.execute(request: closeReqeust, options: options, completionHandler: completionHandler)
    }
}
