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

    func test_07_rangeQuery_encode() throws {
        let query = RangeQuery(field: "age", gte: "10", gt: nil, lte: "20", lt: nil, boost: 2.0)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "range" : {
                "age" : {
                    "gte" : "10",
                    "lte" : "20",
                    "boost" : 2.0
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_08_rangeQuery_encode_2() throws {
        let query = try QueryBuilders.rangeQuery()
            .set(field: "age")
            .set(gt: "14")
            .set(lt: "45")
            .set(gte: "15")
            .set(lte: "45")
            .set(format: "dd/MM/yyyy||yyyy")
            .set(relation: .contains)
            .set(timeZone: "UTC")
            .set(boost: 2.0)
            .build()

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "range" : {
                "age" : {
                    "gte": "15",
                    "lte": "45",
                    "gt": "14",
                    "lt": "45",
                    "format": "dd/MM/yyyy||yyyy",
                    "time_zone": "UTC",
                    "relation": "contains",
                    "boost" : 2.0
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_09_rangeQuery_decode() throws {
        let query = RangeQuery(field: "age", gte: "10", gt: nil, lte: "20", lt: nil, boost: 2.0)

        let jsonStr = """
        {
            "range" : {
                "age" : {
                    "gte" : "10",
                    "lte" : "20",
                    "boost" : 2.0
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(RangeQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_10_rangeQuery_decode_2() throws {
        let query = try QueryBuilders.rangeQuery()
            .set(field: "age")
            .set(gt: "14")
            .set(lt: "45")
            .set(gte: "15")
            .set(lte: "45")
            .set(format: "dd/MM/yyyy||yyyy")
            .set(relation: .contains)
            .set(timeZone: "UTC")
            .set(boost: 2.0)
            .build()

        let jsonStr = """
        {
            "range" : {
                "age" : {
                    "gte": "15",
                    "lte": "45",
                    "gt": "14",
                    "lt": "45",
                    "format": "dd/MM/yyyy||yyyy",
                    "time_zone": "UTC",
                    "relation": "contains",
                    "boost" : 2.0
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(RangeQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_11_existsQuery_encode() throws {
        let query = ExistsQuery(field: "user")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "exists": {
                "field": "user"
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_12_existsQuery_decode() throws {
        let query = ExistsQuery(field: "user")

        let jsonStr = """
        {
            "exists": {
                "field": "user"
            }
        }
        """

        let decoded = try JSONDecoder().decode(ExistsQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_13_prefixQuery_encode() throws {
        let query = PrefixQuery(field: "user", value: "ki")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "prefix" : { "user" : "ki" }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_14_prefixQuery_encode_2() throws {
        let query = PrefixQuery(field: "user", value: "ki", boost: 2.0)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "prefix" : { "user" :  { "value" : "ki", "boost" : 2.0 } }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_15_prefixQuery_decode() throws {
        let query = PrefixQuery(field: "user", value: "ki")

        let jsonStr = """
        {
            "prefix" : { "user" : "ki" }
        }
        """

        let decoded = try JSONDecoder().decode(PrefixQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_16_prefixQuery_decode_2() throws {
        let query = PrefixQuery(field: "user", value: "ki", boost: 2.0)

        let jsonStr = """
        {
            "prefix" : { "user" :  { "value" : "ki", "boost" : 2.0 } }
        }
        """

        let decoded = try JSONDecoder().decode(PrefixQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_17_wildCardQuery_encode() throws {
        let query = WildCardQuery(field: "user", value: "ki*y")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "wildcard": {
                "user": "ki*y"
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_18_wildCardQuery_encode_2() throws {
        let query = WildCardQuery(field: "user", value: "ki*y", boost: 2.0)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "wildcard": {
                "user": {
                    "value": "ki*y",
                    "boost": 2.0
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_19_wildCardQuery_decode() throws {
        let query = WildCardQuery(field: "user", value: "ki*y")

        let jsonStr = """
        {
            "wildcard": {
                "user": "ki*y"
            }
        }
        """

        let decoded = try JSONDecoder().decode(WildCardQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_20_wildCardQuery_decode_2() throws {
        let query = WildCardQuery(field: "user", value: "ki*y", boost: 2.0)

        let jsonStr = """
        {
            "wildcard": {
                "user": {
                    "value": "ki*y",
                    "boost": 2.0
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(WildCardQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
