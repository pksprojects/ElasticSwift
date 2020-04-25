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
        XCTAssertEqual(query.operator, Operator.or)
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

    func test_11_matchPhrasePrefixQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.matchPhrasePrefixQuery().set(field: "text").set(value: "test search").build(), "Should not throw")
    }

    func test_12_matchPhrasePrefixQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.matchPhrasePrefixQuery().set(field: "text").set(value: "test search").set(maxExpansions: 10).build(), "Should not throw")
    }

    func test_13_matchPhrasePrefixQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.matchPhrasePrefixQuery().set(value: "test search").build(), "Should not throw") { error in
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

    func test_14_matchPhrasePrefixQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.matchPhrasePrefixQuery().set(field: "text").build(), "Should not throw") { error in
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

    func test_15_matchPhrasePrefixQueryBuilder() throws {
        let query = try QueryBuilders.matchPhrasePrefixQuery()
            .set(field: "message")
            .set(value: "quick brown f")
            .set(maxExpansions: 10)
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "quick brown f")
        XCTAssertEqual(query.maxExpansions, 10)
        let expectedDic = ["match_phrase_prefix": [
            "message": [
                "query": "quick brown f",
                "max_expansions": 10,
            ],
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }

    func test_16_matchPhrasePrefixQueryBuilder() throws {
        let query = try QueryBuilders.matchPhrasePrefixQuery()
            .set(field: "message")
            .set(value: "quick brown f")
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "quick brown f")
        let expectedDic = ["match_phrase_prefix": [
            "message": "quick brown f",
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }

    func test_17_multiMatchQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.multiMatchQuery().set(fields: "text").set(query: "test search").build(), "Should not throw")
    }

    func test_18_multiMatchQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.multiMatchQuery().set(fields: "text").set(query: "test search").set(tieBreaker: 10).set(type: .bestFields).build(), "Should not throw")
    }

    func test_19_multiMatchQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.multiMatchQuery().set(query: "test search").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atlestOneElementRequired(field):
                    XCTAssertEqual("fields", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_20_multiMatchQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.multiMatchQuery().add(field: "text").build(), "Should not throw") { error in
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

    func test_21_multiMatchQueryBuilder() throws {
        let query = try QueryBuilders.multiMatchQuery()
            .set(fields: "subject", "message")
            .set(query: "this is a test")
            .set(tieBreaker: 0.3)
            .set(type: .bestFields)
            .build()
        XCTAssertEqual(query.fields, ["subject", "message"])
        XCTAssertEqual(query.query, "this is a test")
        XCTAssertEqual(query.tieBreaker, 0.3)
        XCTAssertEqual(query.type, .bestFields)
        let expectedDic = ["multi_match": [
            "query": "this is a test",
            "fields": ["subject", "message"],
            "tie_breaker": Decimal(0.3),
            "type": "best_fields",
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }

    func test_22_commonTermsQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.commonTermsQuery().set(query: "test search").set(cutoffFrequency: 0.001).build(), "Should not throw")
    }

    func test_23_commonTermsQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.commonTermsQuery().set(query: "test search").set(cutoffFrequency: 0.001).set(highFrequencyOperator: .and).set(lowFrequencyOperator: .or).set(minimumShouldMatch: 2).build(), "Should not throw")
    }

    func test_24_commonTermsQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.commonTermsQuery().set(query: "test search").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atlestOneElementRequired(field):
                    XCTAssertEqual("cutoffFrequency", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_25_commonTermsQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.commonTermsQuery().set(cutoffFrequency: 0.001).build(), "Should not throw") { error in
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

    func test_26_commonTermsQueryBuilder() throws {
        let query = try QueryBuilders.commonTermsQuery()
            .set(query: "this is a test")
            .set(cutoffFrequency: 0.001)
            .set(highFrequencyOperator: .and)
            .set(lowFrequencyOperator: .or)
            .set(minimumShouldMatch: 2)
            .build()
        XCTAssertEqual(query.cutoffFrequency, 0.001)
        XCTAssertEqual(query.query, "this is a test")
        XCTAssertEqual(query.highFrequencyOperator, .and)
        XCTAssertEqual(query.lowFrequencyOperator, .or)
        XCTAssertEqual(query.minimumShouldMatch, 2)
        let expectedDic = ["common": [
            "body": [
                "query": "this is a test",
                "cutoff_frequency": Decimal(0.001),
                "low_freq_operator": "or",
                "high_freq_operator": "and",
                "minimum_should_match": 2,
            ],
        ]] as [String: Any]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic), "Expected: \(expectedDic); Actual: \(query.toDic())")
    }
}
