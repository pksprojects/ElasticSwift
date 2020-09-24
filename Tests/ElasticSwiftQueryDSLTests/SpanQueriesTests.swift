//
//  SpanQueriesTests.swift
//
//
//  Created by Prafull Kumar Soni on 6/13/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class SpanQueriesTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.SpanQueriesTests", factory: logFactory)

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

    func test_01_spanTermQuery_encode() throws {
        let query = SpanTermQuery(field: "user", value: "kimchy")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_term" : { "user" : "kimchy" }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_spanTermQuery_encode_2() throws {
        let query = try QueryBuilders.spanTermQuery()
            .set(field: "user")
            .set(value: "kimchy")
            .set(boost: 2.0)
            .build()

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_term" : { "user" : { "value" : "kimchy", "boost" : 2.0 } }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_03_spanTermQuery_decode() throws {
        let query = try QueryBuilders.spanTermQuery()
            .set(field: "user")
            .set(value: "kimchy")
            .build()

        let jsonStr = """
        {
            "span_term" : { "user" : "kimchy" }
        }
        """

        let decoded = try JSONDecoder().decode(SpanTermQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_04_spanTermQuery_decode_2() throws {
        let query = try QueryBuilders.spanTermQuery()
            .set(field: "user")
            .set(value: "kimchy")
            .set(boost: 2.0)
            .build()

        let jsonStr = """
        {
            "span_term" : { "user" : { "value" : "kimchy", "boost" : 2.0 } }
        }
        """

        let decoded = try JSONDecoder().decode(SpanTermQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_05_spanTermQuery_decode_3() throws {
        let query = try QueryBuilders.spanTermQuery()
            .set(field: "user")
            .set(value: "kimchy")
            .set(boost: 2.0)
            .build()

        let jsonStr = """
        {
            "span_term" : { "user" : { "term" : "kimchy", "boost" : 2.0 } }
        }
        """

        let decoded = try JSONDecoder().decode(SpanTermQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_06_spanMultiQuery_encode() throws {
        let query = SpanMultiTermQuery(PrefixQuery(field: "user", value: "ki"))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_multi":{
                "match":{
                    "prefix" : { "user" : "ki" }
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_07_spanMultiQuery_encode_2() throws {
        let query = SpanMultiTermQuery(PrefixQuery(field: "user", value: "ki", boost: 1.08))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_multi":{
                "match":{
                    "prefix" : { "user" :  { "value" : "ki", "boost" : 1.08 } }
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_08_spanMultiQuery_decode() throws {
        let query = try QueryBuilders.spanMultiTermQueryBuilder()
            .set(match: PrefixQuery(field: "user", value: "ki"))
            .build()

        let jsonStr = """
        {
            "span_multi":{
                "match":{
                    "prefix" : { "user" : "ki" }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanMultiTermQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_09_spanMultiQuery_decode_2() throws {
        let query = try QueryBuilders.spanMultiTermQueryBuilder()
            .set(match: PrefixQuery(field: "user", value: "ki", boost: 1.08))
            .build()

        let jsonStr = """
        {
            "span_multi":{
                "match":{
                    "prefix" : { "user" :  { "value" : "ki", "boost" : 1.08 } }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanMultiTermQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_10_spanFirstQuery_encode() throws {
        let query = SpanFirstQuery(SpanTermQuery(field: "user", value: "kimchy"), end: 3)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_first" : {
                "match" : {
                    "span_term" : { "user" : "kimchy" }
                },
                "end" : 3
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_11_spanFirstQuery_decode() throws {
        let query = try QueryBuilders.spanFirstQuery()
            .set(match: SpanTermQuery(field: "user", value: "kimchy"))
            .set(end: 3)
            .build()

        let jsonStr = """
        {
            "span_first" : {
                "match" : {
                    "span_term" : { "user" : "kimchy" }
                },
                "end" : 3
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanFirstQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_12_spanNearQuery_encode() throws {
        let query = SpanNearQuery(SpanTermQuery(field: "field", value: "value1"), SpanTermQuery(field: "field", value: "value2"), SpanTermQuery(field: "field", value: "value3"), slop: 12, inOrder: false)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_near" : {
                "clauses" : [
                    { "span_term" : { "field" : "value1" } },
                    { "span_term" : { "field" : "value2" } },
                    { "span_term" : { "field" : "value3" } }
                ],
                "slop" : 12,
                "in_order" : false
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_13_spanNearQuery_decode() throws {
        let query = try QueryBuilders.spanNearQuery()
            .add(clause: SpanTermQuery(field: "field", value: "value1"))
            .add(clause: SpanTermQuery(field: "field", value: "value2"))
            .add(clause: SpanTermQuery(field: "field", value: "value3"))
            .set(slop: 12)
            .set(inOrder: false)
            .build()

        let jsonStr = """
        {
            "span_near" : {
                "clauses" : [
                    { "span_term" : { "field" : "value1" } },
                    { "span_term" : { "field" : "value2" } },
                    { "span_term" : { "field" : "value3" } }
                ],
                "slop" : 12,
                "in_order" : false
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanNearQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_14_spanOrQuery_encode() throws {
        let query = SpanOrQuery([SpanTermQuery(field: "field", value: "value1"), SpanTermQuery(field: "field", value: "value2"), SpanTermQuery(field: "field", value: "value3")])

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_or" : {
                "clauses" : [
                    { "span_term" : { "field" : "value1" } },
                    { "span_term" : { "field" : "value2" } },
                    { "span_term" : { "field" : "value3" } }
                ]
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_15_spanOrQuery_decode() throws {
        let query = try QueryBuilders.spanOrQuery()
            .add(clause: SpanTermQuery(field: "field", value: "value1"))
            .add(clause: SpanTermQuery(field: "field", value: "value2"))
            .add(clause: SpanTermQuery(field: "field", value: "value3"))
            .build()

        let jsonStr = """
        {
            "span_or" : {
                "clauses" : [
                    { "span_term" : { "field" : "value1" } },
                    { "span_term" : { "field" : "value2" } },
                    { "span_term" : { "field" : "value3" } }
                ]
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanOrQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_16_spanNotQuery_encode() throws {
        let query = SpanNotQuery(include: SpanTermQuery(field: "field1", value: "hoya"),
                                 exclude: SpanNearQuery([SpanTermQuery(field: "field1", value: "la"),
                                                         SpanTermQuery(field: "field1", value: "hoya")], slop: 0, inOrder: true))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_not" : {
                "include" : {
                    "span_term" : { "field1" : "hoya" }
                },
                "exclude" : {
                    "span_near" : {
                        "clauses" : [
                            { "span_term" : { "field1" : "la" } },
                            { "span_term" : { "field1" : "hoya" } }
                        ],
                        "slop" : 0,
                        "in_order" : true
                    }
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_17_spanNotQuery_decode() throws {
        let query = try QueryBuilders.spanNotQuery()
            .set(include: SpanTermQuery(field: "field1", value: "hoya"))
            .set(exclude: SpanNearQuery([SpanTermQuery(field: "field1", value: "la"),
                                         SpanTermQuery(field: "field1", value: "hoya")], slop: 0, inOrder: true))
            .build()

        let jsonStr = """
        {
            "span_not" : {
                "include" : {
                    "span_term" : { "field1" : "hoya" }
                },
                "exclude" : {
                    "span_near" : {
                        "clauses" : [
                            { "span_term" : { "field1" : "la" } },
                            { "span_term" : { "field1" : "hoya" } }
                        ],
                        "slop" : 0,
                        "in_order" : true
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanNotQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_18_spanContainingQuery_encode() throws {
        let query = SpanContainingQuery(big: SpanNearQuery([SpanTermQuery(field: "field1", value: "bar"),
                                                            SpanTermQuery(field: "field1", value: "baz")], slop: 5, inOrder: true),
        little: SpanTermQuery(field: "field1", value: "foo"))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_containing" : {
                "little" : {
                    "span_term" : { "field1" : "foo" }
                },
                "big" : {
                    "span_near" : {
                        "clauses" : [
                            { "span_term" : { "field1" : "bar" } },
                            { "span_term" : { "field1" : "baz" } }
                        ],
                        "slop" : 5,
                        "in_order" : true
                    }
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_19_spanContainingQuery_decode() throws {
        let query = try QueryBuilders.spanContainingQuery()
            .set(little: SpanTermQuery(field: "field1", value: "foo"))
            .set(big: SpanNearQuery([SpanTermQuery(field: "field1", value: "bar"),
                                     SpanTermQuery(field: "field1", value: "baz")], slop: 5, inOrder: true))
            .build()

        let jsonStr = """
        {
            "span_containing" : {
                "little" : {
                    "span_term" : { "field1" : "foo" }
                },
                "big" : {
                    "span_near" : {
                        "clauses" : [
                            { "span_term" : { "field1" : "bar" } },
                            { "span_term" : { "field1" : "baz" } }
                        ],
                        "slop" : 5,
                        "in_order" : true
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanContainingQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_20_spanWithinQuery_encode() throws {
        let query = SpanWithinQuery(big: SpanNearQuery([SpanTermQuery(field: "field1", value: "bar"),
                                                        SpanTermQuery(field: "field1", value: "baz")], slop: 5, inOrder: true),
        little: SpanTermQuery(field: "field1", value: "foo"))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "span_within" : {
                "little" : {
                    "span_term" : { "field1" : "foo" }
                },
                "big" : {
                    "span_near" : {
                        "clauses" : [
                            { "span_term" : { "field1" : "bar" } },
                            { "span_term" : { "field1" : "baz" } }
                        ],
                        "slop" : 5,
                        "in_order" : true
                    }
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_21_spanWithinQuery_decode() throws {
        let query = try QueryBuilders.spanWithinQuery()
            .set(little: SpanTermQuery(field: "field1", value: "foo"))
            .set(big: SpanNearQuery([SpanTermQuery(field: "field1", value: "bar"),
                                     SpanTermQuery(field: "field1", value: "baz")], slop: 5, inOrder: true))
            .build()

        let jsonStr = """
        {
            "span_within" : {
                "little" : {
                    "span_term" : { "field1" : "foo" }
                },
                "big" : {
                    "span_near" : {
                        "clauses" : [
                            { "span_term" : { "field1" : "bar" } },
                            { "span_term" : { "field1" : "baz" } }
                        ],
                        "slop" : 5,
                        "in_order" : true
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanWithinQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_22_fieldMaskingSpanQuery_encode() throws {
        let query = SpanFieldMaskingQuery(field: "text", query: SpanTermQuery(field: "text.stems", value: "fox"))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "field_masking_span": {
              "query": {
                "span_term": {
                  "text.stems": "fox"
                }
              },
              "field": "text"
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_23_fieldMaskingSpanQuery_decode() throws {
        let query = try QueryBuilders.fieldMaskingSpanQuery()
            .set(query: SpanTermQuery(field: "text.stems", value: "fox"))
            .set(field: "text")
            .build()

        let jsonStr = """
        {
            "field_masking_span": {
              "query": {
                "span_term": {
                  "text.stems": "fox"
                }
              },
              "field": "text"
            }
        }
        """

        let decoded = try JSONDecoder().decode(SpanFieldMaskingQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
