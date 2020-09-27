//
//  SpanQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Span Term Query Builder

public class SpanTermQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> Self {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> Self {
        _value = value
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

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanTermQuery {
        return try SpanTermQuery(withBuilder: self)
    }
}

// MARK: - Span Multi Term Query Builder

public class SpanMultiTermQueryBuilder: QueryBuilder {
    private var _match: MultiTermQuery?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(match: MultiTermQuery) -> Self {
        _match = match
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

    public var match: MultiTermQuery? {
        return _match
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanMultiTermQuery {
        return try SpanMultiTermQuery(withBuilder: self)
    }
}

// MARK: - Span First Query Builder

public class SpanFirstQueryBuilder: QueryBuilder {
    private var _match: SpanQuery?
    private var _end: Int?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(match: SpanQuery) -> Self {
        _match = match
        return self
    }

    @discardableResult
    public func set(end: Int) -> Self {
        _end = end
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

    public var match: SpanQuery? {
        return _match
    }

    public var end: Int? {
        return _end
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanFirstQuery {
        return try SpanFirstQuery(withBuilder: self)
    }
}

// MARK: - Span Near Query Builder

public class SpanNearQueryBuilder: QueryBuilder {
    private var _clauses: [SpanQuery]?
    private var _slop: Int?
    private var _inOrder: Bool?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(clauses: [SpanQuery]) -> Self {
        _clauses = clauses
        return self
    }

    @discardableResult
    public func add(clause: SpanQuery) -> Self {
        if _clauses == nil {
            return set(clauses: [clause])
        }
        _clauses?.append(clause)
        return self
    }

    @discardableResult
    public func set(slop: Int) -> Self {
        _slop = slop
        return self
    }

    @discardableResult
    public func set(inOrder: Bool) -> Self {
        _inOrder = inOrder
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

    public var clauses: [SpanQuery]? {
        return _clauses
    }

    public var slop: Int? {
        return _slop
    }

    public var inOrder: Bool? {
        return _inOrder
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanNearQuery {
        return try SpanNearQuery(withBuilder: self)
    }
}

// MARK: - Span Or Query Builder

public class SpanOrQueryBuilder: QueryBuilder {
    private var _clauses: [SpanQuery]?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(clauses: [SpanQuery]) -> Self {
        _clauses = clauses
        return self
    }

    @discardableResult
    public func add(clause: SpanQuery) -> Self {
        if _clauses == nil {
            return set(clauses: [clause])
        }
        _clauses?.append(clause)
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

    public var clauses: [SpanQuery]? {
        return _clauses
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanOrQuery {
        return try SpanOrQuery(withBuilder: self)
    }
}

// MARK: - Span Not Query Builder

public class SpanNotQueryBuilder: QueryBuilder {
    private var _include: SpanQuery?
    private var _exclude: SpanQuery?
    private var _pre: Int?
    private var _post: Int?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(include: SpanQuery) -> Self {
        _include = include
        return self
    }

    @discardableResult
    public func set(exclude: SpanQuery) -> Self {
        _exclude = exclude
        return self
    }

    @discardableResult
    public func set(pre: Int) -> Self {
        _pre = pre
        return self
    }

    @discardableResult
    public func set(post: Int) -> Self {
        _post = post
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

    public var include: SpanQuery? {
        return _include
    }

    public var exclude: SpanQuery? {
        return _exclude
    }

    public var pre: Int? {
        return _pre
    }

    public var post: Int? {
        return _post
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanNotQuery {
        return try SpanNotQuery(withBuilder: self)
    }
}

// MARK: - Span Containing Query Builder

public class SpanContainingQueryBuilder: QueryBuilder {
    private var _big: SpanQuery?
    private var _little: SpanQuery?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(big: SpanQuery) -> Self {
        _big = big
        return self
    }

    @discardableResult
    public func set(little: SpanQuery) -> Self {
        _little = little
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

    public var big: SpanQuery? {
        return _big
    }

    public var little: SpanQuery? {
        return _little
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanContainingQuery {
        return try SpanContainingQuery(withBuilder: self)
    }
}

// MARK: - Span Within Query Builder

public class SpanWithinQueryBuilder: QueryBuilder {
    private var _big: SpanQuery?
    private var _little: SpanQuery?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(big: SpanQuery) -> Self {
        _big = big
        return self
    }

    @discardableResult
    public func set(little: SpanQuery) -> Self {
        _little = little
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

    public var big: SpanQuery? {
        return _big
    }

    public var little: SpanQuery? {
        return _little
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanWithinQuery {
        return try SpanWithinQuery(withBuilder: self)
    }
}

// MARK: - Span Field Masking Query Builder

public class SpanFieldMaskingQueryBuilder: QueryBuilder {
    private var _query: SpanQuery?
    private var _field: String?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(query: SpanQuery) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(field: String) -> Self {
        _field = field
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

    public var query: SpanQuery? {
        return _query
    }

    public var field: String? {
        return _field
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SpanFieldMaskingQuery {
        return try SpanFieldMaskingQuery(withBuilder: self)
    }
}
