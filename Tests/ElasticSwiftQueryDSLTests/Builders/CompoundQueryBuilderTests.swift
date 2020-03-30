//
//  CompoundQueryBuilderTests.swift
//
//
//  Created by Prafull Kumar Soni on 3/29/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class CompoundQueryBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.GeoQueryBuilderTests", factory: logFactory)

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

    func test_01_constantScoreQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.constantScoreQuery().set(query: MatchAllQuery()).set(boost: 0.9).build(), "Should not throw")
    }

    func test_02_constantScoreQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.constantScoreQuery().set(query: MatchAllQuery()).build(), "Should not throw")
    }

    func test_03_constantScoreQueryBuilder_missing_query() throws {
        XCTAssertThrowsError(try QueryBuilders.constantScoreQuery().build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("query", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_04_constantScoreQueryBuilder() throws {
        let query = try QueryBuilders.constantScoreQuery()
            .set(query: MatchAllQuery())
            .set(boost: 0.8)
            .build()
        XCTAssertEqual(query.query as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.boost, 0.8)
        let expectedDic = ["constant_score": [
            "filter": ["match_all": [:]],
            "boost": Decimal(string: "0.8")!,
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }

    func test_05_boolQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.boolQuery().should(query: MatchAllQuery()).set(boost: 0.9).build(), "Should not throw")
    }

    func test_06_boolQueryBuilder_atleast_one_required() throws {
        XCTAssertThrowsError(try QueryBuilders.boolQuery().build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atleastOneFieldRequired(fields):
                    XCTAssertEqual(["filterClauses", "mustClauses", "mustNotClauses", "shouldClauses"], fields)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_07_boolQueryBuilder() throws {
        let query = try QueryBuilders.boolQuery()
            .should(query: MatchAllQuery())
            .filter(query: MatchAllQuery())
            .must(query: MatchAllQuery())
            .mustNot(query: MatchAllQuery())
            .set(boost: 0.8)
            .set(minimumShouldMatch: 10)
            .build()
        XCTAssertEqual(query.shouldClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.filterClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.mustClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.mustNotClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.boost, 0.8)
        let expectedDic = ["bool": [
            "filter": [["match_all": [:]]],
            "must": [["match_all": [:]]],
            "must_not": [["match_all": [:]]],
            "should": [["match_all": [:]]],
            "boost": Decimal(string: "0.8")!,
            "minimum_should_match": 10,
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }
}
