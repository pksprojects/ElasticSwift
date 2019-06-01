//
//  TermLevelQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Term Query

public class TermQuery: Query {
    
    public let name: String = "term"
    var field: String
    var value: String
    var boost: Double?
    
    public init(withBuilder builder: TermQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.boost = builder.boost
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = boost {
            dic = [self.field: ["value": self.value,
                                "boost": boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
}

// MARK:- Terms Query

public class TermsQuery: Query {
    public let name: String = "terms"
    
    var field: String
    var value: [String]
    
    public init(withBuilder builder: TermsQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [self.field : self.value]
        return [self.name: dic]
    }
    
    
}

// MARK:- Range Query

public class RangeQuery: Query {
    public let name: String = "range"
    
    var field: String
    var gte: String?
    var gt: String?
    var lte: String?
    var lt: String?
    var format: String?
    var timeZone: String?
    var boost: Double?
    var relation: ShapeRelation?
    
    public init(withBuilder builder: RangeQueryBuilder) {
        self.field = builder.field!
        self.gt = builder.gt
        self.gte = builder.gte
        self.lt = builder.lt
        self.format = builder.format
        self.timeZone = builder.timeZone
        self.boost = builder.boost
        self.relation = builder.relation
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let gt = self.gt {
            dic["gt"] = gt
        }
        if let gte = self.gte {
            dic["gte"] = gte
        }
        if let lt = self.lt {
            dic["lt"] = lt
        }
        if let lte = self.lte {
            dic["lte"] = lte
        }
        if let boost = self.boost {
            dic["boost"] = boost
        }
        if let format = self.format {
            dic["format"] = format
        }
        if let timeZone = self.timeZone {
            dic["time_zone"] = timeZone
        }
        if let relation = self.relation {
            dic["relation"] = relation
        }
        return [self.name: [self.field: dic]]
    }
    
    
}

// MARK:- Exists Query

public class ExistsQuery: Query {
    public let name: String = "exists"
    
    var field: String
    
    public init(withBuilder builder: ExistsQueryBuilder) {
        self.field = builder.field!
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = ["field": self.field]
        return [self.name: dic]
    }
    
    
}

// MARK:- Prefix Query

public class PrefixQuery: Query {
    public let name: String = "prefix"
    
    var field: String
    var value: String
    var boost: Double?
    
    public init(withBuilder builder: PrefixQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.boost = builder.boost
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic = [self.field: ["value": self.value, "boost": boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
    
}

// MARK:- WildCard Query

public class WildCardQuery: Query {
    public let name: String = "wildcard"
    
    var field: String
    var value: String
    var boost: Double?
    
    public init(withBuilder builder: WildCardQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.boost = builder.boost
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic = [self.field: ["value": self.value, "boost": boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
    
}

// MARK:- Regexp Query

public class RegexpQuery: Query {
    public let name: String = "regexp"
    
    var field: String
    var value: String
    var boost: Double?
    var regexFlags: String?
    var maxDeterminizedStates: Int?
    
    public init(withBuilder builder: RegexpQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.boost = builder.boost
        self.maxDeterminizedStates = builder.maxDeterminizedStates
        self.regexFlags = builder.regexFlags?.map({flag in return flag.rawValue}).joined(separator: "|")
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic["boost"] = boost
        }
        if let regexFlags = self.regexFlags {
            dic["flags"] = regexFlags
        }
        if let maxDeterminizedStates = self.maxDeterminizedStates {
            dic["max_determinized_states"] = maxDeterminizedStates
        }
        dic["value"] = self.value
        return [self.name: [self.field: dic]]
    }
    
    
}

// MARK:- Fuzzy Query

public class FuzzyQuery: Query {
    public let name: String = "fuzzy"
    
    var field: String
    var value: String
    var boost: Double?
    var fuzziness: Int?
    var prefixLenght: Int?
    var maxExpansions: Int?
    var transpositions: Bool?
    
    public init(withBuilder builder: FuzzyQueryBuilder) {
        self.field = builder.field!
        self.value = builder.value!
        self.boost = builder.boost
        self.fuzziness = builder.fuzziness
        self.prefixLenght = builder.prefixLenght
        self.maxExpansions = builder.maxExpansions
        self.transpositions = builder.transpositions
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic["boost"] = boost
        }
        if let fuzziness = self.fuzziness {
            dic["fuzziness"] = fuzziness
        }
        if let prefixLenght = self.prefixLenght {
            dic["prefix_length"] = prefixLenght
        }
        if let maxExpansions = self.maxExpansions {
            dic["max_expansions"] = maxExpansions
        }
        if let transpositions = self.transpositions {
            dic["transpositions"] = transpositions
        }
        
        dic["value"] = self.value
        return [self.name: [self.field: dic]]
    }
    
    
}

// MARK:- Type Query

public class TypeQuery: Query {
    public let name: String = "type"
    
    var type: String
    
    public init(withBuilder builder: TypeQueryBuilder) {
        self.type = builder.type!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: ["value": self.type]]
    }
    
    
}

// MARK:- Ids Query

public class IdsQuery: Query {
    public let name: String = "ids"
    
    var type: String?
    var ids: [String]
    
    public init(withBuilder builder: IdsQueryBuilder) {
        self.ids = builder.ids!
        self.type = builder.type
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = ["values": self.ids]
        if let type = self.type {
            dic["type"] = type
        }
        return [self.name: dic]
    }
    
    
}


