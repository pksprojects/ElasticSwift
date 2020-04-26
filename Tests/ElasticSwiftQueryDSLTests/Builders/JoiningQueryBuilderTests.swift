//
//  JoiningQueryBuilderTests.swift
//
//
//  Created by Prafull Kumar Soni on 1/5/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class JoiningQueryBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.JoiningQueryBuilderTests", factory: logFactory)

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

    func test_01_nestedQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try NestedQueryBuilder().set(path: "path").set(query: MatchAllQuery()).build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_02_nestedQueryBuilder_missing_path() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try NestedQueryBuilder().set(query: MatchAllQuery()).build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("path", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_03_nestedQueryBuilder_missing_query() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try NestedQueryBuilder().set(path: "path").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("query", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_04_hasChildQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try HasChildQueryBuilder().set(type: "type").set(query: MatchAllQuery()).build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_05_hasChildQueryBuilder_missing_type() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasChildQueryBuilder().set(query: MatchAllQuery()).build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("type", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_06_hasChildQueryBuilder_missing_query() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasChildQueryBuilder().set(type: "type").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("query", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_07_hasParentQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try HasParentQueryBuilder().set(parentType: "parent_type").set(query: MatchAllQuery()).build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_08_hasParentQueryBuilder_missing_parentType() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasParentQueryBuilder().set(query: MatchAllQuery()).build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("parentType", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_09_hasParentQueryBuilder_missing_query() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasParentQueryBuilder().set(parentType: "parent_type").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("query", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_10_parentIdQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try ParentIdQueryBuilder().set(type: "type").set(id: "1").build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_11_parentIdQueryBuilder_missing_type() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ParentIdQueryBuilder().set(id: "1").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("type", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_12_parentIdQueryBuilder_missing_id() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ParentIdQueryBuilder().set(type: "type").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("id", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_13_parentIdQueryBuilder() throws {
        let query = try QueryBuilders.parentIdQuery()
            .set(id: "id")
            .set(type: "type")
            .set(ignoreUnmapped: false)
            .build()

        XCTAssertEqual(query.id, "id")
        XCTAssertEqual(query.type, "type")
        XCTAssertEqual(query.ignoreUnmapped, false)
    }

    func test_14_hasParentQueryBuilder_missing_id() throws {
        let query = try QueryBuilders.hasParentQuery()
            .set(query: MatchAllQuery())
            .set(parentType: "parentType")
            .set(ignoreUnmapped: false)
            .set(score: true)
            .set(innerHits: [])
            .build()

        XCTAssertTrue(query.query.isEqualTo(MatchAllQuery()))
        XCTAssertEqual(query.parentType, "parentType")
        XCTAssertEqual(query.ignoreUnmapped, false)
        XCTAssertEqual(query.innerHits, [])
        XCTAssertEqual(query.score, true)
    }

    func test_15_hasChildQueryBuilder() throws {
        let query = try QueryBuilders.hasChildQuery()
            .set(query: MatchAllQuery())
            .set(type: "type")
            .set(ignoreUnmapped: false)
            .set(minChildren: 1)
            .set(maxChildren: 2)
            .set(innerHits: [])
            .set(scoreMode: .AVG)
            .build()

        XCTAssertTrue(query.query.isEqualTo(MatchAllQuery()))
        XCTAssertEqual(query.type, "type")
        XCTAssertEqual(query.ignoreUnmapped, false)
        XCTAssertEqual(query.minChildren, 1)
        XCTAssertEqual(query.maxChildren, 2)
        XCTAssertEqual(query.innerHits, [])
        XCTAssertEqual(query.scoreMode, .AVG)
    }

    func test_16_nestedQueryBuilder_missing_id() throws {
        let query = try QueryBuilders.nestedQuery()
            .set(query: MatchAllQuery())
            .set(path: "type")
            .set(ignoreUnmapped: false)
            .set(innerHits: [])
            .set(scoreMode: .AVG)
            .build()

        XCTAssertTrue(query.query.isEqualTo(MatchAllQuery()))
        XCTAssertEqual(query.path, "type")
        XCTAssertEqual(query.ignoreUnmapped, false)
        XCTAssertEqual(query.innerHits, [])
        XCTAssertEqual(query.scoreMode, .AVG)
    }
}
