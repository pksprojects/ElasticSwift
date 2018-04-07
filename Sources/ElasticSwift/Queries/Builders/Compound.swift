//
//  Compound.swift
//  ElasticSwiftPackageDescription
//
//  Created by Prafull Kumar Soni on 4/7/18.
//

import Foundation

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

