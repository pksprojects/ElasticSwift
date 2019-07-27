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
    //TODO: add completion handler

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

}

public class GetResponse<T: Codable>: Response {

    public var index: String
    public var type: String?
    public var id: String
    public var version: Int
    public var found: Bool

    public var source: T?

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

public struct SearchResponse<T: Codable>: Codable {

    public let took: Int
    public let timedOut: Bool
    public let shards: Shards
    public let hits: Hits<T>

    enum CodingKeys: String, CodingKey {
        case took
        case timedOut = "timed_out"
        case shards = "_shards"
        case hits
    }
}

public struct Shards: Codable {

    public let total: Int
    public let successful: Int
    public let skipped: Int?
    public let failed: Int

}


public struct Hits<T: Codable>: Codable {

    public let total: Int
    public let maxScore: Decimal?
    public let hits: [SearchHit<T>] = []

    enum CodingKeys: String, CodingKey {
        case total
        case maxScore = "max_score"
        case hits
    }

}


public struct SearchHit<T: Codable>: Codable {

    public let index: String
    public let type: String
    public let id: String
    public let score: Decimal
    public let source: T?

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
