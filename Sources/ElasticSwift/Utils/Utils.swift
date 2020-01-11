//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

import ElasticSwiftCore
import Foundation

/// Elasticsearch version type
public enum VersionType: String, Codable {
    case `internal`
    case external
    case externalGte = "external_gte"
    case force
}

/// Elasticsearch index refresh type
public enum IndexRefresh: String, Codable {
    case `true`
    case `false`
    case waitFor = "wait_for"
}

/// Elasticsearch request op_type
public enum OpType: String, Codable {
    case index
    case create
    case update
    case delete
}

/// Mode in which to expand wildcard expresion to concrete indices
public enum ExpandWildcards: String, Codable {
    case open
    case closed
    case none
    case all
}

/// Operator for query string query
public enum QueryStringQueryOperator: String, Codable {
    case and = "AND"
    case or = "OR"
}

/// URLQueryItem extension with convenience initializers with `QueryParams`
extension URLQueryItem {
    /// Convenience initializer
    /// - Parameters:
    ///   - name: query parameter
    ///   - value: optional string value
    init(name: QueryParams, value: String?) {
        self.init(name: name.rawValue, value: value)
    }

    /// Convenience initializer
    /// - Parameters:
    ///   - name: query parameter
    ///   - value: optional bool value
    init(name: QueryParams, value: Bool?) {
        self.init(name: name.rawValue, value: value?.description)
    }

    /// Convenience initializer
    /// - Parameters:
    ///   - name: query parameter
    ///   - value: optional int value
    init(name: QueryParams, value: Int?) {
        self.init(name: name.rawValue, value: value?.description)
    }

    /// Convenience initializer
    /// - Parameters:
    ///   - name: query parameter
    ///   - value: optional float value
    init(name: QueryParams, value: Float?) {
        self.init(name: name.rawValue, value: value?.description)
    }

    /// Convenience initializer
    /// - Parameters:
    ///   - name: query parameter
    ///   - value: optional double value
    init(name: QueryParams, value: Double?) {
        self.init(name: name.rawValue, value: value?.description)
    }

    /// Convenience initializer
    /// - Parameters:
    ///   - name: query parameter
    ///   - value: optional decimal value
    init(name: QueryParams, value: Decimal?) {
        self.init(name: name.rawValue, value: value?.description)
    }

    /// Convenience initializer
    /// - Parameters:
    ///   - name: query parameter
    ///   - value: optional string array value
    init(name: QueryParams, value: [String]?) {
        self.init(name: name.rawValue, value: value?.joined(separator: ","))
    }
}

/// Dictionary Wrapper to pass dictionary as referance
internal class SharedDic<K: Hashable, V> {
    var dict: [K: V] = Dictionary()
    subscript(key: K) -> V? {
        get {
            return dict[key]
        }
        set(newValue) {
            dict[key] = newValue
        }
    }
}
