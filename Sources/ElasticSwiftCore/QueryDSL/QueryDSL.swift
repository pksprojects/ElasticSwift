//
//  Query.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/3/17.
//
//

import Foundation

// MARK: - Query Protocol

/// Protocol that all `Query` conforms to
public protocol Query: Codable {
    var queryType: QueryType { get }
    var boost: Decimal? { get set }
    var name: String? { get set }

    func isEqualTo(_ other: Query) -> Bool
}

public extension Query where Self: Equatable {
    func isEqualTo(_ other: Query) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

// MARK: - QueryType Protocol

/// Protocol to wrap query type information
public protocol QueryType: Codable {
    var metaType: Query.Type { get }

    var name: String { get }

    init?(_ name: String)

    func isEqualTo(_ other: QueryType) -> Bool
}

public extension QueryType where Self: RawRepresentable, Self.RawValue == String {
    var name: String {
        return rawValue
    }

    init?(_ name: String) {
        if let v = Self(rawValue: name) {
            self = v
        } else {
            return nil
        }
    }
}

public extension QueryType where Self: Equatable {
    func isEqualTo(_ other: QueryType) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

/// Protocol that all Builder for `Query` conforms to
public protocol QueryBuilder: ElasticSwiftTypeBuilder where ElasticSwiftType: Query {}

public struct DynamicCodingKeys: CodingKey {
    public var stringValue: String

    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    public var intValue: Int?

    public init?(intValue: Int) {
        self.intValue = intValue
        stringValue = String(intValue)
    }

    public static func key(named name: String) -> DynamicCodingKeys {
        return DynamicCodingKeys(stringValue: name)!
    }

    public static func key(indexed index: Int) -> DynamicCodingKeys {
        return DynamicCodingKeys(intValue: index)!
    }
}
