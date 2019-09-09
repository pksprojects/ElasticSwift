//
//  MatchAllQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/22/18.
//

import Foundation
import ElasticSwiftCore

// MARK:-  Match all Query

public struct MatchAllQuery: Query {
    
    public let name: String = "match_all"
    
    public let boost: Decimal?
    
    public init(_ boost: Decimal? = nil) {
        self.boost = boost
    }
    
    internal init(withBuilder builder: MatchAllQueryBuilder) {
        self.init(builder.boost)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic[CodingKeys.boost.rawValue] = boost
        }
        return [name : dic]
    }
}

extension MatchAllQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        self.boost = try nested.decodeIfPresent(Decimal.self, forKey: .boost)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        try nested.encodeIfPresent(self.boost, forKey: .boost)
    }
    
    enum CodingKeys: String, CodingKey {
        case boost
    }
}

extension MatchAllQuery: Equatable {
    public static func == (lhs: MatchAllQuery, rhs: MatchAllQuery) -> Bool {
        return lhs.name == rhs.name
            && lhs.boost == rhs.boost
    }
}

// MARK:- Match None Query

public struct MatchNoneQuery: Query {
    
    public let name: String = "match_none"
    
    public init() {}
    
    internal init(withBuilder builder: MatchNoneQueryBuilder) {
        self.init()
    }
    
    public func toDic() -> [String : Any] {
        return [self.name : [:]]
    }
}

extension MatchNoneQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        _ = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encode([String:String](), forKey: .key(named: self.name))
    }
}

extension MatchNoneQuery: Equatable {
    public static func == (lhs: MatchNoneQuery, rhs: MatchNoneQuery) -> Bool {
        return lhs.name == rhs.name
    }
}
