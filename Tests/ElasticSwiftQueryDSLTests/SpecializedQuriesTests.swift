//
//  SpecializedQuriesTests.swift
//
//
//  Created by Prafull Kumar Soni on 5/30/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class SpecializedQuriesTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.SpecializedQuriesTests", factory: logFactory)

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

    func test_01_moreLikeThisQuery_encode() throws {
        let query = MoreLikeThisQuery(fields: ["title", "description"], likeTexts: ["Once upon a time"], maxQueryTerms: 12, minTermFreq: 1)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "more_like_this" : {
                "fields" : ["title", "description"],
                "like" : "Once upon a time",
                "min_term_freq" : 1,
                "max_query_terms" : 12
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_moreLikeThisQuery_encode_2() throws {
        let query = try QueryBuilders.moreLikeThisQuery()
            .add(field: "title")
            .add(field: "description")
            .add(like: .init(index: "imdb", type: "movies", id: "1", doc: nil))
            .add(like: .init(index: "imdb", type: "movies", id: "2", doc: nil))
            .set(minTermFreq: 1)
            .set(maxQueryTerms: 12)
            .add(like: "and potentially some more text here as well")
            .build()

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "more_like_this" : {
                "fields" : ["title", "description"],
                "like" : [
                "and potentially some more text here as well",
                {
                    "_index" : "imdb",
                    "_type" : "movies",
                    "_id" : "1"
                },
                {
                    "_index" : "imdb",
                    "_type" : "movies",
                    "_id" : "2"
                }
                ],
                "min_term_freq" : 1,
                "max_query_terms" : 12
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_03_moreLikeThisQuery_encode_3() throws {
        let query = try QueryBuilders.moreLikeThisQuery()
            .set(fields: ["name.first", "name.last"])
            .add(like: .init(index: "marvel", type: "quotes", id: nil, doc: [
                "name": [
                    "first": "Ben",
                    "last": "Grimm",
                ],
                "_doc": "You got no idea what I'd... what I'd give to be invisible.",
            ]))
            .add(like: .init(index: "marvel", type: "quotes", id: "2", doc: nil))
            .set(minTermFreq: 1)
            .set(maxQueryTerms: 12)
            .build()

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "more_like_this" : {
                "fields" : ["name.first", "name.last"],
                "like" : [
                {
                    "_index" : "marvel",
                    "_type" : "quotes",
                    "doc" : {
                        "name": {
                            "first": "Ben",
                            "last": "Grimm"
                        },
                        "_doc": "You got no idea what I'd... what I'd give to be invisible."
                      }
                },
                {
                    "_index" : "marvel",
                    "_type" : "quotes",
                    "_id" : "2"
                }
                ],
                "min_term_freq" : 1,
                "max_query_terms" : 12
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_04_moreLikeThisQuery_decode() throws {
        let query = MoreLikeThisQuery(fields: ["title", "description"], likeTexts: ["Once upon a time"], maxQueryTerms: 12, minTermFreq: 1)

        let jsonStr = """
        {
            "more_like_this" : {
                "fields" : ["title", "description"],
                "like" : "Once upon a time",
                "min_term_freq" : 1,
                "max_query_terms" : 12
            }
        }
        """

        let decoded = try JSONDecoder().decode(MoreLikeThisQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_05_moreLikeThisQuery_decode_2() throws {
        let query = try QueryBuilders.moreLikeThisQuery()
            .add(field: "title")
            .add(field: "description")
            .add(like: .init(index: "imdb", type: "movies", id: "1", doc: nil))
            .add(like: .init(index: "imdb", type: "movies", id: "2", doc: nil))
            .set(minTermFreq: 1)
            .set(maxQueryTerms: 12)
            .add(like: "and potentially some more text here as well")
            .build()

        let jsonStr = """
        {
            "more_like_this" : {
                "fields" : ["title", "description"],
                "like" : [
                {
                    "_index" : "imdb",
                    "_type" : "movies",
                    "_id" : "1"
                },
                {
                    "_index" : "imdb",
                    "_type" : "movies",
                    "_id" : "2"
                },
                "and potentially some more text here as well"
                ],
                "min_term_freq" : 1,
                "max_query_terms" : 12
            }
        }
        """

        let decoded = try JSONDecoder().decode(MoreLikeThisQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_06_moreLikeThisQuery_decode_3() throws {
        let query = try QueryBuilders.moreLikeThisQuery()
            .set(fields: ["name.first", "name.last"])
            .add(like: .init(index: "marvel", type: "quotes", id: nil, doc: [
                "name": [
                    "first": "Ben",
                    "last": "Grimm",
                ],
                "_doc": "You got no idea what I'd... what I'd give to be invisible.",
            ]))
            .add(like: .init(index: "marvel", type: "quotes", id: "2", doc: nil))
            .set(minTermFreq: 1)
            .set(maxQueryTerms: 12)
            .build()

        let jsonStr = """
        {
            "more_like_this" : {
                "fields" : ["name.first", "name.last"],
                "like" : [
                {
                    "_index" : "marvel",
                    "_type" : "quotes",
                    "doc" : {
                        "name": {
                            "first": "Ben",
                            "last": "Grimm"
                        },
                        "_doc": "You got no idea what I'd... what I'd give to be invisible."
                      }
                },
                {
                    "_index" : "marvel",
                    "_type" : "quotes",
                    "_id" : "2"
                }
                ],
                "min_term_freq" : 1,
                "max_query_terms" : 12
            }
        }
        """

        let decoded = try JSONDecoder().decode(MoreLikeThisQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_07_scriptQuery_encode() throws {
        let query = ScriptQuery(.init("doc['num1'].value > 1", lang: "painless"))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "script" : {
                "script" : {
                    "source": "doc['num1'].value > 1",
                    "lang": "painless"
                 }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_08_scriptQuery_encode_2() throws {
        let query = ScriptQuery(.init("doc['num1'].value > params.param1", lang: "painless", params: ["param1": 5]))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "script" : {
                "script" : {
                    "source" : "doc['num1'].value > params.param1",
                    "lang"   : "painless",
                    "params" : {
                        "param1" : 5
                    }
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_09_scriptQuery_decode() throws {
        let query = ScriptQuery(.init("doc['num1'].value > 1", lang: "painless"))

        let jsonStr = """
        {
            "script" : {
                "script" : {
                    "source": "doc['num1'].value > 1",
                    "lang": "painless"
                 }
            }
        }
        """

        let decoded = try JSONDecoder().decode(ScriptQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_10_scriptQuery_decode_2() throws {
        let query = ScriptQuery(.init("doc['num1'].value > params.param1", lang: "painless", params: ["param1": 5]))

        let jsonStr = """
        {
            "script" : {
                "script" : {
                    "source" : "doc['num1'].value > params.param1",
                    "lang"   : "painless",
                    "params" : {
                        "param1" : 5
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(ScriptQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_11_percolateQuery_encode() throws {
        let query = PercolateQuery("query", documents: ["message": "A new bonsai tree in the office"])

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "percolate" : {
                "field" : "query",
                "document" : {
                    "message" : "A new bonsai tree in the office"
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_12_percolateQuery_encode_2() throws {
        let query = PercolateQuery("query", documents: ["message": "bonsai tree"], ["message": "new tree"], ["message": "the office"], ["message": "office tree"])

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "percolate" : {
                "field" : "query",
                "documents" : [
                    {
                        "message" : "bonsai tree"
                    },
                    {
                        "message" : "new tree"
                    },
                    {
                        "message" : "the office"
                    },
                    {
                        "message" : "office tree"
                    }
                ]
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_13_percolateQuery_encode_3() throws {
        let query = PercolateQuery("query", index: "my-index", type: "_doc", id: "2", version: 1)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "percolate" : {
                "field": "query",
                "index" : "my-index",
                "type" : "_doc",
                "id" : "2",
                "version" : 1
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_14_percolateQuery_decode() throws {
        let query = PercolateQuery("query", documents: ["message": "A new bonsai tree in the office"])

        let jsonStr = """
        {
            "percolate" : {
                "field" : "query",
                "document" : {
                    "message" : "A new bonsai tree in the office"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(PercolateQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_15_percolateQuery_decode_2() throws {
        let query = PercolateQuery("query", documents: ["message": "bonsai tree"], ["message": "new tree"], ["message": "the office"], ["message": "office tree"])

        let jsonStr = """
        {
            "percolate" : {
                "field" : "query",
                "documents" : [
                    {
                        "message" : "bonsai tree"
                    },
                    {
                        "message" : "new tree"
                    },
                    {
                        "message" : "the office"
                    },
                    {
                        "message" : "office tree"
                    }
                ]
            }
        }
        """

        let decoded = try JSONDecoder().decode(PercolateQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_16_percolateQuery_decode_3() throws {
        let query = PercolateQuery("query", index: "my-index", type: "_doc", id: "2", version: 1)

        let jsonStr = """
        {
            "percolate" : {
                "field": "query",
                "index" : "my-index",
                "type" : "_doc",
                "id" : "2",
                "version" : 1
            }
        }
        """

        let decoded = try JSONDecoder().decode(PercolateQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_17_wrapperQuery_encode() throws {
        let query = WrapperQuery("eyJ0ZXJtIiA6IHsgInVzZXIiIDogIktpbWNoeSIgfX0=")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "wrapper": {
                "query" : "eyJ0ZXJtIiA6IHsgInVzZXIiIDogIktpbWNoeSIgfX0="
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_18_wrapperQuery_decode() throws {
        let query = WrapperQuery("eyJ0ZXJtIiA6IHsgInVzZXIiIDogIktpbWNoeSIgfX0=")

        let jsonStr = """
        {
            "wrapper": {
                "query" : "eyJ0ZXJtIiA6IHsgInVzZXIiIDogIktpbWNoeSIgfX0="
            }
        }
        """

        let decoded = try JSONDecoder().decode(WrapperQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
