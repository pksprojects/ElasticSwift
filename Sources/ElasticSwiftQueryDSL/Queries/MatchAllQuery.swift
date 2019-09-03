//
//  MatchAllQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/22/18.
//

import Foundation
import ElasticSwiftCore

// MARK:-  Match all Query

public class MatchAllQuery: Query {
    
    private static let BOOST = "boost"
    
    public let name: String = "match_all"
    
    public let boost: Decimal?
    
    public init(_ boost: Decimal? = nil) {
        self.boost = boost
    }
    
    convenience init(withBuilder builder: MatchAllQueryBuilder) {
        self.init(builder.boost)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic[MatchAllQuery.BOOST] = boost
        }
        return [name : dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        try nested.encodeIfPresent(self.boost, forKey: .boost)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        self.boost = try nested.decodeIfPresent(Decimal.self, forKey: .boost)
    }
    
    enum CodingKeys: CodingKey {
        case boost
    }
}

// MARK:- Match None Query

public class MatchNoneQuery: Query {
    
    public let name: String = "match_none"
    
    public init() {}
    
    convenience init(withBuilder builder: MatchNoneQueryBuilder) {
        self.init()
    }
    
    public func toDic() -> [String : Any] {
        return [self.name : [:]]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encode([String:String](), forKey: .key(named: self.name))
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        _ = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
    }
}
