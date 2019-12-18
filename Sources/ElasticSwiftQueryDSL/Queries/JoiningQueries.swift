//
//  JoiningQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Nested Query

internal struct NestedQuery: Query {
    // TODO: remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return name == other.name
    }

    public let name: String = ""

    public init(withBuilder _: NestedQueryBuilder) {}

    public func toDic() -> [String: Any] {
        let dic: [String: Any] = [:]
        return dic
    }
}

// MARK: - HasChild Query

internal struct HasChildQuery: Query {
    // TODO: remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return name == other.name
    }

    public let name: String = ""

    public init(withBuilder _: HasChildQueryBuilder) {}

    public func toDic() -> [String: Any] {
        let dic: [String: Any] = [:]
        return dic
    }
}

// MARK: - HasParent Query

internal struct HasParentQuery: Query {
    // TODO: remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return name == other.name
    }

    public let name: String = ""

    public init(withBuilder _: HasParentQueryBuilder) {}

    public func toDic() -> [String: Any] {
        let dic: [String: Any] = [:]
        return dic
    }
}

// MARK: - ParentId Query

internal struct ParentIdQuery: Query {
    // TODO: remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return name == other.name
    }

    public let name: String = ""

    public init(withBuilder _: ParentIdQueryBuilder) {}

    public func toDic() -> [String: Any] {
        let dic: [String: Any] = [:]
        return dic
    }
}
