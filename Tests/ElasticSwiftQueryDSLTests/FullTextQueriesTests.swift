//
//  FullTextQueriesTests.swift
//  ElasticSwiftQueryDSLTests
//
//
//  Created by Prafull Kumar Soni on 3/31/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class FullTextQueriesTest: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.FullTextQueriesTest", factory: logFactory)

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

    func test_01_matchQuery_encode() throws {
        let query = MatchQuery(field: "message", value: "ny city", autoGenSynonymnsPhraseQuery: false)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "match" : {
                "message": {
                    "query" : "ny city",
                    "auto_generate_synonyms_phrase_query" : false
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_matchQuery_decode() throws {
        let query = try QueryBuilders.matchQuery().set(field: "message")
            .set(value: "to be or not to be")
            .set(operator: .and)
            .set(zeroTermQuery: .all)
            .build()

        let jsonStr = """
        {
            "match" : {
                "message" : {
                    "query" : "to be or not to be",
                    "operator" : "and",
                    "zero_terms_query": "all"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_03_matchQuery_decode_2() throws {
        let query = try QueryBuilders.matchQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .build()

        let jsonStr = """
        {
            "match" : {
                "message" : "this is a test"
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_04_matchQuery_decode_fail() throws {
        let jsonStr = """
        {
            "match" : {
                "message" : "this is a test",
                "invalid_key" : "random"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(MatchQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(MatchQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }
}
