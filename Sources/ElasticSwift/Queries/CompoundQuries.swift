//
//  CompoundQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Constant Score Query

public class ConstantScoreQuery: Query {
    public let name: String = "constant_score"
    
    var queryBuilder: QueryBuilder
    var boost: Int
    
    public init(withBuilder builder: ConstantScoreQueryBuilder) {
        self.queryBuilder = builder.queryBuilder!
        self.boost = builder.boost!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: ["filter": self.queryBuilder.query, "boost": self.boost]]
    }
    
}

// MARK:- Bool Query

public class BoolQuery: Query {
    
    public let name: String = "bool"
    private let MUST: String = "must"
    private let MUST_NOT: String = "must_not"
    private let SHOULD: String = "should"
    private let FILTER: String = "filter"
    private let MIN_SHOULD_MATCH = "minimum_should_match"
    var mustClauses: [Query]
    var mustNotClauses: [Query]
    var shouldClauses: [Query]
    var filterClauses: [Query]
    var minimumShouldMatch: Int?
    var boost: Float?
    
    init(must: [QueryBuilder], mustnot: [QueryBuilder], should: [QueryBuilder], filter: [QueryBuilder]) {
        self.mustClauses = must.map { $0.query }
        self.mustNotClauses = mustnot.map { $0.query }
        self.shouldClauses = should.map { $0.query }
        self.filterClauses = filter.map { $0.query }
    }
    
    public init(withBuilder builder: BoolQueryBuilder) {
        self.mustClauses = builder.getMustClauses().map { $0.query }
        self.mustNotClauses = builder.getMustNotClauses().map { $0.query }
        self.shouldClauses = builder.getShouldClauses().map { $0.query }
        self.filterClauses = builder.getFilterClauses().map { $0.query }
        self.boost = builder.boost
        self.minimumShouldMatch = builder.getMinimumShouldMatch()
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String : Any] = [:]
        if !self.mustClauses.isEmpty {
            dic[MUST] = self.mustClauses.map { $0.toDic() }
        }
        if !self.mustNotClauses.isEmpty {
            dic[MUST_NOT] = self.mustNotClauses.map { $0.toDic() }
        }
        if !self.shouldClauses.isEmpty {
            dic[SHOULD] = self.shouldClauses.map { $0.toDic() }
        }
        if !self.filterClauses.isEmpty {
            dic[FILTER] = self.filterClauses.map { $0.toDic() }
        }
        if let boost = self.boost {
            dic["boost"] = boost
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic["minimum_should_match"] = minimumShouldMatch
        }
        return [self.name: dic]
    }
}

// MARK:- Dis Max Query

public class DisMaxQuery: Query {
    public let name: String = "dis_max"
    
    private static let DEFAULT_TIE_BREAKER: Float = 0.0
    
    var tieBreaker: Float = DEFAULT_TIE_BREAKER
    var boost: Float?
    var queries: [Query]
    
    public init(withBuilder builder: DisMaxQueryBuilder) {
        if let tieBreaker = builder.tieBreaker {
            self.tieBreaker = tieBreaker
        }
        self.boost = builder.boost
        self.queries = builder.queryBuilders.map { $0.query }
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic["tie_breaker"] = self.tieBreaker
        if let boost = self.boost {
            dic["boost"] = boost
        }
        dic["queries"] = self.queries.map { $0.toDic() }
        return [self.name: dic]
    }
    
    
}

// MARK:- Function Score Query

public class FunctionScoreQuery: Query {
    public let name: String = "function_score"
    
    var queryBuilder: QueryBuilder?
    var boost: Float?
    var boostMode: BoostMode?
    var maxBoost: Float?
    var scoreMode: ScoreMode?
    var minScore: Float?
    var functions: [ScoreFunction]
    
    public init(withBuilder builder: FunctionScoreQueryBuilder) {
        self.queryBuilder = builder.queryBuilder
        self.boost = builder.boost
        self.boostMode = builder.boostMode
        self.maxBoost = builder.maxBoost
        self.scoreMode = builder.scoreMode
        self.minScore = builder.minScore
        self.functions = builder.functions 
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let query = self.queryBuilder?.query {
            dic["query"] = query
        }
        if let boost = self.boost {
            dic["boost"] = boost
        }
        if let boostMode = self.boostMode {
            dic["boost_mode"] = boostMode
        }
        if let maxBoost = self.maxBoost {
            dic["max_boost"] = maxBoost
        }
        if let scoreMode = self.scoreMode {
            dic["score_mode"] = scoreMode
        }
        if let minScore = self.minScore {
            dic["min_score"] = minScore
        }
        if !functions.isEmpty {
            if functions.count == 1 {
                let scoreFunction = functions[0]
                dic[scoreFunction.name] = scoreFunction.toDic()[scoreFunction.name]
            } else {
                dic["functions"] = functions.map { $0.toDic() }
            }
        }
        return [self.name: dic]
    }
    
    
}

// MARK:- Boosting Query

public class BoostingQuery: Query {
    
    private static let NEGATIVE_BOOST = "negative_boost"
    private static let NEGATIVE = "negative"
    private static let POSITIVE = "positive"
    
    public let name: String = "boosting"
    
    public var negativeQuery: Query?
    public var positiveQuery: Query?
    public var negativeBoost: Float?
    
    public init(withBuilder builder: BoostingQueryBuilder) {
        self.negativeQuery = builder.negativeQuery
        self.positiveQuery = builder.positiveQuery
        self.negativeBoost = builder.negativeBoost
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let positive = self.positiveQuery {
            dic[BoostingQuery.POSITIVE] = positive
        }
        if let negative = self.negativeQuery {
            dic[BoostingQuery.NEGATIVE] = negative
        }
        if let negativeBoost = self.negativeBoost {
            dic[BoostingQuery.NEGATIVE_BOOST] = negativeBoost
        }
        return [self.name: dic]
    }
    
    
}


