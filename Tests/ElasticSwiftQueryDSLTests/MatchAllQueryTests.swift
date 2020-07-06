//
//  MatchAllQueryTests.swift
//  ElasticSwiftQueryDSLTests
//
//  Created by Prafull Kumar Soni on 6/8/19.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class MatchAllQueryTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.ScriptTests", factory: logFactory)

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

    func test_01_match_all_query() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let query = try! QueryBuilders.matchAllQuery().build()
        let expectedJson = "{\"match_all\":{}}"
        do {
            let data = try JSONEncoder().encode(query)
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            logger.error("Error: \(error)")
            XCTAssert(false)
        }
    }

    func test_02_match_all_boost() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
        let query = try! QueryBuilders.matchAllQuery().set(boost: 1.1).build()
        let expectedJson = "{\"match_all\":{\"boost\":1.1}}"
        do {
            let data = try JSONEncoder().encode(query)
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            logger.error("Error: \(error)")
            XCTAssert(false)
        }
    }

    func test_03_match_non_query() {
        let query = try! MatchNoneQueryBuilder().build()
        let expectedJson = "{\"match_none\":{}}"
        do {
            let data = try JSONEncoder().encode(query)
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            logger.error("Error: \(error)")
            XCTAssert(false)
        }
    }

    func test_04_match_all_non_equality() throws {
        let query1 = MatchAllQuery()
        let query2 = MatchNoneQuery()

        XCTAssertFalse(query1.isEqualTo(query2))
        XCTAssertNotEqual(query1, MatchAllQuery(boost: 1.0))
        XCTAssertEqual(query2, MatchNoneQuery())
    }

    func test_05_match_all_decode() throws {
        let query = try QueryBuilders.matchAllQuery()
            .set(boost: 1.2)
            .set(name: "name")
            .build()

        let jsonData = """
            {
                "match_all" : {
                    "boost" : 1.2,
                    "name" : "name"
                }
            }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(MatchAllQuery.self, from: jsonData)
        XCTAssertEqual(query, decoded)
    }

    func test_05_match_none_decode() throws {
        let query = try QueryBuilders.matchNoneQuery()
            .set(boost: 1.2)
            .set(name: "name")
            .build()

        let jsonData = """
            {
                "match_none" : {
                    "boost" : 1.2,
                    "name" : "name"
                }
            }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(MatchNoneQuery.self, from: jsonData)
        XCTAssertEqual(query, decoded)
    }
}
