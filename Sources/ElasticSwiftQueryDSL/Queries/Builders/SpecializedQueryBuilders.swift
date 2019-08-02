//
//  SpecializedQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- MoreLikeThis Query Builder

public class MoreLikeThisQueryBuilder: QueryBuilder {
    
    public func build() throws -> MoreLikeThisQuery {
        return MoreLikeThisQuery(withBuilder: self)
    }
}

// MARK:- Script Query Builder

public class ScriptQueryBuilder: QueryBuilder {
    
    public func build() throws -> ScriptQuery {
        return ScriptQuery(withBuilder: self)
    }
}

// MARK:- Percolate Query Builder

public class PercoloteQueryBuilder: QueryBuilder {
    
    public func build() throws -> PercoloteQuery {
        return PercoloteQuery(withBuilder: self)
    }
}

// MARK:- Wrapper Query Builder

public class WrapperQueryBuilder: QueryBuilder {
    
    public func build() throws -> WrapperQuery {
        return WrapperQuery(withBuilder: self)
    }
}
