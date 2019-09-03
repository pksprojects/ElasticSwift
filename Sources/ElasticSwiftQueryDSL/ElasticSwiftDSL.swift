

import Foundation
import ElasticSwiftCodableUtils

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
