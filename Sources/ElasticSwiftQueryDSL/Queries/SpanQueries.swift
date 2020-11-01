//
//  SpanQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Span Query

public protocol SpanQuery: Query {}

// MARK: - Span Term Query

public struct SpanTermQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanTerm

    public let field: String
    public let value: String
    public var name: String?
    public var boost: Decimal?

    public init(field: String, value: String, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.value = value
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SpanTermQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.value != nil else {
            throw QueryBuilderError.missingRequiredField("value")
        }

        self.init(field: builder.field!, value: builder.value!, boost: builder.boost, name: builder.name)
    }
}

public extension SpanTermQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(SpanTermQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        if let fieldContainer = try? nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field)) {
            if fieldContainer.allKeys.contains(.term) {
                value = try fieldContainer.decodeString(forKey: .term)
            } else {
                value = try fieldContainer.decodeString(forKey: .value)
            }
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
        case value
        case term
        case boost
        case name
    }
}

extension SpanTermQuery: Equatable {
    public static func == (lhs: SpanTermQuery, rhs: SpanTermQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.value == rhs.value
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span Multi Term Query

public struct SpanMultiTermQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanMulti

    public let match: MultiTermQuery
    public var boost: Decimal?
    public var name: String?

    public init(_ match: MultiTermQuery, boost: Decimal? = nil, name: String? = nil) {
        self.match = match
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SpanMultiTermQueryBuilder) throws {
        guard let match = builder.match else {
            throw QueryBuilderError.missingRequiredField("match")
        }
        self.init(match, boost: builder.boost, name: builder.name)
    }
}

public extension SpanMultiTermQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        guard let multiTermQuery = try nested.decodeQuery(forKey: .match) as? MultiTermQuery else {
            throw Swift.DecodingError.dataCorruptedError(forKey: .match, in: nested, debugDescription: "Unable to decode MultiTermQuery")
        }
        match = multiTermQuery
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(match, forKey: .match)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case match
        case boost
        case name
    }
}

extension SpanMultiTermQuery: Equatable {
    public static func == (lhs: SpanMultiTermQuery, rhs: SpanMultiTermQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.match.isEqualTo(rhs.match)
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span First Query

public struct SpanFirstQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanFirst

    public let match: SpanQuery
    public let end: Int
    public var boost: Decimal?
    public var name: String?

    public init(_ match: SpanQuery, end: Int, boost: Decimal? = nil, name: String? = nil) {
        self.match = match
        self.end = end
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SpanFirstQueryBuilder) throws {
        guard let match = builder.match else {
            throw QueryBuilderError.missingRequiredField("match")
        }
        guard let end = builder.end else {
            throw QueryBuilderError.missingRequiredField("end")
        }
        self.init(match, end: end, boost: builder.boost, name: builder.name)
    }
}

public extension SpanFirstQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        end = try nested.decodeInt(forKey: .end)
        let query = try nested.decodeQuery(forKey: .match)
        guard let spanQuery = query as? SpanQuery else {
            throw Swift.DecodingError.dataCorruptedError(forKey: .match, in: nested, debugDescription: "Unable to decode SpanQuery")
        }
        match = spanQuery
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(match, forKey: .match)
        try nested.encode(end, forKey: .end)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case match
        case end
        case boost
        case name
    }
}

extension SpanFirstQuery: Equatable {
    public static func == (lhs: SpanFirstQuery, rhs: SpanFirstQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.match.isEqualTo(rhs.match)
            && lhs.end == rhs.end
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span Near Query

public struct SpanNearQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanNear

    public let clauses: [SpanQuery]
    public var slop: Int?
    public var inOrder: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(_ clauses: [SpanQuery], slop: Int? = nil, inOrder: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.clauses = clauses
        self.slop = slop
        self.inOrder = inOrder
        self.boost = boost
        self.name = name
    }

    public init(_ clauses: SpanQuery..., slop: Int? = nil, inOrder: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.init(clauses, slop: slop, inOrder: inOrder, boost: boost, name: name)
    }

    internal init(withBuilder builder: SpanNearQueryBuilder) throws {
        guard let clauses = builder.clauses, !clauses.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("clauses")
        }
        self.init(clauses, slop: builder.slop, inOrder: builder.inOrder, boost: builder.boost, name: builder.name)
    }
}

public extension SpanNearQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        let queries = try nested.decodeQueries(forKey: .clauses)
        guard let spanQueries = queries as? [SpanQuery] else {
            throw Swift.DecodingError.dataCorruptedError(forKey: .clauses, in: nested, debugDescription: "Unable to decode SpanQueries")
        }
        clauses = spanQueries
        slop = try nested.decodeIntIfPresent(forKey: .slop)
        inOrder = try nested.decodeBoolIfPresent(forKey: .inOrder)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(clauses, forKey: .clauses)
        try nested.encodeIfPresent(slop, forKey: .slop)
        try nested.encodeIfPresent(inOrder, forKey: .inOrder)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case clauses
        case slop
        case inOrder = "in_order"
        case boost
        case name
    }
}

extension SpanNearQuery: Equatable {
    public static func == (lhs: SpanNearQuery, rhs: SpanNearQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.slop == rhs.slop
            && lhs.inOrder == rhs.inOrder
            && lhs.clauses.count == rhs.clauses.count
            && !zip(lhs.clauses, rhs.clauses).contains { !$0.isEqualTo($1) }
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span Or Query

public struct SpanOrQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanOr

    public let clauses: [SpanQuery]
    public var boost: Decimal?
    public var name: String?

    public init(_ clauses: [SpanQuery], boost: Decimal? = nil, name: String? = nil) {
        self.clauses = clauses
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SpanOrQueryBuilder) throws {
        guard let clauses = builder.clauses, !clauses.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("clauses")
        }
        self.init(clauses, boost: builder.boost, name: builder.name)
    }
}

public extension SpanOrQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        let queries = try nested.decodeQueries(forKey: .clauses)
        guard let spanQueries = queries as? [SpanQuery] else {
            throw Swift.DecodingError.dataCorruptedError(forKey: .clauses, in: nested, debugDescription: "Unable to decode SpanQueries")
        }
        clauses = spanQueries
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(clauses, forKey: .clauses)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case clauses
        case boost
        case name
    }
}

extension SpanOrQuery: Equatable {
    public static func == (lhs: SpanOrQuery, rhs: SpanOrQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.clauses.count == rhs.clauses.count
            && !zip(lhs.clauses, rhs.clauses).contains { !$0.isEqualTo($1) }
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span Not Query

public struct SpanNotQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanNot

    public let include: SpanQuery
    public let exclude: SpanQuery

    public var pre: Int?
    public var post: Int?

    public var boost: Decimal?
    public var name: String?

    public init(include: SpanQuery, exclude: SpanQuery, pre: Int? = nil, post: Int? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.include = include
        self.exclude = exclude
        self.pre = pre
        self.post = post
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SpanNotQueryBuilder) throws {
        guard let include = builder.include else {
            throw QueryBuilderError.missingRequiredField("include")
        }
        guard let exclude = builder.exclude else {
            throw QueryBuilderError.missingRequiredField("exclude")
        }
        self.init(include: include, exclude: exclude, pre: builder.pre, post: builder.post, boost: builder.boost, name: builder.name)
    }
}

public extension SpanNotQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        include = try nested.decodeQuery(forKey: .include) as! SpanQuery
        exclude = try nested.decodeQuery(forKey: .exclude) as! SpanQuery
        if nested.allKeys.contains(.dist) {
            let dist = try nested.decodeInt(forKey: .dist)
            pre = dist
            post = dist
        } else {
            pre = try nested.decodeIntIfPresent(forKey: .pre)
            post = try nested.decodeIntIfPresent(forKey: .post)
        }
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(include, forKey: .include)
        try nested.encode(exclude, forKey: .exclude)
        try nested.encodeIfPresent(pre, forKey: .pre)
        try nested.encodeIfPresent(post, forKey: .post)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case include
        case exclude
        case pre
        case post
        case dist
        case boost
        case name
    }
}

extension SpanNotQuery: Equatable {
    public static func == (lhs: SpanNotQuery, rhs: SpanNotQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.include.isEqualTo(rhs.include)
            && lhs.exclude.isEqualTo(rhs.exclude)
            && lhs.pre == rhs.pre
            && lhs.post == rhs.post
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span Containing Query

public struct SpanContainingQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanContaining

    public let big: SpanQuery
    public let little: SpanQuery
    public var boost: Decimal?
    public var name: String?

    public init(big: SpanQuery, little: SpanQuery, boost: Decimal? = nil, name: String? = nil) {
        self.big = big
        self.little = little
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SpanContainingQueryBuilder) throws {
        guard let big = builder.big else {
            throw QueryBuilderError.missingRequiredField("big")
        }
        guard let little = builder.little else {
            throw QueryBuilderError.missingRequiredField("little")
        }
        self.init(big: big, little: little, boost: builder.boost, name: builder.name)
    }
}

public extension SpanContainingQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        big = try nested.decodeQuery(forKey: .big) as! SpanQuery
        little = try nested.decodeQuery(forKey: .little) as! SpanQuery
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(big, forKey: .big)
        try nested.encode(little, forKey: .little)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case big
        case little
        case boost
        case name
    }
}

extension SpanContainingQuery: Equatable {
    public static func == (lhs: SpanContainingQuery, rhs: SpanContainingQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.big.isEqualTo(rhs.big)
            && lhs.little.isEqualTo(rhs.little)
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span Within Query

public struct SpanWithinQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanWithin

    public let big: SpanQuery
    public let little: SpanQuery
    public var boost: Decimal?
    public var name: String?

    public init(big: SpanQuery, little: SpanQuery, boost _: Decimal? = nil, name _: String? = nil) {
        self.big = big
        self.little = little
    }

    internal init(withBuilder builder: SpanWithinQueryBuilder) throws {
        guard let big = builder.big else {
            throw QueryBuilderError.missingRequiredField("big")
        }
        guard let little = builder.little else {
            throw QueryBuilderError.missingRequiredField("little")
        }
        self.init(big: big, little: little, boost: builder.boost, name: builder.name)
    }
}

public extension SpanWithinQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        big = try nested.decodeQuery(forKey: .big) as! SpanQuery
        little = try nested.decodeQuery(forKey: .little) as! SpanQuery
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(big, forKey: .big)
        try nested.encode(little, forKey: .little)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case big
        case little
        case boost
        case name
    }
}

extension SpanWithinQuery: Equatable {
    public static func == (lhs: SpanWithinQuery, rhs: SpanWithinQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.big.isEqualTo(rhs.big)
            && lhs.little.isEqualTo(rhs.little)
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Span Field Masking Query

public struct SpanFieldMaskingQuery: SpanQuery {
    public let queryType: QueryType = QueryTypes.spanFieldMasking

    public let query: SpanQuery
    public let field: String
    public var boost: Decimal?
    public var name: String?

    public init(field: String, query: SpanQuery, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.query = query
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: SpanFieldMaskingQueryBuilder) throws {
        guard let query = builder.query else {
            throw QueryBuilderError.missingRequiredField("query")
        }
        guard let field = builder.field else {
            throw QueryBuilderError.missingRequiredField("field")
        }
        self.init(field: field, query: query, boost: builder.boost, name: builder.name)
    }
}

public extension SpanFieldMaskingQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        query = try nested.decodeQuery(forKey: .query) as! SpanQuery
        field = try nested.decodeString(forKey: .field)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(query, forKey: .query)
        try nested.encode(field, forKey: .field)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case field
        case query
        case boost
        case name
    }
}

extension SpanFieldMaskingQuery: Equatable {
    public static func == (lhs: SpanFieldMaskingQuery, rhs: SpanFieldMaskingQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.query.isEqualTo(rhs.query)
            && lhs.field == rhs.field
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}
