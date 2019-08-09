//
//  CompoundQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Constant Score Query Builder

public class ConstantScoreQueryBuilder: QueryBuilder {
    
    private var _query: Query?
    private var _boost: Decimal?
    
    typealias BuilderClosure = (ConstantScoreQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(query: Query) -> ConstantScoreQueryBuilder {
        self._query = query
        return self
    }
    
    @discardableResult
    public func set(boost: Decimal) -> ConstantScoreQueryBuilder {
        self._boost = boost
        return self
    }
    
    public var query: Query? {
        return self._query
    }
    
    public var boost: Decimal? {
        return self._boost
    }
    
    public func build() throws -> ConstantScoreQuery {
        return try ConstantScoreQuery(withBuilder: self)
    }
    
}

// MARK:- Bool Query Builder

public class BoolQueryBuilder: QueryBuilder {
    
    private var _mustClauses:[Query] = []
    private var _mustNotClauses:[Query] = []
    private var _shouldClauses:[Query] = []
    private var _filterClauses:[Query] = []
    private var _minimumShouldMatch: Int?
    private var _boost: Decimal?
    
    typealias BuilderClosure = (BoolQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func must<T: Query>(query: T) -> BoolQueryBuilder {
        self._mustClauses.append(query)
        return self
    }
    
    @discardableResult
    public func mustNot<T: Query>(query: T) -> BoolQueryBuilder {
        self._mustNotClauses.append(query)
        return self
    }
    
    @discardableResult
    public func filter<T: Query>(query: T) -> BoolQueryBuilder {
        self._filterClauses.append(query)
        return self
    }
    
    @discardableResult
    public func should<T: Query>(query: T) -> BoolQueryBuilder {
        self._shouldClauses.append(query)
        return self
    }
    
    @discardableResult
    public func set(minimumShouldMatch: Int) -> BoolQueryBuilder {
        self._minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    @discardableResult
    public func set(boost: Decimal) -> BoolQueryBuilder {
        self._boost = boost
        return self
    }
    
    public var mustClauses: [Query] {
        return self._mustClauses
    }
    
    public var mustNotClauses: [Query] {
        return self._mustNotClauses
    }
    
    public var filterClauses: [Query] {
        return self._filterClauses
    }
    
    public var shouldClauses: [Query] {
        return self._shouldClauses
    }
    
    public var minimumShouldMatch: Int? {
        return self._minimumShouldMatch
    }
    
    public var boost: Decimal? {
        return self._boost
    }
    
    public func build() throws -> BoolQuery {
        return try BoolQuery(withBuilder: self)
    }
}

// MARK:- Dis Max Query Builder

public class DisMaxQueryBuilder: QueryBuilder {
    
    private var _tieBreaker: Decimal?
    private var _boost: Decimal?
    private var _queries: [Query] = []
    
    typealias BuilderClosure = (DisMaxQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func add(query: Query) -> DisMaxQueryBuilder {
        self._queries.append(query)
        return self
    }
    
    @discardableResult
    public func set(boost: Decimal) -> DisMaxQueryBuilder {
        self._boost = boost
        return self
    }
    
    @discardableResult
    public func set(tieBreaker: Decimal) -> DisMaxQueryBuilder {
        self._tieBreaker = tieBreaker
        return self
    }
    
    public var tieBreaker: Decimal? {
        return self._tieBreaker
    }
    
    public var boost: Decimal? {
        return self._boost
    }
    
    public var queries: [Query] {
        return self._queries
    }
    
    public func build() throws -> DisMaxQuery {
        return try DisMaxQuery(withBuilder: self)
    }
}

// MARK:- Function Score Query Builder

public class FunctionScoreQueryBuilder: QueryBuilder {
    
    private var _query: Query?
    private var _boost: Decimal?
    private var _boostMode: BoostMode?
    private var _maxBoost: Decimal?
    private var _scoreMode: ScoreMode?
    private var _minScore: Decimal?
    private var _functions: [ScoreFunction] = [ScoreFunction]()
    
    typealias BuilderClosure = (FunctionScoreQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(query: Query) -> FunctionScoreQueryBuilder {
        self._query = query
        return self
    }
    
    @discardableResult
    public func set(boost: Decimal) -> FunctionScoreQueryBuilder {
        self._boost = boost
        return self
    }
    
    @discardableResult
    public func set(boostMode: BoostMode) -> FunctionScoreQueryBuilder {
        self._boostMode = boostMode
        return self
    }
    
    @discardableResult
    public func set(maxBoost: Decimal) -> FunctionScoreQueryBuilder {
        self._maxBoost = maxBoost
        return self
    }
    
    @discardableResult
    public func set(scoreMode: ScoreMode) -> FunctionScoreQueryBuilder {
        self._scoreMode = scoreMode
        return self
    }
    
    @discardableResult
    public func set(minScore: Decimal) -> FunctionScoreQueryBuilder {
        self._minScore = minScore
        return self
    }
    
    @discardableResult
    public func add(function: ScoreFunction) -> FunctionScoreQueryBuilder {
        self._functions.append(function)
        return self
    }
    
    public var query: Query? {
        return self._query
    }
    
    public var boost: Decimal? {
        return self._boost
    }
    
    public var boostMode: BoostMode? {
        return self._boostMode
    }
    
    public var maxBoost: Decimal? {
        return self._maxBoost
    }
    
    public var scoreMode: ScoreMode? {
        return self._scoreMode
    }
    
    public var minScore: Decimal? {
        return self._minScore
    }
    
    public var functions: [ScoreFunction] {
        return self._functions
    }
    
    public func build() throws -> FunctionScoreQuery {
        return try FunctionScoreQuery(withBuilder: self)
    }
    
}

// MARK:- Boosting Query Builder

public class BoostingQueryBuilder: QueryBuilder {
    
    private var _negative: Query?
    private var _positive: Query?
    private var _negativeBoost: Decimal?
    
    typealias BuilderClosure = (BoostingQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(negative: Query) -> BoostingQueryBuilder {
        self._negative = negative
        return self
    }
    
    @discardableResult
    public func set(positive: Query) -> BoostingQueryBuilder {
        self._positive = positive
        return self
    }
    
    @discardableResult
    public func set(negativeBoost: Decimal) -> BoostingQueryBuilder {
        self._negativeBoost = negativeBoost
        return self
    }
    
    public var negative: Query? {
        return self._negative
    }
    
    public var positive: Query? {
        return self._positive
    }
    
    public var negativeBoost: Decimal? {
        return self._negativeBoost
    }
    
    public func build() throws -> BoostingQuery {
        return try BoostingQuery(withBuilder: self)
    }
    
}
