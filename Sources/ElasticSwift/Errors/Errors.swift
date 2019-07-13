//
//  Errors.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/22/17.
//
//

import Foundation

//MARK:- ERRORS

//MARK:- Elasticsearch Default Error

public class ElasticsearchError: Error, Codable {
    
    var error: ElasticError?
    var status: Int?
    
    init() {}
}

public class ElasticError: Codable {
    
    var type: String?
    var index: String?
    var shard: String?
    var reason: String?
    var indexUUID: String?
    var rootCause: [ElasticError]?
    
    init() {}
    
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

public class ResponseConverterError: Error {
    
    public let error: Error
    public let message: String
    public let response: HTTPResponse
    
    public init(message: String, error: Error, response: HTTPResponse) {
        self.error = error
        self.message = message
        self.response = response
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

public enum MakeBodyError: Error {
    
    case noBodyForRequest
    case wrapped(Error)
    
}


public class EncodingError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    public let value: Any
    public let error: Error
    
    public init(value: Any, error: Error) {
        self.value = value
        self.error = error
    }
    
    public var description: String {
        get {
            if let val = value as? CustomStringConvertible {
                return "EncodingError: Unable to encode \(val.description) with Error: \(error.localizedDescription)"
            }
            return "EncodingError: Unable to encode \(String(describing: value)) with Error: \(error.localizedDescription)"
        }
    }
    
    public var debugDescription: String {
        get {
            if let val = value as? CustomDebugStringConvertible {
                return "EncodingError: Unable to encode \(val.debugDescription) with Error: \(error.localizedDescription)"
            } else {
                return description
            }
        }
    }
    
}

public class DecodingError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    public let data: Data
    public let error: Error
    public let type: Any.Type
    
    public init(_ type: Any.Type, data: Data, error: Error) {
        self.data = data
        self.error = error
        self.type = type
    }
    
    public var description: String {
        get {
            return "DecodingError: Unable to decode \(self.type) from \(data.description) with Error: \(error.localizedDescription)"
        }
    }
    
    public var debugDescription: String {
        get {
            return "DecodingError: Unable to decode \(self.type) from \(data.debugDescription) with Error: \(error.localizedDescription)"
        }
    }
    
}
