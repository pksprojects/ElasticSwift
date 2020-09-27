//
//  MatchAll.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import ElasticSwiftCore
import Foundation

/// Builder for MatchAll query.

public class MatchAllQueryBuilder: QueryBuilder {
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> MatchAllQuery {
        return try MatchAllQuery(withBuilder: self)
    }
}

/// Builder for MatchAll query.

public class MatchNoneQueryBuilder: QueryBuilder {
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> MatchNoneQuery {
        return try MatchNoneQuery(withBuilder: self)
    }
}
