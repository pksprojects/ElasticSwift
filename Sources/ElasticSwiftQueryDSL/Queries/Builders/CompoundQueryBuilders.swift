//
//  CompoundQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Constant Score Query Builder

public class ConstantScoreQueryBuilder: QueryBuilder {
    private var _query: Query?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(query: Query) -> ConstantScoreQueryBuilder {
        _query = query
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> ConstantScoreQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> ConstantScoreQueryBuilder {
        _name = name
        return self
    }

    public var query: Query? {
        return _query
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> ConstantScoreQuery {
        return try ConstantScoreQuery(withBuilder: self)
    }
}

// MARK: - Bool Query Builder

public class BoolQueryBuilder: QueryBuilder {
    private var _mustClauses: [Query] = []
    private var _mustNotClauses: [Query] = []
    private var _shouldClauses: [Query] = []
    private var _filterClauses: [Query] = []
    private var _minimumShouldMatch: Int?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func must<T: Query>(query: T) -> BoolQueryBuilder {
        _mustClauses.append(query)
        return self
    }

    @discardableResult
    public func mustNot<T: Query>(query: T) -> BoolQueryBuilder {
        _mustNotClauses.append(query)
        return self
    }

    @discardableResult
    public func filter<T: Query>(query: T) -> BoolQueryBuilder {
        _filterClauses.append(query)
        return self
    }

    @discardableResult
    public func should<T: Query>(query: T) -> BoolQueryBuilder {
        _shouldClauses.append(query)
        return self
    }

    @discardableResult
    public func set(minimumShouldMatch: Int) -> BoolQueryBuilder {
        _minimumShouldMatch = minimumShouldMatch
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> BoolQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> BoolQueryBuilder {
        _name = name
        return self
    }

    public var mustClauses: [Query] {
        return _mustClauses
    }

    public var mustNotClauses: [Query] {
        return _mustNotClauses
    }

    public var filterClauses: [Query] {
        return _filterClauses
    }

    public var shouldClauses: [Query] {
        return _shouldClauses
    }

    public var minimumShouldMatch: Int? {
        return _minimumShouldMatch
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> BoolQuery {
        return try BoolQuery(withBuilder: self)
    }
}

// MARK: - Dis Max Query Builder

public class DisMaxQueryBuilder: QueryBuilder {
    private var _tieBreaker: Decimal?
    private var _boost: Decimal?
    private var _queries: [Query] = []
    private var _name: String?

    public init() {}

    @discardableResult
    public func add(query: Query) -> DisMaxQueryBuilder {
        _queries.append(query)
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> DisMaxQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> DisMaxQueryBuilder {
        _name = name
        return self
    }

    @discardableResult
    public func set(tieBreaker: Decimal) -> DisMaxQueryBuilder {
        _tieBreaker = tieBreaker
        return self
    }

    public var tieBreaker: Decimal? {
        return _tieBreaker
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public var queries: [Query] {
        return _queries
    }

    public func build() throws -> DisMaxQuery {
        return try DisMaxQuery(withBuilder: self)
    }
}

// MARK: - Function Score Query Builder

public class FunctionScoreQueryBuilder: QueryBuilder {
    private var _query: Query?
    private var _boost: Decimal?
    private var _name: String?
    private var _boostMode: BoostMode?
    private var _maxBoost: Decimal?
    private var _scoreMode: ScoreMode?
    private var _minScore: Decimal?
    private var _functions = [ScoreFunction]()

    public init() {}

    @discardableResult
    public func set(query: Query) -> FunctionScoreQueryBuilder {
        _query = query
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> FunctionScoreQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> FunctionScoreQueryBuilder {
        _name = name
        return self
    }

    @discardableResult
    public func set(boostMode: BoostMode) -> FunctionScoreQueryBuilder {
        _boostMode = boostMode
        return self
    }

    @discardableResult
    public func set(maxBoost: Decimal) -> FunctionScoreQueryBuilder {
        _maxBoost = maxBoost
        return self
    }

    @discardableResult
    public func set(scoreMode: ScoreMode) -> FunctionScoreQueryBuilder {
        _scoreMode = scoreMode
        return self
    }

    @discardableResult
    public func set(minScore: Decimal) -> FunctionScoreQueryBuilder {
        _minScore = minScore
        return self
    }

    @discardableResult
    public func add(function: ScoreFunction) -> FunctionScoreQueryBuilder {
        _functions.append(function)
        return self
    }

    public var query: Query? {
        return _query
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public var boostMode: BoostMode? {
        return _boostMode
    }

    public var maxBoost: Decimal? {
        return _maxBoost
    }

    public var scoreMode: ScoreMode? {
        return _scoreMode
    }

    public var minScore: Decimal? {
        return _minScore
    }

    public var functions: [ScoreFunction] {
        return _functions
    }

    public func build() throws -> FunctionScoreQuery {
        return try FunctionScoreQuery(withBuilder: self)
    }
}

// MARK: - Boosting Query Builder

public class BoostingQueryBuilder: QueryBuilder {
    private var _negative: Query?
    private var _positive: Query?
    private var _negativeBoost: Decimal?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(negative: Query) -> BoostingQueryBuilder {
        _negative = negative
        return self
    }

    @discardableResult
    public func set(positive: Query) -> BoostingQueryBuilder {
        _positive = positive
        return self
    }

    @discardableResult
    public func set(negativeBoost: Decimal) -> BoostingQueryBuilder {
        _negativeBoost = negativeBoost
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> BoostingQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> BoostingQueryBuilder {
        _name = name
        return self
    }

    public var negative: Query? {
        return _negative
    }

    public var positive: Query? {
        return _positive
    }

    public var negativeBoost: Decimal? {
        return _negativeBoost
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> BoostingQuery {
        return try BoostingQuery(withBuilder: self)
    }
}
