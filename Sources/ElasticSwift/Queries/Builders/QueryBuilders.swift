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


