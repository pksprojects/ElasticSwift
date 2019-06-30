//
//  Errors.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/22/17.
//
//

import Foundation

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
