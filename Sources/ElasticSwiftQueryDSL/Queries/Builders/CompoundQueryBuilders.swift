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
    
    public var query: Query?
    public var boost: Decimal?
    
    typealias BuilderClosure = (ConstantScoreQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func build() throws -> ConstantScoreQuery {
        return ConstantScoreQuery(withBuilder: self)
    }
    
}

// MARK:- Bool Query Builder

public class BoolQueryBuilder: QueryBuilder {
    
    var boost: Decimal?
    
    private var mustClauses:[Query] = []
    private var mustNotClauses:[Query] = []
    private var shouldClauses:[Query] = []
    private var filterClauses:[Query] = []
    private var minimumShouldMatch: Int?
    
    typealias BuilderClosure = (BoolQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func must<T: Query>(query: T) -> BoolQueryBuilder {
        self.mustClauses.append(query)
        return self
    }
    
    @discardableResult
    public func mustNot<T: Query>(query: T) -> BoolQueryBuilder {
        self.mustNotClauses.append(query)
        return self
    }
    
    @discardableResult
    public func filter<T: Query>(query: T) -> BoolQueryBuilder {
        self.filterClauses.append(query)
        return self
    }
    
    @discardableResult
    public func should<T: Query>(query: T) -> BoolQueryBuilder {
        self.shouldClauses.append(query)
        return self
    }
    
    @discardableResult
    public func set(minimumShouldMatch: Int) -> BoolQueryBuilder {
        self.minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    @discardableResult
    public func set(boost: Decimal) -> BoolQueryBuilder {
        self.boost = boost
        return self
    }
    
    public func getMustClauses() -> [Query] {
        return self.mustClauses
    }
    
    public func getMustNotClauses() -> [Query] {
        return self.mustNotClauses
    }
    
    public func getFilterClauses() -> [Query] {
        return self.filterClauses
    }
    
    public func getShouldClauses() -> [Query] {
        return self.shouldClauses
    }
    
    public func getMinimumShouldMatch() -> Int? {
        return self.minimumShouldMatch
    }
    
    public func build() throws -> BoolQuery {
        return BoolQuery(withBuilder: self)
    }
}

// MARK:- Dis Max Query Builder

public class DisMaxQueryBuilder: QueryBuilder {
    
    public var tieBreaker: Decimal?
    public var boost: Decimal?
    public var querys: [Query] = []
    
    typealias BuilderClosure = (DisMaxQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func add(query: Query) -> DisMaxQueryBuilder {
        self.querys.append(query)
        return self
    }
    
    public func build() throws -> DisMaxQuery {
        return DisMaxQuery(withBuilder: self)
    }
}

// MARK:- Function Score Query Builder

public class FunctionScoreQueryBuilder: QueryBuilder {
    
    public var query: Query?
    public var boost: Decimal?
    public var boostMode: BoostMode?
    public var maxBoost: Decimal?
    public var scoreMode: ScoreMode?
    public var minScore: Decimal?
    public var functions: [ScoreFunction] = [ScoreFunction]()
    
    typealias BuilderClosure = (FunctionScoreQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func build() throws -> FunctionScoreQuery {
        return FunctionScoreQuery(withBuilder: self)
    }
    
}

// MARK:- Boosting Query Builder

public class BoostingQueryBuilder: QueryBuilder {
    
    public var negativeQuery: Query?
    public var positiveQuery: Query?
    public var negativeBoost: Decimal?
    
    typealias BuilderClosure = (BoostingQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func build() throws -> BoostingQuery {
        return BoostingQuery(withBuilder: self)
    }
    
}
