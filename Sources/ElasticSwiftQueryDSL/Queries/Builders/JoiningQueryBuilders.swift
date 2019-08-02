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
    
    public func build() throws -> NestedQuery {
        return NestedQuery(withBuilder: self)
    }
    
}

// MARK:- HasChild Query Builder

public class HasChildQueryBuilder: QueryBuilder {
    
    public func build() throws -> HasChildQuery {
        return HasChildQuery(withBuilder: self)
    }
    
    
}

// MARK:- HasParent Query Builder

public class HasParentQueryBuilder: QueryBuilder {
    
    public func build() throws -> HasParentQuery {
        return HasParentQuery(withBuilder: self)
    }
    
}

// MARK:- ParentId Query Builder

public class ParentIdQueryBuilder: QueryBuilder {
    
    public func build() throws -> ParentIdQuery {
        return ParentIdQuery(withBuilder: self)
    }
    
    
}
