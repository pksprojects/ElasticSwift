//
//  FullTextQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Match Query.

public struct MatchQuery: Query {
    public let queryType: QueryType = QueryTypes.match

    public let field: String
    public let value: String
    public let `operator`: Operator?
    public let zeroTermQuery: ZeroTermQuery?
    public let cutoffFrequency: Decimal?
    public let fuzziness: Fuzziness?
    public let autoGenSynonymnsPhraseQuery: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, value: String, boost: Decimal? = nil, operator: Operator? = nil, zeroTermQuery: ZeroTermQuery? = nil, cutoffFrequency: Decimal? = nil, fuzziness: Fuzziness? = nil, autoGenSynonymnsPhraseQuery: Bool? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.name = name
        self.operator = `operator`
        self.zeroTermQuery = zeroTermQuery
        self.cutoffFrequency = cutoffFrequency
        self.fuzziness = fuzziness
        self.autoGenSynonymnsPhraseQuery = autoGenSynonymnsPhraseQuery
    }

    internal init(withBuilder builder: MatchQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, operator: builder.operator, zeroTermQuery: builder.zeroTermQuery, cutoffFrequency: builder.cutoffFrequency, fuzziness: builder.fuzziness, autoGenSynonymnsPhraseQuery: builder.autoGenSynonymnsPhraseQuery, name: builder.name)
    }
}

public extension MatchQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .query)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
            `operator` = try fieldContainer.decodeIfPresent(Operator.self, forKey: .operator)
            zeroTermQuery = try fieldContainer.decodeIfPresent(ZeroTermQuery.self, forKey: .zeroTermsQuery)
            cutoffFrequency = try fieldContainer.decodeDecimalIfPresent(forKey: .cutoffFrequency)
            fuzziness = try fieldContainer.decodeIfPresent(Fuzziness.self, forKey: .fuzziness)
            autoGenSynonymnsPhraseQuery = try fieldContainer.decodeBoolIfPresent(forKey: .autoGenerateSynonymsPhraseQuery)
        } else {
            value = try nested.decodeString(forKey: .key(named: field))
            `operator` = nil
            zeroTermQuery = nil
            cutoffFrequency = nil
            fuzziness = nil
            autoGenSynonymnsPhraseQuery = nil
            boost = nil
            name = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .query)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
        try fieldContainer.encodeIfPresent(`operator`, forKey: .operator)
        try fieldContainer.encodeIfPresent(zeroTermQuery, forKey: .zeroTermsQuery)
        try fieldContainer.encodeIfPresent(cutoffFrequency, forKey: .cutoffFrequency)
        try fieldContainer.encodeIfPresent(fuzziness, forKey: .fuzziness)
        try fieldContainer.encodeIfPresent(autoGenSynonymnsPhraseQuery, forKey: .autoGenerateSynonymsPhraseQuery)
    }

    internal enum CodingKeys: String, CodingKey {
        case query
        case boost
        case name
        case `operator`
        case fuzziness
        case zeroTermsQuery = "zero_terms_query"
        case cutoffFrequency = "cutoff_frequency"
        case autoGenerateSynonymsPhraseQuery = "auto_generate_synonyms_phrase_query"
    }
}

extension MatchQuery: Equatable {
    public static func == (lhs: MatchQuery, rhs: MatchQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.cutoffFrequency == rhs.cutoffFrequency
            && lhs.autoGenSynonymnsPhraseQuery == rhs.autoGenSynonymnsPhraseQuery
            && lhs.fuzziness == rhs.fuzziness
            && lhs.operator == rhs.operator
            && lhs.zeroTermQuery == rhs.zeroTermQuery
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - MatchPhraseQuery

public struct MatchPhraseQuery: Query {
    public let queryType: QueryType = QueryTypes.matchPhrase

    public let field: String
    public let value: String
    public let analyzer: String?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, value: String, analyzer: String? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.analyzer = analyzer
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: MatchPhraseQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, analyzer: builder.analyzer, boost: builder.boost, name: builder.name)
    }
}

public extension MatchPhraseQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchPhraseQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .query)
            analyzer = try fieldContainer.decodeStringIfPresent(forKey: .analyzer)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
        } else {
            value = try nested.decodeString(forKey: .key(named: field))
            analyzer = nil
            name = nil
            boost = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard analyzer != nil || name != nil || boost != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .query)
        try fieldContainer.encode(analyzer, forKey: .analyzer)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
    }

    internal enum CodingKeys: String, CodingKey {
        case query
        case analyzer
        case name
        case boost
    }
}

extension MatchPhraseQuery: Equatable {
    public static func == (lhs: MatchPhraseQuery, rhs: MatchPhraseQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.analyzer == rhs.analyzer
            && lhs.name == rhs.name
            && lhs.boost == rhs.boost
    }
}

// MARK: - MatchPhrasePrefixQuery

public struct MatchPhrasePrefixQuery: Query {
    public let queryType: QueryType = QueryTypes.matchPhrasePrefix

    public let field: String
    public let value: String
    public let maxExpansions: Int?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, value: String, maxExpansions: Int? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.maxExpansions = maxExpansions
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: MatchPhrasePrefixQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, maxExpansions: builder.maxExpansions, boost: builder.boost, name: builder.name)
    }
}

public extension MatchPhrasePrefixQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchPhrasePrefixQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .query)
            maxExpansions = try fieldContainer.decodeIntIfPresent(forKey: .maxExpansions)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
        } else {
            value = try nested.decodeString(forKey: .key(named: field))
            maxExpansions = nil
            name = nil
            boost = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard maxExpansions != nil || name != nil || boost != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .query)
        try fieldContainer.encode(maxExpansions, forKey: .maxExpansions)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
    }

    internal enum CodingKeys: String, CodingKey {
        case query
        case maxExpansions = "max_expansions"
        case name
        case boost
    }
}

extension MatchPhrasePrefixQuery: Equatable {
    public static func == (lhs: MatchPhrasePrefixQuery, rhs: MatchPhrasePrefixQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.maxExpansions == rhs.maxExpansions
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - MultiMatchQuery

public struct MultiMatchQuery: Query {
    public let queryType: QueryType = QueryTypes.multiMatch

    public let tieBreaker: Decimal?
    public let type: MultiMatchQueryType?
    public let query: String
    public let fields: [String]
    public var boost: Decimal?
    public var name: String?

    internal init(query: String, fields: [String], tieBreaker: Decimal?, type: MultiMatchQueryType?, boost: Decimal? = nil, name: String? = nil) {
        self.tieBreaker = tieBreaker
        self.type = type
        self.query = query
        self.fields = fields
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: MultiMatchQueryBuilder) throws {
        guard !builder.fields.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("fields")
        }

        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(query: builder.query!, fields: builder.fields, tieBreaker: builder.tieBreaker, type: builder.type, boost: builder.boost, name: builder.name)
    }
}

public extension MultiMatchQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        query = try nested.decodeString(forKey: .query)
        fields = try nested.decodeArray(forKey: .fields)
        type = try nested.decodeIfPresent(MultiMatchQueryType.self, forKey: .type)
        tieBreaker = try nested.decodeDecimalIfPresent(forKey: .tieBreaker)
        name = try nested.decodeStringIfPresent(forKey: .name)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        try nested.encode(query, forKey: .query)
        try nested.encode(fields, forKey: .fields)
        try nested.encodeIfPresent(type, forKey: .type)
        try nested.encodeIfPresent(tieBreaker, forKey: .tieBreaker)
        try nested.encodeIfPresent(name, forKey: .name)
        try nested.encodeIfPresent(boost, forKey: .boost)
    }

    internal enum CodingKeys: String, CodingKey {
        case query
        case fields
        case tieBreaker = "tie_breaker"
        case type
        case name
        case boost
    }
}

extension MultiMatchQuery: Equatable {
    public static func == (lhs: MultiMatchQuery, rhs: MultiMatchQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.query == rhs.query
            && lhs.fields == rhs.fields
            && lhs.tieBreaker == rhs.tieBreaker
            && lhs.type == rhs.type
            && lhs.name == rhs.name
            && lhs.boost == rhs.boost
    }
}

// MARK: - CommonTermsQuery

public struct CommonTermsQuery: Query {
    public let queryType: QueryType = QueryTypes.common

    public let field: String
    public let query: String
    public let cutoffFrequency: Decimal
    public let lowFrequencyOperator: Operator?
    public let highFrequencyOperator: Operator?
    public let minimumShouldMatch: Int?
    public let minimumShouldMatchLowFreq: Int?
    public let minimumShouldMatchHighFreq: Int?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, query: String, cutoffFrequency: Decimal, lowFrequencyOperator: Operator? = nil, highFrequencyOperator: Operator? = nil, minimumShouldMatch: Int? = nil, minimumShouldMatchLowFreq: Int? = nil, minimumShouldMatchHighFreq: Int? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.query = query
        self.cutoffFrequency = cutoffFrequency
        self.lowFrequencyOperator = lowFrequencyOperator
        self.highFrequencyOperator = highFrequencyOperator
        self.minimumShouldMatch = minimumShouldMatch
        self.minimumShouldMatchLowFreq = minimumShouldMatchLowFreq
        self.minimumShouldMatchHighFreq = minimumShouldMatchHighFreq
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: CommonTermsQueryBuilder) throws {
        guard builder.cutoffFrequency != nil else {
            throw QueryBuilderError.atlestOneElementRequired("cutoffFrequency")
        }

        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        self.init(field: builder.field!, query: builder.query!, cutoffFrequency: builder.cutoffFrequency!, lowFrequencyOperator: builder.lowFrequencyOperator, highFrequencyOperator: builder.highFrequencyOperator, minimumShouldMatch: builder.minimumShouldMatch, minimumShouldMatchLowFreq: builder.minimumShouldMatchLowFreq, minimumShouldMatchHighFreq: builder.minimumShouldMatchHighFreq, boost: builder.boost, name: builder.name)
    }
}

public extension CommonTermsQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchPhrasePrefixQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))

        query = try fieldContainer.decodeString(forKey: .query)
        cutoffFrequency = try fieldContainer.decodeDecimal(forKey: .cutoffFrequency)
        lowFrequencyOperator = try fieldContainer.decodeIfPresent(Operator.self, forKey: .lowFreqOperator)
        highFrequencyOperator = try fieldContainer.decodeIfPresent(Operator.self, forKey: .highFreqOperator)
        if let minShouldMatch = try? fieldContainer.decodeIntIfPresent(forKey: .minimumShouldMatch) {
            minimumShouldMatch = minShouldMatch
            minimumShouldMatchLowFreq = nil
            minimumShouldMatchHighFreq = nil
        } else {
            let minContainer = try? fieldContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .minimumShouldMatch)
            minimumShouldMatchLowFreq = try minContainer?.decodeIntIfPresent(forKey: .lowFreq)
            minimumShouldMatchHighFreq = try minContainer?.decodeIntIfPresent(forKey: .highFreq)
            minimumShouldMatch = nil
        }
        boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
        name = try fieldContainer.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))

        try fieldContainer.encode(query, forKey: .query)
        try fieldContainer.encode(cutoffFrequency, forKey: .cutoffFrequency)
        try fieldContainer.encodeIfPresent(lowFrequencyOperator, forKey: .lowFreqOperator)
        try fieldContainer.encodeIfPresent(highFrequencyOperator, forKey: .highFreqOperator)
        try fieldContainer.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        if let minHighFreq = minimumShouldMatchHighFreq, let minLowFreq = minimumShouldMatchLowFreq {
            var minShouldMatchContainer = fieldContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .minimumShouldMatch)
            try minShouldMatchContainer.encode(minLowFreq, forKey: .lowFreq)
            try minShouldMatchContainer.encode(minHighFreq, forKey: .highFreq)
        }
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case query
        case cutoffFrequency = "cutoff_frequency"
        case lowFreqOperator = "low_freq_operator"
        case highFreqOperator = "high_freq_operator"
        case minimumShouldMatch = "minimum_should_match"
        case lowFreq = "low_freq"
        case highFreq = "high_freq"
        case name
        case boost
    }
}

extension CommonTermsQuery: Equatable {
    public static func == (lhs: CommonTermsQuery, rhs: CommonTermsQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.query == rhs.query
            && lhs.cutoffFrequency == rhs.cutoffFrequency
            && lhs.highFrequencyOperator == rhs.highFrequencyOperator
            && lhs.lowFrequencyOperator == rhs.lowFrequencyOperator
            && lhs.minimumShouldMatch == rhs.minimumShouldMatch
            && lhs.minimumShouldMatchLowFreq == rhs.minimumShouldMatchLowFreq
            && lhs.minimumShouldMatchHighFreq == rhs.minimumShouldMatchHighFreq
            && lhs.name == rhs.name
            && lhs.boost == rhs.boost
    }
}

// MARK: - QueryStringQuery

public struct QueryStringQuery: Query {
    public let queryType: QueryType = QueryTypes.queryString

    public let defaultField: String?
    public let query: String
    public let fields: [String]?
    public let type: MultiMatchQueryType?
    public let tieBreaker: Decimal?
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
    public let autoGeneratePhraseQueries: Bool?
    public let analyzeWildcard: Bool?
    public let maxDeterminizedStates: Int?
    public let minimumShouldMatch: Int?
    public let lenient: Bool?
    public let timeZone: String?
    public let quoteFieldSuffix: String?
    public let autoGenerateSynonymsPhraseQuery: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(_ query: String, fields: [String]? = nil, type: MultiMatchQueryType? = nil, tieBreaker: Decimal? = nil, defaultField: String? = nil, defaultOperator: String? = nil, analyzer: String? = nil, quoteAnalyzer: String? = nil, allowLeadingWildcard: Bool? = nil, enablePositionIncrements: Bool? = nil, fuzzyMaxExpansions: Int? = nil, fuzziness: String? = nil, fuzzyPrefixLength: Int? = nil, fuzzyTranspositions: Bool? = nil, phraseSlop: Int? = nil, boost: Decimal? = nil, autoGeneratePhraseQueries: Bool? = nil, analyzeWildcard: Bool? = nil, maxDeterminizedStates: Int? = nil, minimumShouldMatch: Int? = nil, lenient: Bool? = nil, timeZone: String? = nil, quoteFieldSuffix: String? = nil, autoGenerateSynonymsPhraseQuery: Bool? = nil, name: String? = nil) {
        self.defaultField = defaultField
        self.query = query
        self.fields = fields
        self.type = type
        self.tieBreaker = tieBreaker
        self.defaultOperator = defaultOperator
        self.analyzer = analyzer
        self.quoteAnalyzer = quoteAnalyzer
        self.allowLeadingWildcard = allowLeadingWildcard
        self.enablePositionIncrements = enablePositionIncrements
        self.fuzzyMaxExpansions = fuzzyMaxExpansions
        self.fuzziness = fuzziness
        self.fuzzyPrefixLength = fuzzyPrefixLength
        self.fuzzyTranspositions = fuzzyTranspositions
        self.phraseSlop = phraseSlop
        self.boost = boost
        self.autoGeneratePhraseQueries = autoGeneratePhraseQueries
        self.analyzeWildcard = analyzeWildcard
        self.maxDeterminizedStates = maxDeterminizedStates
        self.minimumShouldMatch = minimumShouldMatch
        self.lenient = lenient
        self.timeZone = timeZone
        self.quoteFieldSuffix = quoteFieldSuffix
        self.autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        self.name = name
    }

    internal init(withBuilder builder: QueryStringQueryBuilder) throws {
        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(builder.query!, fields: builder.fields, type: builder.type, tieBreaker: builder.tieBreaker, defaultField: builder.defaultField, defaultOperator: builder.defaultOperator, analyzer: builder.analyzer, quoteAnalyzer: builder.quoteAnalyzer, allowLeadingWildcard: builder.allowLeadingWildcard, enablePositionIncrements: builder.enablePositionIncrements, fuzzyMaxExpansions: builder.fuzzyMaxExpansions, fuzziness: builder.fuzziness, fuzzyPrefixLength: builder.fuzzyPrefixLength, fuzzyTranspositions: builder.fuzzyTranspositions, phraseSlop: builder.phraseSlop, boost: builder.boost, autoGeneratePhraseQueries: builder.autoGeneratePhraseQueries, analyzeWildcard: builder.analyzeWildcard, maxDeterminizedStates: builder.maxDeterminizedStates, minimumShouldMatch: builder.minimumShouldMatch, lenient: builder.lenient, timeZone: builder.timeZone, quoteFieldSuffix: builder.quoteFieldSuffix, autoGenerateSynonymsPhraseQuery: builder.autoGenerateSynonymsPhraseQuery, name: builder.name)
    }
}

public extension QueryStringQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        query = try nested.decodeString(forKey: .query)
        fields = try nested.decodeArrayIfPresent(forKey: .fields)
        type = try nested.decodeIfPresent(MultiMatchQueryType.self, forKey: .type)
        tieBreaker = try nested.decodeDecimalIfPresent(forKey: .tieBreaker)
        defaultField = try nested.decodeStringIfPresent(forKey: .defaultField)
        defaultOperator = try nested.decodeStringIfPresent(forKey: .defaultOperator)
        analyzer = try nested.decodeStringIfPresent(forKey: .analyzer)
        quoteAnalyzer = try nested.decodeStringIfPresent(forKey: .quoteAnalyzer)
        allowLeadingWildcard = try nested.decodeBoolIfPresent(forKey: .allowLeadingWildcard)
        enablePositionIncrements = try nested.decodeBoolIfPresent(forKey: .enablePositionIncrements)
        fuzzyMaxExpansions = try nested.decodeIntIfPresent(forKey: .fuzzyMaxExpansions)
        fuzziness = try nested.decodeStringIfPresent(forKey: .fuzziness)
        fuzzyPrefixLength = try nested.decodeIntIfPresent(forKey: .fuzzyPrefixLength)
        fuzzyTranspositions = try nested.decodeBoolIfPresent(forKey: .fuzzyTranspositions)
        phraseSlop = try nested.decodeIntIfPresent(forKey: .phraseSlop)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        autoGeneratePhraseQueries = try nested.decodeBoolIfPresent(forKey: .autoGeneratePhraseQueries)
        analyzeWildcard = try nested.decodeBoolIfPresent(forKey: .analyzeWildcard)
        maxDeterminizedStates = try nested.decodeIntIfPresent(forKey: .maxDeterminizedStates)
        minimumShouldMatch = try nested.decodeIntIfPresent(forKey: .minimumShouldMatch)
        lenient = try nested.decodeBoolIfPresent(forKey: .lenient)
        timeZone = try nested.decodeStringIfPresent(forKey: .timeZone)
        quoteFieldSuffix = try nested.decodeStringIfPresent(forKey: .quoteFieldSuffix)
        autoGenerateSynonymsPhraseQuery = try nested.decodeBoolIfPresent(forKey: .autoGenerateSynonymsPhraseQuery)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(query, forKey: .query)
        try nested.encodeIfPresent(fields, forKey: .fields)
        try nested.encodeIfPresent(type, forKey: .type)
        try nested.encodeIfPresent(tieBreaker, forKey: .tieBreaker)
        try nested.encodeIfPresent(defaultField, forKey: .defaultField)
        try nested.encodeIfPresent(defaultOperator, forKey: .defaultOperator)
        try nested.encodeIfPresent(analyzer, forKey: .analyzer)
        try nested.encodeIfPresent(quoteAnalyzer, forKey: .quoteAnalyzer)
        try nested.encodeIfPresent(allowLeadingWildcard, forKey: .allowLeadingWildcard)
        try nested.encodeIfPresent(enablePositionIncrements, forKey: .enablePositionIncrements)
        try nested.encodeIfPresent(fuzzyMaxExpansions, forKey: .fuzzyMaxExpansions)
        try nested.encodeIfPresent(fuzziness, forKey: .fuzziness)
        try nested.encodeIfPresent(fuzzyPrefixLength, forKey: .fuzzyPrefixLength)
        try nested.encodeIfPresent(fuzzyTranspositions, forKey: .fuzzyTranspositions)
        try nested.encodeIfPresent(phraseSlop, forKey: .phraseSlop)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(autoGeneratePhraseQueries, forKey: .autoGeneratePhraseQueries)
        try nested.encodeIfPresent(analyzeWildcard, forKey: .analyzeWildcard)
        try nested.encodeIfPresent(maxDeterminizedStates, forKey: .maxDeterminizedStates)
        try nested.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        try nested.encodeIfPresent(lenient, forKey: .lenient)
        try nested.encodeIfPresent(timeZone, forKey: .timeZone)
        try nested.encodeIfPresent(quoteFieldSuffix, forKey: .quoteFieldSuffix)
        try nested.encodeIfPresent(autoGenerateSynonymsPhraseQuery, forKey: .autoGenerateSynonymsPhraseQuery)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case query
        case fields
        case type
        case tieBreaker = "tie_breaker"
        case defaultField = "default_field"
        case defaultOperator = "default_operator"
        case analyzer
        case quoteAnalyzer = "quote_analyzer"
        case allowLeadingWildcard = "allow_leading_wildcard"
        case enablePositionIncrements = "enable_position_increments"
        case fuzzyMaxExpansions = "fuzzy_max_expansions"
        case fuzziness
        case fuzzyPrefixLength = "fuzzy_prefix_length"
        case fuzzyTranspositions = "fuzzy_transpositions"
        case phraseSlop = "phrase_slop"
        case boost
        case autoGeneratePhraseQueries = "auto_generate_phrase_queries"
        case analyzeWildcard = "analyze_wildcard"
        case maxDeterminizedStates = "max_determinized_states"
        case minimumShouldMatch = "minimum_should_match"
        case lenient
        case timeZone = "time_zone"
        case quoteFieldSuffix = "quote_field_suffix"
        case autoGenerateSynonymsPhraseQuery = "auto_generate_synonyms_phrase_query"
        case name
    }
}

extension QueryStringQuery: Equatable {
    public static func == (lhs: QueryStringQuery, rhs: QueryStringQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.query == rhs.query
            && lhs.fields == rhs.fields
            && lhs.type == rhs.type
            && lhs.tieBreaker == rhs.tieBreaker
            && lhs.analyzer == rhs.analyzer
            && lhs.allowLeadingWildcard == rhs.allowLeadingWildcard
            && lhs.analyzeWildcard == rhs.analyzeWildcard
            && lhs.autoGeneratePhraseQueries == rhs.autoGeneratePhraseQueries
            && lhs.autoGenerateSynonymsPhraseQuery == rhs.autoGenerateSynonymsPhraseQuery
            && lhs.boost == rhs.boost
            && lhs.defaultField == rhs.defaultField
            && lhs.defaultOperator == rhs.defaultOperator
            && lhs.enablePositionIncrements == rhs.enablePositionIncrements
            && lhs.fuzziness == rhs.fuzziness
            && lhs.fuzzyMaxExpansions == rhs.fuzzyMaxExpansions
            && lhs.fuzzyPrefixLength == rhs.fuzzyPrefixLength
            && lhs.fuzzyTranspositions == rhs.fuzzyTranspositions
            && lhs.lenient == rhs.lenient
            && lhs.maxDeterminizedStates == rhs.maxDeterminizedStates
            && lhs.minimumShouldMatch == rhs.minimumShouldMatch
            && lhs.phraseSlop == rhs.phraseSlop
            && lhs.quoteAnalyzer == rhs.quoteAnalyzer
            && lhs.timeZone == rhs.timeZone
            && lhs.name == rhs.name
    }
}

// MARK: - SimpleQueryStringQuery

public struct SimpleQueryStringQuery: Query {
    public let queryType: QueryType = QueryTypes.simpleQueryString

    public let query: String
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
    public var boost: Decimal?
    public var name: String?

    public init(query: String, fields: [String]? = nil, defaultOperator: String? = nil, analyzer: String? = nil, flags: String? = nil, lenient: Bool? = nil, minimumShouldMatch: Int? = nil, fuzzyMaxExpansions: Int? = nil, fuzzyPrefixLength: Int? = nil, fuzzyTranspositions: Bool? = nil, quoteFieldSuffix: String? = nil, autoGenerateSynonymsPhraseQuery: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.query = query
        self.fields = fields
        self.defaultOperator = defaultOperator
        self.analyzer = analyzer
        self.flags = flags
        self.lenient = lenient
        self.minimumShouldMatch = minimumShouldMatch
        self.fuzzyMaxExpansions = fuzzyMaxExpansions
        self.fuzzyPrefixLength = fuzzyPrefixLength
        self.fuzzyTranspositions = fuzzyTranspositions
        self.quoteFieldSuffix = quoteFieldSuffix
        self.autoGenerateSynonymsPhraseQuery = autoGenerateSynonymsPhraseQuery
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SimpleQueryStringQueryBuilder) throws {
        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(query: builder.query!, fields: builder.fields, defaultOperator: builder.defaultOperator, analyzer: builder.analyzer, flags: builder.flags, lenient: builder.lenient, minimumShouldMatch: builder.minimumShouldMatch, fuzzyMaxExpansions: builder.fuzzyMaxExpansions, fuzzyPrefixLength: builder.fuzzyPrefixLength, fuzzyTranspositions: builder.fuzzyTranspositions, quoteFieldSuffix: builder.quoteFieldSuffix, autoGenerateSynonymsPhraseQuery: builder.autoGenerateSynonymsPhraseQuery, boost: builder.boost, name: builder.name)
    }
}

public extension SimpleQueryStringQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        query = try nested.decodeString(forKey: .query)
        fields = try nested.decodeArrayIfPresent(forKey: .fields)
        defaultOperator = try nested.decodeStringIfPresent(forKey: .defaultOperator)
        analyzer = try nested.decodeStringIfPresent(forKey: .analyzer)
        flags = try nested.decodeStringIfPresent(forKey: .flags)
        lenient = try nested.decodeBoolIfPresent(forKey: .lenient)
        minimumShouldMatch = try nested.decodeIntIfPresent(forKey: .minimumShouldMatch)
        fuzzyMaxExpansions = try nested.decodeIntIfPresent(forKey: .fuzzyMaxExpansions)
        fuzzyPrefixLength = try nested.decodeIntIfPresent(forKey: .fuzzyPrefixLength)
        fuzzyTranspositions = try nested.decodeBoolIfPresent(forKey: .fuzzyTranspositions)
        quoteFieldSuffix = try nested.decodeStringIfPresent(forKey: .quoteFieldSuffix)
        autoGenerateSynonymsPhraseQuery = try nested.decodeBoolIfPresent(forKey: .autoGenerateSynonymsPhraseQuery)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        try nested.encode(query, forKey: .query)
        try nested.encodeIfPresent(fields, forKey: .fields)
        try nested.encodeIfPresent(defaultOperator, forKey: .defaultOperator)
        try nested.encodeIfPresent(analyzer, forKey: .analyzer)
        try nested.encodeIfPresent(fuzzyMaxExpansions, forKey: .fuzzyMaxExpansions)
        try nested.encodeIfPresent(fuzzyPrefixLength, forKey: .fuzzyPrefixLength)
        try nested.encodeIfPresent(fuzzyTranspositions, forKey: .fuzzyTranspositions)
        try nested.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        try nested.encodeIfPresent(flags, forKey: .flags)
        try nested.encodeIfPresent(lenient, forKey: .lenient)
        try nested.encodeIfPresent(quoteFieldSuffix, forKey: .quoteFieldSuffix)
        try nested.encodeIfPresent(autoGenerateSynonymsPhraseQuery, forKey: .autoGenerateSynonymsPhraseQuery)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case query
        case fields
        case defaultOperator = "default_operator"
        case analyzer
        case flags
        case fuzzyMaxExpansions = "fuzzy_max_expansions"
        case fuzzyPrefixLength = "fuzzy_prefix_length"
        case fuzzyTranspositions = "fuzzy_transpositions"
        case minimumShouldMatch = "minimum_should_match"
        case lenient
        case quoteFieldSuffix = "quote_field_suffix"
        case autoGenerateSynonymsPhraseQuery = "auto_generate_synonyms_phrase_query"
        case name
        case boost
    }
}

extension SimpleQueryStringQuery: Equatable {
    public static func == (lhs: SimpleQueryStringQuery, rhs: SimpleQueryStringQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.query == rhs.query
            && lhs.analyzer == rhs.analyzer
            && lhs.autoGenerateSynonymsPhraseQuery == rhs.autoGenerateSynonymsPhraseQuery
            && lhs.defaultOperator == rhs.defaultOperator
            && lhs.fields == rhs.fields
            && lhs.flags == rhs.flags
            && lhs.fuzzyMaxExpansions == rhs.fuzzyMaxExpansions
            && lhs.fuzzyPrefixLength == rhs.fuzzyPrefixLength
            && lhs.fuzzyTranspositions == rhs.fuzzyTranspositions
            && lhs.lenient == rhs.lenient
            && lhs.minimumShouldMatch == rhs.minimumShouldMatch
            && lhs.quoteFieldSuffix == rhs.quoteFieldSuffix
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}
