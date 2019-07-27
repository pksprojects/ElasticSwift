//
//  MatchAll.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation
import ElasticSwiftCore

/// Builder for MatchAll query.

public class MatchAllQueryBuilder: QueryBuilder {
    
    public var boost: Decimal?
    
    typealias BuilderClosure = (MatchAllQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return MatchAllQuery(withBuilder: self)
        }
    }
    
    public func set(boost: Decimal) -> Self {
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
