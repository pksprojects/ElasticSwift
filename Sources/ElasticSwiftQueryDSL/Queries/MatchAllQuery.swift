//
//  MatchAllQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/22/18.
//

import ElasticSwiftCore
import Foundation

// MARK: -  Match all Query

public struct MatchAllQuery: Query {
    public let queryType: QueryType = QueryTypes.matchAll

    public var boost: Decimal?
    public var name: String?

    public init(boost: Decimal? = nil, name: String? = nil) {
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: MatchAllQueryBuilder) throws {
        self.init(boost: builder.boost, name: builder.name)
    }
}

public extension MatchAllQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        boost = try nested.decodeIfPresent(Decimal.self, forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case name
    }
}

extension MatchAllQuery: Equatable {
    public static func == (lhs: MatchAllQuery, rhs: MatchAllQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Match None Query

public struct MatchNoneQuery: Query {
    public let queryType: QueryType = QueryTypes.matchNone

    public var boost: Decimal?
    public var name: String?

    public init(boost: Decimal? = nil, name: String? = nil) {
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: MatchNoneQueryBuilder) throws {
        self.init(boost: builder.boost, name: builder.name)
    }
}

public extension MatchNoneQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        boost = try nested.decodeDecimalIfPresent(forKey: .boost)
        name = try nested.decodeStringIfPresent(forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encodeIfPresent(boost, forKey: .boost)
        try nested.encodeIfPresent(name, forKey: .name)
    }

    internal enum CodingKeys: String, CodingKey {
        case boost
        case name
    }
}

extension MatchNoneQuery: Equatable {
    public static func == (lhs: MatchNoneQuery, rhs: MatchNoneQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}
