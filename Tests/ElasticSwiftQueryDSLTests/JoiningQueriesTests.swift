//
//  JoiningQueriesTests.swift
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

class JoiningQueriesTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.JoiningQueriesTests", factory: logFactory)

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

    func test_01_nestedQuery_encode() throws {
        let query = NestedQuery("obj1", query: MatchAllQuery(), scoreMode: .avg, innerHits: InnerHit())

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from:
            """
            {
                "nested" : {
                    "path" : "obj1",
                    "query" : {
                        "match_all" : {}
                    },
                    "score_mode" : "avg",
                    "inner_hits" : {}
                }
            }
            """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_nestedQuery_decode() throws {
        let query = NestedQuery("obj1", query: BoolQuery(must: [MatchQuery(field: "obj1.name", value: "blue"), RangeQuery(field: "obj1.count", gte: nil, gt: "5", lte: nil, lt: nil)], mustNot: [], should: [], filter: []), scoreMode: .avg, innerHits: InnerHit())

        let jsonStr = """
        {
            "nested" : {
                "path" : "obj1",
                "query" : {
                    "bool" : {
                        "must" : [
                        { "match" : {"obj1.name" : "blue"} },
                        { "range" : {"obj1.count" : {"gt" : "5"}} }
                        ]
                    }
                },
                "score_mode" : "avg",
                "inner_hits" : {}
            }
        }
        """

        let decoded = try JSONDecoder().decode(NestedQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_03_hasChildQuery_encode() throws {
        let query = HasChildQuery("type", query: MatchAllQuery())

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"has_child\":{\"type\":\"type\",\"query\":{\"match_all\":{}}}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_04_hasChildQuery_decode() throws {
        let query = HasChildQuery("blog_tag", query: TermQuery(field: "tag", value: "something"), scoreMode: .min, minChildren: 2, maxChildren: 10)

        let jsonStr = """
        {
            "has_child" : {
                "type" : "blog_tag",
                "score_mode" : "min",
                "min_children": 2,
                "max_children": 10,
                "query" : {
                    "term" : {
                        "tag" : "something"
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(HasChildQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_05_hasParentQuery_encode() throws {
        let query = HasParentQuery("type", query: MatchAllQuery())

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"has_parent\":{\"parent_type\":\"type\",\"query\":{\"match_all\":{}}}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_06_hasParentQuery_decode() throws {
        let query = HasParentQuery("blog", query: TermQuery(field: "tag", value: "something"), score: true)

        let jsonStr = """
        {
            "has_parent" : {
                "parent_type" : "blog",
                "score" : true,
                "query" : {
                    "term" : {
                        "tag" : "something"
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(HasParentQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_07_parentIdQuery_encode() throws {
        let query = ParentIdQuery("1", type: "my_child", ignoreUnmapped: true)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"parent_id\":{\"type\":\"my_child\",\"id\":\"1\",\"ignore_unmapped\":true}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_08_parentIdQuery_decode() throws {
        let query = ParentIdQuery("1", type: "my_child")

        let jsonStr = """
        {
          "parent_id": {
            "type": "my_child",
            "id": "1"
          }
        }
        """

        let decoded = try JSONDecoder().decode(ParentIdQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
