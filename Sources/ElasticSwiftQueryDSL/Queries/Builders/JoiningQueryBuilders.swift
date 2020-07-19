//
//  JoiningQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - Nested Query Builder

public class NestedQueryBuilder: QueryBuilder {
    private var _path: String?
    private var _query: Query?
    private var _scoreMode: ScoreMode?
    private var _ignoreUnmapped: Bool?
    private var _innerHits: InnerHit?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(path: String) -> Self {
        _path = path
        return self
    }

    @discardableResult
    public func set(query: Query) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(scoreMode: ScoreMode) -> Self {
        _scoreMode = scoreMode
        return self
    }

    @discardableResult
    public func set(ignoreUnmapped: Bool) -> Self {
        _ignoreUnmapped = ignoreUnmapped
        return self
    }

    @discardableResult
    public func set(innerHits: InnerHit) -> Self {
        _innerHits = innerHits
        return self
    }

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

    public var path: String? {
        return _path
    }

    public var query: Query? {
        return _query
    }

    public var scoreMode: ScoreMode? {
        return _scoreMode
    }

    public var ignoreUnmapped: Bool? {
        return _ignoreUnmapped
    }

    public var innerHits: InnerHit? {
        return _innerHits
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> NestedQuery {
        return try NestedQuery(withBuilder: self)
    }
}

// MARK: - HasChild Query Builder

public class HasChildQueryBuilder: QueryBuilder {
    private var _type: String?
    private var _query: Query?
    private var _scoreMode: ScoreMode?
    private var _minChildren: Int?
    private var _maxChildren: Int?
    private var _ignoreUnmapped: Bool?
    private var _innerHits: InnerHit?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(type: String) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(query: Query) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(scoreMode: ScoreMode) -> Self {
        _scoreMode = scoreMode
        return self
    }

    @discardableResult
    public func set(ignoreUnmapped: Bool) -> Self {
        _ignoreUnmapped = ignoreUnmapped
        return self
    }

    @discardableResult
    public func set(innerHits: InnerHit) -> Self {
        _innerHits = innerHits
        return self
    }

    @discardableResult
    public func set(minChildren: Int) -> Self {
        _minChildren = minChildren
        return self
    }

    @discardableResult
    public func set(maxChildren: Int) -> Self {
        _maxChildren = maxChildren
        return self
    }

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

    public var type: String? {
        return _type
    }

    public var query: Query? {
        return _query
    }

    public var scoreMode: ScoreMode? {
        return _scoreMode
    }

    public var minChildren: Int? {
        return _minChildren
    }

    public var maxChildren: Int? {
        return _maxChildren
    }

    public var ignoreUnmapped: Bool? {
        return _ignoreUnmapped
    }

    public var innerHits: InnerHit? {
        return _innerHits
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> HasChildQuery {
        return try HasChildQuery(withBuilder: self)
    }
}

// MARK: - HasParent Query Builder

public class HasParentQueryBuilder: QueryBuilder {
    private var _parentType: String?
    private var _query: Query?
    private var _score: Bool?
    private var _ignoreUnmapped: Bool?
    private var _innerHits: InnerHit?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(parentType: String) -> Self {
        _parentType = parentType
        return self
    }

    @discardableResult
    public func set(query: Query) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(score: Bool) -> Self {
        _score = score
        return self
    }

    @discardableResult
    public func set(ignoreUnmapped: Bool) -> Self {
        _ignoreUnmapped = ignoreUnmapped
        return self
    }

    @discardableResult
    public func set(innerHits: InnerHit) -> Self {
        _innerHits = innerHits
        return self
    }

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

    public var parentType: String? {
        return _parentType
    }

    public var query: Query? {
        return _query
    }

    public var score: Bool? {
        return _score
    }

    public var ignoreUnmapped: Bool? {
        return _ignoreUnmapped
    }

    public var innerHits: InnerHit? {
        return _innerHits
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> HasParentQuery {
        return try HasParentQuery(withBuilder: self)
    }
}

// MARK: - ParentId Query Builder

public class ParentIdQueryBuilder: QueryBuilder {
    private var _type: String?
    private var _id: String?
    private var _ignoreUnmapped: Bool?
    private var _boost: Decimal?
    private var _name: String?

    @discardableResult
    public func set(type: String) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(ignoreUnmapped: Bool) -> Self {
        _ignoreUnmapped = ignoreUnmapped
        return self
    }

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

    public var type: String? {
        return _type
    }

    public var id: String? {
        return _id
    }

    public var ignoreUnmapped: Bool? {
        return _ignoreUnmapped
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> ParentIdQuery {
        return try ParentIdQuery(withBuilder: self)
    }
}
