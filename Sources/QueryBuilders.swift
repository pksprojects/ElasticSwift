//
//  QueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/3/17.
//
//

import Foundation

/// Class to get instances of various Query Builders.

final class QueryBuilders {
    
    private init() {}
    
    static func matchAllQuery() -> MatchAllQueryBuilder {
        return MatchAllQueryBuilder()
    }
    
    static func matchQuery() -> MatchQueryBuilder {
        return MatchQueryBuilder()
    }
    
    static func boolQuery() -> BoolQueryBuilder {
        return BoolQueryBuilder()
    }
}


/// Builder for MatchAll query.

class MatchAllQueryBuilder: QueryBuilder {
    
    private var _query: MatchAllQuery
    
    init() {
        self._query = MatchAllQuery()
    }
    
    func set(boost: Float) -> Self {
        return self
    }
    
    var query: Query {
        get {
            return self._query
        }
    }
}

/// Builder for Match query.

class MatchQueryBuilder: QueryBuilder {
    
    private var _query: MatchQuery
    
    init() {
        self._query = MatchQuery()
    }
    
    init(field: String, value: String) {
        self._query = MatchQuery(field: field, value: value)
    }
    
    func match(field: String, value: String) -> Self {
        self._query.field = field
        self._query.value = value
        return self
    }
    
    var query: Query {
        get {
            return self._query
        }
    }
    
    func set(boost: Float) -> Self {
        return self
    }
}


/// Builder for Bool query.

class BoolQueryBuilder: QueryBuilder {
    
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
    func must(query: QueryBuilder) -> BoolQueryBuilder {
        self.mustClauses.append(query)
        return self
    }
    
    @discardableResult
    func mustNot(query: QueryBuilder) -> BoolQueryBuilder {
        self.mustNotClauses.append(query)
        return self
    }
    
    @discardableResult
    func filter(query: QueryBuilder) -> BoolQueryBuilder {
        self.filterClauses.append(query)
        return self
    }
    
    @discardableResult
    func should(query: QueryBuilder) -> BoolQueryBuilder {
        self.shouldClauses.append(query)
        return self
    }
    
    func set(minimumShouldMatch: Int) -> BoolQueryBuilder {
        self.minimumShouldMatch = String(minimumShouldMatch)
        return self
    }
    
    func set(boost: Float) -> Self {
        return self
    }
    
    var query: Query {
        get {
            return BoolQuery(must: self.mustClauses, mustnot: self.mustNotClauses, should: self.shouldClauses, filter: self.filterClauses)
        }
    }
}

