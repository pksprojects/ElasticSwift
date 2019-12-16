//
//  MatchAllQueryTests.swift
//  ElasticSwiftQueryDSLTests
//
//  Created by Prafull Kumar Soni on 6/8/19.
//

import XCTest
import Logging
import UnitTestSettings

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

    func testMatchAllQuery() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let query = try! QueryBuilders.matchAllQuery().build()
        let expectedJson = "{\"match_all\":{}}"
        do {
            let data = try JSONSerialization.data(withJSONObject: query.toDic(), options: [])
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            logger.error("Error: \(error)")
            XCTAssert(false)
        }
    }

    func testMatchAllBoost() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
        let query = try! QueryBuilders.matchAllQuery().set(boost: 1.1).build()
        let expectedJson = "{\"match_all\":{\"boost\":1.1}}"
        do {
            let data = try JSONSerialization.data(withJSONObject: query.toDic(), options: [])
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            logger.error("Error: \(error)")
            XCTAssert(false)
        }
    }
    
    func testMatchNonQuery() {
        let query = try! MatchNoneQueryBuilder().build()
        let expectedJson = "{\"match_none\":{}}"
        do {
            let data = try JSONSerialization.data(withJSONObject: query.toDic(), options: [])
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            logger.error("Error: \(error)")
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testMatchAllQuery", testMatchAllQuery),
        ("testMatchAllBoost", testMatchAllBoost),
        ("testMatchNonQuery", testMatchNonQuery)
    ]
}
