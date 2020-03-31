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
    public let `operator`: MatchQueryOperator?
    public let zeroTermQuery: ZeroTermQuery?
    public let cutoffFrequency: Decimal?
    public let fuzziness: Fuzziness?
    public let autoGenSynonymnsPhraseQuery: Bool?
    public let boost: Decimal?

    public init(field: String, value: String, boost: Decimal? = nil, operator: MatchQueryOperator? = nil, zeroTermQuery: ZeroTermQuery? = nil, cutoffFrequency: Decimal? = nil, fuzziness: Fuzziness? = nil, autoGenSynonymnsPhraseQuery: Bool? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
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

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, operator: builder.operator, zeroTermQuery: builder.zeroTermQuery, cutoffFrequency: builder.cutoffFrequency, fuzziness: builder.fuzziness, autoGenSynonymnsPhraseQuery: builder.autoGenSynonymnsPhraseQuery)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic[CodingKeys.query.rawValue] = value
        if let boost = self.boost {
            dic[CodingKeys.boost.rawValue] = boost
        }
        if let `operator` = self.operator {
            dic[CodingKeys.operator.rawValue] = `operator`.rawValue
        }
        if let zeroTermQuery = self.zeroTermQuery {
            dic[CodingKeys.zeroTermsQuery.rawValue] = zeroTermQuery.rawValue
        }
        if let cutoffFrequency = self.cutoffFrequency {
            dic[CodingKeys.cutoffFrequency.rawValue] = cutoffFrequency
        }
        if let fuzziness = self.fuzziness {
            dic[CodingKeys.fuzziness.rawValue] = fuzziness.rawValue
        }
        if let autoGenSynonymnsPhraseQuery = self.autoGenSynonymnsPhraseQuery {
            dic[CodingKeys.autoGenerateSynonymsPhraseQuery.rawValue] = autoGenSynonymnsPhraseQuery
        }
        return [queryType.name: [field: dic]]
    }
}

extension MatchQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .query)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
            `operator` = try fieldContainer.decodeIfPresent(MatchQueryOperator.self, forKey: .operator)
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
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .query)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(`operator`, forKey: .operator)
        try fieldContainer.encodeIfPresent(zeroTermQuery, forKey: .zeroTermsQuery)
        try fieldContainer.encodeIfPresent(cutoffFrequency, forKey: .cutoffFrequency)
        try fieldContainer.encodeIfPresent(fuzziness, forKey: .fuzziness)
        try fieldContainer.encodeIfPresent(autoGenSynonymnsPhraseQuery, forKey: .autoGenerateSynonymsPhraseQuery)
    }

    enum CodingKeys: String, CodingKey {
        case query
        case boost
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
    }
}

// MARK: - MatchPhraseQuery

public struct MatchPhraseQuery: Query {
    public let queryType: QueryType = QueryTypes.matchPhrase

    public let field: String
    public let value: String
    public let analyzer: String?

    public init(field: String, value: String, analyzer: String? = nil) {
        self.field = field
        self.value = value
        self.analyzer = analyzer
    }

    internal init(withBuilder builder: MatchPhraseQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, analyzer: builder.analyzer)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        if let analyzer = analyzer {
            dic[queryType.name] = [field: [CodingKeys.query.rawValue: value,
                                           CodingKeys.analyzer.rawValue: analyzer]]
        } else {
            dic[queryType.name] = [field: value]
        }
        return dic
    }
}

extension MatchPhraseQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchPhraseQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .query)
            analyzer = try fieldContainer.decodeStringIfPresent(forKey: .analyzer)
        } else {
            var fieldContainer = try nested.nestedUnkeyedContainer(forKey: .key(named: field))
            value = try fieldContainer.decode(String.self)
            analyzer = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard analyzer != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .query)
        try fieldContainer.encode(analyzer, forKey: .analyzer)
    }

    enum CodingKeys: String, CodingKey {
        case query
        case analyzer
    }
}

extension MatchPhraseQuery: Equatable {
    public static func == (lhs: MatchPhraseQuery, rhs: MatchPhraseQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.analyzer == rhs.analyzer
    }
}

// MARK: - MatchPhrasePrefixQuery

public struct MatchPhrasePrefixQuery: Query {
    public let queryType: QueryType = QueryTypes.matchPhrasePrefix

    public let field: String
    public let value: String
    public let maxExpansions: Int?

    public init(field: String, value: String, maxExpansions: Int? = nil) {
        self.field = field
        self.value = value
        self.maxExpansions = maxExpansions
    }

    internal init(withBuilder builder: MatchPhrasePrefixQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, maxExpansions: builder.maxExpansions)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        if let maxExpansions = maxExpansions {
            dic[queryType.name] = [field: [CodingKeys.query.rawValue: value,
                                           CodingKeys.maxExpansions.rawValue: maxExpansions]]
        } else {
            dic[queryType.name] = [field: value]
        }
        return dic
    }
}

extension MatchPhrasePrefixQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchPhraseQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .query)
            maxExpansions = try fieldContainer.decodeIntIfPresent(forKey: .maxExpansions)
        } else {
            var fieldContainer = try nested.nestedUnkeyedContainer(forKey: .key(named: field))
            value = try fieldContainer.decode(String.self)
            maxExpansions = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard maxExpansions != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .query)
        try fieldContainer.encode(maxExpansions, forKey: .maxExpansions)
    }

    enum CodingKeys: String, CodingKey {
        case query
        case maxExpansions = "max_expansions"
    }
}

extension MatchPhrasePrefixQuery: Equatable {
    public static func == (lhs: MatchPhrasePrefixQuery, rhs: MatchPhrasePrefixQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.maxExpansions == rhs.maxExpansions
    }
}

// MARK: - MultiMatchQuery

public struct MultiMatchQuery: Query {
    public let queryType: QueryType = QueryTypes.multiMatch

    public let tieBreaker: Decimal?
    public let type: MultiMatchQueryType?
    public let query: String
    public let fields: [String]

    internal init(query: String, fields: [String], tieBreaker: Decimal?, type: MultiMatchQueryType?) {
        self.tieBreaker = tieBreaker
        self.type = type
        self.query = query
        self.fields = fields
    }

    public init(withBuilder builder: MultiMatchQueryBuilder) throws {
        guard !builder.fields.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("fields")
        }

        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(query: builder.query!, fields: builder.fields, tieBreaker: builder.tieBreaker, type: builder.type)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic[CodingKeys.query.rawValue] = query
        dic[CodingKeys.fields.rawValue] = fields
        if let type = self.type {
            dic[CodingKeys.type.rawValue] = type
        }
        if let tieBreaker = self.tieBreaker {
            dic[CodingKeys.tieBreaker.rawValue] = tieBreaker
        }
        return [queryType.name: dic]
    }
}

extension MultiMatchQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        query = try nested.decodeString(forKey: .query)
        fields = try nested.decodeArray(forKey: .fields)
        type = try nested.decodeIfPresent(MultiMatchQueryType.self, forKey: .type)
        tieBreaker = try nested.decodeDecimalIfPresent(forKey: .tieBreaker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        try nested.encode(query, forKey: .query)
        try nested.encode(fields, forKey: .fields)
        try nested.encodeIfPresent(type, forKey: .type)
        try nested.encodeIfPresent(tieBreaker, forKey: .tieBreaker)
    }

    enum CodingKeys: String, CodingKey {
        case query
        case fields
        case tieBreaker = "tie_breaker"
        case type
    }
}

extension MultiMatchQuery: Equatable {
    public static func == (lhs: MultiMatchQuery, rhs: MultiMatchQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.query == rhs.query
            && lhs.fields == rhs.fields
            && lhs.tieBreaker == rhs.tieBreaker
            && lhs.type == rhs.type
    }
}

// MARK: - CommonTermsQuery

public struct CommonTermsQuery: Query {
    private static let BODY = "body"

    public let queryType: QueryType = QueryTypes.common

    public let query: String
    public let cutoffFrequency: Decimal
    public let lowFrequencyOperator: String?
    public let highFrequencyOperator: String?
    public let minimumShouldMatch: Int?
    public let minimumShouldMatchLowFreq: Int?
    public let minimumShouldMatchHighFreq: Int?

    public init(query: String, cutoffFrequency: Decimal, lowFrequencyOperator: String? = nil, highFrequencyOperator: String? = nil, minimumShouldMatch: Int? = nil, minimumShouldMatchLowFreq: Int? = nil, minimumShouldMatchHighFreq: Int? = nil) {
        self.query = query
        self.cutoffFrequency = cutoffFrequency
        self.lowFrequencyOperator = lowFrequencyOperator
        self.highFrequencyOperator = highFrequencyOperator
        self.minimumShouldMatch = minimumShouldMatch
        self.minimumShouldMatchLowFreq = minimumShouldMatchLowFreq
        self.minimumShouldMatchHighFreq = minimumShouldMatchHighFreq
    }

    internal init(withBuilder builder: CommonTermsQueryBuilder) throws {
        guard builder.cutoffFrequency != nil else {
            throw QueryBuilderError.atlestOneElementRequired("cutoffFrequency")
        }

        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(query: builder.query!, cutoffFrequency: builder.cutoffFrequency!, lowFrequencyOperator: builder.lowFrequencyOperator, highFrequencyOperator: builder.highFrequencyOperator, minimumShouldMatch: builder.minimumShouldMatch, minimumShouldMatchLowFreq: builder.minimumShouldMatchLowFreq, minimumShouldMatchHighFreq: builder.minimumShouldMatchHighFreq)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic[CodingKeys.query.rawValue] = query
        dic[CodingKeys.cutoffFrequency.rawValue] = cutoffFrequency
        if let lowFrequencyOperator = self.lowFrequencyOperator {
            dic[CodingKeys.lowFreqOperator.rawValue] = lowFrequencyOperator
        }
        if let highFrequencyOperator = self.highFrequencyOperator {
            dic[CodingKeys.highFreqOperator.rawValue] = highFrequencyOperator
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[CodingKeys.minimumShouldMatch.rawValue] = minimumShouldMatch
        }
        if let minHighFreq = minimumShouldMatchHighFreq, let minLowFreq = minimumShouldMatchLowFreq {
            dic[CodingKeys.minimumShouldMatch.rawValue] = [
                CodingKeys.lowFreq.rawValue: minHighFreq,
                CodingKeys.highFreq.rawValue: minLowFreq,
            ]
        }
        return [queryType.name: [CommonTermsQuery.BODY: dic]]
    }
}

extension CommonTermsQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        let bodyContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: CommonTermsQuery.BODY))

        query = try bodyContainer.decodeString(forKey: .query)
        cutoffFrequency = try bodyContainer.decodeDecimal(forKey: .cutoffFrequency)
        lowFrequencyOperator = try bodyContainer.decodeStringIfPresent(forKey: .lowFreqOperator)
        highFrequencyOperator = try bodyContainer.decodeStringIfPresent(forKey: .highFreqOperator)
        if let minShouldMatch = try? bodyContainer.decodeIntIfPresent(forKey: .minimumShouldMatch) {
            minimumShouldMatch = minShouldMatch
            minimumShouldMatchLowFreq = nil
            minimumShouldMatchHighFreq = nil
        } else {
            let minContainer = try? bodyContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .minimumShouldMatch)
            minimumShouldMatchLowFreq = try minContainer?.decodeIntIfPresent(forKey: .lowFreq)
            minimumShouldMatchHighFreq = try minContainer?.decodeIntIfPresent(forKey: .highFreq)
            minimumShouldMatch = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var bodyContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: CommonTermsQuery.BODY))

        try bodyContainer.encode(query, forKey: .query)
        try bodyContainer.encode(cutoffFrequency, forKey: .cutoffFrequency)
        try bodyContainer.encodeIfPresent(lowFrequencyOperator, forKey: .lowFreqOperator)
        try bodyContainer.encodeIfPresent(highFrequencyOperator, forKey: .highFreqOperator)
        try bodyContainer.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        if let minHighFreq = minimumShouldMatchHighFreq, let minLowFreq = minimumShouldMatchLowFreq {
            var minShouldMatchContainer = bodyContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .minimumShouldMatch)
            try minShouldMatchContainer.encode(minLowFreq, forKey: .lowFreq)
            try minShouldMatchContainer.encode(minHighFreq, forKey: .highFreq)
        }
    }

    enum CodingKeys: String, CodingKey {
        case query
        case cutoffFrequency = "cutoff_frequency"
        case lowFreqOperator
        case highFreqOperator = "high_freq_operator"
        case minimumShouldMatch = "minimum_should_match"
        case lowFreq = "low_freq"
        case highFreq = "high_freq"
    }
}

extension CommonTermsQuery: Equatable {
    public static func == (lhs: CommonTermsQuery, rhs: CommonTermsQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.query == rhs.query
            && lhs.cutoffFrequency == rhs.cutoffFrequency
            && lhs.highFrequencyOperator == rhs.highFrequencyOperator
            && lhs.lowFrequencyOperator == rhs.lowFrequencyOperator
            && lhs.minimumShouldMatch == rhs.minimumShouldMatch
            && lhs.minimumShouldMatchLowFreq == rhs.minimumShouldMatchLowFreq
            && lhs.minimumShouldMatchHighFreq == rhs.minimumShouldMatchHighFreq
    }
}

// MARK: - QueryStringQuery

public struct QueryStringQuery: Query {
    public let queryType: QueryType = QueryTypes.queryString

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

    public init(_ value: String, defaultField: String? = nil, defaultOperator: String? = nil, analyzer: String? = nil, quoteAnalyzer: String? = nil, allowLeadingWildcard: Bool? = nil, enablePositionIncrements: Bool? = nil, fuzzyMaxExpansions: Int? = nil, fuzziness: String? = nil, fuzzyPrefixLength: Int? = nil, fuzzyTranspositions: Bool? = nil, phraseSlop: Int? = nil, boost: Decimal? = nil, autoGeneratePhraseQueries: Bool? = nil, analyzeWildcard: Bool? = nil, maxDeterminizedStates: Int? = nil, minimumShouldMatch: Int? = nil, lenient: Bool? = nil, timeZone: String? = nil, quoteFieldSuffix: String? = nil, autoGenerateSynonymsPhraseQuery: Bool? = nil) {
        self.defaultField = defaultField
        self.value = value
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
    }

    internal init(withBuilder builder: QueryStringQueryBuilder) throws {
        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(builder.value!, defaultField: builder.defaultField, defaultOperator: builder.defaultOperator, analyzer: builder.analyzer, quoteAnalyzer: builder.quoteAnalyzer, allowLeadingWildcard: builder.allowLeadingWildcard, enablePositionIncrements: builder.enablePositionIncrements, fuzzyMaxExpansions: builder.fuzzyMaxExpansions, fuzziness: builder.fuzziness, fuzzyPrefixLength: builder.fuzzyPrefixLength, fuzzyTranspositions: builder.fuzzyTranspositions, phraseSlop: builder.phraseSlop, boost: builder.boost, autoGeneratePhraseQueries: builder.autoGeneratePhraseQueries, analyzeWildcard: builder.analyzeWildcard, maxDeterminizedStates: builder.maxDeterminizedStates, minimumShouldMatch: builder.minimumShouldMatch, lenient: builder.lenient, timeZone: builder.timeZone, quoteFieldSuffix: builder.quoteFieldSuffix, autoGenerateSynonymsPhraseQuery: builder.autoGenerateSynonymsPhraseQuery)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic[CodingKeys.query.rawValue] = value
        if let defaultField = self.defaultField {
            dic[CodingKeys.defaultField.rawValue] = defaultField
        }
        if let defaultOperator = self.defaultOperator {
            dic[CodingKeys.defaultOperator.rawValue] = defaultOperator
        }
        if let analyzer = self.analyzer {
            dic[CodingKeys.analyzer.rawValue] = analyzer
        }
        if let quoteAnalyzer = self.quoteAnalyzer {
            dic[CodingKeys.quoteAnalyzer.rawValue] = quoteAnalyzer
        }
        if let allowLeadingWildCard = allowLeadingWildcard {
            dic[CodingKeys.allowLeadingWildcard.rawValue] = allowLeadingWildCard
        }
        if let enablePositionIncrements = self.enablePositionIncrements {
            dic[CodingKeys.enablePositionIncrements.rawValue] = enablePositionIncrements
        }
        if let fuzzyMaxExpantions = fuzzyMaxExpansions {
            dic[CodingKeys.fuzzyMaxExpansions.rawValue] = fuzzyMaxExpantions
        }
        if let fuzzines = fuzziness {
            dic[CodingKeys.fuzziness.rawValue] = fuzzines
        }
        if let fuzzyPrefixLength = self.fuzzyPrefixLength {
            dic[CodingKeys.fuzzyPrefixLength.rawValue] = fuzzyPrefixLength
        }
        if let fuzzyTranspositions = self.fuzzyTranspositions {
            dic[CodingKeys.fuzzyTranspositions.rawValue] = fuzzyTranspositions
        }
        if let phraseSlop = self.phraseSlop {
            dic[CodingKeys.phraseSlop.rawValue] = phraseSlop
        }
        if let boost = self.boost {
            dic[CodingKeys.boost.rawValue] = boost
        }
        if let autoGeneratePhraseQuries = autoGeneratePhraseQueries {
            dic[CodingKeys.autoGeneratePhraseQueries.rawValue] = autoGeneratePhraseQuries
        }
        if let analyzeWildCard = analyzeWildcard {
            dic[CodingKeys.analyzeWildcard.rawValue] = analyzeWildCard
        }
        if let maxDeterminedStates = maxDeterminizedStates {
            dic[CodingKeys.maxDeterminizedStates.rawValue] = maxDeterminedStates
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[CodingKeys.minimumShouldMatch.rawValue] = minimumShouldMatch
        }
        if let lenient = self.lenient {
            dic[CodingKeys.lenient.rawValue] = lenient
        }
        if let timeZone = self.timeZone {
            dic[CodingKeys.timeZone.rawValue] = timeZone
        }
        if let quoteFieldSuffix = self.quoteFieldSuffix {
            dic[CodingKeys.quoteFieldSuffix.rawValue] = quoteFieldSuffix
        }
        if let autoGenerateSynonymsPhraseQuery = self.autoGenerateSynonymsPhraseQuery {
            dic[CodingKeys.autoGenerateSynonymsPhraseQuery.rawValue] = autoGenerateSynonymsPhraseQuery
        }
        return [queryType.name: dic]
    }
}

extension QueryStringQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        value = try nested.decodeString(forKey: .query)
        defaultField = try nested.decodeStringIfPresent(forKey: .defaultField)
        defaultOperator = try nested.decodeStringIfPresent(forKey: .defaultField)
        analyzer = try nested.decodeStringIfPresent(forKey: .defaultField)
        quoteAnalyzer = try nested.decodeStringIfPresent(forKey: .defaultField)
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
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(value, forKey: .query)
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
    }

    enum CodingKeys: String, CodingKey {
        case query
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
    }
}

extension QueryStringQuery: Equatable {
    public static func == (lhs: QueryStringQuery, rhs: QueryStringQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.value == rhs.value
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

    public init(query: String, fields: [String]? = nil, defaultOperator: String? = nil, analyzer: String? = nil, flags: String? = nil, lenient: Bool? = nil, minimumShouldMatch: Int? = nil, fuzzyMaxExpansions: Int? = nil, fuzzyPrefixLength: Int? = nil, fuzzyTranspositions: Bool? = nil, quoteFieldSuffix: String? = nil, autoGenerateSynonymsPhraseQuery: Bool? = nil) {
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
    }

    internal init(withBuilder builder: SimpleQueryStringQueryBuilder) throws {
        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(query: builder.query!, fields: builder.fields, defaultOperator: builder.defaultOperator, analyzer: builder.analyzer, flags: builder.flags, lenient: builder.lenient, minimumShouldMatch: builder.minimumShouldMatch, fuzzyMaxExpansions: builder.fuzzyMaxExpansions, fuzzyPrefixLength: builder.fuzzyPrefixLength, fuzzyTranspositions: builder.fuzzyTranspositions, quoteFieldSuffix: builder.quoteFieldSuffix, autoGenerateSynonymsPhraseQuery: builder.autoGenerateSynonymsPhraseQuery)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic[CodingKeys.query.rawValue] = query
        if let fields = self.fields {
            dic[CodingKeys.fields.rawValue] = fields
        }
        if let defaultOperator = self.defaultOperator {
            dic[CodingKeys.defaultOperator.rawValue] = defaultOperator
        }
        if let analyzer = self.analyzer {
            dic[CodingKeys.analyzer.rawValue] = analyzer
        }
        if let fuzzyMaxExpantions = fuzzyMaxExpansions {
            dic[CodingKeys.fuzzyMaxExpansions.rawValue] = fuzzyMaxExpantions
        }
        if let fuzzyPrefixLength = self.fuzzyPrefixLength {
            dic[CodingKeys.fuzzyPrefixLength.rawValue] = fuzzyPrefixLength
        }
        if let fuzzyTranspositions = self.fuzzyTranspositions {
            dic[CodingKeys.fuzzyTranspositions.rawValue] = fuzzyTranspositions
        }
        if let minimumShouldMatch = self.minimumShouldMatch {
            dic[CodingKeys.minimumShouldMatch.rawValue] = minimumShouldMatch
        }
        if let flags = self.flags {
            dic[CodingKeys.flags.rawValue] = flags
        }
        if let lenient = self.lenient {
            dic[CodingKeys.lenient.rawValue] = lenient
        }
        if let quoteFieldSuffix = self.quoteFieldSuffix {
            dic[CodingKeys.quoteFieldSuffix.rawValue] = quoteFieldSuffix
        }
        if let autoGenerateSynonymsPhraseQuery = self.autoGenerateSynonymsPhraseQuery {
            dic[CodingKeys.autoGenerateSynonymsPhraseQuery.rawValue] = autoGenerateSynonymsPhraseQuery
        }
        return [queryType.name: dic]
    }
}

extension SimpleQueryStringQuery {
    public init(from decoder: Decoder) throws {
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
    }

    public func encode(to encoder: Encoder) throws {
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
    }

    enum CodingKeys: String, CodingKey {
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
    }
}

public enum MultiMatchQueryType: String, Codable {
    case bestFields = "best_fields"
    case mostFields = "most_fields"
    case crossFields = "cross_fields"
    case phrase
    case phrasePrefix = "phrase_prefix"
}

public enum MatchQueryOperator: String, Codable {
    case and
    case or
}

public enum ZeroTermQuery: String, Codable {
    case none
    case all
}
