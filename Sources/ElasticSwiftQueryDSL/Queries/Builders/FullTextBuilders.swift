//
//  FullTextSearch.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Builder for Match query.

public class MatchQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _isFuzzy: Bool?
    private var _boost: Decimal?
    private var _operator: MatchQueryOperator?
    private var _zeroTermQuery: ZeroTermQuery?
    private var _cutoffFrequency: Decimal?
    private var _fuzziness: String?
    private var _autoGenSynonymnsPhraseQuery: Bool?
    
    typealias BuilderClosure = (MatchQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(field: String) -> MatchQueryBuilder {
        self._field = field
        return self
    }
    
    @discardableResult
    public func set(value: String) -> MatchQueryBuilder {
        self._value = value
        return self
    }
    
    @discardableResult
    public func set(cutoffFrequency: Decimal) -> MatchQueryBuilder {
        self._cutoffFrequency = cutoffFrequency
        return self
    }
    
    @discardableResult
    public func set(`operator`: MatchQueryOperator) -> MatchQueryBuilder {
        self._operator = `operator`
        return self
    }
    
    @discardableResult
    public func set(zeroTermQuery: ZeroTermQuery) -> MatchQueryBuilder {
        self._zeroTermQuery = zeroTermQuery
        return self
    }
    
    @discardableResult
    public func set(isFuzzy: Bool) -> MatchQueryBuilder {
        self._isFuzzy = isFuzzy
        return self
    }
    
    @discardableResult
    public func set(boost: Decimal) -> MatchQueryBuilder {
        self._boost = boost
        return self
    }
    
    @discardableResult
    public func set(fuzziness: String) -> MatchQueryBuilder {
        self._fuzziness = fuzziness
        return self
    }
    
    @discardableResult
    public func set(autoGenSynonymnsPhraseQuery: Bool) -> Self {
        self._autoGenSynonymnsPhraseQuery = autoGenSynonymnsPhraseQuery
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var value: String? {
        return self._value
    }
    public var isFuzzy: Bool? {
        return self._isFuzzy
    }
    public var boost: Decimal? {
        return self._boost
    }
    public var `operator`: MatchQueryOperator? {
        return self._operator
    }
    public var zeroTermQuery: ZeroTermQuery? {
        return self._zeroTermQuery
    }
    public var cutoffFrequency: Decimal? {
        return self._cutoffFrequency
    }
    public var fuzziness: String? {
        return self._fuzziness
    }
    public var autoGenSynonymnsPhraseQuery: Bool? {
        return self._autoGenSynonymnsPhraseQuery
    }
    
    public func build() throws -> MatchQuery {
        return try MatchQuery(withBuilder: self)
    }
}

// MARK:- Builder for Match Phrase query.

public class MatchPhraseQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _analyzer: String?
    
    typealias BuilderClosure = (MatchPhraseQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(field: String) -> MatchPhraseQueryBuilder {
        self._field = field
        return self
    }
    
    @discardableResult
    public func set(value: String) -> MatchPhraseQueryBuilder {
        self._value = value
        return self
    }
    
    @discardableResult
    public func set(analyzer: String) -> MatchPhraseQueryBuilder {
        self._analyzer = analyzer
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var value: String? {
        return self._value
    }
    public var analyzer: String? {
        return self._analyzer
    }
    
    public func build() throws -> MatchPhraseQuery {
        return try MatchPhraseQuery(withBuilder: self)
    }
    
    
}

// MARK:- Builder for Match Phrase query.

public class MatchPhrasePrefixQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _maxExpansions: Int?
    
    typealias BuilderClosure = (MatchPhrasePrefixQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(field: String) -> Self {
        self._field = field
        return self
    }
    
    @discardableResult
    public func set(value: String) -> Self {
        self._value = value
        return self
    }
    
    @discardableResult
    public func set(maxExpansions: Int) -> Self {
        self._maxExpansions = maxExpansions
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var value: String? {
        return self._value
    }
    public var maxExpansions: Int? {
        return self._maxExpansions
    }
    
    public func build() throws -> MatchPhrasePrefixQuery {
        return try MatchPhrasePrefixQuery(withBuilder: self)
    }
    
}

// MARK:- Builder for MultiMatch query.

public class MultiMatchQueryBuilder: QueryBuilder {
    
    private var _query: String?
    private var _fields: [String] = []
    private var _type: MultiMatchQueryType?
    private var _tieBreaker: Decimal?
    
    typealias BuilderClosure = (MultiMatchQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(query: String) -> MultiMatchQueryBuilder {
        self._query = query
        return self
    }
    
    @discardableResult
    public func set(fields: String...) -> MultiMatchQueryBuilder {
        self._fields = fields
        return self
    }
    
    @discardableResult
    public func add(field: String) -> MultiMatchQueryBuilder {
        self._fields.append(field)
        return self
    }
    
    @discardableResult
    public func set(type: MultiMatchQueryType) -> MultiMatchQueryBuilder {
        self._type = type
        return self
    }
    
    @discardableResult
    public func set(tieBreaker: Decimal) -> MultiMatchQueryBuilder {
        self._tieBreaker = tieBreaker
        return self
    }
    
    public var query: String? {
        return self._query
    }
    public var fields: [String] {
        return self._fields
    }
    public var type: MultiMatchQueryType? {
        return self._type
    }
    public var tieBreaker: Decimal? {
        return self._tieBreaker
    }
    
    @discardableResult
    public func build() throws -> MultiMatchQuery {
        return try MultiMatchQuery(withBuilder: self)
    }
    
}

// MARK:- Builder for Common Terms query.

public class CommonTermsQueryBuilder: QueryBuilder {
    
    private var _query: String?
    private var _cutoffFrequency: Decimal?
    private var _lowFrequencyOperator: String?
    private var _highFrequencyOperator: String?
    private var _minimumShouldMatch: Int?
    private var _minimumShouldMatchLowFreq: Int?
    private var _minimumShouldMatchHighFreq: Int?
    
    typealias BuilderClosure = (CommonTermsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(query: String) -> CommonTermsQueryBuilder {
        self._query = query
        return self
    }
    
    @discardableResult
    public func set(cutoffFrequency: Decimal) -> CommonTermsQueryBuilder {
        self._cutoffFrequency = cutoffFrequency
        return self
    }
    
    @discardableResult
    public func set(lowFrequencyOperator: String) -> CommonTermsQueryBuilder {
        self._lowFrequencyOperator = lowFrequencyOperator
        return self
    }
    
    @discardableResult
    public func set(highFrequencyOperator: String) -> CommonTermsQueryBuilder {
        self._highFrequencyOperator = highFrequencyOperator
        return self
    }
    
    @discardableResult
    public func set(minimumShouldMatch: Int) -> CommonTermsQueryBuilder {
        self._minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    @discardableResult
    public func set(minimumShouldMatchLowFreq: Int) -> CommonTermsQueryBuilder {
        self._minimumShouldMatchLowFreq = minimumShouldMatchLowFreq
        return self
    }
    
    @discardableResult
    public func set(minimumShouldMatchHighFreq: Int) -> CommonTermsQueryBuilder {
        self._minimumShouldMatchHighFreq = minimumShouldMatchHighFreq
        return self
    }
    
    public var query: String? {
        return self._query
    }
    public var cutoffFrequency: Decimal? {
        return self._cutoffFrequency
    }
    public var lowFrequencyOperator: String? {
        return self._lowFrequencyOperator
    }
    public var highFrequencyOperator: String? {
        return self._highFrequencyOperator
    }
    public var minimumShouldMatch: Int? {
        return self._minimumShouldMatch
    }
    public var minimumShouldMatchLowFreq: Int? {
        return self._minimumShouldMatchLowFreq
    }
    public var minimumShouldMatchHighFreq: Int? {
        return self._minimumShouldMatchHighFreq
    }
    
    public func build() throws -> CommonTermsQuery {
        return try CommonTermsQuery(withBuilder: self)
    }
    
}

// MARK:- Builder for QueryString query.

public class QueryStringQueryBuilder: QueryBuilder {
    
    private var _defaultField: String?
    private var _value: String?
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
    
    typealias BuilderClosure = (QueryStringQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(allowLeadingWildcard: Bool) -> Self {
        self._allowLeadingWildcard = allowLeadingWildcard
        return self
    }
    
    @discardableResult
    public func set(value: String) -> Self {
        self._value = value
        return self
    }
    
    @discardableResult
    public func set(fuzziness: String) -> Self {
        self._fuzziness = fuzziness
        return self
    }
    
    @discardableResult
    public func set(phraseSlop: Int) -> Self {
        self._phraseSlop = phraseSlop
        return self
    }
    
    @discardableResult
    public func set(enablePositionIncrements: Bool) -> Self {
        self._enablePositionIncrements = enablePositionIncrements
        return self
    }
    
    @discardableResult
    public func set(quoteAnalyzer: String) -> Self {
        self._quoteAnalyzer = quoteAnalyzer
        return self
    }
    
    @discardableResult
    public func set(autoGenerateSynonymsPhraseQuery: Bool) -> Self {
        self._autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        return self
    }
    
    @discardableResult
    public func set(quoteFieldSuffix: String) -> Self {
        self._quoteFieldSuffix = quoteFieldSuffix
        return self
    }
    
    @discardableResult
    public func set(fuzzyTranspositions: Bool) -> Self {
        self._fuzzyTranspositions = fuzzyTranspositions
        return self
    }
    
    @discardableResult
    public func set(fuzzyPrefixLength: Int) -> Self {
        self._fuzzyPrefixLength = fuzzyPrefixLength
        return self
    }
    
    @discardableResult
    public func set(fuzzyMaxExpansions: Int) -> Self {
        self._fuzzyMaxExpansions = fuzzyMaxExpansions
        return self
    }
    
    @discardableResult
    public func set(maxDeterminizedStates: Int) -> Self {
        self._maxDeterminizedStates = maxDeterminizedStates
        return self
    }
    
    @discardableResult
    public func set(minimumShouldMatch: Int) -> Self {
        self._minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    @discardableResult
    public func set(lenient: Bool) -> Self {
        self._lenient = lenient
        return self
    }
    
    @discardableResult
    public func set(analyzeWildcard: Bool) -> Self {
        self._analyzeWildcard = analyzeWildcard
        return self
    }
    
    @discardableResult
    public func set(autoGeneratePhraseQueries: Bool) -> Self {
        self._autoGeneratePhraseQueries = autoGeneratePhraseQueries
        return self
    }
    
    @discardableResult
    public func set(timeZone: String) -> Self {
        self._timeZone = timeZone
        return self
    }
    
    @discardableResult
    public func set(analyzer: String) -> Self {
        self._analyzer = analyzer
        return self
    }
    
    @discardableResult
    public func set(defaultField: String) -> Self {
        self._defaultField = defaultField
        return self
    }
    
    @discardableResult
    public func set(defaultOperator: String) -> Self {
        self._defaultOperator = defaultOperator
        return self
    }
    
    @discardableResult
    public func set(boost: Decimal) -> Self {
        self._boost = boost
        return self
    }
    
    public var defaultField: String? {
        return self._defaultField
    }
    public var value: String? {
        return self._value
    }
    public var defaultOperator: String? {
        return self._defaultOperator
    }
    public var analyzer: String? {
        return self._analyzer
    }
    public var quoteAnalyzer: String? {
        return self._quoteAnalyzer
    }
    public var allowLeadingWildcard: Bool? {
        return self._allowLeadingWildcard
    }
    public var enablePositionIncrements: Bool? {
        return self._enablePositionIncrements
    }
    public var fuzzyMaxExpansions: Int? {
        return self._fuzzyMaxExpansions
    }
    public var fuzziness: String? {
        return self._fuzziness
    }
    public var fuzzyPrefixLength: Int? {
        return self._fuzzyPrefixLength
    }
    public var fuzzyTranspositions: Bool? {
        return self._fuzzyTranspositions
    }
    public var phraseSlop: Int? {
        return self._phraseSlop
    }
    public var boost: Decimal? {
        return self._boost
    }
    public var autoGeneratePhraseQueries: Bool? {
        return self._autoGeneratePhraseQueries
    }
    public var analyzeWildcard: Bool? {
        return self._analyzeWildcard
    }
    public var maxDeterminizedStates: Int? {
        return self._maxDeterminizedStates
    }
    public var minimumShouldMatch: Int? {
        return self._minimumShouldMatch
    }
    public var lenient: Bool? {
        return self._lenient
    }
    public var timeZone: String? {
        return self._timeZone
    }
    public var quoteFieldSuffix: String? {
        return self._quoteFieldSuffix
    }
    public var autoGenerateSynonymsPhraseQuery: Bool? {
        return self._autoGenerateSynonymsPhraseQuery
    }
    
    public func build() throws -> QueryStringQuery {
        return try QueryStringQuery(withBuilder: self)
    }
    
}

// MARK:- Builder for SimpleQueryString query.

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
    
    typealias BuilderClosure = (SimpleQueryStringQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    @discardableResult
    public func set(query: String) -> Self {
        self._query = query
        return self
    }
    
    @discardableResult
    public func set(autoGenerateSynonymsPhraseQuery: Bool) -> Self {
        self._autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        return self
    }
    
    @discardableResult
    public func set(quoteFieldSuffix: String) -> Self {
        self._quoteFieldSuffix = quoteFieldSuffix
        return self
    }
    
    @discardableResult
    public func set(fuzzyTranspositions: Bool) -> Self {
        self._fuzzyTranspositions = fuzzyTranspositions
        return self
    }
    
    @discardableResult
    public func set(fuzzyPrefixLength: Int) -> Self {
        self._fuzzyPrefixLength = fuzzyPrefixLength
        return self
    }
    
    @discardableResult
    public func set(fuzzyMaxExpansions: Int) -> Self {
        self._fuzzyMaxExpansions = fuzzyMaxExpansions
        return self
    }
    
    @discardableResult
    public func set(minimumShouldMatch: Int) -> Self {
        self._minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    @discardableResult
    public func set(lenient: Bool) -> Self {
        self._lenient = lenient
        return self
    }
    
    @discardableResult
    public func set(flags: String) -> Self {
        self._flags = flags
        return self
    }
    
    @discardableResult
    public func set(analyzer: String) -> Self {
        self._analyzer = analyzer
        return self
    }
    
    @discardableResult
    public func set(fields: String...) -> Self {
        self._fields = fields
        return self
    }
    
    @discardableResult
    public func set(defaultOperator: String) -> Self {
        self._defaultOperator = defaultOperator
        return self
    }
    
    public var query: String? {
        return self._query
    }
    public var fields: [String]? {
        return self._fields
    }
    public var defaultOperator: String? {
        return self._defaultOperator
    }
    public var analyzer: String? {
        return self._analyzer
    }
    public var flags: String? {
        return self._flags
    }
    public var lenient: Bool? {
        return self._lenient
    }
    public var minimumShouldMatch: Int? {
        return self._minimumShouldMatch
    }
    public var fuzzyMaxExpansions: Int? {
        return self._fuzzyMaxExpansions
    }
    public var fuzzyPrefixLength: Int? {
        return self._fuzzyPrefixLength
    }
    public var fuzzyTranspositions: Bool? {
        return self._fuzzyTranspositions
    }
    public var quoteFieldSuffix: String? {
        return self._quoteFieldSuffix
    }
    public var autoGenerateSynonymsPhraseQuery: Bool? {
        return self._autoGenerateSynonymsPhraseQuery
    }
    
    public func build() throws -> SimpleQueryStringQuery {
        return try SimpleQueryStringQuery(withBuilder: self)
    }
    
}

