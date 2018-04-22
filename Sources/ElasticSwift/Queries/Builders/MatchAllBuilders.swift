//
//  MatchAll.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation

/// Builder for MatchAll query.

public class MatchAllQueryBuilder: QueryBuilder {
    
    public var boost: Float?
    
    public var query: Query {
        get {
            return MatchAllQuery(withBuilder: self)
        }
    }
    
    public func set(boost: Float) -> Self {
        self.boost = boost
        return self
    }
}

/// Builder for MatchAll query.

public class MatchNoneQueryBuilder: QueryBuilder {
    
    public var query: Query {
        get {
            return MatchNoneQuery(withBuilder: self)
        }
    }
}
