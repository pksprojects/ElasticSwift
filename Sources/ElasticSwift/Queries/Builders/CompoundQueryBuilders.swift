//
//  CompoundQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Constant Score Query Builder

public class ConstantScoreQueryBuilder: QueryBuilder {
    
    public var query: Query {
        return ConstantScoreQuery(withBuilder: self)
    }
    
}

// MARK:- Bool Query Builder

public class BoolQueryBuilder: QueryBuilder {
    
    var boost: Float = 0.0
    
    private let MUST: String = "must"
    private let MUST_NOT: String = "must_not"
    private let SHOULD: String = "should"
    private let FILTER: String = "filter"
    
    private var mustClauses:[QueryBuilder] = []
    private var mustNotClauses:[QueryBuilder] = []
    private var shouldClauses:[QueryBuilder] = []
    private var filterClauses:[QueryBuilder] = []
    private var minimumShouldMatch: String = ""
    
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
        self.minimumShouldMatch = String(minimumShouldMatch)
        return self
    }
    
    public func set(boost: Float) -> Self {
        return self
    }
    
    public var query: Query {
        get {
            return BoolQuery(must: self.mustClauses, mustnot: self.mustNotClauses, should: self.shouldClauses, filter: self.filterClauses)
        }
    }
}

// MARK:- Dis Max Query Builder

public class DisMaxQueryBuilder: QueryBuilder {
    
    public var query: Query {
        return DisMaxQuery(withBuilder: self)
    }
    
}

// MARK:- Function Score Query Builder

public class FunctionScoreQueryBuilder: QueryBuilder {
    
    public var query: Query {
        return FunctionScoreQuery(withBuilder: self)
    }
    
}

// MARK:- Boosting Query Builder

public class BoostingQueryBuilder: QueryBuilder {
    
    public var query: Query {
        return BoostingQuery(withBuilder: self)
    }
    
}
