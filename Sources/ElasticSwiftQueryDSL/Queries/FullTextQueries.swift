//
//  FullTextQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Match Query.

public class MatchQuery: Query {
    
    private static let QUERY = "query"
    private static let OPERATOR = "operator"
    private static let FUZZINESS = "fuzziness"
    private static let ZERO_TERMS_QUERY = "zero_terms_query"
    private static let CUTOFF_FREQUENCY = "cutoff_frequency"
    private static let AUTO_GENERATE_SYNONYMS_PHRASE_QUERY = "auto_generate_synonyms_phrase_query"
    
    public let name: String = "match"
    
    public let field: String
    public let value: String
    public let `operator`: MatchQueryOperator?
    public let zeroTermQuery: ZeroTermQuery?
    public let cutoffFrequency: Decimal?
    public let fuzziness: String?
    public let autoGenSynonymnsPhraseQuery: Bool?
    
    init(withBuilder builder: MatchQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.`operator` = builder.`operator`
        self.zeroTermQuery = builder.zeroTermQuery
        self.fuzziness = builder.fuzziness
        self.cutoffFrequency = builder.cutoffFrequency
        self.autoGenSynonymnsPhraseQuery = builder.autoGenSynonymnsPhraseQuery
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic[MatchQuery.QUERY] = value
        if let `operator` = self.`operator` {
            dic[MatchQuery.OPERATOR] = `operator`.rawValue
        }
        if let zeroTermQuery = self.zeroTermQuery {
            dic[MatchQuery.ZERO_TERMS_QUERY] = zeroTermQuery.rawValue
        }
        if let cutoffFrequency = self.cutoffFrequency {
            dic[MatchQuery.CUTOFF_FREQUENCY] = cutoffFrequency
        }
        if let fuzziness = self.fuzziness {
            dic[MatchQuery.FUZZINESS] = fuzziness
        }
        if let autoGenSynonymnsPhraseQuery = self.autoGenSynonymnsPhraseQuery {
            dic[MatchQuery.AUTO_GENERATE_SYNONYMS_PHRASE_QUERY] = autoGenSynonymnsPhraseQuery
        }
        return  [name : [field: dic]]
    }
    
}

// MARK:- MatchPhraseQuery

public class MatchPhraseQuery: Query {
    
    private static let QUERY = "query"
    private static let ANALYZER = "analyzer"
    
    public let name: String = "match_phrase"
    
    public let field: String
    public let value: String
    public let analyzer: String?
    
    public init(withBuilder builder: MatchPhraseQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.analyzer = builder.analyzer
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let analyzer = analyzer {
            dic[name] = [self.field: [MatchPhraseQuery.QUERY: self.value,
                                      MatchPhraseQuery.ANALYZER: analyzer]
            ]
        } else {
            dic[name] = [self.field: self.value]
        }
        return dic
    }
    
}

// MARK:- MatchPhrasePrefixQuery

public class MatchPhrasePrefixQuery: Query {
    
    private static let QUERY = "query"
    private static let MAX_EXPANSIONS = "max_expansions"
    
    public let name: String = "match_phrase_prefix"
    
    public let field: String
    public let value: String
    public let maxExpansions: Int?
    
    public init(withBuilder builder: MatchPhrasePrefixQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.maxExpansions = builder.maxExpansions
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let maxExpansions = maxExpansions {
            dic[name] = [self.field: [MatchPhrasePrefixQuery.QUERY: self.value,
                                      MatchPhrasePrefixQuery.MAX_EXPANSIONS: maxExpansions]
            ]
        } else {
            dic[name] = [self.field: self.value]
        }
        return dic
    }
    
}

// MARK:- MultiMatchQuery

public class MultiMatchQuery: Query {
    
    private static let QUERY = "query"
    private static let FIELDS = "fields"
    private static let TIE_BREAKER = "tie_breaker"
    private static let TYPE = "type"
    
    public let name: String = "multi_match"
    
    public let tieBreaker: Decimal?
    public let type: MultiMatchQueryType?
    public let query: String
    public let fields: [String]
    
    public init(withBuilder builder: MultiMatchQueryBuilder) {
        self.query = builder.value!
        self.fields = builder.fields!
        self.tieBreaker = builder.tieBreaker
        self.type = builder.type
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic[MultiMatchQuery.QUERY] = query
        dic[MultiMatchQuery.FIELDS] = fields
        if let type = self.type {
            dic[MultiMatchQuery.TYPE] = type
        }
        if let tieBreaker = self.tieBreaker {
            dic[MultiMatchQuery.TIE_BREAKER] = tieBreaker
        }
        return [name: dic]
    }
    
}

// MARK:- CommonTermsQuery

public class CommonTermsQuery: Query {
    
    private static let QUERY = "query"
    private static let CUTOFF_FREQUENCY = "cutoff_frequency"
    private static let LOW_FREQ_OPERATOR = "low_freq_operator"
    private static let HIGH_FREQ_OPERATOR = "high_freq_operator"
    private static let MINIMUM_SHOULD_MATCH = "minimum_should_match"
    private static let LOW_FREQ = "low_freq"
    private static let HIGH_FREQ = "high_freq"
    private static let BODY = "body"
    
    public let name: String = "common"
    
    public let value: String
    public let cutoffFrequency: Decimal
    public let lowFrequencyOperator: String?
    public let highFrequencyOperator: String?
    public let minimumShouldMatch: Int?
    public let minimumShouldMatchLowFreq: Int?
    public let minimumShouldMatchHighFreq: Int?
    
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
        dic[CommonTermsQuery.QUERY] = value
        dic[CommonTermsQuery.CUTOFF_FREQUENCY] = cutoffFrequency
        if let lowFrequencyOperator = self.lowFrequencyOperator {
            dic[CommonTermsQuery.LOW_FREQ_OPERATOR] = lowFrequencyOperator
        }
        if let highFrequencyOperator = self.highFrequencyOperator {
            dic[CommonTermsQuery.HIGH_FREQ_OPERATOR] = highFrequencyOperator
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[CommonTermsQuery.MINIMUM_SHOULD_MATCH] = minimumShouldMatch
        }
        if let minHighFreq = self.minimumShouldMatchHighFreq, let minLowFreq = self.minimumShouldMatchLowFreq {
            dic[CommonTermsQuery.MINIMUM_SHOULD_MATCH] = [
                CommonTermsQuery.LOW_FREQ: minHighFreq,
                CommonTermsQuery.HIGH_FREQ: minLowFreq
            ]
        }
        return [name: [CommonTermsQuery.BODY: dic]]
    }
    
}

// MARK:- QueryStringQuery

public class QueryStringQuery: Query {
    
    private static let QUERY = "query"
    private static let DEFAULT_FIELD = "default_field"
    private static let DEFAULT_OPERATOR = "default_operator"
    private static let ANALYZER = "analyzer"
    private static let QUOTE_ANALYZER = "quote_analyzer"
    private static let ALLOW_LEADING_WILDCARD = "allow_leading_wildcard"
    private static let ENABLE_POSITION_INCREMENTS = "enable_position_increments"
    private static let FUZZY_MAX_EXPANSIONS = "fuzzy_max_expansions"
    private static let FUZZINESS = "fuzziness"
    private static let FUZZY_PREFIX_LENGTH = "fuzzy_prefix_length"
    private static let FUZZY_TRANSPOSITIONS = "fuzzy_transpositions"
    private static let PHRASE_SLOP = "phrase_slop"
    private static let BOOST = "boost"
    private static let AUTO_GENERATE_PHRASE_QUERIES = "auto_generate_phrase_queries"
    private static let ANALYZE_WILDCARD = "analyze_wildcard"
    private static let MAX_DETERMINIZED_STATES = "max_determinized_states"
    private static let MIN_SHOULD_MATCH = "minimum_should_match"
    private static let LENIENT = "lenient"
    private static let TIME_ZONE = "time_zone"
    private static let QUOTE_FIELD_SUFFIX = "quote_field_suffix"
    private static let AUTO_GENERATE_SYNONYMS_PHRASE_QUERY = "auto_generate_synonyms_phrase_query"
    
    public let name: String = "query_string"
    public let defaultField: String?
    public let value: String
    public let defaultOperator: String?
    public let analyzer: String?
    public let quoteAnalyzer: String?
    public let allowLeadingWildcard: Bool?
    public let enablePositionIncrements: Bool?
    public let fuzzyMaxExpansions: Int?
    public let fuzziness: String?
    public let fuzzyPrefixLength: Int?
    public let fuzzyTranspositions: Bool?
    public let phraseSlop: Int?
    public let boost: Decimal?
    public let autoGeneratePhraseQueries: Bool?
    public let analyzeWildcard: Bool?
    public let maxDeterminizedStates: Int?
    public let minimumShouldMatch: Int?
    public let lenient: Bool?
    public let timeZone: String?
    public let quoteFieldSuffix: String?
    public let autoGenerateSynonymsPhraseQuery: Bool?
    
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
        self.minimumShouldMatch = builder.minimumShouldMatch
        self.lenient = builder.lenient
        self.timeZone = builder.timeZone
        self.quoteFieldSuffix = builder.quoteFieldSuffix
        self.autoGenerateSynonymsPhraseQuery = builder.autoGenerateSynonymsPhraseQuery
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        dic[QueryStringQuery.QUERY] = value
        if let defaultField = self.defaultField {
            dic[QueryStringQuery.DEFAULT_FIELD] = defaultField
        }
        if let defaultOperator = self.defaultOperator {
            dic[QueryStringQuery.DEFAULT_OPERATOR] = defaultOperator
        }
        if let analyzer = self.analyzer {
            dic[QueryStringQuery.ANALYZER] = analyzer
        }
        if let quoteAnalyzer = self.quoteAnalyzer {
            dic[QueryStringQuery.QUOTE_ANALYZER] = quoteAnalyzer
        }
        if let allowLeadingWildCard = self.allowLeadingWildcard {
            dic[QueryStringQuery.ALLOW_LEADING_WILDCARD] = allowLeadingWildCard
        }
        if let enablePositionIncrements = self.enablePositionIncrements {
            dic[QueryStringQuery.ENABLE_POSITION_INCREMENTS] = enablePositionIncrements
        }
        if let fuzzyMaxExpantions = self.fuzzyMaxExpansions {
            dic[QueryStringQuery.FUZZY_MAX_EXPANSIONS] = fuzzyMaxExpantions
        }
        if let fuzzines = self.fuzziness {
            dic[QueryStringQuery.FUZZINESS] = fuzzines
        }
        if let fuzzyPrefixLength = self.fuzzyPrefixLength {
            dic[QueryStringQuery.FUZZY_PREFIX_LENGTH] = fuzzyPrefixLength
        }
        if let fuzzyTranspositions = self.fuzzyTranspositions {
            dic[QueryStringQuery.FUZZY_TRANSPOSITIONS] = fuzzyTranspositions
        }
        if let phraseSlop = self.phraseSlop {
            dic[QueryStringQuery.PHRASE_SLOP] = phraseSlop
        }
        if let boost = self.boost {
            dic[QueryStringQuery.BOOST] = boost
        }
        if let autoGeneratePhraseQuries = self.autoGeneratePhraseQueries {
            dic[QueryStringQuery.AUTO_GENERATE_PHRASE_QUERIES] = autoGeneratePhraseQuries
        }
        if let analyzeWildCard = self.analyzeWildcard {
            dic[QueryStringQuery.ANALYZE_WILDCARD] = analyzeWildCard
        }
        if let maxDeterminedStates = self.maxDeterminizedStates {
            dic[QueryStringQuery.MAX_DETERMINIZED_STATES] = maxDeterminedStates
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[QueryStringQuery.MIN_SHOULD_MATCH] = minimumShouldMatch
        }
        if let lenient = self.lenient {
            dic[QueryStringQuery.LENIENT] = lenient
        }
        if let timeZone = self.timeZone {
            dic[QueryStringQuery.TIME_ZONE] = timeZone
        }
        if let quoteFieldSuffix = self.quoteFieldSuffix {
            dic[QueryStringQuery.QUOTE_FIELD_SUFFIX] = quoteFieldSuffix
        }
        if let autoGenerateSynonymsPhraseQuery = self.autoGenerateSynonymsPhraseQuery {
            dic[QueryStringQuery.AUTO_GENERATE_SYNONYMS_PHRASE_QUERY] = autoGenerateSynonymsPhraseQuery
        }
        return [name: dic]
    }
    
}

// MARK:- SimpleQueryStringQuery

public class SimpleQueryStringQuery: Query {
    
    private static let QUERY = "query"
    private static let FIELDS = "fields"
    private static let DEFAULT_OPERATOR = "default_operator"
    private static let ANALYZER = "analyzer"
    private static let FLAGS = "flags"
    private static let FUZZY_MAX_EXPANSIONS = "fuzzy_max_expansions"
    private static let FUZZY_PREFIX_LENGTH = "fuzzy_prefix_length"
    private static let FUZZY_TRANSPOSITIONS = "fuzzy_transpositions"
    private static let MINIMUM_SHOULD_MATCH = "minimum_should_match"
    private static let LENIENT = "lenient"
    private static let QUOTE_FIELD_SUFFIX = "quote_field_suffix"
    private static let AUTO_GENERATE_SYNONYMS_PHRASE_QUERY = "auto_generate_synonyms_phrase_query"
    
    public let name: String = "simple_query_string"
    
    public let value: String
    public let fields: [String]?
    public let defaultOperator: String?
    public let analyzer: String?
    public let flags: String?
    public let lenient: Bool?
    public let minimumShouldMatch: Int?
    public let fuzzyMaxExpansions: Int?
    public let fuzzyPrefixLength: Int?
    public let fuzzyTranspositions: Bool?
    public let quoteFieldSuffix: String?
    public let autoGenerateSynonymsPhraseQuery: Bool?
    
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
        dic[SimpleQueryStringQuery.QUERY] = value
        if let fields = self.fields {
            dic[SimpleQueryStringQuery.FIELDS] = fields
        }
        if let defaultOperator = self.defaultOperator {
            dic[SimpleQueryStringQuery.DEFAULT_OPERATOR] = defaultOperator
        }
        if let analyzer = self.analyzer {
            dic[SimpleQueryStringQuery.ANALYZER] = analyzer
        }
        if let fuzzyMaxExpantions = self.fuzzyMaxExpansions {
            dic[SimpleQueryStringQuery.FUZZY_MAX_EXPANSIONS] = fuzzyMaxExpantions
        }
        if let fuzzyPrefixLength = self.fuzzyPrefixLength {
            dic[SimpleQueryStringQuery.FUZZY_PREFIX_LENGTH] = fuzzyPrefixLength
        }
        if let fuzzyTranspositions = self.fuzzyTranspositions {
            dic[SimpleQueryStringQuery.FUZZY_TRANSPOSITIONS] = fuzzyTranspositions
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[SimpleQueryStringQuery.MINIMUM_SHOULD_MATCH] = minimumShouldMatch
        }
        if let flags = self.flags {
            dic[SimpleQueryStringQuery.FLAGS] = flags
        }
        if let lenient = self.lenient {
            dic[SimpleQueryStringQuery.LENIENT] = lenient
        }
        if let quoteFieldSuffix = self.quoteFieldSuffix {
            dic[SimpleQueryStringQuery.QUOTE_FIELD_SUFFIX] = quoteFieldSuffix
        }
        if let autoGenerateSynonymsPhraseQuery = self.autoGenerateSynonymsPhraseQuery {
            dic[SimpleQueryStringQuery.AUTO_GENERATE_SYNONYMS_PHRASE_QUERY] = autoGenerateSynonymsPhraseQuery
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
