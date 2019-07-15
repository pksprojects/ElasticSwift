//
//  Response.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

public class ESResponse {
    
    public let data: Data?
    public let httpResponse: URLResponse?
    public let error: Error?
    
    init(data: Data? ,httpResponse: URLResponse?, error: Error?) {
        self.data = data
        self.httpResponse = httpResponse
        self.error = error
    }
}

//MARK:- Get Response

public struct GetResponse<T: Codable>: Codable {
    
    public let index: String
    public let type: String
    public let id: String
    public let version: Int?
    public let found: Bool
    public let source: T?
    public let seqNumber: Int?
    public let primaryTerm: Int?
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case source = "_source"
        case found
        case seqNumber = "_seq_no"
        case primaryTerm = "_primary_term"
    }
}

//MARK:- Index Response

public struct IndexResponse: Codable {
    
    public let shards: Shards
    public let index: String
    public let type: String
    public let id: String
    public let version: Int
    public let seqNumber: Int
    public let primaryTerm: Int
    public let result: String
    
    enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case seqNumber = "_seq_no"
        case primaryTerm = "_primary_term"
        case result
    }
}

//MARK:- Search Response

public class SearchResponse<T: Codable>: Codable {
    
    public var took: Int?
    public var timedOut: Bool?
    public var shards: Shards?
    public var hits: Hits<T>?
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
    }
}

public struct Shards: Codable {
    
    public var total: Int
    public var successful: Int
    public var skipped: Int?
    public var failed: Int
    
}


public class Hits<T: Codable>: Codable {
    
    public var total: Int?
    public var maxScore: Decimal?
    public var hits: [SearchHit<T>] = []
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case total
        case maxScore = "max_score"
        case hits
    }
    
}


public class SearchHit<T: Codable>: Codable {
    
    public var index: String?
    public var type: String?
    public var id: String?
    public var score: Decimal?
    public var source: T?
    
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case score = "_score"
        case source = "_source"
    }
}

//MARK:- Delete Response

public struct DeleteResponse: Codable {
    
    public let shards: Shards?
    public let index: String?
    public let type: String?
    public let id: String?
    public let version: Int?
    public let seqNumber: Int?
    public let primaryTerm: Int?
    public let result: String?
    
    enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case seqNumber = "_seq_no"
        case primaryTerm = "_primary_term"
        case result
    }
}
