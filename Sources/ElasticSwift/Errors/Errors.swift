//
//  Errors.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/22/17.
//
//

import Foundation
import ElasticSwiftCore

//MARK:- ERRORS

//MARK:- Elasticsearch Default Error

public struct ElasticsearchError: Error, Codable {
    
    var error: ElasticError
    var status: Int
}

public struct ElasticError: Codable {
    
    var type: String?
    var index: String?
    var shard: String?
    var reason: String?
    var indexUUID: String?
    var rootCause: [ElasticError]?
    
    enum CodingKeys: String, CodingKey {
        case rootCause = "root_cause"
        case indexUUID = "index_uuid"
        case shard
        case index
        case reason
        case type
    }
}


public class UnsupportedResponseError: Error {
    
    let response: HTTPResponse
    let msg: String
    
    public init(msg: String = "UnsupportedResponseError", response: HTTPResponse) {
        self.response = response
        self.msg = msg
    }
    
    public var localizedDescription: String {
        get {
            return "\(msg): \(response)"
        }
    }
    
}

public class RequestConverterError<T: Request>: Error {
    
    public let error: Error
    public let message: String
    public let request: T
    
    public init(message: String, error: Error, request: T) {
        self.error = error
        self.message = message
        self.request = request
    }
    
}

public class ResponseConverterError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    public let error: Error
    public let message: String
    public let response: HTTPResponse
    
    public init(message: String, error: Error, response: HTTPResponse) {
        self.error = error
        self.message = message
        self.response = response
    }
    
    public var description: String {
        get {
            return "ResponseConverterError: \(message) Response: \(String(describing: response)) with Error: \(String(describing: error))"
        }
    }
    
    public var debugDescription: String {
        get {
            return "ResponseConverterError: \(message) Response: \(String(reflecting: response)) with Error: \(String(reflecting: error))"
        }
    }
    
}


public protocol ESClientError: Error {
    
    func message() -> String
    
}

public class RequestCreationError: ESClientError {
    
    let msg: String
    
    init(msg: String) {
        self.msg = msg
    }
    
    public func message() -> String {
        return msg
    }
    
}

public enum RequestBuilderError: Error {
    case missingRequiredField(String)
    case atleastOneFieldRequired([String])
}
