//
//  QueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/3/17.
//
//

import Foundation
import ElasticSwiftCore

/// Class to get instances of various Query Builders.

public final class QueryBuilders {
    
    private init() {}
    
    public static func matchAllQuery() -> MatchAllQueryBuilder {
        return MatchAllQueryBuilder()
    }
    
    public static func matchQuery() -> MatchQueryBuilder {
        return MatchQueryBuilder()
    }
    
    public static func matchPhraseQuery() -> MatchPhraseQueryBuilder {
        return MatchPhraseQueryBuilder()
    }
    
    public static func matchPhrasePrefixQuery() -> MatchPhrasePrefixQueryBuilder {
        return MatchPhrasePrefixQueryBuilder()
    }
    
    public static func multiMatchQuery() -> MultiMatchQueryBuilder {
        return MultiMatchQueryBuilder()
    }
    
    public static func commonTermsQuery() -> CommonTermsQueryBuilder {
        return CommonTermsQueryBuilder()
    }
    
    public static func queryStringQuery() -> QueryStringQueryBuilder {
        return QueryStringQueryBuilder()
    }
    
    public static func simpleQueryStringQuery() -> SimpleQueryStringQueryBuilder {
        return SimpleQueryStringQueryBuilder()
    }
    
    public static func termQuery() -> TermQueryBuilder {
        return TermQueryBuilder()
    }
    
    public static func termsQuery() -> TermsQueryBuilder {
        return TermsQueryBuilder()
    }
    
    public static func rangeQuery() -> RangeQueryBuilder {
        return RangeQueryBuilder()
    }
    
    public static func existsQuery() -> ExistsQueryBuilder {
        return ExistsQueryBuilder()
    }
    
    public static func prefixQuery() -> PrefixQueryBuilder {
        return PrefixQueryBuilder()
    }
    
    public static func wildCardQuery() -> WildCardQueryBuilder {
        return WildCardQueryBuilder()
    }
    
    public static func regexpQuery() -> RegexpQueryBuilder {
        return RegexpQueryBuilder()
    }
    
    public static func fuzzyQuery() -> FuzzyQueryBuilder {
        return FuzzyQueryBuilder()
    }
    
    public static func typeQuery() -> TypeQueryBuilder {
        return TypeQueryBuilder()
    }
    
    public static func idsQuery() -> IdsQueryBuilder {
        return IdsQueryBuilder()
    }
    
    public static func boolQuery() -> BoolQueryBuilder {
        return BoolQueryBuilder()
    }
    
    public static func constantScoreQuery() -> ConstantScoreQueryBuilder {
        return ConstantScoreQueryBuilder()
    }
    
    public static func disMaxQuery() -> DisMaxQueryBuilder {
        return DisMaxQueryBuilder()
    }
    
    public static func functionScoreQuery() -> FunctionScoreQueryBuilder {
        return FunctionScoreQueryBuilder()
    }
    
    public static func boostingQuery() -> BoostingQueryBuilder {
        return BoostingQueryBuilder()
    }
    
}

/// QueryBuilders Extension with builder encloser syntax

extension QueryBuilders {
    
    public static func matchAllQuery(_ closure: (MatchAllQueryBuilder) -> Void) -> MatchAllQueryBuilder {
        return MatchAllQueryBuilder(builderClosure: closure)
    }
    
    public static func matchQuery(_ closure: (MatchQueryBuilder) -> Void) -> MatchQueryBuilder {
        return MatchQueryBuilder(builderClosure: closure)
    }
    
    public static func matchPhraseQuery(_ closure: (MatchPhraseQueryBuilder) -> Void) -> MatchPhraseQueryBuilder {
        return MatchPhraseQueryBuilder(builderClosure: closure)
    }
    
    public static func matchPhrasePrefixQuery(_ closure: (MatchPhrasePrefixQueryBuilder) -> Void) -> MatchPhrasePrefixQueryBuilder {
        return MatchPhrasePrefixQueryBuilder(builderClosure: closure)
    }
    
    public static func multiMatchQuery(_ closure: (MultiMatchQueryBuilder) -> Void) -> MultiMatchQueryBuilder {
        return MultiMatchQueryBuilder(builderClosure: closure)
    }
    
    public static func commonTermsQuery(_ closure: (CommonTermsQueryBuilder) -> Void) -> CommonTermsQueryBuilder {
        return CommonTermsQueryBuilder(builderClosure: closure)
    }
    
    public static func queryStringQuery(_ closure: (QueryStringQueryBuilder) -> Void) -> QueryStringQueryBuilder {
        return QueryStringQueryBuilder(builderClosure: closure)
    }
    
    public static func simpleQueryStringQuery(_ closure: (SimpleQueryStringQueryBuilder) -> Void) -> SimpleQueryStringQueryBuilder {
        return SimpleQueryStringQueryBuilder(builderClosure: closure)
    }
    
    public static func termQuery(_ closure: (TermQueryBuilder) -> Void) -> TermQueryBuilder {
        return TermQueryBuilder(builderClosure: closure)
    }
    
    public static func termsQuery(_ closure: (TermsQueryBuilder) -> Void) -> TermsQueryBuilder {
        return TermsQueryBuilder(builderClosure: closure)
    }
    
    public static func rangeQuery(_ closure: (RangeQueryBuilder) -> Void) -> RangeQueryBuilder {
        return RangeQueryBuilder(builderClosure: closure)
    }
    
    public static func existsQuery(_ closure: (ExistsQueryBuilder) -> Void) -> ExistsQueryBuilder {
        return ExistsQueryBuilder(builderClosure: closure)
    }
    
    public static func prefixQuery(_ closure: (PrefixQueryBuilder) -> Void) -> PrefixQueryBuilder {
        return PrefixQueryBuilder(builderClosure: closure)
    }
    
    public static func wildCardQuery(_ closure: (WildCardQueryBuilder) -> Void) -> WildCardQueryBuilder {
        return WildCardQueryBuilder(builderClosure: closure)
    }
    
    public static func regexpQuery(_ closure: (RegexpQueryBuilder) -> Void) -> RegexpQueryBuilder {
        return RegexpQueryBuilder(builderClosure: closure)
    }
    
    public static func fuzzyQuery(_ closure: (FuzzyQueryBuilder) -> Void) -> FuzzyQueryBuilder {
        return FuzzyQueryBuilder(builderClosure: closure)
    }
    
    public static func typeQuery(_ closure: (TypeQueryBuilder) -> Void) -> TypeQueryBuilder {
        return TypeQueryBuilder(builderClosure: closure)
    }
    
    public static func idsQuery(_ closure: (IdsQueryBuilder) -> Void) -> IdsQueryBuilder {
        return IdsQueryBuilder(builderClosure: closure)
    }
    
    public static func boolQuery(_ closure: (BoolQueryBuilder) -> Void) -> BoolQueryBuilder {
        return BoolQueryBuilder(builderClosure: closure)
    }
    
    public static func constantScoreQuery(_ closure: (ConstantScoreQueryBuilder) -> Void) -> ConstantScoreQueryBuilder {
        return ConstantScoreQueryBuilder(builderClosure: closure)
    }
    
    public static func DisMaxQuery(_ closure: (DisMaxQueryBuilder) -> Void) -> DisMaxQueryBuilder {
        return DisMaxQueryBuilder(builderClosure: closure)
    }
    
    public static func functionScoreQuery(_ closure: (FunctionScoreQueryBuilder) -> Void) -> FunctionScoreQueryBuilder {
        return FunctionScoreQueryBuilder(builderClosure: closure)
    }
    
    public static func boostingeQuery(_ closure: (BoostingQueryBuilder) -> Void) -> BoostingQueryBuilder {
        return BoostingQueryBuilder(builderClosure: closure)
    }
}
