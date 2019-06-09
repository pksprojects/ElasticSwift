//
//  CompoundQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Constant Score Query

public class ConstantScoreQuery: Query {
    
    private static let BOOST = "boost"
    private static let FILTER = "filter"
    
    public let name: String = "constant_score"
    
    var queryBuilder: QueryBuilder
    var boost: Decimal
    
    public init(withBuilder builder: ConstantScoreQueryBuilder) {
        self.queryBuilder = builder.queryBuilder!
        self.boost = builder.boost!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: [ConstantScoreQuery.FILTER: self.queryBuilder.query, ConstantScoreQuery.BOOST: self.boost]]
    }
    
}

// MARK:- Bool Query

public class BoolQuery: Query {
    
    private static let BOOST = "boost"
    private static let MUST: String = "must"
    private static let MUST_NOT: String = "must_not"
    private static let SHOULD: String = "should"
    private static let FILTER: String = "filter"
    private static let MIN_SHOULD_MATCH = "minimum_should_match"
    
    public let name: String = "bool"
    
    var mustClauses: [Query]
    var mustNotClauses: [Query]
    var shouldClauses: [Query]
    var filterClauses: [Query]
    var minimumShouldMatch: Int?
    var boost: Decimal?
    
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
            dic[BoolQuery.MUST] = self.mustClauses.map { $0.toDic() }
        }
        if !self.mustNotClauses.isEmpty {
            dic[BoolQuery.MUST_NOT] = self.mustNotClauses.map { $0.toDic() }
        }
        if !self.shouldClauses.isEmpty {
            dic[BoolQuery.SHOULD] = self.shouldClauses.map { $0.toDic() }
        }
        if !self.filterClauses.isEmpty {
            dic[BoolQuery.FILTER] = self.filterClauses.map { $0.toDic() }
        }
        if let boost = self.boost {
            dic[BoolQuery.BOOST] = boost
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[BoolQuery.MIN_SHOULD_MATCH] = minimumShouldMatch
        }
        return [self.name: dic]
    }
}

// MARK:- Dis Max Query

public class DisMaxQuery: Query {
    
    private static let BOOST = "boost"
    private static let TIE_BREAKER = "tie_breaker"
    private static let QUERIES = "queries"
    
    public let name: String = "dis_max"
    
    private static let DEFAULT_TIE_BREAKER: Decimal = 0.0
    
    var tieBreaker: Decimal = DEFAULT_TIE_BREAKER
    var boost: Decimal?
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
        dic[DisMaxQuery.TIE_BREAKER] = self.tieBreaker
        if let boost = self.boost {
            dic[DisMaxQuery.BOOST] = boost
        }
        dic[DisMaxQuery.QUERIES] = self.queries.map { $0.toDic() }
        return [self.name: dic]
    }
    
    
}

// MARK:- Function Score Query

public class FunctionScoreQuery: Query {
    
    private static let QUERY = "query"
    private static let BOOST = "boost"
    private static let BOOST_MODE = "boost_mode"
    private static let MAX_BOOST = "max_boost"
    private static let SCORE_MODE = "score_mode"
    private static let MIN_SCORE = "min_score"
    private static let FUNCTIONS = "functions"
    
    public let name: String = "function_score"
    
    var queryBuilder: QueryBuilder?
    var boost: Decimal?
    var boostMode: BoostMode?
    var maxBoost: Decimal?
    var scoreMode: ScoreMode?
    var minScore: Decimal?
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
            dic[FunctionScoreQuery.QUERY] = query
        }
        if let boost = self.boost {
            dic[FunctionScoreQuery.BOOST] = boost
        }
        if let boostMode = self.boostMode {
            dic[FunctionScoreQuery.BOOST_MODE] = boostMode
        }
        if let maxBoost = self.maxBoost {
            dic[FunctionScoreQuery.MAX_BOOST] = maxBoost
        }
        if let scoreMode = self.scoreMode {
            dic[FunctionScoreQuery.SCORE_MODE] = scoreMode
        }
        if let minScore = self.minScore {
            dic[FunctionScoreQuery.MIN_SCORE] = minScore
        }
        if !functions.isEmpty {
            if functions.count == 1 {
                let scoreFunction = functions[0]
                dic[scoreFunction.name] = scoreFunction.toDic()[scoreFunction.name]
            } else {
                dic[FunctionScoreQuery.FUNCTIONS] = functions.map { $0.toDic() }
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
    public var negativeBoost: Decimal?
    
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


