//
//  CompoundQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Constant Score Query

public class ConstantScoreQuery: Query {
    
    private static let BOOST = "boost"
    private static let FILTER = "filter"
    
    public let name: String = "constant_score"
    
    public let query: Query
    public let boost: Decimal
    
    public init(_ query: Query, boost: Decimal = 1.0) {
        self.query = query
        self.boost = boost
    }
    
    internal convenience init(withBuilder builder: ConstantScoreQueryBuilder) throws {
        
        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }
        
        self.init(builder.query!, boost: builder.boost!)
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: [ConstantScoreQuery.FILTER: self.query.toDic(), ConstantScoreQuery.BOOST: self.boost]]
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
    
    public let mustClauses: [Query]
    public let mustNotClauses: [Query]
    public let shouldClauses: [Query]
    public let filterClauses: [Query]
    public let minimumShouldMatch: Int?
    public let boost: Decimal?
    
    public init(must: [Query], mustNot: [Query], should: [Query], filter: [Query], minimumShouldMatch: Int? = nil,  boost: Decimal? = nil) {
        self.mustNotClauses = mustNot
        self.mustClauses = must
        self.shouldClauses = should
        self.filterClauses = filter
        self.minimumShouldMatch = minimumShouldMatch
        self.boost = boost
    }
    
    internal init(withBuilder builder: BoolQueryBuilder) throws {
        
        guard !builder.filterClauses.isEmpty || !builder.mustClauses.isEmpty || !builder.mustNotClauses.isEmpty || !builder.shouldClauses.isEmpty else {
            throw QueryBuilderError.atleastOneFieldRequired(["filterClauses", "mustClauses", "mustNotClauses", "shouldClauses"])
        }
        
        self.mustClauses = builder.mustClauses
        self.mustNotClauses = builder.mustNotClauses
        self.shouldClauses = builder.shouldClauses
        self.filterClauses = builder.filterClauses
        self.boost = builder.boost
        self.minimumShouldMatch = builder.minimumShouldMatch
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
    
    public static let DEFAULT_TIE_BREAKER: Decimal = 0.0
    
    public let tieBreaker: Decimal
    public let boost: Decimal?
    public let queries: [Query]
    
    public init(_ queries: [Query], tieBreaker: Decimal = DisMaxQuery.DEFAULT_TIE_BREAKER, boost: Decimal? = nil) {
        self.tieBreaker = tieBreaker
        self.boost = boost
        self.queries = queries
    }
    
    internal init(withBuilder builder: DisMaxQueryBuilder) throws {
        
        guard !builder.queries.isEmpty else {
            throw QueryBuilderError.missingRequiredField("query")
        }
        
        self.tieBreaker = builder.tieBreaker ?? DisMaxQuery.DEFAULT_TIE_BREAKER
        self.boost = builder.boost
        self.queries = builder.queries
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
    
    public let query: Query
    public let boost: Decimal?
    public let boostMode: BoostMode?
    public let maxBoost: Decimal?
    public let scoreMode: ScoreMode?
    public let minScore: Decimal?
    public let functions: [ScoreFunction]
    
    public init(query: Query, boost: Decimal? = nil, boostMode: BoostMode? = nil, maxBoost: Decimal? = nil, scoreMode: ScoreMode? = nil, minScore: Decimal? = nil, functions: ScoreFunction...) {
        self.query = query
        self.boost = boost
        self.boostMode = boostMode
        self.maxBoost = maxBoost
        self.scoreMode = scoreMode
        self.minScore = minScore
        self.functions = functions
    }
    
    internal init(withBuilder builder: FunctionScoreQueryBuilder) throws {
        
        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }
        
        guard builder.functions.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("functions")
        }
        
        self.query = builder.query!
        self.boost = builder.boost
        self.boostMode = builder.boostMode
        self.maxBoost = builder.maxBoost
        self.scoreMode = builder.scoreMode
        self.minScore = builder.minScore
        self.functions = builder.functions 
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        
        dic[FunctionScoreQuery.QUERY] = query.toDic()
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
    
    public let negative: Query
    public let positive: Query
    public let negativeBoost: Decimal?
    
    public init(positive: Query, negative: Query, negativeBoost: Decimal? = nil) {
        self.positive = positive
        self.negative = negative
        self.negativeBoost = negativeBoost
    }
    
    internal convenience init(withBuilder builder: BoostingQueryBuilder) throws {
        
        guard builder.positive != nil else {
            throw QueryBuilderError.missingRequiredField("positive")
        }
        
        guard builder.negative != nil else {
            throw QueryBuilderError.missingRequiredField("negative")
        }
        
        self.init(positive: builder.positive!, negative: builder.negative!, negativeBoost: builder.negativeBoost)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
       
        dic[BoostingQuery.POSITIVE] = positive
        dic[BoostingQuery.NEGATIVE] = negative
        
        if let negativeBoost = self.negativeBoost {
            dic[BoostingQuery.NEGATIVE_BOOST] = negativeBoost
        }
        return [self.name: dic]
    }
    
    
}


