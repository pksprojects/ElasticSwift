//
//  TermLevelQueriesTests.swift
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

class TermLevelQueriesTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.TermLevelQueriesTests", factory: logFactory)

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

    func test_01_termQuery_encode() throws {
        let query = TermQuery(field: "user", value: "Kimchy")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "term" : { "user" : "Kimchy" }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_termQuery_encode_2() throws {
        let query = TermQuery(field: "status", value: "urgent", boost: 2.0)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "term": {
              "status": {
                "value": "urgent",
                "boost": 2.0
              }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_03_termQuery_decode() throws {
        let query = TermQuery(field: "user", value: "Kimchy")

        let jsonStr = """
        {
            "term" : { "user" : "Kimchy" }
        }
        """

        let decoded = try JSONDecoder().decode(TermQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_04_termQuery_decode_2() throws {
        let query = TermQuery(field: "status", value: "urgent", boost: 2.0)

        let jsonStr = """
        {
            "term": {
              "status": {
                "value": "urgent",
                "boost": 2.0
              }
            }
        }
        """

        let decoded = try JSONDecoder().decode(TermQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_05_termsQuery_encode() throws {
        let query = TermsQuery(field: "user", values: ["kimchy", "elasticsearch"])

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "terms" : { "user" : ["kimchy", "elasticsearch"]}
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_06_termsQuery_decode() throws {
        let query = TermsQuery(field: "user", values: ["kimchy", "elasticsearch"])

        let jsonStr = """
        {
            "terms" : { "user" : ["kimchy", "elasticsearch"]}
        }
        """

        let decoded = try JSONDecoder().decode(TermsQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
