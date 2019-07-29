

import Foundation
import ElasticSwiftCodableUtils

// MARK:- SCRIPT

public struct Script: Codable {
    
    public let source: String
    public let lang: String?
    public let params: [String: CodableValue]?
    
    public init(_ source: String, lang: String? = nil, params: [String: CodableValue]? = nil) {
        self.source = source
        self.lang = lang
        self.params = params
    }
    
    public func encode(_ encoder: Encoder) throws {
        if self.lang == nil && self.params == nil {
            var container = encoder.singleValueContainer()
            try container.encode(self.source)
        }
        var container = encoder.container(keyedBy: Script.CodingKeys.self)
        try container.encode(self.source, forKey: .source)
        try container.encodeIfPresent(self.lang, forKey: .lang)
        try container.encodeIfPresent(self.params, forKey: .params)
    }
}

public enum ShapeRelation: String {
    case INTERSECTS = "intersects"
    case DISJOINT = "disjoint"
    case WITHIN = "within"
    case CONTAINS = "contains"
}

public enum RegexFlag: String {
    case INTERSECTION = "INTERSECTION"
    case COMPLEMENT = "COMPLEMENT"
    case EMPTY = "EMPTY"
    case ANYSTRING = "ANYSTRING"
    case INTERVAL = "INTERVAL"
    case NONE = "NONE"
    case ALL = "ALL"
}

public enum ScoreMode: String {
    case FIRST = "first"
    case AVG = "avg"
    case MAX = "max"
    case SUM = "sum"
    case MIN = "min"
    case MULTIPLY = "multiply"
}

public enum BoostMode: String {
    case MULTIPLY = "multiply"
    case REPLACE = "replace"
    case SUM = "sum"
    case AVG = "avg"
    case MIN = "min"
    case MAX = "max"
}
