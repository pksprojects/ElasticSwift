//
//  MatchAllQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/22/18.
//

import Foundation

// MARK:-  Match all Query

public class MatchAllQuery: Query {
    
    public let name: String = "match_all"
    
    var boost: Float?
    
    init(withBuilder builder: MatchAllQueryBuilder) {
        self.boost = builder.boost
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic["boost"] = boost
        }
        return [name : dic]
    }
}

// MARK:- Match None Query

public class MatchNoneQuery: Query {
    
    public let name: String = "match_none"
    
    init(withBuilder builder: MatchNoneQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        return [self.name : [:]]
    }
}
