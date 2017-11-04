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

public struct GetResponse{//: Codable {
    public let index: String
    public let type: String
    public let id: String
    public let version: Int
    public let found: Bool
    public let source: AnyObject
}

public struct SearchResponse {
    
    public let took: Int? = 0
    public let timedOut: Bool?
    public let shards: Shard?
    public let hits: Hits?
    
    public struct Shard {
        public let total: Int
        public let successful: Int32
        public let final: Int32
    }
    
    public struct Hits {
        public let total: Int
        public let maxScore: Double
        public let hits: [SearchHit]
    }
}

public struct SearchHit {
    
    public let index: String
    public let type: String
    public let id: String
    public let score: Double
    public let source: AnyObject
    
}
