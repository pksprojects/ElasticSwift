//
//  TermLevelQueryBuilderTests.swift
//
//
//  Created by Prafull Kumar Soni on 4/26/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class TermLevelQueryBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.TermLevelQueryBuilderTests", factory: logFactory)

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

    func test_01_termQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.termQuery().set(field: "text").set(value: "test search").build(), "Should not throw")
    }

    func test_02_termQueryBuilder_2() throws {
        XCTAssertNoThrow(try QueryBuilders.termQuery().set(field: "text").set(value: "test search").set(boost: 1.0).build(), "Should not throw")
    }

    func test_03_termQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.termQuery().set(value: "test search").build(), "Should not throw") { error in
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

    func test_04_termQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.termQuery().set(field: "text").build(), "Should not throw") { error in
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

    func test_05_termsQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.termsQuery().set(field: "text").set(values: "test search").build(), "Should not throw")
    }

    func test_06_termsQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.termsQuery().set(values: "test search").build(), "Should not throw") { error in
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

    func test_07_termsQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.termsQuery().set(field: "text").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atlestOneElementRequired(field):
                    XCTAssertEqual("values", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_08_termQueryBuilder() throws {
        let query = try QueryBuilders.termQuery()
            .set(field: "message")
            .set(value: "to be or not to be")
            .set(boost: 2.0)
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "to be or not to be")
        XCTAssertEqual(query.boost, 2.0)
    }

    func test_09_termsQueryBuilder() throws {
        let query = try QueryBuilders.termsQuery()
            .set(field: "message")
            .set(values: "to be or not to be")
            .add(value: "test")
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.values, ["to be or not to be", "test"])
    }

    func test_10_rangeQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.rangeQuery().set(field: "age").set(gt: "14").build(), "Should not throw")
    }

    func test_11_rangeQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.rangeQuery().set(gt: "10").set(boost: 2.0).build(), "Should not throw") { error in
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

    func test_12_rangeQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.rangeQuery().set(field: "text").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atleastOneFieldRequired(fields):
                    XCTAssertEqual(["gte", "gt", "lt", "lte"], fields)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_13_rangeQueryBuilder() throws {
        let query = try QueryBuilders.rangeQuery()
            .set(field: "age")
            .set(gt: "14")
            .set(lt: "45")
            .set(gte: "15")
            .set(lte: "45")
            .set(format: "format")
            .set(relation: .contains)
            .set(timeZone: "UTC")
            .set(boost: 2.0)
            .build()
        XCTAssertEqual(query.field, "age")
        XCTAssertEqual(query.gt, "14")
        XCTAssertEqual(query.lt, "45")
        XCTAssertEqual(query.gte, "15")
        XCTAssertEqual(query.lte, "45")
        XCTAssertEqual(query.format, "format")
        XCTAssertEqual(query.relation, .contains)
        XCTAssertEqual(query.timeZone, "UTC")
        XCTAssertEqual(query.boost, 2.0)
    }

    func test_14_existsQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.existsQuery().set(field: "age").build(), "Should not throw")
    }

    func test_15_existsQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.existsQuery().build(), "Should not throw") { error in
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

    func test_16_existsQueryBuilder() throws {
        let query = try QueryBuilders.existsQuery()
            .set(field: "message")
            .build()
        XCTAssertEqual(query.field, "message")
    }

    func test_17_prefixQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.prefixQuery().set(field: "text").set(value: "test search").build(), "Should not throw")
    }

    func test_18_prefixQueryBuilder_2() throws {
        XCTAssertNoThrow(try QueryBuilders.prefixQuery().set(field: "text").set(value: "test search").set(boost: 1.0).build(), "Should not throw")
    }

    func test_19_prefixQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.prefixQuery().set(value: "test search").build(), "Should not throw") { error in
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

    func test_20_prefixQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.prefixQuery().set(field: "text").build(), "Should not throw") { error in
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

    func test_21_prefixQueryBuilder() throws {
        let query = try QueryBuilders.prefixQuery()
            .set(field: "message")
            .set(value: "to be or not to be")
            .set(boost: 2.0)
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "to be or not to be")
        XCTAssertEqual(query.boost, 2.0)
    }

    func test_22_wildCardQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.wildCardQuery().set(field: "text").set(value: "test search").build(), "Should not throw")
    }

    func test_23_wildCardQueryBuilder_2() throws {
        XCTAssertNoThrow(try QueryBuilders.wildCardQuery().set(field: "text").set(value: "test search").set(boost: 1.0).build(), "Should not throw")
    }

    func test_24_wildCardQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.wildCardQuery().set(value: "test search").build(), "Should not throw") { error in
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

    func test_25_wildCardQueryBuilder_missing_value() throws {
        XCTAssertThrowsError(try QueryBuilders.wildCardQuery().set(field: "text").build(), "Should not throw") { error in
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

    func test_26_wildCardQueryBuilder() throws {
        let query = try QueryBuilders.wildCardQuery()
            .set(field: "message")
            .set(value: "to be or not to be")
            .set(boost: 2.0)
            .build()
        XCTAssertEqual(query.field, "message")
        XCTAssertEqual(query.value, "to be or not to be")
        XCTAssertEqual(query.boost, 2.0)
    }
}
