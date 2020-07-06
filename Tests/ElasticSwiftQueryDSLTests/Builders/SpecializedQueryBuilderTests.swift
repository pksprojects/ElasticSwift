//
//  SpecializedQueryBuilderTests.swift
//
//
//  Created by Prafull Kumar Soni on 6/7/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class SpecializedQueryBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.SpecializedQueryBuilderTests", factory: logFactory)

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

    func test_01_moreLikeThisQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.moreLikeThisQuery().set(likeTexts: ["test"]).build(), "Should not throw")
    }

    func test_02_moreLikeThisQueryBuilder_missing_like() throws {
        XCTAssertThrowsError(try QueryBuilders.moreLikeThisQuery().set(fields: ["field1"]).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atlestOneElementRequired(field):
                    XCTAssertEqual("likeTexts OR likeItems", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_03_moreLikeThisQueryBuilder() throws {
        let query = try QueryBuilders.moreLikeThisQuery()
            .set(fields: ["field1"])
            .set(likeTexts: ["like"])
            .set(analyzer: "analyzer")
            .set(include: false)
            .set(likeItems: [.init(id: "id")])
            .set(boostTerms: 2.0)
            .set(stopWords: ["stop"])
            .set(maxDocFreq: 2)
            .set(minDocFreq: 1)
            .set(minTermFreq: 2)
            .set(unlikeItems: [.init(id: "id2")])
            .set(unlikeTexts: ["unlike"])
            .set(maxQueryTerms: 2)
            .set(maxWordLength: 1)
            .set(minWordLength: 1)
            .set(minimumShouldMatch: "2")
            .set(failOnUnsupportedField: true)
            .add(like: .init(id: "id3"))
            .add(like: "like2")
            .add(field: "field2")
            .add(unlike: "unlike2")
            .add(stopWord: "stop2")
            .add(unlike: MoreLikeThisQuery.Item(id: "id4"))
            .set(boost: 1.0)
            .set(name: "name")
            .build()
        XCTAssertEqual(query.fields, ["field1", "field2"])
        XCTAssertEqual(query.likeTexts, ["like", "like2"])
        XCTAssertEqual(query.likeItems, [.init(id: "id"), .init(id: "id3")])
        XCTAssertEqual(query.unlikeTexts, ["unlike", "unlike2"])
        XCTAssertEqual(query.unlikeItems, [.init(id: "id2"), .init(id: "id4")])
        XCTAssertEqual(query.stopWords, ["stop", "stop2"])
        XCTAssertEqual(query.analyzer, "analyzer")
        XCTAssertEqual(query.failOnUnsupportedField, true)
        XCTAssertEqual(query.include, false)
        XCTAssertEqual(query.maxDocFreq, 2)
        XCTAssertEqual(query.minDocFreq, 1)
        XCTAssertEqual(query.minTermFreq, 2)
        XCTAssertEqual(query.maxQueryTerms, 2)
        XCTAssertEqual(query.maxWordLength, 1)
        XCTAssertEqual(query.minWordLength, 1)
        XCTAssertEqual(query.minimumShouldMatch, "2")
        XCTAssertEqual(query.boostTerms, 2.0)
        XCTAssertEqual(query.boost, 1.0)
        XCTAssertEqual(query.name, "name")
    }

    func test_04_scriptQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.scriptQuery().set(script: .init("some script")).build(), "Should not throw")
    }

    func test_05_scriptQueryBuilder_missing_script() throws {
        XCTAssertThrowsError(try QueryBuilders.scriptQuery().build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("script", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_06_scriptQueryBuilder() throws {
        let query = try QueryBuilders.scriptQuery()
            .set(script: .init("some script"))
            .build()
        XCTAssertEqual(query.script, Script("some script"))
    }

    func test_07_percoloteQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.percolateQuery().set(field: "field").set(documents: [["test": "abc"]]).build(), "Should not throw")
    }

    func test_08_percoloteQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.percolateQuery().set(documents: [["test": "abc"]]).build(), "Should not throw") { error in
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

    func test_09_percoloteQueryBuilder_missing_document() throws {
        XCTAssertThrowsError(try QueryBuilders.percolateQuery().set(field: "field").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atleastOneFieldRequired(fields):
                    XCTAssertEqual(["documents", "index AND type AND id"], fields)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_10_percoloteQueryBuilder() throws {
        let query = try QueryBuilders.percolateQuery()
            .set(field: "field")
            .set(documents: [["test": "abc"]])
            .build()
        XCTAssertEqual(query.field, "field")
        XCTAssertEqual(query.documents, [["test": "abc"]])
    }

    func test_11_percoloteQueryBuilder() throws {
        let query = try QueryBuilders.percolateQuery()
            .set(field: "field")
            .set(id: "id")
            .set(type: "type")
            .set(index: "index")
            .set(routing: "routing")
            .set(version: 2)
            .set(preference: "preference")
            .set(boost: 1.0)
            .set(name: "name")
            .build()
        XCTAssertEqual(query.field, "field")
        XCTAssertEqual(query.id, "id")
        XCTAssertEqual(query.type, "type")
        XCTAssertEqual(query.index, "index")
        XCTAssertEqual(query.routing, "routing")
        XCTAssertEqual(query.version, 2)
        XCTAssertEqual(query.preference, "preference")
        XCTAssertEqual(query.boost, 1.0)
        XCTAssertEqual(query.name, "name")
    }

    func test_12_wrapperQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.wrapperQuery().set(query: "base64querystring").build(), "Should not throw")
    }

    func test_13_wrapperQueryBuilder_missing_script() throws {
        XCTAssertThrowsError(try QueryBuilders.wrapperQuery().build(), "Should not throw") { error in
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

    func test_14_wrapperQueryBuilder() throws {
        let query = try QueryBuilders.wrapperQuery()
            .set(query: "base64querystring")
            .build()
        XCTAssertEqual(query.query, "base64querystring")
    }
}
