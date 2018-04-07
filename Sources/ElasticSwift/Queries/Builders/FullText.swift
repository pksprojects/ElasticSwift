//
//  FullTextSearch.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation

/// Builder for Match query.

public class MatchQueryBuilder: QueryBuilder {
    
    private var _query: MatchQuery
    
    init() {
        self._query = MatchQuery()
    }
    
    public init(field: String, value: String) {
        self._query = MatchQuery(field: field, value: value)
    }
    
    public func match(field: String, value: String) -> Self {
        self._query.field = field
        self._query.value = value
        return self
    }
    
    public var query: Query {
        get {
            return self._query
        }
    }
    
    public func set(boost: Float) -> Self {
        return self
    }
}


