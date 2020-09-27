//
//  FullTextSearch.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Builder for Match query.

public class MatchQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _name: String?
    private var _operator: Operator?
    private var _zeroTermQuery: ZeroTermQuery?
    private var _cutoffFrequency: Decimal?
    private var _fuzziness: Fuzziness?
    private var _autoGenSynonymnsPhraseQuery: Bool?

    public init() {}

    @discardableResult
    public func set(field: String) -> MatchQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> MatchQueryBuilder {
        _value = value
        return self
    }

    @discardableResult
    public func set(cutoffFrequency: Decimal) -> MatchQueryBuilder {
        _cutoffFrequency = cutoffFrequency
        return self
    }

    @discardableResult
    public func set(operator: Operator) -> MatchQueryBuilder {
        _operator = `operator`
        return self
    }

    @discardableResult
    public func set(zeroTermQuery: ZeroTermQuery) -> MatchQueryBuilder {
        _zeroTermQuery = zeroTermQuery
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> MatchQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> MatchQueryBuilder {
        _name = name
        return self
    }

    @discardableResult
    public func set(fuzziness: Fuzziness) -> MatchQueryBuilder {
        _fuzziness = fuzziness
        return self
    }

    @discardableResult
    public func set(autoGenSynonymnsPhraseQuery: Bool) -> Self {
        _autoGenSynonymnsPhraseQuery = autoGenSynonymnsPhraseQuery
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public var `operator`: Operator? {
        return _operator
    }

    public var zeroTermQuery: ZeroTermQuery? {
        return _zeroTermQuery
    }

    public var cutoffFrequency: Decimal? {
        return _cutoffFrequency
    }

    public var fuzziness: Fuzziness? {
        return _fuzziness
    }

    public var autoGenSynonymnsPhraseQuery: Bool? {
        return _autoGenSynonymnsPhraseQuery
    }

    public func build() throws -> MatchQuery {
        return try MatchQuery(withBuilder: self)
    }
}

// MARK: - Builder for Match Phrase query.

public class MatchPhraseQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _analyzer: String?
    private var _name: String?
    private var _boost: Decimal?

    public init() {}

    @discardableResult
    public func set(field: String) -> MatchPhraseQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> MatchPhraseQueryBuilder {
        _value = value
        return self
    }

    @discardableResult
    public func set(analyzer: String) -> MatchPhraseQueryBuilder {
        _analyzer = analyzer
        return self
    }

    @discardableResult
    public func set(name: String) -> MatchPhraseQueryBuilder {
        _name = name
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> MatchPhraseQueryBuilder {
        _boost = boost
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var analyzer: String? {
        return _analyzer
    }

    public var name: String? {
        return _name
    }

    public var boost: Decimal? {
        return _boost
    }

    public func build() throws -> MatchPhraseQuery {
        return try MatchPhraseQuery(withBuilder: self)
    }
}

// MARK: - Builder for Match Phrase query.

public class MatchPhrasePrefixQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _maxExpansions: Int?
    private var _name: String?
    private var _boost: Decimal?

    public init() {}

    @discardableResult
    public func set(field: String) -> Self {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> Self {
        _value = value
        return self
    }

    @discardableResult
    public func set(maxExpansions: Int) -> Self {
        _maxExpansions = maxExpansions
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var maxExpansions: Int? {
        return _maxExpansions
    }

    public var name: String? {
        return _name
    }

    public var boost: Decimal? {
        return _boost
    }

    public func build() throws -> MatchPhrasePrefixQuery {
        return try MatchPhrasePrefixQuery(withBuilder: self)
    }
}

// MARK: - Builder for MultiMatch query.

public class MultiMatchQueryBuilder: QueryBuilder {
    private var _query: String?
    private var _fields: [String] = []
    private var _type: MultiMatchQueryType?
    private var _tieBreaker: Decimal?
    private var _name: String?
    private var _boost: Decimal?

    init() {}

    @discardableResult
    public func set(query: String) -> MultiMatchQueryBuilder {
        _query = query
        return self
    }

    @discardableResult
    public func set(fields: String...) -> MultiMatchQueryBuilder {
        _fields = fields
        return self
    }

    @discardableResult
    public func add(field: String) -> MultiMatchQueryBuilder {
        _fields.append(field)
        return self
    }

    @discardableResult
    public func set(type: MultiMatchQueryType) -> MultiMatchQueryBuilder {
        _type = type
        return self
    }

    @discardableResult
    public func set(tieBreaker: Decimal) -> MultiMatchQueryBuilder {
        _tieBreaker = tieBreaker
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    public var query: String? {
        return _query
    }

    public var fields: [String] {
        return _fields
    }

    public var type: MultiMatchQueryType? {
        return _type
    }

    public var tieBreaker: Decimal? {
        return _tieBreaker
    }

    public var name: String? {
        return _name
    }

    public var boost: Decimal? {
        return _boost
    }

    @discardableResult
    public func build() throws -> MultiMatchQuery {
        return try MultiMatchQuery(withBuilder: self)
    }
}

// MARK: - Builder for Common Terms query.

public class CommonTermsQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _query: String?
    private var _cutoffFrequency: Decimal?
    private var _lowFrequencyOperator: Operator?
    private var _highFrequencyOperator: Operator?
    private var _minimumShouldMatch: Int?
    private var _minimumShouldMatchLowFreq: Int?
    private var _minimumShouldMatchHighFreq: Int?
    private var _name: String?
    private var _boost: Decimal?

    init() {}

    @discardableResult
    public func set(field: String) -> CommonTermsQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(query: String) -> CommonTermsQueryBuilder {
        _query = query
        return self
    }

    @discardableResult
    public func set(cutoffFrequency: Decimal) -> CommonTermsQueryBuilder {
        _cutoffFrequency = cutoffFrequency
        return self
    }

    @discardableResult
    public func set(lowFrequencyOperator: Operator) -> CommonTermsQueryBuilder {
        _lowFrequencyOperator = lowFrequencyOperator
        return self
    }

    @discardableResult
    public func set(highFrequencyOperator: Operator) -> CommonTermsQueryBuilder {
        _highFrequencyOperator = highFrequencyOperator
        return self
    }

    @discardableResult
    public func set(minimumShouldMatch: Int) -> CommonTermsQueryBuilder {
        _minimumShouldMatch = minimumShouldMatch
        return self
    }

    @discardableResult
    public func set(minimumShouldMatchLowFreq: Int) -> CommonTermsQueryBuilder {
        _minimumShouldMatchLowFreq = minimumShouldMatchLowFreq
        return self
    }

    @discardableResult
    public func set(minimumShouldMatchHighFreq: Int) -> CommonTermsQueryBuilder {
        _minimumShouldMatchHighFreq = minimumShouldMatchHighFreq
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> CommonTermsQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> CommonTermsQueryBuilder {
        _name = name
        return self
    }

    public var field: String? {
        return _field
    }

    public var query: String? {
        return _query
    }

    public var cutoffFrequency: Decimal? {
        return _cutoffFrequency
    }

    public var lowFrequencyOperator: Operator? {
        return _lowFrequencyOperator
    }

    public var highFrequencyOperator: Operator? {
        return _highFrequencyOperator
    }

    public var minimumShouldMatch: Int? {
        return _minimumShouldMatch
    }

    public var minimumShouldMatchLowFreq: Int? {
        return _minimumShouldMatchLowFreq
    }

    public var minimumShouldMatchHighFreq: Int? {
        return _minimumShouldMatchHighFreq
    }

    public var name: String? {
        return _name
    }

    public var boost: Decimal? {
        return _boost
    }

    public func build() throws -> CommonTermsQuery {
        return try CommonTermsQuery(withBuilder: self)
    }
}

// MARK: - Builder for QueryString query.

public class QueryStringQueryBuilder: QueryBuilder {
    private var _defaultField: String?
    private var _query: String?
    private var _fields: [String]?
    private var _type: MultiMatchQueryType?
    private var _tieBreaker: Decimal?
    private var _defaultOperator: String?
    private var _analyzer: String?
    private var _quoteAnalyzer: String?
    private var _allowLeadingWildcard: Bool?
    private var _enablePositionIncrements: Bool?
    private var _fuzzyMaxExpansions: Int?
    private var _fuzziness: String?
    private var _fuzzyPrefixLength: Int?
    private var _fuzzyTranspositions: Bool?
    private var _phraseSlop: Int?
    private var _boost: Decimal?
    private var _autoGeneratePhraseQueries: Bool?
    private var _analyzeWildcard: Bool?
    private var _maxDeterminizedStates: Int?
    private var _minimumShouldMatch: Int?
    private var _lenient: Bool?
    private var _timeZone: String?
    private var _quoteFieldSuffix: String?
    private var _autoGenerateSynonymsPhraseQuery: Bool?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(allowLeadingWildcard: Bool) -> Self {
        _allowLeadingWildcard = allowLeadingWildcard
        return self
    }

    @discardableResult
    public func set(query: String) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(fields: [String]) -> Self {
        _fields = fields
        return self
    }

    @discardableResult
    public func set(type: MultiMatchQueryType) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(tieBreaker: Decimal) -> Self {
        _tieBreaker = tieBreaker
        return self
    }

    @discardableResult
    public func set(fuzziness: String) -> Self {
        _fuzziness = fuzziness
        return self
    }

    @discardableResult
    public func set(phraseSlop: Int) -> Self {
        _phraseSlop = phraseSlop
        return self
    }

    @discardableResult
    public func set(enablePositionIncrements: Bool) -> Self {
        _enablePositionIncrements = enablePositionIncrements
        return self
    }

    @discardableResult
    public func set(quoteAnalyzer: String) -> Self {
        _quoteAnalyzer = quoteAnalyzer
        return self
    }

    @discardableResult
    public func set(autoGenerateSynonymsPhraseQuery: Bool) -> Self {
        _autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        return self
    }

    @discardableResult
    public func set(quoteFieldSuffix: String) -> Self {
        _quoteFieldSuffix = quoteFieldSuffix
        return self
    }

    @discardableResult
    public func set(fuzzyTranspositions: Bool) -> Self {
        _fuzzyTranspositions = fuzzyTranspositions
        return self
    }

    @discardableResult
    public func set(fuzzyPrefixLength: Int) -> Self {
        _fuzzyPrefixLength = fuzzyPrefixLength
        return self
    }

    @discardableResult
    public func set(fuzzyMaxExpansions: Int) -> Self {
        _fuzzyMaxExpansions = fuzzyMaxExpansions
        return self
    }

    @discardableResult
    public func set(maxDeterminizedStates: Int) -> Self {
        _maxDeterminizedStates = maxDeterminizedStates
        return self
    }

    @discardableResult
    public func set(minimumShouldMatch: Int) -> Self {
        _minimumShouldMatch = minimumShouldMatch
        return self
    }

    @discardableResult
    public func set(lenient: Bool) -> Self {
        _lenient = lenient
        return self
    }

    @discardableResult
    public func set(analyzeWildcard: Bool) -> Self {
        _analyzeWildcard = analyzeWildcard
        return self
    }

    @discardableResult
    public func set(autoGeneratePhraseQueries: Bool) -> Self {
        _autoGeneratePhraseQueries = autoGeneratePhraseQueries
        return self
    }

    @discardableResult
    public func set(timeZone: String) -> Self {
        _timeZone = timeZone
        return self
    }

    @discardableResult
    public func set(analyzer: String) -> Self {
        _analyzer = analyzer
        return self
    }

    @discardableResult
    public func set(defaultField: String) -> Self {
        _defaultField = defaultField
        return self
    }

    @discardableResult
    public func set(defaultOperator: String) -> Self {
        _defaultOperator = defaultOperator
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var defaultField: String? {
        return _defaultField
    }

    public var query: String? {
        return _query
    }

    public var fields: [String]? {
        return _fields
    }

    public var type: MultiMatchQueryType? {
        return _type
    }

    public var tieBreaker: Decimal? {
        return _tieBreaker
    }

    public var defaultOperator: String? {
        return _defaultOperator
    }

    public var analyzer: String? {
        return _analyzer
    }

    public var quoteAnalyzer: String? {
        return _quoteAnalyzer
    }

    public var allowLeadingWildcard: Bool? {
        return _allowLeadingWildcard
    }

    public var enablePositionIncrements: Bool? {
        return _enablePositionIncrements
    }

    public var fuzzyMaxExpansions: Int? {
        return _fuzzyMaxExpansions
    }

    public var fuzziness: String? {
        return _fuzziness
    }

    public var fuzzyPrefixLength: Int? {
        return _fuzzyPrefixLength
    }

    public var fuzzyTranspositions: Bool? {
        return _fuzzyTranspositions
    }

    public var phraseSlop: Int? {
        return _phraseSlop
    }

    public var boost: Decimal? {
        return _boost
    }

    public var autoGeneratePhraseQueries: Bool? {
        return _autoGeneratePhraseQueries
    }

    public var analyzeWildcard: Bool? {
        return _analyzeWildcard
    }

    public var maxDeterminizedStates: Int? {
        return _maxDeterminizedStates
    }

    public var minimumShouldMatch: Int? {
        return _minimumShouldMatch
    }

    public var lenient: Bool? {
        return _lenient
    }

    public var timeZone: String? {
        return _timeZone
    }

    public var quoteFieldSuffix: String? {
        return _quoteFieldSuffix
    }

    public var autoGenerateSynonymsPhraseQuery: Bool? {
        return _autoGenerateSynonymsPhraseQuery
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> QueryStringQuery {
        return try QueryStringQuery(withBuilder: self)
    }
}

// MARK: - Builder for SimpleQueryString query.

public class SimpleQueryStringQueryBuilder: QueryBuilder {
    private var _query: String?
    private var _fields: [String]?
    private var _defaultOperator: String?
    private var _analyzer: String?
    private var _flags: String?
    private var _lenient: Bool?
    private var _minimumShouldMatch: Int?
    private var _fuzzyMaxExpansions: Int?
    private var _fuzzyPrefixLength: Int?
    private var _fuzzyTranspositions: Bool?
    private var _quoteFieldSuffix: String?
    private var _autoGenerateSynonymsPhraseQuery: Bool?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(query: String) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(autoGenerateSynonymsPhraseQuery: Bool) -> Self {
        _autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        return self
    }

    @discardableResult
    public func set(quoteFieldSuffix: String) -> Self {
        _quoteFieldSuffix = quoteFieldSuffix
        return self
    }

    @discardableResult
    public func set(fuzzyTranspositions: Bool) -> Self {
        _fuzzyTranspositions = fuzzyTranspositions
        return self
    }

    @discardableResult
    public func set(fuzzyPrefixLength: Int) -> Self {
        _fuzzyPrefixLength = fuzzyPrefixLength
        return self
    }

    @discardableResult
    public func set(fuzzyMaxExpansions: Int) -> Self {
        _fuzzyMaxExpansions = fuzzyMaxExpansions
        return self
    }

    @discardableResult
    public func set(minimumShouldMatch: Int) -> Self {
        _minimumShouldMatch = minimumShouldMatch
        return self
    }

    @discardableResult
    public func set(lenient: Bool) -> Self {
        _lenient = lenient
        return self
    }

    @discardableResult
    public func set(flags: String) -> Self {
        _flags = flags
        return self
    }

    @discardableResult
    public func set(analyzer: String) -> Self {
        _analyzer = analyzer
        return self
    }

    @discardableResult
    public func set(fields: String...) -> Self {
        _fields = fields
        return self
    }

    @discardableResult
    public func set(defaultOperator: String) -> Self {
        _defaultOperator = defaultOperator
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var query: String? {
        return _query
    }

    public var fields: [String]? {
        return _fields
    }

    public var defaultOperator: String? {
        return _defaultOperator
    }

    public var analyzer: String? {
        return _analyzer
    }

    public var flags: String? {
        return _flags
    }

    public var lenient: Bool? {
        return _lenient
    }

    public var minimumShouldMatch: Int? {
        return _minimumShouldMatch
    }

    public var fuzzyMaxExpansions: Int? {
        return _fuzzyMaxExpansions
    }

    public var fuzzyPrefixLength: Int? {
        return _fuzzyPrefixLength
    }

    public var fuzzyTranspositions: Bool? {
        return _fuzzyTranspositions
    }

    public var quoteFieldSuffix: String? {
        return _quoteFieldSuffix
    }

    public var autoGenerateSynonymsPhraseQuery: Bool? {
        return _autoGenerateSynonymsPhraseQuery
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> SimpleQueryStringQuery {
        return try SimpleQueryStringQuery(withBuilder: self)
    }
}
