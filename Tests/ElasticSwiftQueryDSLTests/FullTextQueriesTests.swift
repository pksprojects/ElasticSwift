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

    func test_05_matchPhraseQuery_encode() throws {
        let query = MatchPhraseQuery(field: "message", value: "this is a test", analyzer: "my_analyzer")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "match_phrase" : {
                "message" : {
                    "query" : "this is a test",
                    "analyzer" : "my_analyzer"
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_06_matchPhraseQuery_decode() throws {
        let query = try QueryBuilders.matchPhraseQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .set(analyzer: "my_analyzer")
            .build()

        let jsonStr = """
        {
            "match_phrase" : {
                "message" : {
                    "query" : "this is a test",
                    "analyzer" : "my_analyzer"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhraseQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_07_matchPhraseQuery_decode_2() throws {
        let query = try QueryBuilders.matchPhraseQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .build()

        let jsonStr = """
        {
            "match_phrase" : {
                "message" : "this is a test"
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhraseQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_08_matchPhraseQuery_decode_fail() throws {
        let jsonStr = """
        {
            "match_phrase" : {
                "message" : "this is a test",
                "invalid_key": "random"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(MatchPhraseQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(MatchPhraseQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }

    func test_09_matchPhrasePrefixQuery_encode() throws {
        let query = MatchPhrasePrefixQuery(field: "message", value: "quick brown f", maxExpansions: 10)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "match_phrase_prefix" : {
                "message" : {
                    "query" : "quick brown f",
                    "max_expansions" : 10
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_10_matchPhrasePrefixQuery_decode() throws {
        let query = try QueryBuilders.matchPhrasePrefixQuery()
            .set(field: "message")
            .set(value: "quick brown f")
            .set(maxExpansions: 10)
            .build()

        let jsonStr = """
        {
            "match_phrase_prefix" : {
                "message" : {
                    "query" : "quick brown f",
                    "max_expansions" : 10
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhrasePrefixQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_11_matchPhrasePrefixQuery_decode_2() throws {
        let query = try QueryBuilders.matchPhrasePrefixQuery()
            .set(field: "message")
            .set(value: "quick brown f")
            .build()

        let jsonStr = """
        {
            "match_phrase_prefix" : {
                "message" : "quick brown f"
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhrasePrefixQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_12_matchPhrasePrefixQuery_decode_fail() throws {
        let jsonStr = """
        {
            "match_phrase_prefix" : {
                "message" : "quick brown f",
                "invalid_key": "random"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(MatchPhrasePrefixQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(MatchPhrasePrefixQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }
}
