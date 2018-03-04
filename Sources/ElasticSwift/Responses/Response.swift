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

public class GetResponse<T: Codable>: Codable {
    
    public var index: String?
    public var type: String?
    public var id: String?
    public var version: Int?
    public var found: Bool?
    
    public var source: T?
    
    init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case source = "_source"
        
        case found
    }
}

public class IndexResponse: Codable {
    
    public var shards: Shards?
    public var index: String?
    public var type: String?
    public var id: String?
    public var version: Int?
    public var seqNumber: Int?
    public var primaryTerm: Int?
    public var result: String?
    
    init() {
        
    }
    
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

public class Shards: Codable {
    
    public var total: Int?
    public var successful: Int?
    public var skipped: Int?
    public var failed: Int?
    
    init() {
        
    }
    
}


public class Hits<T: Codable>: Codable {
    
    public var total: Int?
    public var maxScore: Double?
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
    public var score: Double?
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
