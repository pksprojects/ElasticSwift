//
//  FullTextQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation

// MARK:- Match Query.

public class MatchQuery: Query {
    
    public let name: String = "match"
    
    var field: String
    var value: String
    var `operator`: MatchQueryOperator?
    var zeroTermQuery: ZeroTermQuery?
    var cutoffFrequency: Decimal?
    
    init(field: String, value: String) {
        self.field = field
        self.value = value
    }
    
    init(withBuilder builder: MatchQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.`operator` = builder.`operator`
        self.zeroTermQuery = builder.zeroTermQuery
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic["query"] = value
        if let `operator` = self.`operator` {
            dic["operator"] = `operator`.rawValue
        }
        if let zeroTermQuery = self.zeroTermQuery {
            dic["zero_terms_query"] = zeroTermQuery.rawValue
        }
        if let cutoffFrequency = self.cutoffFrequency {
            dic["cutoff_frequency"] = cutoffFrequency
        }
        return  [name : [field: dic]]
    }
    
}

// MARK:- MatchPhraseQuery

public class MatchPhraseQuery: Query {
    
    public let name: String = "match_phrase"
    
    var field: String
    var value: String
    var analyzer: String?
    
    public init(withBuilder builder: MatchPhraseQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.analyzer = builder.analyzer
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let analyzer = analyzer {
            dic[name] = [self.field: ["query": self.value,
                                      "analyzer": analyzer]
            ]
        } else {
            dic[name] = [self.field: self.value]
        }
        return dic
    }
    
}

// MARK:- MatchPhrasePrefixQuery

public class MatchPhrasePrefixQuery: Query {
    
    public let name: String = "match_phrase_prefix"
    
    var field: String
    var value: String
    var maxExpansions: Int?
    
    public init(withBuilder builder: MatchPhrasePrefixQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.maxExpansions = builder.maxExpansions
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let maxExpansions = maxExpansions {
            dic[name] = [self.field: ["query": self.value,
                                      "max_expansions": maxExpansions]
            ]
        } else {
            dic[name] = [self.field: self.value]
        }
        return dic
    }
    
}

// MARK:- MultiMatchQuery

public class MultiMatchQuery: Query {
    
    public let name: String = "multi_match"
    
    var tieBreakerKey = "tie_breaker"
    var typeKey = "type"
    var tieBreaker: Decimal?
    var type: MultiMatchQueryType?
    var query: String
    var fields: [String]
    
    public init(withBuilder builder: MultiMatchQueryBuilder) {
        self.query = builder.value!
        self.fields = builder.fields!
        self.tieBreaker = builder.tieBreaker
        self.type = builder.type
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic["query"] = query
        dic["fields"] = fields
        if let type = self.type {
            dic[typeKey] = type
        }
        if let tieBreaker = self.tieBreaker {
            dic[tieBreakerKey] = tieBreaker
        }
        return [name: dic]
    }
    
}

// MARK:- CommonTermsQuery

public class CommonTermsQuery: Query {
    
    public let name: String = "common"
    
    var value: String
    var cutoffFrequency: Decimal
    var lowFrequencyOperator: String?
    var highFrequencyOperator: String?
    var minimumShouldMatch: Int?
    var minimumShouldMatchLowFreq: Int?
    var minimumShouldMatchHighFreq: Int?
    
    public init(withBuilder builder: CommonTermsQueryBuilder) {
        self.value = builder.value!
        self.cutoffFrequency = builder.cutoffFrequency!
        self.lowFrequencyOperator = builder.lowFrequencyOperator
        self.highFrequencyOperator = builder.highFrequencyOperator
        self.minimumShouldMatch = builder.minimumShouldMatch
        self.minimumShouldMatchHighFreq = builder.minimumShouldMatchHighFreq
        self.minimumShouldMatchLowFreq = builder.minimumShouldMatchLowFreq
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic["query"] = value
        dic["cutoff_frequency"] = cutoffFrequency
        if let lowFrequencyOperator = self.lowFrequencyOperator {
            dic["low_freq_operator"] = lowFrequencyOperator
        }
        if let highFrequencyOperator = self.highFrequencyOperator {
            dic["high_freq_operator"] = highFrequencyOperator
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic["minimum_should_match"] = minimumShouldMatch
        }
        if let minHighFreq = self.minimumShouldMatchHighFreq, let minLowFreq = self.minimumShouldMatchLowFreq {
            dic["minimum_should_match"] = [
                "low_freq": minHighFreq,
                "high_freq": minLowFreq
            ]
        }
        return [name: ["body": dic]]
    }
    
}

// MARK:- QueryStringQuery

public class QueryStringQuery: Query {
    
    public let name: String = "query_string"
    var defaultField: String?
    var value: String
    var defaultOperator: String?
    var analyzer: String?
    var quoteAnalyzer: String?
    var allowLeadingWildcard: Bool?
    var enablePositionIncrements: Bool?
    var fuzzyMaxExpansions: Int?
    var fuzziness: String?
    var fuzzyPrefixLength: Int?
    var fuzzyTranspositions: Bool?
    var phraseSlop: Int?
    var boost: Decimal?
    var autoGeneratePhraseQueries: Bool?
    var analyzeWildcard: Bool?
    var maxDeterminizedStates: Int?
    var minimumShouldMatch: Int?
    var lenient: Bool?
    var timeZone: String?
    var quoteFieldSuffix: String?
    var autoGenerateSynonymsPhraseQuery: Bool?
    
    public init(withBuilder builder: QueryStringQueryBuilder) {
        self.defaultField = builder.defaultField
        self.value = builder.value!
        self.defaultOperator = builder.defaultOperator
        self.analyzer = builder.analyzer
        self.quoteAnalyzer = builder.quoteAnalyzer
        self.allowLeadingWildcard = builder.allowLeadingWildcard
        self.enablePositionIncrements = builder.enablePositionIncrements
        self.fuzzyMaxExpansions = builder.fuzzyMaxExpansions
        self.fuzziness = builder.fuzziness
        self.fuzzyPrefixLength = builder.fuzzyPrefixLength
        self.fuzzyTranspositions = builder.fuzzyTranspositions
        self.phraseSlop = builder.phraseSlop
        self.boost = builder.boost
        self.autoGeneratePhraseQueries = builder.autoGeneratePhraseQueries
        self.analyzeWildcard = builder.analyzeWildcard
        self.maxDeterminizedStates = builder.maxDeterminizedStates
        self.lenient = builder.lenient
        self.timeZone = builder.timeZone
        self.quoteFieldSuffix = builder.quoteFieldSuffix
        self.autoGenerateSynonymsPhraseQuery = builder.autoGenerateSynonymsPhraseQuery
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic["query"] = value
        if let defaultField = self.defaultField {
            dic["default_field"] = defaultField
        }
        if let defaultOperator = self.defaultOperator {
            dic["default_operator"] = defaultOperator
        }
        if let analyzer = self.analyzer {
            dic["analyzer"] = analyzer
        }
        if let quoteAnalyzer = self.quoteAnalyzer {
            dic["quote_analyzer"] = quoteAnalyzer
        }
        if let allowLeadingWildCard = self.allowLeadingWildcard {
            dic["allow_leading_wildcard"] = allowLeadingWildCard
        }
        if let enablePositionIncrements = self.enablePositionIncrements {
            dic["enable_position_increments"] = enablePositionIncrements
        }
        if let fuzzyMaxExpantions = self.fuzzyMaxExpansions {
            dic["fuzzy_max_expansions"] = fuzzyMaxExpantions
        }
        if let fuzzines = self.fuzziness {
            dic["fuzziness"] = fuzzines
        }
        if let fuzzyPrefixLength = self.fuzzyPrefixLength {
            dic["fuzzy_prefix_length"] = fuzzyPrefixLength
        }
        if let fuzzyTranspositions = self.fuzzyTranspositions {
            dic["fuzzy_transpositions"] = fuzzyTranspositions
        }
        if let phraseSlop = self.phraseSlop {
            dic["phrase_slop"] = phraseSlop
        }
        if let boost = self.boost {
            dic["boost"] = boost
        }
        if let autoGeneratePhraseQuries = self.autoGeneratePhraseQueries {
            dic["auto_generate_phrase_queries"] = autoGeneratePhraseQuries
        }
        if let analyzeWildCard = self.analyzeWildcard {
            dic["analyze_wildcard"] = analyzeWildCard
        }
        if let maxDeterminedStates = self.maxDeterminizedStates {
            dic["max_determinized_states"] = maxDeterminedStates
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic["minimum_should_match"] = minimumShouldMatch
        }
        if let lenient = self.lenient {
            dic["lenient"] = lenient
        }
        if let timeZone = self.timeZone {
            dic["time_zone"] = timeZone
        }
        if let quoteFieldSuffix = self.quoteFieldSuffix {
            dic["quote_field_suffix"] = quoteFieldSuffix
        }
        if let autoGenerateSynonymsPhraseQuery = self.autoGenerateSynonymsPhraseQuery {
            dic["auto_generate_synonyms_phrase_query"] = autoGenerateSynonymsPhraseQuery
        }
        return [name: dic]
    }
    
}

// MARK:- SimpleQueryStringQuery

public class SimpleQueryStringQuery: Query {
    
    public let name: String = "simple_query_string"
    
    var value: String
    var fields: [String]?
    var defaultOperator: String?
    var analyzer: String?
    var flags: String?
    var lenient: Bool?
    var minimumShouldMatch: Int?
    var fuzzyMaxExpansions: Int?
    var fuzzyPrefixLength: Int?
    var fuzzyTranspositions: Bool?
    var quoteFieldSuffix: String?
    var autoGenerateSynonymsPhraseQuery: Bool?
    
    public init(withBuilder builder: SimpleQueryStringQueryBuilder) {
        self.value = builder.value!
        self.fields = builder.fields
        self.defaultOperator = builder.defaultOperator
        self.analyzer = builder.analyzer
        self.flags = builder.flags
        self.fuzzyMaxExpansions = builder.fuzzyMaxExpansions
        self.fuzzyPrefixLength = builder.fuzzyPrefixLength
        self.fuzzyTranspositions = builder.fuzzyTranspositions
        self.lenient = builder.lenient
        self.quoteFieldSuffix = builder.quoteFieldSuffix
        self.minimumShouldMatch = builder.minimumShouldMatch
        self.autoGenerateSynonymsPhraseQuery = builder.autoGenerateSynonymsPhraseQuery
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic["query"] = value
        if let fields = self.fields {
            dic["fields"] = fields
        }
        if let defaultOperator = self.defaultOperator {
            dic["default_operator"] = defaultOperator
        }
        if let analyzer = self.analyzer {
            dic["analyzer"] = analyzer
        }
        if let fuzzyMaxExpantions = self.fuzzyMaxExpansions {
            dic["fuzzy_max_expansions"] = fuzzyMaxExpantions
        }
        if let fuzzyPrefixLength = self.fuzzyPrefixLength {
            dic["fuzzy_prefix_length"] = fuzzyPrefixLength
        }
        if let fuzzyTranspositions = self.fuzzyTranspositions {
            dic["fuzzy_transpositions"] = fuzzyTranspositions
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic["minimum_should_match"] = minimumShouldMatch
        }
        if let lenient = self.lenient {
            dic["lenient"] = lenient
        }
        if let quoteFieldSuffix = self.quoteFieldSuffix {
            dic["quote_field_suffix"] = quoteFieldSuffix
        }
        if let autoGenerateSynonymsPhraseQuery = self.autoGenerateSynonymsPhraseQuery {
            dic["auto_generate_synonyms_phrase_query"] = autoGenerateSynonymsPhraseQuery
        }
        return [name: dic]
    }
}


public enum MultiMatchQueryType: String {
    case bestFields = "best_fields"
    case mostFields = "most_fields"
    case crossFields = "cross_fields"
    case phrase = "phrase"
    case phrasePrefix = "phrase_prefix"
}

public enum MatchQueryOperator: String {
    case and = "and"
    case or = "or"
}

public enum ZeroTermQuery: String {
    case none = "none"
    case all = "all"
}
