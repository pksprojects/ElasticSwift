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

    func test_03_matchQueryBuilder_missing_field() throws {
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

    func test_04_matchQueryBuilder_missing_value() throws {
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
}
