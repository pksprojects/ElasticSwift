//
//  MatchAllQueryTests.swift
//  ElasticSwiftTests
//
//  Created by Prafull Kumar Soni on 6/8/19.
//

import XCTest

@testable import ElasticSwift

class MatchAllQueryTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMatchAllQuery() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let query = QueryBuilders.matchAllQuery().query
        let expectedJson = "{\"match_all\":{}}"
        do {
            let data = try JSONSerialization.data(withJSONObject: query.toDic(), options: [])
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            print("Error:", error)
            XCTAssert(false)
        }
    }

    func testMatchAllBoost() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
        let query = QueryBuilders.matchAllQuery(){ builder in builder.boost = 1.1 }.query
        let expectedJson = "{\"match_all\":{\"boost\":1.1}}"
        do {
            let data = try JSONSerialization.data(withJSONObject: query.toDic(), options: [])
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            print("Error:", error)
            XCTAssert(false)
        }
    }
    
    func testMatchNonQuery() {
        let query = MatchNoneQueryBuilder().query
        let expectedJson = "{\"match_none\":{}}"
        do {
            let data = try JSONSerialization.data(withJSONObject: query.toDic(), options: [])
            let dataStr = String(data: data, encoding: .utf8)
            XCTAssert(expectedJson == dataStr)
        } catch {
            print("Error:", error)
            XCTAssert(false)
        }
    }

    static var allTests = [
        ("testMatchAllQuery", testMatchAllQuery),
        ("testMatchAllBoost", testMatchAllBoost),
        ("testMatchNonQuery", testMatchNonQuery)
    ]
}
