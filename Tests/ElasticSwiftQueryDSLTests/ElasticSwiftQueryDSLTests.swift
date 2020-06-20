//
//  ElasticSwiftQueryDSLTests.swift
//
//
//  Created by Prafull Kumar Soni on 6/14/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class ElasticSwiftQueryDSLTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.ElasticSwiftQueryDSLTests", factory: logFactory)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        logger.info("====================TEST=END===============================")
    }

    func test_01_QueryTypes() throws {
        XCTAssertEqual(QueryTypes.matchAll.rawValue, "match_all")
        XCTAssertEqual("\(QueryTypes.matchAll.metaType)", "\(MatchAllQuery.self)")
        XCTAssertEqual(QueryTypes.matchNone.rawValue, "match_none")
        XCTAssertEqual("\(QueryTypes.matchNone.metaType)", "\(MatchNoneQuery.self)")
        XCTAssertEqual(QueryTypes.constantScore.rawValue, "constant_score")
        XCTAssertEqual("\(QueryTypes.constantScore.metaType)", "\(ConstantScoreQuery.self)")
        XCTAssertEqual(QueryTypes.bool.rawValue, "bool")
        XCTAssertEqual("\(QueryTypes.bool.metaType)", "\(BoolQuery.self)")
        XCTAssertEqual(QueryTypes.disMax.rawValue, "dis_max")
        XCTAssertEqual("\(QueryTypes.disMax.metaType)", "\(DisMaxQuery.self)")
        XCTAssertEqual(QueryTypes.functionScore.rawValue, "function_score")
        XCTAssertEqual("\(QueryTypes.functionScore.metaType)", "\(FunctionScoreQuery.self)")
        XCTAssertEqual(QueryTypes.boosting.rawValue, "boosting")
        XCTAssertEqual("\(QueryTypes.boosting.metaType)", "\(BoostingQuery.self)")
        XCTAssertEqual(QueryTypes.match.rawValue, "match")
        XCTAssertEqual("\(QueryTypes.match.metaType)", "\(MatchQuery.self)")
        XCTAssertEqual(QueryTypes.matchPhrase.rawValue, "match_phrase")
        XCTAssertEqual("\(QueryTypes.matchPhrase.metaType)", "\(MatchPhraseQuery.self)")
        XCTAssertEqual(QueryTypes.matchPhrasePrefix.rawValue, "match_phrase_prefix")
        XCTAssertEqual("\(QueryTypes.matchPhrasePrefix.metaType)", "\(MatchPhrasePrefixQuery.self)")
        XCTAssertEqual(QueryTypes.multiMatch.rawValue, "multi_match")
        XCTAssertEqual("\(QueryTypes.multiMatch.metaType)", "\(MultiMatchQuery.self)")
        XCTAssertEqual(QueryTypes.common.rawValue, "common")
        XCTAssertEqual("\(QueryTypes.common.metaType)", "\(CommonTermsQuery.self)")
        XCTAssertEqual(QueryTypes.queryString.rawValue, "query_string")
        XCTAssertEqual("\(QueryTypes.queryString.metaType)", "\(QueryStringQuery.self)")
        XCTAssertEqual(QueryTypes.simpleQueryString.rawValue, "simple_query_string")
        XCTAssertEqual("\(QueryTypes.simpleQueryString.metaType)", "\(SimpleQueryStringQuery.self)")
        XCTAssertEqual(QueryTypes.term.rawValue, "term")
        XCTAssertEqual("\(QueryTypes.term.metaType)", "\(TermQuery.self)")
        XCTAssertEqual(QueryTypes.terms.rawValue, "terms")
        XCTAssertEqual("\(QueryTypes.terms.metaType)", "\(TermsQuery.self)")
        XCTAssertEqual(QueryTypes.range.rawValue, "range")
        XCTAssertEqual("\(QueryTypes.range.metaType)", "\(RangeQuery.self)")
        XCTAssertEqual(QueryTypes.exists.rawValue, "exists")
        XCTAssertEqual("\(QueryTypes.exists.metaType)", "\(ExistsQuery.self)")
        XCTAssertEqual(QueryTypes.prefix.rawValue, "prefix")
        XCTAssertEqual("\(QueryTypes.prefix.metaType)", "\(PrefixQuery.self)")
        XCTAssertEqual(QueryTypes.wildcard.rawValue, "wildcard")
        XCTAssertEqual("\(QueryTypes.wildcard.metaType)", "\(WildCardQuery.self)")
        XCTAssertEqual(QueryTypes.regexp.rawValue, "regexp")
        XCTAssertEqual("\(QueryTypes.regexp.metaType)", "\(RegexpQuery.self)")
        XCTAssertEqual(QueryTypes.fuzzy.rawValue, "fuzzy")
        XCTAssertEqual("\(QueryTypes.fuzzy.metaType)", "\(FuzzyQuery.self)")
        XCTAssertEqual(QueryTypes.type.rawValue, "type")
        XCTAssertEqual("\(QueryTypes.type.metaType)", "\(TypeQuery.self)")
        XCTAssertEqual(QueryTypes.ids.rawValue, "ids")
        XCTAssertEqual("\(QueryTypes.ids.metaType)", "\(IdsQuery.self)")
        XCTAssertEqual(QueryTypes.nested.rawValue, "nested")
        XCTAssertEqual("\(QueryTypes.nested.metaType)", "\(NestedQuery.self)")
        XCTAssertEqual(QueryTypes.hasChild.rawValue, "has_child")
        XCTAssertEqual("\(QueryTypes.hasChild.metaType)", "\(HasChildQuery.self)")
        XCTAssertEqual(QueryTypes.hasParent.rawValue, "has_parent")
        XCTAssertEqual("\(QueryTypes.hasParent.metaType)", "\(HasParentQuery.self)")
        XCTAssertEqual(QueryTypes.parentId.rawValue, "parent_id")
        XCTAssertEqual("\(QueryTypes.parentId.metaType)", "\(ParentIdQuery.self)")
        XCTAssertEqual(QueryTypes.geoShape.rawValue, "geo_shape")
        XCTAssertEqual("\(QueryTypes.geoShape.metaType)", "\(GeoShapeQuery.self)")
        XCTAssertEqual(QueryTypes.geoBoundingBox.rawValue, "geo_bounding_box")
        XCTAssertEqual("\(QueryTypes.geoBoundingBox.metaType)", "\(GeoBoundingBoxQuery.self)")
        XCTAssertEqual(QueryTypes.geoDistance.rawValue, "geo_distance")
        XCTAssertEqual("\(QueryTypes.geoDistance.metaType)", "\(GeoDistanceQuery.self)")
        XCTAssertEqual(QueryTypes.geoPolygon.rawValue, "geo_polygon")
        XCTAssertEqual("\(QueryTypes.geoPolygon.metaType)", "\(GeoPolygonQuery.self)")
        XCTAssertEqual(QueryTypes.moreLikeThis.rawValue, "more_like_this")
        XCTAssertEqual("\(QueryTypes.moreLikeThis.metaType)", "\(MoreLikeThisQuery.self)")
        XCTAssertEqual(QueryTypes.script.rawValue, "script")
        XCTAssertEqual("\(QueryTypes.script.metaType)", "\(ScriptQuery.self)")
        XCTAssertEqual(QueryTypes.percolate.rawValue, "percolate")
        XCTAssertEqual("\(QueryTypes.percolate.metaType)", "\(PercolateQuery.self)")
        XCTAssertEqual(QueryTypes.wrapper.rawValue, "wrapper")
        XCTAssertEqual("\(QueryTypes.wrapper.metaType)", "\(WrapperQuery.self)")
        XCTAssertEqual(QueryTypes.spanTerm.rawValue, "span_term")
        XCTAssertEqual("\(QueryTypes.spanTerm.metaType)", "\(SpanTermQuery.self)")
        XCTAssertEqual(QueryTypes.spanMulti.rawValue, "span_multi")
        XCTAssertEqual("\(QueryTypes.spanMulti.metaType)", "\(SpanMultiTermQuery.self)")
        XCTAssertEqual(QueryTypes.spanFirst.rawValue, "span_first")
        XCTAssertEqual("\(QueryTypes.spanFirst.metaType)", "\(SpanFirstQuery.self)")
        XCTAssertEqual(QueryTypes.spanNear.rawValue, "span_near")
        XCTAssertEqual("\(QueryTypes.spanNear.metaType)", "\(SpanNearQuery.self)")
        XCTAssertEqual(QueryTypes.spanOr.rawValue, "span_or")
        XCTAssertEqual("\(QueryTypes.spanOr.metaType)", "\(SpanOrQuery.self)")
        XCTAssertEqual(QueryTypes.spanNot.rawValue, "span_not")
        XCTAssertEqual("\(QueryTypes.spanNot.metaType)", "\(SpanNotQuery.self)")
        XCTAssertEqual(QueryTypes.spanContaining.rawValue, "span_containing")
        XCTAssertEqual("\(QueryTypes.spanContaining.metaType)", "\(SpanContainingQuery.self)")
        XCTAssertEqual(QueryTypes.spanWithin.rawValue, "span_within")
        XCTAssertEqual("\(QueryTypes.spanWithin.metaType)", "\(SpanWithinQuery.self)")
        XCTAssertEqual(QueryTypes.spanFieldMasking.rawValue, "field_masking_span")
        XCTAssertEqual("\(QueryTypes.spanFieldMasking.metaType)", "\(SpanFieldMaskingQuery.self)")
    }

    func test_02_ScoreFunctionTypes() throws {
        XCTAssertEqual(ScoreFunctionType.weight.rawValue, "weight")
        XCTAssertEqual("\(ScoreFunctionType.weight.metaType)", "\(WeightScoreFunction.self)")
        XCTAssertEqual(ScoreFunctionType.randomScore.rawValue, "random_score")
        XCTAssertEqual("\(ScoreFunctionType.randomScore.metaType)", "\(RandomScoreFunction.self)")
        XCTAssertEqual(ScoreFunctionType.scriptScore.rawValue, "script_score")
        XCTAssertEqual("\(ScoreFunctionType.scriptScore.metaType)", "\(ScriptScoreFunction.self)")
        XCTAssertEqual(ScoreFunctionType.linear.rawValue, "linear")
        XCTAssertEqual("\(ScoreFunctionType.linear.metaType)", "\(LinearDecayScoreFunction.self)")
        XCTAssertEqual(ScoreFunctionType.gauss.rawValue, "gauss")
        XCTAssertEqual("\(ScoreFunctionType.gauss.metaType)", "\(GaussScoreFunction.self)")
        XCTAssertEqual(ScoreFunctionType.exp.rawValue, "exp")
        XCTAssertEqual("\(ScoreFunctionType.exp.metaType)", "\(ExponentialDecayScoreFunction.self)")
        XCTAssertEqual(ScoreFunctionType.fieldValueFactor.rawValue, "field_value_factor")
        XCTAssertEqual("\(ScoreFunctionType.fieldValueFactor.metaType)", "\(FieldValueFactorScoreFunction.self)")
    }
}
