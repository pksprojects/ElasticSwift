//
//  Indices.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation
import Logging
import ElasticSwiftCore

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
        self.client = withClient
    }
    
    /// Asynchronously creates an index using the Create Index API.
    ///
    /// [Create Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
    /// - Parameters:
    ///   - createRequest: the request
    ///   - completionHandler: callback to be invoked upon request completion.
    public func create(_ createRequest: CreateIndexRequest, completionHandler: @escaping (_ result: Result<CreateIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: createRequest, options: .default, completionHandler: completionHandler)
    }
    
    /// Retrieve information about one or more indexes
    ///
    /// [Indices Get Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-index.html)
    /// - Parameters:
    ///   - getReqeust: the request
    ///   - completionHandler: callback to be invoked upon request completion.
    public func get(_ getReqeust: GetIndexRequest, completionHandler: @escaping (_ result: Result<GetIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: .default, completionHandler: completionHandler)
    }
    
    /// Asynchronously checks if the index (indices) exists or not.
    ///
    /// [Indices Exists API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html)
    /// - Parameters:
    ///   - getReqeust: the request
    ///   - completionHandler: callback to be invoked upon request completion.
    public func exists(_ getReqeust: GetIndexRequest, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: .default, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    /// Asynchronously checks if the index (indices) exists or not.
    ///
    /// [Indices Exists API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html)
    /// - Parameters:
    ///   - existsReqeust: the request
    ///   - completionHandler: callback to be invoked upon request completion.
    public func exists(_ existsReqeust: IndexExistsRequest, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: existsReqeust, options: .default, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    /// Asynchronously deletes an index using the Delete Index API.
    ///
    /// [Delete Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html)
    /// - Parameters:
    ///   - deleteReqeust: the request
    ///   - completionHandler: callback to be invoked upon request completion.
    public func delete(_ deleteReqeust: DeleteIndexRequest, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: deleteReqeust, options: .default, completionHandler: completionHandler)
    }
    
    /// Asynchronously opens an index using the Open Index API.
    ///
    /// [Open Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)
    /// - Parameters:
    ///   - openReqeust: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func open(_ openReqeust: OpenIndexRequest, completionHandler: @escaping (_ rresult: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: openReqeust, options: .default, completionHandler: completionHandler)
    }
    
    /// Asynchronously closes an index using the Close Index API.
    ///
    /// [Close Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)
    /// - Parameters:
    ///   - closeReqeust: the request
    ///   - completionHandler: callback to be invoked upon request completion.
    public func close(_ closeReqeust: CloseIndexRequest, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: closeReqeust, options: .default, completionHandler: completionHandler)
    }
    
}

extension IndicesClient {
    
    /// Asynchronously creates an index using the Create Index API.
    ///
    /// [Create Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
    /// - Parameters:
    ///   - createRequest: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func create(_ createRequest: CreateIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<CreateIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: createRequest, options: options, completionHandler: completionHandler)
    }
    
    /// Retrieve information about one or more indexes
    ///
    /// [Indices Get Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-index.html)
    /// - Parameters:
    ///   - getReqeust: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func get(_ getReqeust: GetIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<GetIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: options, completionHandler: completionHandler)
    }
    
    /// Asynchronously checks if the index (indices) exists or not.
    ///
    /// [Indices Exists API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html)
    /// - Parameters:
    ///   - getReqeust: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func exists(_ getReqeust: GetIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: options, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    /// Asynchronously checks if the index (indices) exists or not.
    ///
    /// [Indices Exists API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html)
    /// - Parameters:
    ///   - existsReqeust: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func exists(_ existsReqeust: IndexExistsRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: existsReqeust, options: options, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    /// Asynchronously deletes an index using the Delete Index API.
    ///
    /// [Delete Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html)
    /// - Parameters:
    ///   - deleteReqeust: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func delete(_ deleteReqeust: DeleteIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: deleteReqeust, options: options, completionHandler: completionHandler)
    }
    
    /// Asynchronously opens an index using the Open Index API.
    ///
    /// [Open Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)
    /// - Parameters:
    ///   - openReqeust: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func open(_ openReqeust: OpenIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: openReqeust, options: options, completionHandler: completionHandler)
    }
    
    /// Asynchronously closes an index using the Close Index API.
    ///
    /// [Close Index API on elastic.co](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)
    /// - Parameters:
    ///   - closeReqeust: the request
    ///   - options: the request options (e.g. headers), use `RequestOptions.default` if nothing to be customized.
    ///   - completionHandler: callback to be invoked upon request completion.
    public func close(_ closeReqeust: CloseIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: closeReqeust, options: options, completionHandler: completionHandler)
    }
}

