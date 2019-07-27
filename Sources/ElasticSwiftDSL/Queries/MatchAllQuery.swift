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
}
