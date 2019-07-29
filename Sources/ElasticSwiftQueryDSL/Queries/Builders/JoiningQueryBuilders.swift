//
//  JoiningQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Nested Query Builder

public class NestedQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return NestedQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- HasChild Query Builder

public class HasChildQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return HasChildQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- HasParent Query Builder

public class HasParentQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return HasParentQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- ParentId Query Builder

public class ParentIdQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return ParentIdQuery(withBuilder: self)
        }
    }
    
    
}
