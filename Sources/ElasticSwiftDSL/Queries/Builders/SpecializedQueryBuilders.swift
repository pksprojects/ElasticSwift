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
    public var query: Query {
        get {
            return MoreLikeThisQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Script Query Builder

public class ScriptQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return ScriptQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Percolate Query Builder

public class PercoloteQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return PercoloteQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Wrapper Query Builder

public class WrapperQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return WrapperQuery(withBuilder: self)
        }
    }
    
    
}
