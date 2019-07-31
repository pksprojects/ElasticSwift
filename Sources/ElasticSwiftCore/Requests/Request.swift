//
//  Request.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import NIOHTTP1

//MARK:- Reqeust Protocol

/// Represents High Level Elasticsearch Reqeust
public protocol Request {
    
    var headers: HTTPHeaders { get }
    
    var queryParams: [URLQueryItem] { get }
    
    var method: HTTPMethod { get }
    
    var endPoint: String { get }
    
    func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError>
    
}

//MARK:- Request options

/// Represents Additional options for Elasticsearch Reqeust like queryParam and/or header
public class RequestOptions {
    
    public let headers: HTTPHeaders
    public let queryParams: [URLQueryItem]
    
    init(headers: HTTPHeaders = HTTPHeaders(), queryParams: [URLQueryItem] = []) {
        self.headers = headers
        self.queryParams = queryParams
    }
    
    public static var `default`: RequestOptions {
        get {
            return RequestOptions()
        }
    }
}

//MARK:- RequestBuilder Protocol

/// Protocol to which all `Request` Builders conforms to
public protocol RequestBuilder {
    
    associatedtype RequestType: Request
    
    func build() throws -> RequestType
}

