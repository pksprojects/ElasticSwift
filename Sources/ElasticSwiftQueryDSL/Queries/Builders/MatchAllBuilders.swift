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
    
    @discardableResult
    public func set(boost: Decimal) -> Self {
        self.boost = boost
        return self
    }
    
    public func build() throws -> MatchAllQuery {
        return MatchAllQuery(withBuilder: self)
    }
}

/// Builder for MatchAll query.

public class MatchNoneQueryBuilder: QueryBuilder {
    
    public func build() throws -> MatchNoneQuery {
        return MatchNoneQuery(withBuilder: self)
    }
}
