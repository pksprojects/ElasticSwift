//
//  QueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/3/17.
//
//

import Foundation

/// Class to get instances of various Query Builders.

public final class QueryBuilders {
    
    private init() {}
    
    public static func matchAllQuery() -> MatchAllQueryBuilder {
        return MatchAllQueryBuilder()
    }
    
    public static func matchQuery() -> MatchQueryBuilder {
        return MatchQueryBuilder()
    }
    
    public static func boolQuery() -> BoolQueryBuilder {
        return BoolQueryBuilder()
    }
}


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


/// Builder for Bool query.

public class BoolQueryBuilder: QueryBuilder {
    
    var boost: Float = 0.0
    
    private let MUST: String = "must"
    private let MUST_NOT: String = "must_not"
    private let SHOULD: String = "should"
    private let FILTER: String = "filter"
    
    private var mustClauses:[QueryBuilder] = []
    private var mustNotClauses:[QueryBuilder] = []
    private var shouldClauses:[QueryBuilder] = []
    private var filterClauses:[QueryBuilder] = []
    private var minimumShouldMatch: String = ""
    
    @discardableResult
    public func must(query: QueryBuilder) -> BoolQueryBuilder {
        self.mustClauses.append(query)
        return self
    }
    
    @discardableResult
    public func mustNot(query: QueryBuilder) -> BoolQueryBuilder {
        self.mustNotClauses.append(query)
        return self
    }
    
    @discardableResult
    public func filter(query: QueryBuilder) -> BoolQueryBuilder {
        self.filterClauses.append(query)
        return self
    }
    
    @discardableResult
    public func should(query: QueryBuilder) -> BoolQueryBuilder {
        self.shouldClauses.append(query)
        return self
    }
    
    public func set(minimumShouldMatch: Int) -> BoolQueryBuilder {
        self.minimumShouldMatch = String(minimumShouldMatch)
        return self
    }
    
    public func set(boost: Float) -> Self {
        return self
    }
    
    public var query: Query {
        get {
            return BoolQuery(must: self.mustClauses, mustnot: self.mustNotClauses, should: self.shouldClauses, filter: self.filterClauses)
        }
    }
}

