//
//  Request.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import NIOHTTP1

public protocol Request {
    
    associatedtype ResponseType: Codable
    
    var headers: HTTPHeaders { get }
    
    var queryParams: [URLQueryItem] { get }
    
    var method: HTTPMethod { get }
    
    var endPoint: String { get }
    
    var body: Data { get }
    
}


public class RequestOptions {
    
    let headers: HTTPHeaders
    let queryParams: [URLQueryItem]
    
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


public class Response<T: Codable> {
    
    public let data: T?
    public let httpResponse: URLResponse?
    public let error: Error?
    
    init(data: T? ,httpResponse: URLResponse?, error: Error?) {
        self.data = data
        self.httpResponse = httpResponse
        self.error = error
    }
}


public protocol RequestBuilder {
    
    associatedtype RequestType: Request
    
    func build() throws -> RequestType
}

