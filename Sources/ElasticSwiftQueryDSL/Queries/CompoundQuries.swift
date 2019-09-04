//
//  CompoundQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore
import ElasticSwiftCodableUtils

// MARK:- Constant Score Query

public class ConstantScoreQuery: Query {
    
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
        return [self.name: [CodingKeys.filter.rawValue: self.query.toDic(), CodingKeys.boost.rawValue: self.boost]]
    }
    
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
//        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
//        self.boost = try nested.decode(Decimal.self, forKey: .boost)
//        self.query = try nested.decode(MatchAllQuery.self, forKey: .filter)
//    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
        try nested.encode(self.query, forKey: .filter)
        try nested.encode(self.boost, forKey: .boost)
    }
    
    enum CodingKeys: String, CodingKey {
        case boost
        case filter
    }
    
}

extension ConstantScoreQuery: Equatable {
    public static func == (lhs: ConstantScoreQuery, rhs: ConstantScoreQuery) -> Bool {
        return lhs.name == rhs.name
            && lhs.query.isEqualTo(rhs.query)
            && lhs.boost == rhs.boost
    }
}

// MARK:- Bool Query

public class BoolQuery: Query {
    
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
            dic[CodingKeys.must.rawValue] = self.mustClauses.map { $0.toDic() }
        }
        if !self.mustNotClauses.isEmpty {
            dic[CodingKeys.mustNot.rawValue] = self.mustNotClauses.map { $0.toDic() }
        }
        if !self.shouldClauses.isEmpty {
            dic[CodingKeys.should.rawValue] = self.shouldClauses.map { $0.toDic() }
        }
        if !self.filterClauses.isEmpty {
            dic[CodingKeys.filter.rawValue] = self.filterClauses.map { $0.toDic() }
        }
        if let boost = self.boost {
            dic[CodingKeys.boost.rawValue] = boost
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[CodingKeys.minShouldMatch.rawValue] = minimumShouldMatch
        }
        return [self.name: dic]
    }
    
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
//        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
//        self.boost = try nested.decodeIfPresent(Decimal.self, forKey: .boost)
//        //self.filterClauses = nested.decodeIfPresent([Query].self, forKey: .filter) ?? []
//    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        if !self.filterClauses.isEmpty {
            try nested.encode(self.filterClauses, forKey: .filter)
        }
        if !self.mustClauses.isEmpty {
            try nested.encode(self.mustClauses, forKey: .must)
        }
        if !self.mustNotClauses.isEmpty {
            try nested.encode(self.mustNotClauses, forKey: .mustNot)
        }
        if !self.shouldClauses.isEmpty {
            try nested.encode(self.shouldClauses, forKey: .should)
        }
        try nested.encodeIfPresent(self.boost, forKey: .boost)
        try nested.encodeIfPresent(self.minimumShouldMatch, forKey: .minShouldMatch)
    }
    
    enum CodingKeys: String, CodingKey {
        case must
        case mustNot = "must_not"
        case should
        case filter
        case minShouldMatch = "minimum_should_match"
        case boost
    }
}

extension BoolQuery: Equatable {
    public static func == (lhs: BoolQuery, rhs: BoolQuery) -> Bool {
        return lhs.name == rhs.name
            && lhs.minimumShouldMatch == rhs.minimumShouldMatch
            && lhs.boost == rhs.boost
            && lhs.filterClauses.count == rhs.filterClauses.count
            && !zip(lhs.filterClauses, rhs.filterClauses).contains { !$0.isEqualTo($1) }
            && lhs.mustClauses.count == rhs.mustClauses.count
            && !zip(lhs.mustClauses, rhs.mustClauses).contains { !$0.isEqualTo($1) }
            && lhs.mustNotClauses.count == rhs.mustNotClauses.count
            && !zip(lhs.mustNotClauses, rhs.mustNotClauses).contains { !$0.isEqualTo($1) }
            && lhs.shouldClauses.count == rhs.shouldClauses.count
            && !zip(lhs.shouldClauses, rhs.shouldClauses).contains { !$0.isEqualTo($1) }
    }
}

// MARK:- Dis Max Query

public class DisMaxQuery: Query {
    
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
        dic[CodingKeys.tieBreaker.rawValue] = self.tieBreaker
        if let boost = self.boost {
            dic[CodingKeys.boost.rawValue] = boost
        }
        dic[CodingKeys.queries.rawValue] = self.queries.map { $0.toDic() }
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        
        try nested.encode(self.queries, forKey: .queries)
        try nested.encode(self.tieBreaker, forKey: .tieBreaker)
        try nested.encodeIfPresent(self.boost, forKey: .boost)
    }
    
    enum CodingKeys: String, CodingKey {
        case queries
        case boost
        case tieBreaker = "tie_breaker"
    }
}

extension DisMaxQuery: Equatable {
    public static func == (lhs: DisMaxQuery, rhs: DisMaxQuery) -> Bool {
        return lhs.name == rhs.name
            && lhs.tieBreaker == rhs.tieBreaker
            && lhs.boost == rhs.boost
            && lhs.queries.count == rhs.queries.count
            && !zip(lhs.queries, rhs.queries).contains { !$0.isEqualTo($1) }
    }
}

// MARK:- Function Score Query

public class FunctionScoreQuery: Query {
    
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
        
        guard !builder.functions.isEmpty else {
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
        
        dic[CodingKeys.query.rawValue] = query.toDic()
        if let boost = self.boost {
            dic[CodingKeys.boost.rawValue] = boost
        }
        if let boostMode = self.boostMode {
            dic[CodingKeys.boostMode.rawValue] = boostMode
        }
        if let maxBoost = self.maxBoost {
            dic[CodingKeys.maxBoost.rawValue] = maxBoost
        }
        if let scoreMode = self.scoreMode {
            dic[CodingKeys.scoreMode.rawValue] = scoreMode
        }
        if let minScore = self.minScore {
            dic[CodingKeys.minScore.rawValue] = minScore
        }
        if !functions.isEmpty {
            if functions.count == 1 {
                let scoreFunction = functions[0]
                dic[scoreFunction.name] = scoreFunction.toDic()[scoreFunction.name]
            } else {
                dic[CodingKeys.functions.rawValue] = functions.map { $0.toDic() }
            }
        }
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        try nested.encode(self.query, forKey: .query)
        try nested.encodeIfPresent(self.scoreMode, forKey: .scoreMode)
        try nested.encodeIfPresent(self.boostMode, forKey: .boostMode)
        try nested.encodeIfPresent(self.boost, forKey: .boost)
        try nested.encodeIfPresent(self.maxBoost, forKey: .maxBoost)
        try nested.encodeIfPresent(self.minScore, forKey: .minScore)
        if !functions.isEmpty {
            try nested.encode(self.functions, forKey: .functions)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case query
        case boost
        case boostMode = "boost_mode"
        case maxBoost = "max_boost"
        case scoreMode = "score_mode"
        case minScore = "min_score"
        case functions
    }
}

extension FunctionScoreQuery: Equatable {
    
    public static func == (lhs: FunctionScoreQuery, rhs: FunctionScoreQuery) -> Bool {
        return lhs.name == rhs.name
            && lhs.boost == rhs.boost
            && lhs.boostMode == rhs.boostMode
            && lhs.maxBoost == rhs.maxBoost
            && lhs.minScore == rhs.minScore
            && lhs.query.isEqualTo(rhs.query)
            && lhs.scoreMode == rhs.scoreMode
            && lhs.functions.count == rhs.functions.count
            && !zip(lhs.functions, rhs.functions).contains { !$0.isEqualTo($1) }
    }
}

// MARK:- Boosting Query

public class BoostingQuery: Query {
    
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
       
        dic[CodingKeys.positive.rawValue] = positive
        dic[CodingKeys.negative.rawValue] = negative
        
        if let negativeBoost = self.negativeBoost {
            dic[CodingKeys.negativeBoost.rawValue] = negativeBoost
        }
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        
        try nested.encode(self.positive, forKey: .positive)
        try nested.encode(self.negative, forKey: .negative)
        try nested.encodeIfPresent(self.negativeBoost, forKey: .negativeBoost)
    }
    
    enum CodingKeys: String, CodingKey {
        case positive
        case negative
        case negativeBoost = "negative_boost"
    }
    
}

extension BoostingQuery: Equatable {
    
    public static func == (lhs: BoostingQuery, rhs: BoostingQuery) -> Bool {
        return lhs.name == rhs.name
            && lhs.negative.isEqualTo(rhs.negative)
            && lhs.positive.isEqualTo(rhs.positive)
            && lhs.negativeBoost == rhs.negativeBoost
    }
}

