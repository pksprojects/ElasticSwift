//
//  SpecializedQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - MoreLikeThis Query Builder

internal class MoreLikeThisQueryBuilder: QueryBuilder {
    public func build() throws -> MoreLikeThisQuery {
        return MoreLikeThisQuery(withBuilder: self)
    }
}

// MARK: - Script Query Builder

internal class ScriptQueryBuilder: QueryBuilder {
    public func build() throws -> ScriptQuery {
        return ScriptQuery(withBuilder: self)
    }
}

// MARK: - Percolate Query Builder

internal class PercoloteQueryBuilder: QueryBuilder {
    public func build() throws -> PercoloteQuery {
        return PercoloteQuery(withBuilder: self)
    }
}

// MARK: - Wrapper Query Builder

internal class WrapperQueryBuilder: QueryBuilder {
    public func build() throws -> WrapperQuery {
        return WrapperQuery(withBuilder: self)
    }
}
