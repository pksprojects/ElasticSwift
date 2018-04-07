//
//  MatchAll.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation

/// Builder for MatchAll query.

public class MatchAllQueryBuilder: QueryBuilder {
    
    private var _query: MatchAllQuery
    
    init() {
        self._query = MatchAllQuery()
    }
    
    public func set(boost: Float) -> Self {
        return self
    }
    
    public var query: Query {
        get {
            return self._query
        }
    }
}
