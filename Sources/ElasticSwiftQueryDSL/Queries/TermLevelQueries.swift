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
            dic = [self.field: [CodingKeys.value.rawValue: self.value,
                                CodingKeys.boost.rawValue: boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
        
        guard self.boost != nil else {
            try nested.encode(self.value, forKey: .key(named: self.field))
            return
        }
        
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
        try fieldContainer.encode(self.value, forKey: .value)
        try fieldContainer.encodeIfPresent(self.boost, forKey: .boost)
    }
    
    enum CodingKeys: String, CodingKey {
        case boost
        case value
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
        try nested.encode(self.values, forKey: .key(named: self.field))
    }
}

// MARK:- Range Query

public class RangeQuery: Query {
    
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
            dic[CodingKeys.gt.rawValue] = gt
        }
        if let gte = self.gte {
            dic[CodingKeys.gte.rawValue] = gte
        }
        if let lt = self.lt {
            dic[CodingKeys.lt.rawValue] = lt
        }
        if let lte = self.lte {
            dic[CodingKeys.lte.rawValue] = lte
        }
        if let boost = self.boost {
            dic[CodingKeys.boost.rawValue] = boost
        }
        if let format = self.format {
            dic[CodingKeys.format.rawValue] = format
        }
        if let timeZone = self.timeZone {
            dic[CodingKeys.timeZone.rawValue] = timeZone
        }
        if let relation = self.relation {
            dic[CodingKeys.relation.rawValue] = relation
        }
        return [self.name: [self.field: dic]]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
        var fieldContainer =  nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
        
        try fieldContainer.encodeIfPresent(self.gt, forKey: .gt)
        try fieldContainer.encodeIfPresent(self.gte, forKey: .gte)
        try fieldContainer.encodeIfPresent(self.lt, forKey: .lt)
        try fieldContainer.encodeIfPresent(self.lte, forKey: .lte)
        try fieldContainer.encodeIfPresent(self.boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(self.format, forKey: .format)
        try fieldContainer.encodeIfPresent(self.timeZone, forKey: .timeZone)
        try fieldContainer.encodeIfPresent(self.relation, forKey: .relation)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case gt
        case gte
        case lt
        case lte
        case boost
        case format
        case timeZone = "time_zone"
        case relation
    }
}

// MARK:- Exists Query

public class ExistsQuery: Query {
    
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
        let dic: [String: Any] = [CodingKeys.field.rawValue: self.field]
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested =  container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        try nested.encode(self.field, forKey: .field)
    }
    
    enum CodingKeys: String, CodingKey {
        case field
    }
}

// MARK:- Prefix Query

public class PrefixQuery: Query {
    
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
            dic = [self.field: [CodingKeys.value.rawValue: self.value, CodingKeys.boost.rawValue: boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
        
        guard self.boost != nil else {
            try nested.encode(self.value, forKey: .key(named: self.field))
            return
        }
        
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
        try fieldContainer.encode(self.value, forKey: .value)
        try fieldContainer.encodeIfPresent(self.boost, forKey: .boost)
    }
    
    enum CodingKeys: String, CodingKey {
        case boost
        case value
    }
}

// MARK:- WildCard Query

public class WildCardQuery: Query {
    
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
            dic = [self.field: [CodingKeys.value.rawValue: self.value,
                                CodingKeys.boost.rawValue: boost]]
        } else {
            dic = [self.field: self.value]
        }
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
        
        guard self.boost != nil else {
            try nested.encode(self.value, forKey: .key(named: self.field))
            return
        }
        
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
        try fieldContainer.encode(self.value, forKey: .value)
        try fieldContainer.encodeIfPresent(self.boost, forKey: .boost)
    }
    
    enum CodingKeys: String, CodingKey {
        case boost
        case value
    }
}

// MARK:- Regexp Query

public class RegexpQuery: Query {
    
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
            dic[CodingKeys.boost.rawValue] = boost
        }
        if !self.regexFlags.isEmpty {
            dic[CodingKeys.flags.rawValue] = regexFlags
        }
        if let maxDeterminizedStates = self.maxDeterminizedStates {
            dic[CodingKeys.maxDeterminizedStates.rawValue] = maxDeterminizedStates
        }
        dic[CodingKeys.value.rawValue] = self.value
        return [self.name: [self.field: dic]]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
        
        try fieldContainer.encode(self.value, forKey: .value)
        try fieldContainer.encodeIfPresent(self.boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(self.regexFlags, forKey: .flags)
        try fieldContainer.encodeIfPresent(self.maxDeterminizedStates, forKey: .maxDeterminizedStates)
    }
    
    enum CodingKeys: String, CodingKey {
        case boost
        case flags
        case value
        case maxDeterminizedStates = "max_determinized_states"
    }
}

// MARK:- Fuzzy Query

public class FuzzyQuery: Query {
    
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
            dic[CodingKeys.boost.rawValue] = boost
        }
        if let fuzziness = self.fuzziness {
            dic[CodingKeys.fuzziness.rawValue] = fuzziness
        }
        if let prefixLenght = self.prefixLenght {
            dic[CodingKeys.prefixLength.rawValue] = prefixLenght
        }
        if let maxExpansions = self.maxExpansions {
            dic[CodingKeys.maxExpansions.rawValue] = maxExpansions
        }
        if let transpositions = self.transpositions {
            dic[CodingKeys.tranpositions.rawValue] = transpositions
        }
        
        dic[CodingKeys.value.rawValue] = self.value
        return [self.name: [self.field: dic]]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
        
        try fieldContainer.encode(self.value, forKey: .value)
        try fieldContainer.encodeIfPresent(self.boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(self.fuzziness, forKey: .fuzziness)
        try fieldContainer.encodeIfPresent(self.maxExpansions, forKey: .maxExpansions)
        try fieldContainer.encodeIfPresent(self.prefixLenght, forKey: .prefixLength)
        try fieldContainer.encodeIfPresent(self.transpositions, forKey: .tranpositions)
    }
    
    enum CodingKeys: String, CodingKey {
        case boost
        case value
        case fuzziness
        case prefixLength = "prefix_length"
        case maxExpansions = "max_expansions"
        case tranpositions
    }
}

// MARK:- Type Query

public class TypeQuery: Query {
    
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
        return [self.name: [CodingKeys.value.rawValue: self.type]]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        try nested.encode(self.type, forKey: .value)
    }
    
    enum CodingKeys: String, CodingKey {
        case value
    }
}

// MARK:- Ids Query

public class IdsQuery: Query {
    
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
        var dic: [String: Any] = [CodingKeys.values.rawValue: self.ids]
        if let type = self.type {
            dic[CodingKeys.type.rawValue] = type
        }
        return [self.name: dic]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.name))
        try nested.encode(self.ids, forKey: .values)
        try nested.encodeIfPresent(self.type, forKey: .type)
    }
    
    enum CodingKeys: String, CodingKey {
        case values
        case type
    }
    
}


