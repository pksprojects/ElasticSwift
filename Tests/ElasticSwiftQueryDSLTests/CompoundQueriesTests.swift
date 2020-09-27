//
//  CompoundQuriesTests.swift
//  ElasticSwiftQueryDSLTests
//
//  Created by Prafull Kumar Soni on 9/2/19.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class CompoundQueriesTest: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.CompoundQuriesTest", factory: logFactory)

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

    func test_01_constantScoreQuery_encode() throws {
        let query = ConstantScoreQuery(MatchAllQuery(), boost: 1.1)

        let data = try! JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"constant_score\":{\"filter\":{\"match_all\":{}},\"boost\":1.1}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_constantScoreQuery_decode() throws {
        let query = ConstantScoreQuery(MatchAllQuery(boost: 1.1), boost: 1.1)

        let jsonStr = "{\"constant_score\":{\"filter\":{\"match_all\":{\"boost\":1.1}},\"boost\":1.1}}"

        let decoded = try! JSONDecoder().decode(ConstantScoreQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_03_boolQuery_encode() throws {
        let query = try BoolQueryBuilder()
            .filter(query: MatchAllQuery())
            .filter(query: MatchNoneQuery())
            .must(query: MatchAllQuery())
            .mustNot(query: MatchNoneQuery())
            .build()

        let data = try! JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"bool\":{\"filter\":[{\"match_all\":{}},{\"match_none\":{}}],\"must\":[{\"match_all\":{}}],\"must_not\":[{\"match_none\":{}}]}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_04_boolQuery_decode() throws {
        let query = try BoolQueryBuilder()
            .filter(query: MatchAllQuery())
            .filter(query: MatchNoneQuery())
            .must(query: MatchAllQuery())
            .mustNot(query: MatchNoneQuery())
            .build()

        let jsonStr = "{\"bool\":{\"filter\":[{\"match_all\":{}},{\"match_none\":{}}],\"must\":[{\"match_all\":{}}],\"must_not\":[{\"match_none\":{}}]}}"

        let decoded = try! JSONDecoder().decode(BoolQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_05_functionScoreQuery_encode() throws {
        let scoreFunction = try LinearDecayFunctionBuilder()
            .set(field: "date")
            .set(origin: "2013-09-17")
            .set(scale: "10d")
            .set(offset: "5d")
            .set(decay: 0.5)
            .build()

        let query = try FunctionScoreQueryBuilder()
            .set(query: MatchAllQuery())
            .add(function: scoreFunction)
            .build()

        let data = try! JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"function_score\":{\"query\":{\"match_all\":{}},\"functions\":[{\"linear\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}]}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_06_functionScoreQuery_decode() throws {
        let gaussFunction = try GaussDecayFunctionBuilder()
            .set(field: "price")
            .set(origin: "0")
            .set(scale: "20")
            .build()
        let gaussFunction2 = try GaussDecayFunctionBuilder()
            .set(field: "location")
            .set(origin: "11, 12")
            .set(scale: "2km")
            .build()
        let query = FunctionScoreQuery(query: MatchQuery(field: "properties", value: "balcony"), scoreMode: .multiply, functions: gaussFunction, gaussFunction2)

        let jsonStr = """
        {
            "function_score": {
              "functions": [
                {
                  "gauss": {
                    "price": {
                      "origin": "0",
                      "scale": "20"
                    }
                  }
                },
                {
                  "gauss": {
                    "location": {
                      "origin": "11, 12",
                      "scale": "2km"
                    }
                  }
                }
              ],
              "query": {
                "match": {
                  "properties": "balcony"
                }
              },
              "score_mode": "multiply"
            }
        }
        """

        let decoded = try JSONDecoder().decode(FunctionScoreQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_07_disMaxQuery_encode() throws {
        let query = DisMaxQuery([TermQuery(field: "title", value: "Quick pets"), TermQuery(field: "body", value: "Quick pets")], tieBreaker: 0.7, boost: 1.0)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "dis_max" : {
                "queries" : [
                    { "term" : { "title" : "Quick pets" }},
                    { "term" : { "body" : "Quick pets" }}
                ],
                "tie_breaker" : 0.7,
                "boost": 1.0
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_08_disMaxQuery_decode() throws {
        let query = DisMaxQuery([TermQuery(field: "title", value: "Quick pets"), TermQuery(field: "body", value: "Quick pets")], tieBreaker: 0.7)

        let jsonStr = """
        {
            "dis_max" : {
                "queries" : [
                    { "term" : { "title" : "Quick pets" }},
                    { "term" : { "body" : "Quick pets" }}
                ],
                "tie_breaker" : 0.7
            }
        }
        """

        let decoded = try JSONDecoder().decode(DisMaxQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_09_boostingQuery_encode() throws {
        let query = BoostingQuery(positive: TermQuery(field: "text", value: "apple"), negative: TermQuery(field: "text", value: "pie tart fruit crumble tree"), negativeBoost: 0.5)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "boosting" : {
                "positive" : {
                    "term" : {
                        "text" : "apple"
                    }
                },
                "negative" : {
                     "term" : {
                         "text" : "pie tart fruit crumble tree"
                    }
                },
                "negative_boost" : 0.5
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_10_boostingQuery_decode() throws {
        let query = BoostingQuery(positive: TermQuery(field: "text", value: "apple"), negative: TermQuery(field: "text", value: "pie tart fruit crumble tree"), negativeBoost: 0.5)

        let jsonStr = """
        {
            "boosting" : {
                "positive" : {
                    "term" : {
                        "text" : "apple"
                    }
                },
                "negative" : {
                     "term" : {
                         "text" : "pie tart fruit crumble tree"
                    }
                },
                "negative_boost" : 0.5
            }
        }
        """

        let decoded = try JSONDecoder().decode(BoostingQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
