

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
    case rescoreQuery
    case nested
    case hasChild = "has_child"
    case hasParent = "has_parent"
    case parentId = "parent_id"
    case geoShape = "geo_shape"
    case geoBoundingBox = "geo_bounding_box"
    case geoDistance = "geo_distance"
    case geoPolygon = "geo_polygon"
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
        case .rescoreQuery:
            return RescoreQuery.self
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

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]

        dic[CodingKeys.source.stringValue] = source

        if let lang = self.lang, !lang.isEmpty {
            dic[CodingKeys.lang.stringValue] = lang
        }

        if let params = self.params, !params.isEmpty {
            dic[CodingKeys.params.stringValue] = params
        }
        return dic
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

public enum ShapeRelation: String, Codable {
    case intersects
    case disjoint
    case within
    case contains
}

public enum RegexFlag: String, Codable {
    case INTERSECTION
    case COMPLEMENT
    case EMPTY
    case ANYSTRING
    case INTERVAL
    case NONE
    case ALL
}

public enum ScoreMode: String, Codable {
    case FIRST = "first"
    case AVG = "avg"
    case MAX = "max"
    case SUM = "sum"
    case MIN = "min"
    case MULTIPLY = "multiply"
    case TOTAL = "total"
}

public enum BoostMode: String, Codable {
    case MULTIPLY = "multiply"
    case REPLACE = "replace"
    case SUM = "sum"
    case AVG = "avg"
    case MIN = "min"
    case MAX = "max"
}

// MARK: - Rescore Query

/// Wrapper for Query for use in `QueryRescorer` to facilitate rescoring in `SearchRequest`
public struct RescoreQuery: Query {
    public let queryType: QueryType = QueryTypes.rescoreQuery

    public let query: Query
    public let queryWeight: Decimal?
    public let rescoreQueryWeight: Decimal?
    public let scoreMode: ScoreMode?

    public init(_ query: Query, scoreMode: ScoreMode? = nil, queryWeight: Decimal? = nil, rescoreQueryWeight: Decimal? = nil) {
        self.query = query
        self.scoreMode = scoreMode
        self.queryWeight = queryWeight
        self.rescoreQueryWeight = rescoreQueryWeight
    }
}

extension RescoreQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        query = try container.decodeQuery(forKey: .query)
        scoreMode = try container.decodeIfPresent(ScoreMode.self, forKey: .scoreMode)
        queryWeight = try container.decodeDecimalIfPresent(forKey: .queryWeight)
        rescoreQueryWeight = try container.decodeDecimalIfPresent(forKey: .rescoreQueryWeight)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        try container.encodeIfPresent(scoreMode, forKey: .scoreMode)
        try container.encodeIfPresent(queryWeight, forKey: .queryWeight)
        try container.encodeIfPresent(rescoreQueryWeight, forKey: .rescoreQueryWeight)
    }

    enum CodingKeys: String, CodingKey {
        case query = "rescore_query"
        case rescoreQueryWeight = "rescore_query_weight"
        case queryWeight = "query_weight"
        case scoreMode = "score_mode"
    }

    public func toDic() -> [String: Any] {
        var dic = [String: Any]()

        dic[CodingKeys.query.rawValue] = query.toDic()

        if let rescoreQueryWeight = self.rescoreQueryWeight {
            dic[CodingKeys.rescoreQueryWeight.rawValue] = rescoreQueryWeight
        }
        if let queryWeight = self.queryWeight {
            dic[CodingKeys.queryWeight.rawValue] = queryWeight
        }
        if let scoreMode = self.scoreMode {
            dic[CodingKeys.scoreMode.rawValue] = scoreMode
        }
        return dic
    }
}

extension RescoreQuery: Equatable {
    public static func == (lhs: RescoreQuery, rhs: RescoreQuery) -> Bool {
        return lhs.queryWeight == rhs.queryWeight
            && lhs.rescoreQueryWeight == rhs.rescoreQueryWeight
            && lhs.scoreMode == rhs.scoreMode
            && isEqualQueries(lhs.query, rhs.query)
    }
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
extension DynamicCodingKeys {
    public static func key(named queryType: QueryType) -> DynamicCodingKeys {
        return .key(named: queryType.name)
    }

    public static func key(named scoreFunctionType: ScoreFunctionType) -> DynamicCodingKeys {
        return .key(named: scoreFunctionType.rawValue)
    }
}

// MARK: - Codable Extenstions

extension KeyedEncodingContainer {
    public mutating func encode(_ value: Query, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    public mutating func encode(_ value: ScoreFunction, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    public mutating func encode(_ value: [Query], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let queriesEncoder = superEncoder(forKey: key)
        var queriesContainer = queriesEncoder.unkeyedContainer()
        for query in value {
            let queryEncoder = queriesContainer.superEncoder()
            try query.encode(to: queryEncoder)
        }
    }

    public mutating func encode(_ value: [ScoreFunction], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let scoreFunctionEncoder = superEncoder(forKey: key)
        var scoreFunctionsContainer = scoreFunctionEncoder.unkeyedContainer()
        for scoreFunction in value {
            let scoreFunctionEncoder = scoreFunctionsContainer.superEncoder()
            try scoreFunction.encode(to: scoreFunctionEncoder)
        }
    }

    public mutating func encodeIfPresent(_ value: Query?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try value.encode(to: superEncoder(forKey: key))
        }
    }

    public mutating func encode(_ value: [Query]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            let queriesEncoder = superEncoder(forKey: key)
            var queriesContainer = queriesEncoder.unkeyedContainer()
            for query in value {
                let queryEncoder = queriesContainer.superEncoder()
                try query.encode(to: queryEncoder)
            }
        }
    }
}

extension KeyedDecodingContainer {
    public func decodeQuery(forKey key: KeyedDecodingContainer<K>.Key) throws -> Query {
        let qContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for qKey in qContainer.allKeys {
            if let qType = QueryTypes(qKey.stringValue) {
                return try qType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(QueryTypes.self, .init(codingPath: codingPath, debugDescription: "Unable to identify query type from key(s) \(qContainer.allKeys)"))
    }

    public func decodeQueryIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Query? {
        guard contains(key) else {
            return nil
        }
        return try decodeQuery(forKey: key)
    }

    public func decodeQueries(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Query] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [Query]()
        if let count = arrayContainer.count {
            var iterations = 0
            while !arrayContainer.isAtEnd {
                var copy = arrayContainer
                let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
                for qKey in elementContainer.allKeys {
                    if let qType = QueryTypes(qKey.stringValue) {
                        let q = try qType.metaType.init(from: arrayContainer.superDecoder())
                        result.append(q)
                    }
                }
                iterations += 1
                if iterations > count {
                    break
                }
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all Queries expected: \(count) actual: \(result.count). Probable cause: Unable to determine QueryType form key(s)"))
            }
        }
        return result
    }

    public func decodeQueriesIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Query]? {
        guard contains(key) else {
            return nil
        }

        return try decodeQueries(forKey: key)
    }

    public func decodeScoreFunction(forKey key: KeyedDecodingContainer<K>.Key) throws -> ScoreFunction {
        let fContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)

        for fKey in fContainer.allKeys {
            if let fType = ScoreFunctionType(rawValue: fKey.stringValue) {
                return try fType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(ScoreFunctionType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify score function type from key(s) \(fContainer.allKeys)"))
    }

    public func decodeScoreFunctionIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> ScoreFunction? {
        guard contains(key) else {
            return nil
        }
        return try decodeScoreFunction(forKey: key)
    }

    public func decodeScoreFunctions(forKey key: KeyedDecodingContainer<K>.Key) throws -> [ScoreFunction] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [ScoreFunction]()
        if let count = arrayContainer.count {
            var iterations = 0
            while !arrayContainer.isAtEnd {
                var copy = arrayContainer
                let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
                for fKey in elementContainer.allKeys {
                    if let fType = ScoreFunctionType(rawValue: fKey.stringValue) {
                        let f = try fType.metaType.init(from: arrayContainer.superDecoder())
                        result.append(f)
                    }
                }
                iterations += 1
                if iterations > count {
                    break
                }
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all ScoreFunctions expected: \(count) actual: \(result.count). Probable cause: Unable to determine ScoreFunctionType form key(s)"))
            }
        }
        return result
    }

    public func decodeScoreFunctionsIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [ScoreFunction]? {
        guard contains(key) else {
            return nil
        }

        return try decodeScoreFunctions(forKey: key)
    }
}
