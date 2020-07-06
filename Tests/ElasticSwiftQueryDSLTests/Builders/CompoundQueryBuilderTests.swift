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
            .set(name: "name")
            .build()
        XCTAssertEqual(query.query as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.boost, 0.8)
        XCTAssertEqual(query.name, "name")
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
            .set(name: "name")
            .set(minimumShouldMatch: 10)
            .build()
        XCTAssertEqual(query.shouldClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.filterClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.mustClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.mustNotClauses.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.boost, 0.8)
        XCTAssertEqual(query.name, "name")
    }

    func test_08_disMaxQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.disMaxQuery().add(query: MatchAllQuery()).set(tieBreaker: 1.1).set(boost: 0.9).build(), "Should not throw")
    }

    func test_09_disMaxQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.disMaxQuery().add(query: MatchAllQuery()).set(tieBreaker: 1.1).build(), "Should not throw")
    }

    func test_10_disMaxQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.disMaxQuery().add(query: MatchAllQuery()).build(), "Should not throw")
    }

    func test_11_disMaxQueryBuilder_missing_query() throws {
        XCTAssertThrowsError(try QueryBuilders.disMaxQuery().build(), "Should not throw") { error in
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

    func test_12_disMaxQueryBuilder() throws {
        let query = try QueryBuilders.disMaxQuery()
            .add(query: MatchAllQuery())
            .set(tieBreaker: 1.0)
            .set(boost: 0.8)
            .set(name: "name")
            .build()
        XCTAssertEqual(query.queries.first as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.tieBreaker, 1.0)
        XCTAssertEqual(query.boost, 0.8)
        XCTAssertEqual(query.name, "name")
    }

    func test_13_functionScoreQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.functionScoreQuery().set(query: MatchAllQuery()).add(function: WeightScoreFunction(1.0)).build(), "Should not throw")
    }

    func test_14_functionScoreQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.functionScoreQuery().set(query: MatchAllQuery()).add(function: RandomScoreFunction()).set(boost: 0.1).build(), "Should not throw")
    }

    func test_15_functionScoreQueryBuilder_missing_query() throws {
        XCTAssertThrowsError(try QueryBuilders.functionScoreQuery().add(function: WeightScoreFunction(1.0)).build(), "Should not throw") { error in
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

    func test_16_functionScoreQueryBuilder_missing_score_function() throws {
        XCTAssertThrowsError(try QueryBuilders.functionScoreQuery().set(query: MatchAllQuery()).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atlestOneElementRequired(field):
                    XCTAssertEqual("functions", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_17_functionScoreQueryBuilder() throws {
        let query = try QueryBuilders.functionScoreQuery()
            .set(query: MatchAllQuery())
            .add(function: RandomScoreFunction())
            .set(maxBoost: 1.0)
            .set(minScore: 0.5)
            .set(boostMode: .avg)
            .set(scoreMode: .multiply)
            .set(boost: 0.8)
            .set(name: "name")
            .build()
        XCTAssertEqual(query.query as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.functions.first as! RandomScoreFunction, RandomScoreFunction())
        XCTAssertEqual(query.maxBoost, 1.0)
        XCTAssertEqual(query.minScore, 0.5)
        XCTAssertEqual(query.boostMode, BoostMode.avg)
        XCTAssertEqual(query.scoreMode, ScoreMode.multiply)
        XCTAssertEqual(query.boost, 0.8)
        XCTAssertEqual(query.name, "name")
    }

    func test_18_functionScoreQueryBuilder() throws {
        let query = try QueryBuilders.functionScoreQuery()
            .set(query: MatchAllQuery())
            .add(function: RandomScoreFunction())
            .add(function: WeightScoreFunction(1.1))
            .set(maxBoost: 1.0)
            .set(minScore: 0.5)
            .set(boostMode: .avg)
            .set(scoreMode: .multiply)
            .set(boost: 0.8)
            .build()
        XCTAssertEqual(query.query as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.functions[0] as! RandomScoreFunction, RandomScoreFunction())
        XCTAssertEqual(query.functions[1] as! WeightScoreFunction, WeightScoreFunction(1.1))
        XCTAssertEqual(query.maxBoost, 1.0)
        XCTAssertEqual(query.minScore, 0.5)
        XCTAssertEqual(query.boostMode, BoostMode.avg)
        XCTAssertEqual(query.scoreMode, ScoreMode.multiply)
        XCTAssertEqual(query.boost, 0.8)
    }

    func test_19_boostingQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.boostingQuery().set(positive: MatchAllQuery()).set(negative: TermQuery(field: "text", value: "random")).build(), "Should not throw")
    }

    func test_20_boostingQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.boostingQuery().set(positive: MatchAllQuery()).set(negative: TermQuery(field: "text", value: "random")).set(negativeBoost: 1.2).build(), "Should not throw")
    }

    func test_21_boostingQueryBuilder_missing_negative() throws {
        XCTAssertThrowsError(try QueryBuilders.boostingQuery().set(positive: MatchAllQuery()).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("negative", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_22_boostingQueryBuilder_missing_positive() throws {
        XCTAssertThrowsError(try QueryBuilders.boostingQuery().set(negative: MatchAllQuery()).set(negativeBoost: 1.2).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("positive", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_23_boostingQueryBuilder() throws {
        let query = try QueryBuilders.boostingQuery()
            .set(positive: MatchAllQuery())
            .set(negative: TermQuery(field: "text", value: "random"))
            .set(negativeBoost: 0.8)
            .set(name: "name")
            .set(boost: 1.0)
            .build()
        XCTAssertEqual(query.positive as! MatchAllQuery, MatchAllQuery())
        XCTAssertEqual(query.negative as! TermQuery, TermQuery(field: "text", value: "random"))
        XCTAssertEqual(query.negativeBoost, 0.8)
        XCTAssertEqual(query.boost, 1.0)
        XCTAssertEqual(query.name, "name")
    }
}
