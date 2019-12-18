//
//  JoiningQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Nested Query Builder

internal class NestedQueryBuilder: QueryBuilder {
    public func build() throws -> NestedQuery {
        return NestedQuery(withBuilder: self)
    }
}

// MARK: - HasChild Query Builder

internal class HasChildQueryBuilder: QueryBuilder {
    public func build() throws -> HasChildQuery {
        return HasChildQuery(withBuilder: self)
    }
}

// MARK: - HasParent Query Builder

internal class HasParentQueryBuilder: QueryBuilder {
    public func build() throws -> HasParentQuery {
        return HasParentQuery(withBuilder: self)
    }
}

// MARK: - ParentId Query Builder

internal class ParentIdQueryBuilder: QueryBuilder {
    public func build() throws -> ParentIdQuery {
        return ParentIdQuery(withBuilder: self)
    }
}
