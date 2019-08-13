//
//  TermLevelQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Term Query

public class TermQuery: Query {
    
    private static let BOOST = "boost"
    private static let VALUE = "value"
    
    public let name: String = "term"
    public let field: String
    public let value: String
    public let boost: Decimal?
    
    
    public init(field: String, value: String, boost: Decimal? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
    }
    
    internal convenience init(withBuilder builder: TermQueryBuilder) throws {
        
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }
        
        self.init(field: builder.field!, value: builder.value!, boost: builder.boost)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = boost {
            dic = [self.field: [TermQuery.VALUE: self.value,
                                TermQuery.BOOST: boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
}

// MARK:- Terms Query

public class TermsQuery: Query {
    public let name: String = "terms"
    
    public let field: String
    public let values: [String]
    
    public init(field: String, values: [String]) {
        self.field = field
        self.values = values
    }
    
    internal init(withBuilder builder: TermsQueryBuilder) throws {
        
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        guard !builder.values.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("values")
        }
        
        self.field = builder.field!
        self.values = builder.values
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [self.field : self.values]
        return [self.name: dic]
    }
    
    
}

// MARK:- Range Query

public class RangeQuery: Query {
    
    private static let GT = "gt"
    private static let GTE = "gte"
    private static let LT = "lt"
    private static let LTE = "lte"
    private static let BOOST = "boost"
    private static let FORMAT = "format"
    private static let TIME_ZONE = "time_zone"
    private static let RELATION = "relation"
    
    public let name: String = "range"
    
    public let field: String
    public let gte: String?
    public let gt: String?
    public let lte: String?
    public let lt: String?
    public let format: String?
    public let timeZone: String?
    public let boost: Decimal?
    public let relation: ShapeRelation?
    
    public init(field: String, gte: String?, gt: String?, lte: String?, lt: String?, format: String? = nil, timeZone: String? = nil, boost: Decimal? = nil, relation: ShapeRelation? = nil) {
        self.field = field
        self.gte = gte
        self.gt = gt
        self.lte = lte
        self.lt = lt
        self.format = format
        self.timeZone = timeZone
        self.boost = boost
        self.relation = relation
    }
    
    internal init(withBuilder builder: RangeQueryBuilder) throws {
        
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        guard builder.gte != nil || builder.gt != nil || builder.lt != nil || builder.lte != nil else {
            throw QueryBuilderError.atleastOneFieldRequired(["gte", "gt", "lt", "lte"])
        }
        
        self.field = builder.field!
        self.gt = builder.gt
        self.gte = builder.gte
        self.lt = builder.lt
        self.lte = builder.lte
        self.format = builder.format
        self.timeZone = builder.timeZone
        self.boost = builder.boost
        self.relation = builder.relation
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let gt = self.gt {
            dic[RangeQuery.GT] = gt
        }
        if let gte = self.gte {
            dic[RangeQuery.GTE] = gte
        }
        if let lt = self.lt {
            dic[RangeQuery.LT] = lt
        }
        if let lte = self.lte {
            dic[RangeQuery.LTE] = lte
        }
        if let boost = self.boost {
            dic[RangeQuery.BOOST] = boost
        }
        if let format = self.format {
            dic[RangeQuery.FORMAT] = format
        }
        if let timeZone = self.timeZone {
            dic[RangeQuery.TIME_ZONE] = timeZone
        }
        if let relation = self.relation {
            dic[RangeQuery.RELATION] = relation
        }
        return [self.name: [self.field: dic]]
    }
    
    
}

// MARK:- Exists Query

public class ExistsQuery: Query {
    
    private static let FIELD = "field"
    
    public let name: String = "exists"
    
    public let field: String
    
    public init(field: String) {
        self.field = field
    }
    
    internal init(withBuilder builder: ExistsQueryBuilder) throws {
        
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        self.field = builder.field!
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [ExistsQuery.FIELD: self.field]
        return [self.name: dic]
    }
    
    
}

// MARK:- Prefix Query

public class PrefixQuery: Query {
    
    private static let BOOST = "boost"
    private static let VALUE = "value"
    
    public let name: String = "prefix"
    
    public let field: String
    public let value: String
    public let boost: Decimal?
    
    public init(field: String, value: String, boost: Decimal? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
    }
    
    internal convenience init(withBuilder builder: PrefixQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }
        
        self.init(field: builder.field!, value: builder.value!, boost: builder.boost)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic = [self.field: [PrefixQuery.VALUE: self.value, PrefixQuery.BOOST: boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
    
}

// MARK:- WildCard Query

public class WildCardQuery: Query {
    
    private static let BOOST = "boost"
    private static let VALUE = "value"
    
    public let name: String = "wildcard"
    
    public let field: String
    public let value: String
    public let boost: Decimal?
    
    public init(field: String, value: String, boost: Decimal? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
    }
    
    internal convenience init(withBuilder builder: WildCardQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }
        
        self.init(field: builder.field!, value: builder.value!, boost: builder.boost)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic = [self.field: [WildCardQuery.VALUE: self.value, WildCardQuery.BOOST: boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
    
}

// MARK:- Regexp Query

public class RegexpQuery: Query {
    
    private static let BOOST = "boost"
    private static let FLAGS = "flags"
    private static let MAX_DETERMINIZED_STATUS = "max_determinized_states"
    private static let VALUE = "value"
    
    public let name: String = "regexp"
    
    public let field: String
    public let value: String
    public let boost: Decimal?
    public let regexFlags: String
    public let maxDeterminizedStates: Int?
    
    public init(field: String, value: String, boost: Decimal? = nil, regexFlags: [RegexFlag] = [], maxDeterminizedStates: Int? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.regexFlags = regexFlags.map({flag in return flag.rawValue}).joined(separator: "|")
        self.maxDeterminizedStates = maxDeterminizedStates
    }
    
    internal convenience init(withBuilder builder: RegexpQueryBuilder) throws {
        
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }
        
        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, regexFlags: builder.regexFlags, maxDeterminizedStates: builder.maxDeterminizedStates)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic[RegexpQuery.BOOST] = boost
        }
        if !self.regexFlags.isEmpty {
            dic[RegexpQuery.FLAGS] = regexFlags
        }
        if let maxDeterminizedStates = self.maxDeterminizedStates {
            dic[RegexpQuery.MAX_DETERMINIZED_STATUS] = maxDeterminizedStates
        }
        dic[RegexpQuery.VALUE] = self.value
        return [self.name: [self.field: dic]]
    }
    
    
}

// MARK:- Fuzzy Query

public class FuzzyQuery: Query {
    
    private static let BOOST = "boost"
    private static let FUZZINESS = "fuzziness"
    private static let PREFIX_LENGTH = "prefix_length"
    private static let MAX_EXPANSIONS = "max_expansions"
    private static let TRANSPOSITIONS = "transpositions"
    private static let VALUE = "value"
    
    public let name: String = "fuzzy"
    
    public let field: String
    public let value: String
    public let boost: Decimal?
    public let fuzziness: Int?
    public let prefixLenght: Int?
    public let maxExpansions: Int?
    public let transpositions: Bool?
    
    public init(field: String, value: String, boost: Decimal? = nil, fuzziness: Int? = nil, prefixLenght: Int? = nil, maxExpansions: Int? = nil, transpositions: Bool? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.fuzziness = fuzziness
        self.prefixLenght = prefixLenght
        self.maxExpansions = maxExpansions
        self.transpositions = transpositions
    }
    
    internal convenience init(withBuilder builder: FuzzyQueryBuilder) throws {
        
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        
        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }
        
        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, fuzziness: builder.fuzziness, prefixLenght: builder.prefixLenght, maxExpansions: builder.maxExpansions, transpositions: builder.transpositions)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        if let boost = self.boost {
            dic[FuzzyQuery.BOOST] = boost
        }
        if let fuzziness = self.fuzziness {
            dic[FuzzyQuery.FUZZINESS] = fuzziness
        }
        if let prefixLenght = self.prefixLenght {
            dic[FuzzyQuery.PREFIX_LENGTH] = prefixLenght
        }
        if let maxExpansions = self.maxExpansions {
            dic[FuzzyQuery.MAX_EXPANSIONS] = maxExpansions
        }
        if let transpositions = self.transpositions {
            dic[FuzzyQuery.TRANSPOSITIONS] = transpositions
        }
        
        dic[FuzzyQuery.VALUE] = self.value
        return [self.name: [self.field: dic]]
    }
    
    
}

// MARK:- Type Query

public class TypeQuery: Query {
    
    private static let VALUE = "value"
    
    public let name: String = "type"
    
    public let type: String
    
    public init(type: String) {
        self.type = type
    }
    
    internal init(withBuilder builder: TypeQueryBuilder) throws {
        
        guard builder.type != nil else {
            throw QueryBuilderError.missingRequiredField("type")
        }
        
        self.type = builder.type!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: [TypeQuery.VALUE: self.type]]
    }
    
    
}

// MARK:- Ids Query

public class IdsQuery: Query {
    
    private static let VALUES = "values"
    private static let TYPE = "type"
    
    public let name: String = "ids"
    
    public let type: String?
    public let ids: [String]
    
    public init(ids: String..., type: String? = nil) {
        self.type = type
        self.ids = ids
    }
    
    internal init(withBuilder builder: IdsQueryBuilder) throws {
        
        guard !builder.ids.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("ids")
        }
        
        self.ids = builder.ids
        self.type = builder.type
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [IdsQuery.VALUES: self.ids]
        if let type = self.type {
            dic[IdsQuery.TYPE] = type
        }
        return [self.name: dic]
    }
    
    
}


