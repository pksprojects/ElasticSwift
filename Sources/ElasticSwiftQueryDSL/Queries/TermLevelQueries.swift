//
//  TermLevelQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Term Query

public struct TermQuery: Query {
    public let queryType: QueryType = QueryTypes.term

    public let field: String
    public let value: String
    public var boost: Decimal?
    public var name: String?

    public init(field: String, value: String, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: TermQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, name: builder.name)
    }
}

public extension TermQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(TermQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .value)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
        } else {
            value = try nested.decodeString(forKey: .key(named: field))
            boost = nil
            name = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard boost != nil || name != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .value)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case value
        case name
    }
}

extension TermQuery: Equatable {
    public static func == (lhs: TermQuery, rhs: TermQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Terms Query

public struct TermsQuery: Query {
    public let queryType: QueryType = QueryTypes.terms

    public let field: String
    public let values: [String]
    public var boost: Decimal?
    public var name: String?

    public init(field: String, values: [String], boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.values = values
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: TermsQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard !builder.values.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("values")
        }

        self.init(field: builder.field!, values: builder.values, boost: builder.boost, name: builder.name)
    }
}

public extension TermsQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(TermsQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue

        values = try nested.decode([String].self, forKey: .key(named: field))
        boost = try nested.decodeDecimalIfPresent(forKey: .key(named: CodingKeys.boost.rawValue))
        name = try nested.decodeStringIfPresent(forKey: .key(named: CodingKeys.name.rawValue))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(values, forKey: .key(named: field))
        try nested.encodeIfPresent(boost, forKey: .key(named: CodingKeys.boost.rawValue))
        try nested.encodeIfPresent(name, forKey: .key(named: CodingKeys.name.rawValue))
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case name
    }
}

extension TermsQuery: Equatable {
    public static func == (lhs: TermsQuery, rhs: TermsQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.values == rhs.values
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Multi Term Query

public protocol MultiTermQuery: Query {}

// MARK: - Range Query

public struct RangeQuery: MultiTermQuery {
    public let queryType: QueryType = QueryTypes.range

    public let field: String
    public let gte: String?
    public let gt: String?
    public let lte: String?
    public let lt: String?
    public let format: String?
    public let timeZone: String?
    public let relation: ShapeRelation?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, gte: String?, gt: String?, lte: String?, lt: String?, format: String? = nil, timeZone: String? = nil, boost: Decimal? = nil, relation: ShapeRelation? = nil, name: String? = nil) {
        self.field = field
        self.gte = gte
        self.gt = gt
        self.lte = lte
        self.lt = lt
        self.format = format
        self.timeZone = timeZone
        self.boost = boost
        self.relation = relation
        self.name = name
    }

    internal init(withBuilder builder: RangeQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.gte != nil || builder.gt != nil || builder.lt != nil || builder.lte != nil else {
            throw QueryBuilderError.atleastOneFieldRequired(["gte", "gt", "lt", "lte"])
        }

        self.init(field: builder.field!, gte: builder.gte, gt: builder.gt, lte: builder.lte, lt: builder.lt, format: builder.format, timeZone: builder.timeZone, boost: builder.boost, relation: builder.relation, name: builder.name)
    }
}

public extension RangeQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(RangeQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        gte = try fieldContainer.decodeStringIfPresent(forKey: .gte)
        gt = try fieldContainer.decodeStringIfPresent(forKey: .gt)
        lte = try fieldContainer.decodeStringIfPresent(forKey: .lte)
        lt = try fieldContainer.decodeStringIfPresent(forKey: .lt)
        format = try fieldContainer.decodeStringIfPresent(forKey: .format)
        timeZone = try fieldContainer.decodeStringIfPresent(forKey: .timeZone)
        boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
        name = try fieldContainer.decodeStringIfPresent(forKey: .name)
        relation = try fieldContainer.decodeIfPresent(ShapeRelation.self, forKey: .relation)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))

        try fieldContainer.encodeIfPresent(gt, forKey: .gt)
        try fieldContainer.encodeIfPresent(gte, forKey: .gte)
        try fieldContainer.encodeIfPresent(lt, forKey: .lt)
        try fieldContainer.encodeIfPresent(lte, forKey: .lte)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(format, forKey: .format)
        try fieldContainer.encodeIfPresent(timeZone, forKey: .timeZone)
        try fieldContainer.encodeIfPresent(relation, forKey: .relation)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case gt
        case gte
        case lt
        case lte
        case boost
        case format
        case timeZone = "time_zone"
        case relation
        case name
    }
}

extension RangeQuery: Equatable {
    public static func == (lhs: RangeQuery, rhs: RangeQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.gt == rhs.gt
            && lhs.gte == rhs.gte
            && lhs.lt == rhs.lt
            && lhs.lte == rhs.lte
            && lhs.boost == rhs.boost
            && lhs.relation == rhs.relation
            && lhs.format == rhs.format
            && lhs.timeZone == rhs.timeZone
            && lhs.name == rhs.name
    }
}

// MARK: - Exists Query

public struct ExistsQuery: Query {
    public let queryType: QueryType = QueryTypes.exists

    public let field: String
    public var boost: Decimal?
    public var name: String?

    public init(field: String, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: ExistsQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        self.init(field: builder.field!, boost: builder.boost, name: builder.name)
    }
}

public extension ExistsQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        field = try nested.decodeString(forKey: .field)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(field, forKey: .field)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case field
        case boost
        case name
    }
}

extension ExistsQuery: Equatable {
    public static func == (lhs: ExistsQuery, rhs: ExistsQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Prefix Query

public struct PrefixQuery: MultiTermQuery {
    public let queryType: QueryType = QueryTypes.prefix

    public let field: String
    public let value: String
    public var boost: Decimal?
    public var name: String?

    public init(field: String, value: String, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: PrefixQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, name: builder.name)
    }
}

public extension PrefixQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(PrefixQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .value)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
        } else {
            value = try nested.decodeString(forKey: .key(named: field))
            boost = nil
            name = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard boost != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .value)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case value
        case name
    }
}

extension PrefixQuery: Equatable {
    public static func == (lhs: PrefixQuery, rhs: PrefixQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - WildCard Query

public struct WildCardQuery: MultiTermQuery {
    public let queryType: QueryType = QueryTypes.wildcard

    public let field: String
    public let value: String
    public var boost: Decimal?
    public var name: String?

    public init(field: String, value: String, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: WildCardQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, name: builder.name)
    }
}

public extension WildCardQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(WildCardQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            value = try fieldContainer.decodeString(forKey: .value)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
        } else {
            value = try nested.decodeString(forKey: .key(named: field))
            boost = nil
            name = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard boost != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(value, forKey: .value)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case value
        case name
    }
}

extension WildCardQuery: Equatable {
    public static func == (lhs: WildCardQuery, rhs: WildCardQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Regexp Query

public struct RegexpQuery: MultiTermQuery {
    public let queryType: QueryType = QueryTypes.regexp

    public let field: String
    public let value: String
    public var boost: Decimal?
    public let regexFlags: [RegexFlag]
    public let maxDeterminizedStates: Int?
    public var name: String?

    public init(field: String, value: String, boost: Decimal? = nil, regexFlags: [RegexFlag] = [], maxDeterminizedStates: Int? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.regexFlags = regexFlags
        self.maxDeterminizedStates = maxDeterminizedStates
        self.name = name
    }

    internal init(withBuilder builder: RegexpQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, regexFlags: builder.regexFlags, maxDeterminizedStates: builder.maxDeterminizedStates, name: builder.name)
    }

    public var regexFlagsStr: String {
        return regexFlags.map { flag in flag.rawValue }.joined(separator: "|")
    }
}

public extension RegexpQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(RegexpQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let val = try? nested.decodeString(forKey: .key(named: field)) {
            value = val
            boost = nil
            regexFlags = []
            maxDeterminizedStates = nil
            name = nil
        } else {
            let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))

            value = try fieldContainer.decodeString(forKey: .value)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
            let regexFlagStr = try fieldContainer.decodeStringIfPresent(forKey: .flags)
            if let flagStr = regexFlagStr {
                regexFlags = flagStr.split(separator: "|").map(String.init).map { RegexFlag(rawValue: $0)! }
            } else {
                regexFlags = []
            }
            maxDeterminizedStates = try fieldContainer.decodeIntIfPresent(forKey: .maxDeterminizedStates)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard boost != nil || !regexFlags.isEmpty || maxDeterminizedStates != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))

        try fieldContainer.encode(value, forKey: .value)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(regexFlagsStr, forKey: .flags)
        try fieldContainer.encodeIfPresent(maxDeterminizedStates, forKey: .maxDeterminizedStates)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case flags
        case value
        case maxDeterminizedStates = "max_determinized_states"
        case name
    }
}

extension RegexpQuery: Equatable {
    public static func == (lhs: RegexpQuery, rhs: RegexpQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.regexFlags == rhs.regexFlags
            && lhs.boost == rhs.boost
            && lhs.maxDeterminizedStates == rhs.maxDeterminizedStates
            && lhs.name == rhs.name
    }
}

// MARK: - Fuzzy Query

public struct FuzzyQuery: MultiTermQuery {
    public let queryType: QueryType = QueryTypes.fuzzy

    public let field: String
    public let value: String
    public var boost: Decimal?
    public let fuzziness: Int?
    public let prefixLenght: Int?
    public let maxExpansions: Int?
    public let transpositions: Bool?
    public var name: String?

    public init(field: String, value: String, boost: Decimal? = nil, fuzziness: Int? = nil, prefixLenght: Int? = nil, maxExpansions: Int? = nil, transpositions: Bool? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.fuzziness = fuzziness
        self.prefixLenght = prefixLenght
        self.maxExpansions = maxExpansions
        self.transpositions = transpositions
        self.name = name
    }

    internal init(withBuilder builder: FuzzyQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, fuzziness: builder.fuzziness, prefixLenght: builder.prefixLenght, maxExpansions: builder.maxExpansions, transpositions: builder.transpositions, name: builder.name)
    }
}

public extension FuzzyQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(FuzzyQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let val = try? nested.decodeString(forKey: .key(named: field)) {
            value = val
            boost = nil
            fuzziness = nil
            prefixLenght = nil
            maxExpansions = nil
            transpositions = nil
            name = nil
        } else {
            let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
            value = try fieldContainer.decodeString(forKey: .value)
            boost = try fieldContainer.decodeDecimalIfPresent(forKey: .boost)
            fuzziness = try fieldContainer.decodeIntIfPresent(forKey: .fuzziness)
            prefixLenght = try fieldContainer.decodeIntIfPresent(forKey: .prefixLength)
            maxExpansions = try fieldContainer.decodeIntIfPresent(forKey: .maxExpansions)
            transpositions = try fieldContainer.decodeBoolIfPresent(forKey: .transpositions)
            name = try fieldContainer.decodeStringIfPresent(forKey: .name)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard boost != nil || fuzziness != nil || maxExpansions != nil || prefixLenght != nil || transpositions != nil else {
            try nested.encode(value, forKey: .key(named: field))
            return
        }

        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))

        try fieldContainer.encode(value, forKey: .value)
        try fieldContainer.encodeIfPresent(boost, forKey: .boost)
        try fieldContainer.encodeIfPresent(fuzziness, forKey: .fuzziness)
        try fieldContainer.encodeIfPresent(maxExpansions, forKey: .maxExpansions)
        try fieldContainer.encodeIfPresent(prefixLenght, forKey: .prefixLength)
        try fieldContainer.encodeIfPresent(transpositions, forKey: .transpositions)
        try fieldContainer.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case value
        case fuzziness
        case prefixLength = "prefix_length"
        case maxExpansions = "max_expansions"
        case transpositions
        case name
    }
}

extension FuzzyQuery: Equatable {
    public static func == (lhs: FuzzyQuery, rhs: FuzzyQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.boost == rhs.boost
            && lhs.fuzziness == rhs.fuzziness
            && lhs.maxExpansions == rhs.maxExpansions
            && lhs.prefixLenght == rhs.prefixLenght
            && lhs.transpositions == rhs.transpositions
            && lhs.name == rhs.name
    }
}

// MARK: - Type Query

public struct TypeQuery: Query {
    public let queryType: QueryType = QueryTypes.type

    public let type: String
    public var boost: Decimal?
    public var name: String?

    public init(type: String, boost: Decimal? = nil, name: String? = nil) {
        self.type = type
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: TypeQueryBuilder) throws {
        guard builder.type != nil else {
            throw QueryBuilderError.missingRequiredField("type")
        }

        self.init(type: builder.type!, boost: builder.boost, name: builder.name)
    }
}

public extension TypeQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        type = try nested.decodeString(forKey: .value)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(type, forKey: .value)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case value
        case boost
        case name
    }
}

extension TypeQuery: Equatable {
    public static func == (lhs: TypeQuery, rhs: TypeQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.type == rhs.type
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Ids Query

public struct IdsQuery: Query {
    public let queryType: QueryType = QueryTypes.ids

    public let type: String?
    public let ids: [String]
    public var boost: Decimal?
    public var name: String?

    public init(ids: [String], type: String? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.type = type
        self.ids = ids
        self.boost = boost
        self.name = name
    }

    public init(ids: String..., type: String? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.init(ids: ids, type: type, boost: boost, name: name)
    }

    internal init(withBuilder builder: IdsQueryBuilder) throws {
        guard !builder.ids.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("ids")
        }

        self.init(ids: builder.ids, type: builder.type, boost: builder.boost, name: builder.name)
    }
}

public extension IdsQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        type = try nested.decodeStringIfPresent(forKey: .type)
        ids = try nested.decode([String].self, forKey: .values)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(ids, forKey: .values)
        try nested.encodeIfPresent(type, forKey: .type)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case values
        case type
        case boost
        case name
    }
}

extension IdsQuery: Equatable {
    public static func == (lhs: IdsQuery, rhs: IdsQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.ids == rhs.ids
            && lhs.type == rhs.type
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}
