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
        XCTAssertEqual(query.boost, 0.8)
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
    }

    func test_10_matchPhraseQueryBuilder() throws {
        let query = try QueryBuilders.matchPhraseQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "this is a test")
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
    }

    func test_16_matchPhrasePrefixQueryBuilder() throws {
        let query = try QueryBuilders.matchPhrasePrefixQuery()
            .set(field: "message")
            .set(value: "quick brown f")
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "quick brown f")
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
    }

    func test_27_commonTermsQueryBuilder() throws {
        let query = try QueryBuilders.commonTermsQuery()
            .set(query: "this is a test")
            .set(cutoffFrequency: 0.001)
            .set(highFrequencyOperator: .and)
            .set(lowFrequencyOperator: .or)
            .set(minimumShouldMatchLowFreq: 2)
            .set(minimumShouldMatchHighFreq: 3)
            .build()
        XCTAssertEqual(query.cutoffFrequency, 0.001)
        XCTAssertEqual(query.query, "this is a test")
        XCTAssertEqual(query.highFrequencyOperator, .and)
        XCTAssertEqual(query.lowFrequencyOperator, .or)
        XCTAssertEqual(query.minimumShouldMatch, nil)
        XCTAssertEqual(query.minimumShouldMatchLowFreq, 2)
        XCTAssertEqual(query.minimumShouldMatchHighFreq, 3)
    }

    func test_28_queryStringQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.queryStringQuery().set(query: "test search").build(), "Should not throw")
    }

    func test_29_queryStringQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.queryStringQuery().set(boost: 0).build(), "Should not throw") { error in
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

    func test_30_queryStringQueryBuilder() throws {
        let query = try QueryBuilders.queryStringQuery()
            .set(query: "this is a test")
            .set(minimumShouldMatch: 2)
            .set(boost: 1)
            .set(type: .bestFields)
            .set(autoGenerateSynonymsPhraseQuery: false)
            .set(tieBreaker: 0)
            .set(fields: ["test"])
            .set(lenient: false)
            .set(analyzer: "test_analyzer")
            .set(timeZone: "UTC")
            .set(fuzziness: "fuzz")
            .set(phraseSlop: 1)
            .set(defaultField: "test")
            .set(quoteAnalyzer: "quote_analyzer")
            .set(analyzeWildcard: true)
            .set(defaultOperator: "OR")
            .set(quoteFieldSuffix: "s")
            .set(fuzzyTranspositions: false)
            .set(allowLeadingWildcard: true)
            .set(fuzzyPrefixLength: 1)
            .set(fuzzyMaxExpansions: 2)
            .set(maxDeterminizedStates: 4)
            .set(enablePositionIncrements: false)
            .set(autoGeneratePhraseQueries: false)
            .build()
        XCTAssertEqual(query.minimumShouldMatch, 2)
        XCTAssertEqual(query.query, "this is a test")
        XCTAssertEqual(query.boost, 1)
        XCTAssertEqual(query.autoGenerateSynonymsPhraseQuery, false)
        XCTAssertEqual(query.type, .bestFields)
        XCTAssertEqual(query.tieBreaker, 0)
        XCTAssertEqual(query.fields, ["test"])
        XCTAssertEqual(query.lenient, false)
        XCTAssertEqual(query.analyzer, "test_analyzer")
        XCTAssertEqual(query.timeZone, "UTC")
        XCTAssertEqual(query.fuzziness, "fuzz")
        XCTAssertEqual(query.phraseSlop, 1)
        XCTAssertEqual(query.defaultField, "test")
        XCTAssertEqual(query.quoteAnalyzer, "quote_analyzer")
        XCTAssertEqual(query.analyzeWildcard, true)
        XCTAssertEqual(query.defaultOperator, "OR")
        XCTAssertEqual(query.quoteFieldSuffix, "s")
        XCTAssertEqual(query.fuzzyTranspositions, false)
        XCTAssertEqual(query.allowLeadingWildcard, true)
        XCTAssertEqual(query.fuzzyPrefixLength, 1)
        XCTAssertEqual(query.fuzzyMaxExpansions, 2)
        XCTAssertEqual(query.maxDeterminizedStates, 4)
        XCTAssertEqual(query.enablePositionIncrements, false)
        XCTAssertEqual(query.autoGeneratePhraseQueries, false)
    }

    func test_31_simpleQueryStringQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.simpleQueryStringQuery().set(query: "test search").build(), "Should not throw")
    }

    func test_32_simpleQueryStringQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.simpleQueryStringQuery().set(minimumShouldMatch: 2).build(), "Should not throw") { error in
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

    func test_33_simpleQueryStringQueryBuilder() throws {
        let query = try QueryBuilders.simpleQueryStringQuery()
            .set(query: "this is a test")
            .set(minimumShouldMatch: 2)
            .set(autoGenerateSynonymsPhraseQuery: false)
            .set(fields: "test", "test2")
            .set(lenient: false)
            .set(analyzer: "test_analyzer")
            .set(flags: "OR|AND|PREFIX")
            .set(defaultOperator: "OR")
            .set(quoteFieldSuffix: "s")
            .set(fuzzyTranspositions: false)
            .set(fuzzyPrefixLength: 1)
            .set(fuzzyMaxExpansions: 2)
            .build()
        XCTAssertEqual(query.minimumShouldMatch, 2)
        XCTAssertEqual(query.query, "this is a test")
        XCTAssertEqual(query.autoGenerateSynonymsPhraseQuery, false)
        XCTAssertEqual(query.fields, ["test", "test2"])
        XCTAssertEqual(query.lenient, false)
        XCTAssertEqual(query.analyzer, "test_analyzer")
        XCTAssertEqual(query.flags, "OR|AND|PREFIX")
        XCTAssertEqual(query.defaultOperator, "OR")
        XCTAssertEqual(query.quoteFieldSuffix, "s")
        XCTAssertEqual(query.fuzzyTranspositions, false)
        XCTAssertEqual(query.fuzzyPrefixLength, 1)
        XCTAssertEqual(query.fuzzyMaxExpansions, 2)
    }
}
