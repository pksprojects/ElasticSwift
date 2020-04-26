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

    public let boost: Decimal?

    public init(_ boost: Decimal? = nil) {
        self.boost = boost
    }

    internal init(withBuilder builder: MatchAllQueryBuilder) {
        self.init(builder.boost)
    }
}

extension MatchAllQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        boost = try nested.decodeIfPresent(Decimal.self, forKey: .boost)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encodeIfPresent(boost, forKey: .boost)
    }

    enum CodingKeys: String, CodingKey {
        case boost
    }
}

extension MatchAllQuery: Equatable {
    public static func == (lhs: MatchAllQuery, rhs: MatchAllQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.boost == rhs.boost
    }
}

// MARK: - Match None Query

public struct MatchNoneQuery: Query {
    public let queryType: QueryType = QueryTypes.matchNone

    public init() {}

    internal init(withBuilder _: MatchNoneQueryBuilder) {
        self.init()
    }
}

extension MatchNoneQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        _ = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encode([String: String](), forKey: .key(named: queryType))
    }
}

extension MatchNoneQuery: Equatable {
    public static func == (lhs: MatchNoneQuery, rhs: MatchNoneQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
    }
}
