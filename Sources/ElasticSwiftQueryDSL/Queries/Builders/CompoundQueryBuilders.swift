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
    
    public var queryBuilder: QueryBuilder?
    public var boost: Decimal?
    
    typealias BuilderClosure = (ConstantScoreQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        return ConstantScoreQuery(withBuilder: self)
    }
    
}

// MARK:- Bool Query Builder

public class BoolQueryBuilder: QueryBuilder {
    
    var boost: Decimal?
    
    private var mustClauses:[QueryBuilder] = []
    private var mustNotClauses:[QueryBuilder] = []
    private var shouldClauses:[QueryBuilder] = []
    private var filterClauses:[QueryBuilder] = []
    private var minimumShouldMatch: Int?
    
    typealias BuilderClosure = (BoolQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func must<T: QueryBuilder>(query: T) -> BoolQueryBuilder {
        self.mustClauses.append(query)
        return self
    }
    
    @discardableResult
    public func mustNot<T: QueryBuilder>(query: T) -> BoolQueryBuilder {
        self.mustNotClauses.append(query)
        return self
    }
    
    @discardableResult
    public func filter<T: QueryBuilder>(query: T) -> BoolQueryBuilder {
        self.filterClauses.append(query)
        return self
    }
    
    @discardableResult
    public func should<T: QueryBuilder>(query: T) -> BoolQueryBuilder {
        self.shouldClauses.append(query)
        return self
    }
    
    public func set(minimumShouldMatch: Int) -> BoolQueryBuilder {
        self.minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    public func set(boost: Decimal) -> BoolQueryBuilder {
        self.boost = boost
        return self
    }
    
    public func getMustClauses() -> [QueryBuilder] {
        return self.mustClauses
    }
    
    public func getMustNotClauses() -> [QueryBuilder] {
        return self.mustNotClauses
    }
    
    public func getFilterClauses() -> [QueryBuilder] {
        return self.filterClauses
    }
    
    public func getShouldClauses() -> [QueryBuilder] {
        return self.shouldClauses
    }
    
    public func getMinimumShouldMatch() -> Int? {
        return self.minimumShouldMatch
    }
    
    public var query: Query {
        get {
            return BoolQuery(withBuilder: self)
        }
    }
}

// MARK:- Dis Max Query Builder

public class DisMaxQueryBuilder: QueryBuilder {
    
    public var tieBreaker: Decimal?
    public var boost: Decimal?
    public var queryBuilders: [QueryBuilder] = []
    
    typealias BuilderClosure = (DisMaxQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func add(queryBuilder: QueryBuilder) -> DisMaxQueryBuilder {
        self.queryBuilders.append(queryBuilder)
        return self
    }
    
    public var query: Query {
        return DisMaxQuery(withBuilder: self)
    }
    
}

// MARK:- Function Score Query Builder

public class FunctionScoreQueryBuilder: QueryBuilder {
    
    public var queryBuilder: QueryBuilder?
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
    
    public var query: Query {
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
    
    public var query: Query {
        return BoostingQuery(withBuilder: self)
    }
    
}
