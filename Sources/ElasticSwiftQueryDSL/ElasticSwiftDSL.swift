

import Foundation
import ElasticSwiftCore
import ElasticSwiftCodableUtils

// MARK:- Query Types

enum QueryType: String, Codable {
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
    
    var metaType: Query.Type {
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
        }
    }
}

// MARK:- Score Function Types

enum ScoreFunctionType: String, Codable {
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

// MARK:- SCRIPT

public struct Script: Codable, Equatable {
    
    public let source: String
    public let lang: String?
    public let params: [String: CodableValue]?
    
    public init(_ source: String, lang: String? = nil, params: [String: CodableValue]? = nil) {
        self.source = source
        self.lang = lang
        self.params = params
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        
        dic[CodingKeys.source.stringValue] = self.source
        
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
            self.source = try container.decodeString(forKey: .source)
            self.lang = try container.decodeStringIfPresent(forKey: .lang)
            self.params = try container.decodeIfPresent(Dictionary<String, CodableValue>.self, forKey: .params)
            return
        } else if let container = try? decoder.singleValueContainer() {
            self.source = try container.decodeString()
            self.params = nil
            self.lang = nil
            return
        } else {
            throw Swift.DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unable to decode Script as String/Dic"))
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        if self.lang == nil && self.params == nil {
            var container = encoder.singleValueContainer()
            try container.encode(self.source)
            return
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.source, forKey: .source)
        try container.encodeIfPresent(self.lang, forKey: .lang)
        try container.encodeIfPresent(self.params, forKey: .params)
    }
    
    enum CodingKeys: String, CodingKey {
        case source
        case lang
        case params
    }
}

public enum ShapeRelation: String, Codable {
    case INTERSECTS = "intersects"
    case DISJOINT = "disjoint"
    case WITHIN = "within"
    case CONTAINS = "contains"
}

public enum RegexFlag: String, Codable {
    case INTERSECTION = "INTERSECTION"
    case COMPLEMENT = "COMPLEMENT"
    case EMPTY = "EMPTY"
    case ANYSTRING = "ANYSTRING"
    case INTERVAL = "INTERVAL"
    case NONE = "NONE"
    case ALL = "ALL"
}

public enum ScoreMode: String, Codable {
    case FIRST = "first"
    case AVG = "avg"
    case MAX = "max"
    case SUM = "sum"
    case MIN = "min"
    case MULTIPLY = "multiply"
}

public enum BoostMode: String, Codable {
    case MULTIPLY = "multiply"
    case REPLACE = "replace"
    case SUM = "sum"
    case AVG = "avg"
    case MIN = "min"
    case MAX = "max"
}


// MARK:- Codable Extenstions

extension KeyedEncodingContainer {
    
    public mutating func encode(_ value: Query, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: self.superEncoder(forKey: key))
    }
    
    public mutating func encode(_ value: ScoreFunction, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: self.superEncoder(forKey: key))
    }
    
    public mutating func encode(_ value: [Query], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let queriesEncoder = self.superEncoder(forKey: key)
        var queriesContainer = queriesEncoder.unkeyedContainer()
        for query in value {
            let queryEncoder =  queriesContainer.superEncoder()
            try query.encode(to: queryEncoder)
        }
    }
    
    public mutating func encode(_ value: [ScoreFunction], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let scoreFunctionEncoder = self.superEncoder(forKey: key)
        var scoreFunctionsContainer = scoreFunctionEncoder.unkeyedContainer()
        for scoreFunction in value {
            let scoreFunctionEncoder =  scoreFunctionsContainer.superEncoder()
            try scoreFunction.encode(to: scoreFunctionEncoder)
        }
    }
    
    public mutating func encodeIfPresent(_ value: Query?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try value.encode(to: self.superEncoder(forKey: key))
        }
    }

    public mutating func encode(_ value: [Query]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            let queriesEncoder = self.superEncoder(forKey: key)
            var queriesContainer = queriesEncoder.unkeyedContainer()
            for query in value {
                let queryEncoder =  queriesContainer.superEncoder()
                try query.encode(to: queryEncoder)
            }
        }
    }
    
}

extension KeyedDecodingContainer {
    
    public func decodeQuery(forKey key: KeyedDecodingContainer<K>.Key) throws -> Query {
        let qContainer = try self.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for qKey in qContainer.allKeys {
            if let qType = QueryType(rawValue: qKey.stringValue) {
                return try qType.metaType.init(from: self.superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(QueryType.self, .init(codingPath: self.codingPath, debugDescription: "Unable to identify query type from key(s) \(qContainer.allKeys)"))
    }
    
    public func decodeQueryIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Query? {
        guard self.contains(key) else {
            return nil
        }
        return try self.decodeQuery(forKey: key)
    }
    
    public func decodeQueries(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Query] {
        var arrayContainer = try self.nestedUnkeyedContainer(forKey: key)
        var result = [Query]()
        if let count = arrayContainer.count {
            var iterations = 0
            while !arrayContainer.isAtEnd {
                var copy = arrayContainer
                let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
                for qKey in elementContainer.allKeys {
                    if let qType = QueryType(rawValue: qKey.stringValue) {
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
        
        guard self.contains(key) else {
            return nil
        }
        
        return try self.decodeQueries(forKey: key)
    }
    
    public func decodeScoreFunction(forKey key: KeyedDecodingContainer<K>.Key) throws -> ScoreFunction {
        let fContainer = try self.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        
        for fKey in fContainer.allKeys {
            if let fType = ScoreFunctionType(rawValue: fKey.stringValue) {
                return try fType.metaType.init(from: self.superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(QueryType.self, .init(codingPath: self.codingPath, debugDescription: "Unable to identify score function type from key(s) \(fContainer.allKeys)"))
    }
    
    public func decodeScoreFunctionIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> ScoreFunction? {
        guard self.contains(key) else {
            return nil
        }
        return try self.decodeScoreFunction(forKey: key)
    }
    
    public func decodeScoreFunctions(forKey key: KeyedDecodingContainer<K>.Key) throws -> [ScoreFunction] {
        var arrayContainer = try self.nestedUnkeyedContainer(forKey: key)
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
        
        guard self.contains(key) else {
            return nil
        }
        
        return try self.decodeScoreFunctions(forKey: key)
    }
    
}
