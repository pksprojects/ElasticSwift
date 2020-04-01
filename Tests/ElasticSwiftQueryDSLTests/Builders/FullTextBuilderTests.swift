//
//  FullTextBuilderTests.swift
//  ElasticSwiftQueryDSLTests
//
//
//  Created by Prafull Kumar Soni on 3/31/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class FullTextBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.FullTextBuilderTests", factory: logFactory)

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

    func test_01_matchQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.matchQuery().set(field: "text").set(value: "test search").build(), "Should not throw")
    }

    func test_02_matchQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.matchQuery().set(value: "test search").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_03_matchQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.matchQuery().set(field: "text").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("value", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_04_matchQueryBuilder() throws {
        let query = try QueryBuilders.matchQuery()
            .set(field: "message")
            .set(value: "to be or not to be")
            .set(zeroTermQuery: .all)
            .set(operator: .or)
            .set(fuzziness: .auto)
            .set(cutoffFrequency: 0.1)
            .set(boost: 0.8)
            .set(autoGenSynonymnsPhraseQuery: false)
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "to be or not to be")
        XCTAssertEqual(query.zeroTermQuery, ZeroTermQuery.all)
        XCTAssertEqual(query.cutoffFrequency, Decimal(0.1))
        XCTAssertEqual(query.operator, MatchQueryOperator.or)
        // XCTAssertEqual(query.boost, 0.8)
        let expectedDic = ["match": [
            "message": [
                "query": "to be or not to be",
                "boost": Decimal(0.8),
                "fuzziness": "AUTO",
                "operator": "or",
                "zero_terms_query": "all",
                "cutoff_frequency": Decimal(0.1),
                "auto_generate_synonyms_phrase_query": false,
            ],
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }

    func test_05_matchPhraseQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.matchPhraseQuery().set(field: "text").set(value: "test search").build(), "Should not throw")
    }

    func test_06_matchPhraseQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.matchPhraseQuery().set(field: "text").set(value: "test search").set(analyzer: "my_analyzer").build(), "Should not throw")
    }

    func test_07_matchPhraseQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.matchPhraseQuery().set(value: "test search").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_08_matchPhraseQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.matchPhraseQuery().set(field: "text").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("value", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_09_matchPhraseQueryBuilder() throws {
        let query = try QueryBuilders.matchPhraseQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .set(analyzer: "my_analyzer")
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "this is a test")
        XCTAssertEqual(query.analyzer, "my_analyzer")
        let expectedDic = ["match_phrase": [
            "message": [
                "query": "this is a test",
                "analyzer": "my_analyzer",
            ],
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }

    func test_10_matchPhraseQueryBuilder() throws {
        let query = try QueryBuilders.matchPhraseQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "this is a test")
        let expectedDic = ["match_phrase": [
            "message": "this is a test",
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }
}
