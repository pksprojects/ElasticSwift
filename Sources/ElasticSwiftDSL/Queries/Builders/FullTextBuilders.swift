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
    
    var field: String?
    var value: String?
    var isFuzzy: Bool?
    var boost: Decimal?
    var `operator`: MatchQueryOperator?
    var zeroTermQuery: ZeroTermQuery?
    var cutoffFrequency: Decimal?
    var fuzziness: String?
    var autoGenSynonymnsPhraseQuery: Bool?
    
    typealias BuilderClosure = (MatchQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return MatchQuery(withBuilder: self)
        }
    }
    
    public func set(field: String) -> Self {
        self.field = field
        return self
    }
    
    public func set(value: String) -> Self {
        self.value = value
        return self
    }
    
    public func set(cutoffFrequency: Decimal) -> Self {
        self.cutoffFrequency = cutoffFrequency
        return self
    }
    
    public func set(`operator`: MatchQueryOperator) -> Self {
        self.`operator` = `operator`
        return self
    }
    
    public func set(zeroTermQuery: ZeroTermQuery) -> Self {
        self.zeroTermQuery = zeroTermQuery
        return self
    }
    
    public func set(isFuzzy: Bool) -> Self {
        self.isFuzzy = isFuzzy
        return self
    }
    
    public func set(boost: Decimal) -> Self {
        self.boost = boost
        return self
    }
}

// MARK:- Builder for Match Phrase query.

public class MatchPhraseQueryBuilder: QueryBuilder {
    
    var field: String?
    var value: String?
    var analyzer: String?
    
    typealias BuilderClosure = (MatchPhraseQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return MatchPhraseQuery(withBuilder: self)
        }
    }
    
    public func set(field: String) -> Self {
        self.field = field
        return self
    }
    
    public func set(value: String) -> Self {
        self.value = value
        return self
    }
    
    public func set(analyzer: String) -> Self {
        self.analyzer = analyzer
        return self
    }
    
    
}

// MARK:- Builder for Match Phrase query.

public class MatchPhrasePrefixQueryBuilder: QueryBuilder {
    
    var field: String?
    var value: String?
    var maxExpansions: Int?
    
    typealias BuilderClosure = (MatchPhrasePrefixQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }

    public var query: Query {
        get {
            return MatchPhrasePrefixQuery(withBuilder: self)
        }
    }
    
    public func set(field: String) -> Self {
        self.field = field
        return self
    }
    
    public func set(value: String) -> Self {
        self.value = value
        return self
    }
    
    public func set(maxExpansions: Int) -> Self {
        self.maxExpansions = maxExpansions
        return self
    }
    
    
}

// MARK:- Builder for MultiMatch query.

public class MultiMatchQueryBuilder: QueryBuilder {
    
    var value: String?
    var fields: [String]?
    var type: MultiMatchQueryType?
    var tieBreaker: Decimal?
    
    typealias BuilderClosure = (MultiMatchQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return MultiMatchQuery(withBuilder: self)
        }
    }
    
    public func set(value: String) -> Self {
        self.value = value
        return self
    }
    
    public func set(fields: String...) -> Self {
        self.fields = fields
        return self
    }
    
    
    public func set(type: MultiMatchQueryType) -> Self {
        self.type = type
        return self
    }
    
    public func set(tieBreaker: Decimal) -> Self {
        self.tieBreaker = tieBreaker
        return self
    }
    
}

// MARK:- Builder for Common Terms query.

public class CommonTermsQueryBuilder: QueryBuilder {
    
    var value: String?
    var cutoffFrequency: Decimal?
    var lowFrequencyOperator: String?
    var highFrequencyOperator: String?
    var minimumShouldMatch: Int?
    var minimumShouldMatchLowFreq: Int?
    var minimumShouldMatchHighFreq: Int?
    
    typealias BuilderClosure = (CommonTermsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return CommonTermsQuery(withBuilder: self)
        }
    }
    
    public func set(value: String) -> Self {
        self.value = value
        return self
    }
    
    public func set(cutoffFrequency: Decimal) -> Self {
        self.cutoffFrequency = cutoffFrequency
        return self
    }
    
    public func set(lowFrequencyOperator: String) -> Self {
        self.lowFrequencyOperator = lowFrequencyOperator
        return self
    }
    
    public func set(highFrequencyOperator: String) -> Self {
        self.highFrequencyOperator = highFrequencyOperator
        return self
    }
    
    public func set(minimumShouldMatch: Int) -> Self {
        self.minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    public func set(minimumShouldMatchLowFreq: Int) -> Self {
        self.minimumShouldMatchLowFreq = minimumShouldMatchLowFreq
        return self
    }
    
    public func set(minimumShouldMatchHighFreq: Int) -> Self {
        self.minimumShouldMatchHighFreq = minimumShouldMatchHighFreq
        return self
    }
    
}

// MARK:- Builder for QueryString query.

public class QueryStringQueryBuilder: QueryBuilder {
    
    var defaultField: String?
    var value: String?
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
    
    typealias BuilderClosure = (QueryStringQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return QueryStringQuery(withBuilder: self)
        }
    }
    
    public func set(value: String) -> Self {
        self.value = value
        return self
    }
    
    public func set(fuzziness: String) -> Self {
        self.fuzziness = fuzziness
        return self
    }
    
    public func set(phraseSlop: Int) -> Self {
        self.phraseSlop = phraseSlop
        return self
    }
    
    public func set(enablePositionIncrements: Bool) -> Self {
        self.enablePositionIncrements = enablePositionIncrements
        return self
    }
    
    public func set(quoteAnalyzer: String) -> Self {
        self.quoteAnalyzer = quoteAnalyzer
        return self
    }
    
    public func set(autoGenerateSynonymsPhraseQuery: Bool) -> Self {
        self.autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        return self
    }
    
    public func set(quoteFieldSuffix: String) -> Self {
        self.quoteFieldSuffix = quoteFieldSuffix
        return self
    }
    
    public func set(fuzzyTranspositions: Bool) -> Self {
        self.fuzzyTranspositions = fuzzyTranspositions
        return self
    }
    
    public func set(fuzzyPrefixLength: Int) -> Self {
        self.fuzzyPrefixLength = fuzzyPrefixLength
        return self
    }
    
    public func set(fuzzyMaxExpansions: Int) -> Self {
        self.fuzzyMaxExpansions = fuzzyMaxExpansions
        return self
    }
    
    public func set(maxDeterminizedStates: Int) -> Self {
        self.maxDeterminizedStates = maxDeterminizedStates
        return self
    }
    
    public func set(minimumShouldMatch: Int) -> Self {
        self.minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    public func set(lenient: Bool) -> Self {
        self.lenient = lenient
        return self
    }
    
    public func set(analyzeWildcard: Bool) -> Self {
        self.analyzeWildcard = analyzeWildcard
        return self
    }
    
    public func set(autoGeneratePhraseQueries: Bool) -> Self {
        self.autoGeneratePhraseQueries = autoGeneratePhraseQueries
        return self
    }
    
    public func set(timeZone: String) -> Self {
        self.timeZone = timeZone
        return self
    }
    
    public func set(analyzer: String) -> Self {
        self.analyzer = analyzer
        return self
    }
    
    public func set(defaultField: String) -> Self {
        self.defaultField = defaultField
        return self
    }
    
    public func set(defaultOperator: String) -> Self {
        self.defaultOperator = defaultOperator
        return self
    }
    public func set(boost: Decimal) -> Self {
        self.boost = boost
        return self
    }
    
}

// MARK:- Builder for SimpleQueryString query.

public class SimpleQueryStringQueryBuilder: QueryBuilder {
    
    var value: String?
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
    
    typealias BuilderClosure = (SimpleQueryStringQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return SimpleQueryStringQuery(withBuilder: self)
        }
    }
    
    public func set(value: String) -> Self {
        self.value = value
        return self
    }
    
    public func set(autoGenerateSynonymsPhraseQuery: Bool) -> Self {
        self.autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        return self
    }
    
    public func set(quoteFieldSuffix: String) -> Self {
        self.quoteFieldSuffix = quoteFieldSuffix
        return self
    }
    
    public func set(fuzzyTranspositions: Bool) -> Self {
        self.fuzzyTranspositions = fuzzyTranspositions
        return self
    }
    
    public func set(fuzzyPrefixLength: Int) -> Self {
        self.fuzzyPrefixLength = fuzzyPrefixLength
        return self
    }
    
    public func set(fuzzyMaxExpansions: Int) -> Self {
        self.fuzzyMaxExpansions = fuzzyMaxExpansions
        return self
    }
    
    public func set(minimumShouldMatch: Int) -> Self {
        self.minimumShouldMatch = minimumShouldMatch
        return self
    }
    
    public func set(lenient: Bool) -> Self {
        self.lenient = lenient
        return self
    }
    
    public func set(flags: String) -> Self {
        self.flags = flags
        return self
    }
    
    public func set(analyzer: String) -> Self {
        self.analyzer = analyzer
        return self
    }
    
    public func set(fields: String...) -> Self {
        self.fields = fields
        return self
    }
    
    public func set(defaultOperator: String) -> Self {
        self.defaultOperator = defaultOperator
        return self
    }
    
}

