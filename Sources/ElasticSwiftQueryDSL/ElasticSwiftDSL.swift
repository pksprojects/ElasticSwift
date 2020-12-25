

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - Query Types

public enum QueryTypes: String, Codable {
    case matchAll = "match_all"
    case matchNone = "match_none"
    case constantScore = "constant_score"
    case bool
    case disMax = "dis_max"
    case functionScore = "function_score"
    case boosting
    case match
    case matchPhrase = "match_phrase"
    case matchPhrasePrefix = "match_phrase_prefix"
    case multiMatch = "multi_match"
    case common
    case queryString = "query_string"
    case simpleQueryString = "simple_query_string"
    case term
    case terms
    case range
    case exists
    case prefix
    case wildcard
    case regexp
    case fuzzy
    case type
    case ids
    case nested
    case hasChild = "has_child"
    case hasParent = "has_parent"
    case parentId = "parent_id"
    case geoShape = "geo_shape"
    case geoBoundingBox = "geo_bounding_box"
    case geoDistance = "geo_distance"
    case geoPolygon = "geo_polygon"
    case moreLikeThis = "more_like_this"
    case script
    case percolate
    case wrapper
    case spanTerm = "span_term"
    case spanMulti = "span_multi"
    case spanFirst = "span_first"
    case spanNear = "span_near"
    case spanOr = "span_or"
    case spanNot = "span_not"
    case spanContaining = "span_containing"
    case spanWithin = "span_within"
    case spanFieldMasking = "field_masking_span"
}

extension QueryTypes: QueryType {
    public var metaType: Query.Type {
        switch self {
        case .matchAll:
            return MatchAllQuery.self
        case .matchNone:
            return MatchNoneQuery.self
        case .constantScore:
            return ConstantScoreQuery.self
        case .bool:
            return BoolQuery.self
        case .disMax:
            return DisMaxQuery.self
        case .functionScore:
            return FunctionScoreQuery.self
        case .boosting:
            return BoostingQuery.self
        case .match:
            return MatchQuery.self
        case .matchPhrase:
            return MatchPhraseQuery.self
        case .matchPhrasePrefix:
            return MatchPhrasePrefixQuery.self
        case .multiMatch:
            return MultiMatchQuery.self
        case .common:
            return CommonTermsQuery.self
        case .queryString:
            return QueryStringQuery.self
        case .simpleQueryString:
            return SimpleQueryStringQuery.self
        case .term:
            return TermQuery.self
        case .terms:
            return TermsQuery.self
        case .range:
            return RangeQuery.self
        case .exists:
            return ExistsQuery.self
        case .prefix:
            return PrefixQuery.self
        case .wildcard:
            return WildCardQuery.self
        case .regexp:
            return RegexpQuery.self
        case .fuzzy:
            return FuzzyQuery.self
        case .type:
            return TypeQuery.self
        case .ids:
            return IdsQuery.self
        case .nested:
            return NestedQuery.self
        case .hasChild:
            return HasChildQuery.self
        case .hasParent:
            return HasParentQuery.self
        case .parentId:
            return ParentIdQuery.self
        case .geoShape:
            return GeoShapeQuery.self
        case .geoBoundingBox:
            return GeoBoundingBoxQuery.self
        case .geoDistance:
            return GeoDistanceQuery.self
        case .geoPolygon:
            return GeoPolygonQuery.self
        case .moreLikeThis:
            return MoreLikeThisQuery.self
        case .script:
            return ScriptQuery.self
        case .percolate:
            return PercolateQuery.self
        case .wrapper:
            return WrapperQuery.self
        case .spanTerm:
            return SpanTermQuery.self
        case .spanMulti:
            return SpanMultiTermQuery.self
        case .spanFirst:
            return SpanFirstQuery.self
        case .spanNear:
            return SpanNearQuery.self
        case .spanOr:
            return SpanOrQuery.self
        case .spanNot:
            return SpanNotQuery.self
        case .spanContaining:
            return SpanContainingQuery.self
        case .spanWithin:
            return SpanWithinQuery.self
        case .spanFieldMasking:
            return SpanFieldMaskingQuery.self
        }
    }
}

// MARK: - Score Function Types

public enum ScoreFunctionType: String, Codable {
    case weight
    case randomScore = "random_score"
    case scriptScore = "script_score"
    case linear
    case gauss
    case exp
    case fieldValueFactor = "field_value_factor"

    var metaType: ScoreFunction.Type {
        switch self {
        case .weight:
            return WeightScoreFunction.self
        case .randomScore:
            return RandomScoreFunction.self
        case .scriptScore:
            return ScriptScoreFunction.self
        case .linear:
            return LinearDecayScoreFunction.self
        case .gauss:
            return GaussScoreFunction.self
        case .exp:
            return ExponentialDecayScoreFunction.self
        case .fieldValueFactor:
            return FieldValueFactorScoreFunction.self
        }
    }
}

// MARK: - SCRIPT

public struct Script: Codable, Equatable {
    public let source: String
    public let lang: String?
    public let params: [String: CodableValue]?

    public init(_ source: String, lang: String? = nil, params: [String: CodableValue]? = nil) {
        self.source = source
        self.lang = lang
        self.params = params
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            source = try container.decodeString(forKey: .source)
            lang = try container.decodeStringIfPresent(forKey: .lang)
            params = try container.decodeIfPresent([String: CodableValue].self, forKey: .params)
            return
        } else if let container = try? decoder.singleValueContainer() {
            source = try container.decodeString()
            params = nil
            lang = nil
            return
        } else {
            throw Swift.DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unable to decode Script as String/Dic"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        if lang == nil, params == nil {
            var container = encoder.singleValueContainer()
            try container.encode(source)
            return
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(lang, forKey: .lang)
        try container.encodeIfPresent(params, forKey: .params)
    }

    enum CodingKeys: String, CodingKey {
        case source
        case lang
        case params
    }
}

// MARK: - Script Type

public enum ScriptType: String, Codable {
    case inline
    case stored
}

// MARK: - Enums

public enum Fuzziness: String, Codable {
    case zero = "ZERO"
    case one = "ONE"
    case two = "TWO"
    case auto = "AUTO"
}

public enum ShapeRelation: String, Codable {
    case intersects
    case disjoint
    case within
    case contains
}

public enum RegexFlag: String, Codable {
    case intersection = "INTERSECTION"
    case complement = "COMPLEMENT"
    case empty = "EMPTY"
    case anyString = "ANYSTRING"
    case interval = "INTERVAL"
    case none = "NONE"
    case all = "ALL"
}

public enum ScoreMode: String, Codable {
    case first
    case avg
    case max
    case sum
    case min
    case multiply
    case total
}

public enum BoostMode: String, Codable {
    case multiply
    case replace
    case sum
    case avg
    case min
    case max
}

public enum MultiMatchQueryType: String, Codable {
    case bestFields = "best_fields"
    case mostFields = "most_fields"
    case crossFields = "cross_fields"
    case phrase
    case phrasePrefix = "phrase_prefix"
}

public enum ZeroTermQuery: String, Codable {
    case none
    case all
}

public enum Operator: String, Codable {
    case and
    case or
}

/// A helper function compares two queries wrapped as optional
public func isEqualQueries(_ lhs: Query?, _ rhs: Query?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    if let lhs = lhs, let rhs = rhs {
        return lhs.isEqualTo(rhs)
    }
    return false
}

/// Extention for DynamicCodingKeys
public extension DynamicCodingKeys {
    static func key(named queryType: QueryType) -> DynamicCodingKeys {
        return .key(named: queryType.name)
    }

    static func key(named scoreFunctionType: ScoreFunctionType) -> DynamicCodingKeys {
        return .key(named: scoreFunctionType.rawValue)
    }
}

// MARK: - Codable Extenstions

public extension KeyedEncodingContainer {
    mutating func encode(_ value: Query, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    mutating func encode(_ value: ScoreFunction, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    mutating func encode(_ value: [Query], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let queriesEncoder = superEncoder(forKey: key)
        var queriesContainer = queriesEncoder.unkeyedContainer()
        for query in value {
            let queryEncoder = queriesContainer.superEncoder()
            try query.encode(to: queryEncoder)
        }
    }

    mutating func encode(_ value: [ScoreFunction], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let scoreFunctionEncoder = superEncoder(forKey: key)
        var scoreFunctionsContainer = scoreFunctionEncoder.unkeyedContainer()
        for scoreFunction in value {
            let scoreFunctionEncoder = scoreFunctionsContainer.superEncoder()
            try scoreFunction.encode(to: scoreFunctionEncoder)
        }
    }

    mutating func encodeIfPresent(_ value: Query?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try value.encode(to: superEncoder(forKey: key))
        }
    }

    mutating func encodeIfPresent(_ value: ScoreFunction?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }

    mutating func encodeIfPresent(_ value: [Query]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }

    mutating func encodeIfPresent(_ value: [ScoreFunction]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}

public extension KeyedDecodingContainer {
    func decodeQuery(forKey key: KeyedDecodingContainer<K>.Key) throws -> Query {
        let qContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for qKey in qContainer.allKeys {
            if let qType = QueryTypes(qKey.stringValue) {
                return try qType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(QueryTypes.self, .init(codingPath: codingPath, debugDescription: "Unable to identify query type from key(s) \(qContainer.allKeys)"))
    }

    func decodeQueryIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Query? {
        guard contains(key) else {
            return nil
        }
        return try decodeQuery(forKey: key)
    }

    func decodeQueries(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Query] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [Query]()
        if let count = arrayContainer.count {
            while !arrayContainer.isAtEnd {
                let query = try arrayContainer.decodeQuery()
                result.append(query)
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all Queries expected: \(count) actual: \(result.count). Probable cause: Unable to determine QueryType form key(s)"))
            }
        }
        return result
    }

    func decodeQueriesIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Query]? {
        guard contains(key) else {
            return nil
        }

        return try decodeQueries(forKey: key)
    }

    func decodeScoreFunction(forKey key: KeyedDecodingContainer<K>.Key) throws -> ScoreFunction {
        let fContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)

        for fKey in fContainer.allKeys {
            if let fType = ScoreFunctionType(rawValue: fKey.stringValue) {
                return try fType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(ScoreFunctionType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify score function type from key(s) \(fContainer.allKeys)"))
    }

    func decodeScoreFunctionIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> ScoreFunction? {
        guard contains(key) else {
            return nil
        }
        return try decodeScoreFunction(forKey: key)
    }

    func decodeScoreFunctions(forKey key: KeyedDecodingContainer<K>.Key) throws -> [ScoreFunction] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [ScoreFunction]()
        if let count = arrayContainer.count {
            while !arrayContainer.isAtEnd {
                let function = try arrayContainer.decodeScoreFunction()
                result.append(function)
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all ScoreFunctions expected: \(count) actual: \(result.count). Probable cause: Unable to determine ScoreFunctionType form key(s)"))
            }
        }
        return result
    }

    func decodeScoreFunctionsIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [ScoreFunction]? {
        guard contains(key) else {
            return nil
        }

        return try decodeScoreFunctions(forKey: key)
    }
}

extension UnkeyedDecodingContainer {
    mutating func decodeQuery() throws -> Query {
        var copy = self
        let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
        for qKey in elementContainer.allKeys {
            if let qType = QueryTypes(qKey.stringValue) {
                return try qType.metaType.init(from: superDecoder())
            }
        }
        throw Swift.DecodingError.typeMismatch(QueryTypes.self, .init(codingPath: codingPath, debugDescription: "Unable to identify query type from key(s) \(elementContainer.allKeys)"))
    }

    mutating func decodeScoreFunction() throws -> ScoreFunction {
        var copy = self
        let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
        for fKey in elementContainer.allKeys {
            if let fType = ScoreFunctionType(rawValue: fKey.stringValue) {
                return try fType.metaType.init(from: superDecoder())
            }
        }
        throw Swift.DecodingError.typeMismatch(ScoreFunctionType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify score function type from key(s) \(elementContainer.allKeys)"))
    }
}
