//
//  JoiningQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - Nested Query

public struct NestedQuery: Query {
    public let queryType: QueryType = QueryTypes.nested

    public let path: String
    public let query: Query
    public let scoreMode: ScoreMode?
    public let ignoreUnmapped: Bool?
    public let innerHits: InnerHit?
    public var boost: Decimal?
    public var name: String?

    public init(_ path: String, query: Query, scoreMode: ScoreMode? = nil, ignoreUnmapped: Bool? = nil, innerHits: InnerHit? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.path = path
        self.query = query
        self.scoreMode = scoreMode
        self.ignoreUnmapped = ignoreUnmapped
        self.innerHits = innerHits
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: NestedQueryBuilder) throws {
        guard builder.path != nil else {
            throw QueryBuilderError.missingRequiredField("path")
        }

        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(builder.path!, query: builder.query!, scoreMode: builder.scoreMode, ignoreUnmapped: builder.ignoreUnmapped, innerHits: builder.innerHits, boost: builder.boost, name: builder.name)
    }
}

public extension NestedQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(NestedQuery.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        path = try nested.decodeString(forKey: .path)
        query = try nested.decodeQuery(forKey: .query)
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .ignoreUnmapped)
        scoreMode = try nested.decodeIfPresent(ScoreMode.self, forKey: .scoreMode)
        innerHits = try nested.decodeIfPresent(InnerHit.self, forKey: .innerHits)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(path, forKey: .path)
        try nested.encode(query, forKey: .query)
        try nested.encodeIfPresent(scoreMode, forKey: .scoreMode)
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .ignoreUnmapped)
        try nested.encodeIfPresent(innerHits, forKey: .innerHits)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case path
        case query
        case scoreMode = "score_mode"
        case ignoreUnmapped = "ignore_unmapped"
        case innerHits = "inner_hits"
        case boost
        case name
    }
}

extension NestedQuery: Equatable {
    public static func == (lhs: NestedQuery, rhs: NestedQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.path == rhs.path
            && lhs.query.isEqualTo(rhs.query)
            && lhs.scoreMode == rhs.scoreMode
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.innerHits == rhs.innerHits
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - HasChild Query

public struct HasChildQuery: Query {
    public let queryType: QueryType = QueryTypes.hasChild

    public let type: String
    public let query: Query
    public let scoreMode: ScoreMode?
    public let minChildren: Int?
    public let maxChildren: Int?
    public let ignoreUnmapped: Bool?
    public let innerHits: InnerHit?
    public var boost: Decimal?
    public var name: String?

    public init(_ type: String, query: Query, scoreMode: ScoreMode? = nil, minChildren: Int? = nil, maxChildren: Int? = nil, ignoreUnmapped: Bool? = nil, innerHits: InnerHit? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.type = type
        self.query = query
        self.scoreMode = scoreMode
        self.maxChildren = maxChildren
        self.minChildren = minChildren
        self.ignoreUnmapped = ignoreUnmapped
        self.innerHits = innerHits
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: HasChildQueryBuilder) throws {
        guard builder.type != nil else {
            throw QueryBuilderError.missingRequiredField("type")
        }

        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(builder.type!, query: builder.query!, scoreMode: builder.scoreMode, minChildren: builder.minChildren, maxChildren: builder.maxChildren, ignoreUnmapped: builder.ignoreUnmapped, innerHits: builder.innerHits, boost: builder.boost, name: builder.name)
    }
}

public extension HasChildQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(HasChildQuery.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        type = try nested.decodeString(forKey: .type)
        query = try nested.decodeQuery(forKey: .query)
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .ignoreUnmapped)
        scoreMode = try nested.decodeIfPresent(ScoreMode.self, forKey: .scoreMode)
        innerHits = try nested.decodeIfPresent(InnerHit.self, forKey: .innerHits)
        minChildren = try nested.decodeIntIfPresent(forKey: .minChildren)
        maxChildren = try nested.decodeIntIfPresent(forKey: .maxChildren)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(type, forKey: .type)
        try nested.encode(query, forKey: .query)
        try nested.encodeIfPresent(scoreMode, forKey: .scoreMode)
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .ignoreUnmapped)
        try nested.encodeIfPresent(innerHits, forKey: .innerHits)
        try nested.encodeIfPresent(minChildren, forKey: .minChildren)
        try nested.encodeIfPresent(maxChildren, forKey: .maxChildren)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case type
        case query
        case scoreMode = "score_mode"
        case minChildren = "min_children"
        case maxChildren = "max_children"
        case ignoreUnmapped = "ignore_unmapped"
        case innerHits = "inner_hits"
        case boost
        case name
    }
}

extension HasChildQuery: Equatable {
    public static func == (lhs: HasChildQuery, rhs: HasChildQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.type == rhs.type
            && lhs.query.isEqualTo(rhs.query)
            && lhs.scoreMode == rhs.scoreMode
            && lhs.minChildren == rhs.minChildren
            && lhs.maxChildren == rhs.maxChildren
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - HasParent Query

public struct HasParentQuery: Query {
    public let queryType: QueryType = QueryTypes.hasParent

    public let parentType: String
    public let query: Query
    public let score: Bool?
    public let ignoreUnmapped: Bool?
    public let innerHits: InnerHit?
    public var boost: Decimal?
    public var name: String?

    public init(_ parentType: String, query: Query, score: Bool? = nil, ignoreUnmapped: Bool? = nil, innerHits: InnerHit? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.parentType = parentType
        self.query = query
        self.score = score
        self.ignoreUnmapped = ignoreUnmapped
        self.innerHits = innerHits
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: HasParentQueryBuilder) throws {
        guard builder.parentType != nil else {
            throw QueryBuilderError.missingRequiredField("parentType")
        }

        guard builder.query != nil else {
            throw QueryBuilderError.missingRequiredField("query")
        }

        self.init(builder.parentType!, query: builder.query!, score: builder.score, ignoreUnmapped: builder.ignoreUnmapped, innerHits: builder.innerHits, boost: builder.boost, name: builder.name)
    }
}

public extension HasParentQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(HasParentQuery.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        parentType = try nested.decodeString(forKey: .parentType)
        query = try nested.decodeQuery(forKey: .query)
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .ignoreUnmapped)
        score = try nested.decodeBoolIfPresent(forKey: .score)
        innerHits = try nested.decodeIfPresent(InnerHit.self, forKey: .innerHits)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(parentType, forKey: .parentType)
        try nested.encode(query, forKey: .query)
        try nested.encodeIfPresent(score, forKey: .score)
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .ignoreUnmapped)
        try nested.encodeIfPresent(innerHits, forKey: .innerHits)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case parentType = "parent_type"
        case query
        case score
        case ignoreUnmapped = "ignore_unmapped"
        case innerHits = "inner_hits"
        case boost
        case name
    }
}

extension HasParentQuery: Equatable {
    public static func == (lhs: HasParentQuery, rhs: HasParentQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.parentType == rhs.parentType
            && lhs.query.isEqualTo(rhs.query)
            && lhs.score == rhs.score
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.innerHits == rhs.innerHits
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - ParentId Query

public struct ParentIdQuery: Query {
    public let queryType: QueryType = QueryTypes.parentId

    public let type: String
    public let id: String
    public let ignoreUnmapped: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(_ id: String, type: String, ignoreUnmapped: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.id = id
        self.type = type
        self.ignoreUnmapped = ignoreUnmapped
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: ParentIdQueryBuilder) throws {
        guard builder.id != nil else {
            throw QueryBuilderError.missingRequiredField("id")
        }

        guard builder.type != nil else {
            throw QueryBuilderError.missingRequiredField("type")
        }
        self.init(builder.id!, type: builder.type!, ignoreUnmapped: builder.ignoreUnmapped, boost: builder.boost, name: builder.name)
    }
}

public extension ParentIdQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(ParentIdQuery.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))

        type = try nested.decodeString(forKey: .type)
        id = try nested.decodeString(forKey: .id)
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .ignoreUnmapped)
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(type, forKey: .type)
        try nested.encode(id, forKey: .id)
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .ignoreUnmapped)
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case type
        case id
        case ignoreUnmapped = "ignore_unmapped"
        case boost
        case name
    }
}

extension ParentIdQuery: Equatable {
    public static func == (lhs: ParentIdQuery, rhs: ParentIdQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.id == rhs.id
            && lhs.type == rhs.type
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}
