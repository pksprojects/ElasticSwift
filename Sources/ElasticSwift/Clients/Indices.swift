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

public class IndicesClient {
    
    let client: ElasticClient
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Clients.IndicesClient")
    
    init(withClient: ElasticClient) {
        self.client = withClient
    }
    
    public func create(_ createRequest: CreateIndexRequest, completionHandler: @escaping (_ result: Result<CreateIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: createRequest, options: .default, completionHandler: completionHandler)
    }
    
    public func get(_ getReqeust: GetIndexRequest, completionHandler: @escaping (_ result: Result<GetIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: .default, completionHandler: completionHandler)
    }
    
    public func exists(_ getReqeust: GetIndexRequest, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: .default, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    public func exists(_ existsReqeust: IndexExistsRequest, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: existsReqeust, options: .default, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    public func delete(_ deleteReqeust: DeleteIndexRequest, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: deleteReqeust, options: .default, completionHandler: completionHandler)
    }
    
    public func open(_ openReqeust: OpenIndexRequest, completionHandler: @escaping (_ rresult: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: openReqeust, options: .default, completionHandler: completionHandler)
    }
    
    public func close(_ closeReqeust: CloseIndexRequest, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: closeReqeust, options: .default, completionHandler: completionHandler)
    }
    
}

extension IndicesClient {
    
    public func create(_ createRequest: CreateIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<CreateIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: createRequest, options: options, completionHandler: completionHandler)
    }
    
    public func get(_ getReqeust: GetIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<GetIndexResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: options, completionHandler: completionHandler)
    }
    
    public func exists(_ getReqeust: GetIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: getReqeust, options: options, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    public func exists(_ existsReqeust: IndexExistsRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<IndexExistsResponse, Error>) -> Void) -> Void {
        self.client.execute(request: existsReqeust, options: options, converter: ResponseConverters.indexExistsResponseConverter, completionHandler: completionHandler)
    }
    
    public func delete(_ deleteReqeust: DeleteIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: deleteReqeust, options: options, completionHandler: completionHandler)
    }
    
    public func open(_ openReqeust: OpenIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: openReqeust, options: options, completionHandler: completionHandler)
    }
    
    public func close(_ closeReqeust: CloseIndexRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<AcknowledgedResponse, Error>) -> Void) -> Void {
        self.client.execute(request: closeReqeust, options: options, completionHandler: completionHandler)
    }
}

