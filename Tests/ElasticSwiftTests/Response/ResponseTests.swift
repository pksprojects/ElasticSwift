//
//  ResponseTests.swift
//  ElasticSwiftTests
//
//  Created by Prafull Kumar Soni on 12/24/19.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore

class ResponseTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Response.ResponseTests", factory: logFactory)

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

    func test_01_search_response_decode() throws {
        let serializer = DefaultSerializer()

        let data =
            """
            {
              "took" : 4,
              "timed_out" : false,
              "_shards" : {
                "total" : 63,
                "successful" : 63,
                "skipped" : 0,
                "failed" : 0
              },
              "hits" : {
                "total" : 1,
                "max_score" : 0.2876821,
                "hits" : [
                  {
                    "_index" : "test",
                    "_type" : "_doc",
                    "_id" : "1",
                    "_score" : 0.2876821,
                    "_source" : {
                      "title" : "Test title",
                      "content" : "Some test content kimchy",
                      "comments" : [
                        {
                          "author" : "kimchy",
                          "text" : "comment text",
                          "votes" : [ ]
                        },
                        {
                          "author" : "nik9000",
                          "text" : "words words words",
                          "votes" : [
                            {
                              "value" : 1,
                              "voter" : "kimchy"
                            },
                            {
                              "value" : -1,
                              "voter" : "other"
                            }
                          ]
                        }
                      ]
                    },
                    "highlight" : {
                      "content" : [
                        "Some test content <em>kimchy</em>"
                      ]
                    }
                  }
                ]
              }
            }
            """.data(using: .utf8)

        let result: Result<SearchResponse<CodableValue>, DecodingError> = serializer.decode(data: data!)

        switch result {
        case let .success(resposne):
            logger.info("Decoded: \(resposne)")
            XCTAssertNotNil(resposne.hits.hits[0].highlightFields)
        case let .failure(error):
            logger.info("Unexpected Error: \(error.localizedDescription)")
            XCTAssert(false, "Encoding Failed!")
        }
    }

    func test_02_search_response_encode() throws {
        let serializer = DefaultSerializer()

        let hit = SearchHit(index: "test", type: "_doc", id: "1", score: 0.2876821, source: ["test": "test"], sort: nil, version: nil, seqNo: nil, primaryTerm: nil, fields: nil, explanation: nil, matchedQueries: nil, innerHits: nil, node: nil, shard: nil, highlightFields: ["content": .init(name: "content", fragments: ["test"])], nested: nil)
        let searchResponse = SearchResponse(took: 1, timedOut: false, shards: .init(total: 1, successful: 1, skipped: 0, failed: 0, failures: nil), hits: .init(total: 1, maxScore: 1.0, hits: [hit]), scrollId: nil, profile: nil, suggest: nil)

        let result: Result<Data, EncodingError> = serializer.encode(searchResponse)

        switch result {
        case let .success(resposne):
            let encodeStr = String(data: resposne, encoding: .utf8)
            XCTAssertNotNil(encodeStr)
            logger.info("Encoded: \(encodeStr!)")
            let decodeResult: Result<SearchResponse<[String: String]>, DecodingError> = serializer.decode(data: resposne)
            switch decodeResult {
            case let .success(decoded):
                XCTAssertTrue(searchResponse == decoded)
            case let .failure(error):
                logger.info("Unexpected Error: \(error)")
                XCTAssert(false, "Decoding Failed!")
            }
        case let .failure(error):
            logger.info("Unexpected Error: \(error)")
            XCTAssert(false, "Encoding Failed!")
        }
    }

    func test_03_search_response_decode_inner_hits() throws {
        let serializer = DefaultSerializer()

        let data =
            """
            {
              "took" : 1,
              "timed_out" : false,
              "_shards" : {
                "total" : 5,
                "successful" : 5,
                "skipped" : 0,
                "failed" : 0
              },
              "hits" : {
                "total" : 1,
                "max_score" : 0.6931472,
                "hits" : [
                  {
                    "_shard" : "[test][3]",
                    "_node" : "tfhe9abbSBy2bxQcrRqspw",
                    "_index" : "test",
                    "_type" : "_doc",
                    "_id" : "1",
                    "_score" : 0.6931472,
                    "fields" : {
                        "test1" : [
                          "null"
                        ],
                        "test2" : [
                          80
                        ]
                    },
                    "_source" : {
                      "title" : "Test title",
                      "content" : "Some test content kimchy",
                      "comments" : [
                        {
                          "author" : "kimchy",
                          "text" : "comment text",
                          "votes" : [ ]
                        },
                        {
                          "author" : "nik9000",
                          "text" : "words words words",
                          "votes" : [
                            {
                              "value" : 1,
                              "voter" : "kimchy"
                            },
                            {
                              "value" : -1,
                              "voter" : "other"
                            }
                          ]
                        }
                      ]
                    },
                    "_explanation" : {
                      "value" : 0.6931472,
                      "description" : "Score based on 1 child docs in range from 0 to 3, best match:",
                      "details" : [
                        {
                          "value" : 0.6931472,
                          "description" : "weight(comments.votes.voter:kimchy in 1) [PerFieldSimilarity], result of:",
                          "details" : [
                            {
                              "value" : 0.6931472,
                              "description" : "score(doc=1,freq=1.0 = termFreq=1.0\\n), product of:",
                              "details" : [
                                {
                                  "value" : 0.6931472,
                                  "description" : "idf, computed as log(1 + (docCount - docFreq + 0.5) / (docFreq + 0.5)) from:",
                                  "details" : [
                                    {
                                      "value" : 1.0,
                                      "description" : "docFreq",
                                      "details" : [ ]
                                    },
                                    {
                                      "value" : 2.0,
                                      "description" : "docCount",
                                      "details" : [ ]
                                    }
                                  ]
                                },
                                {
                                  "value" : 1.0,
                                  "description" : "tfNorm, computed as (freq * (k1 + 1)) / (freq + k1 * (1 - b + b * fieldLength / avgFieldLength)) from:",
                                  "details" : [
                                    {
                                      "value" : 1.0,
                                      "description" : "termFreq=1.0",
                                      "details" : [ ]
                                    },
                                    {
                                      "value" : 1.2,
                                      "description" : "parameter k1",
                                      "details" : [ ]
                                    },
                                    {
                                      "value" : 0.75,
                                      "description" : "parameter b",
                                      "details" : [ ]
                                    },
                                    {
                                      "value" : 1.0,
                                      "description" : "avgFieldLength",
                                      "details" : [ ]
                                    },
                                    {
                                      "value" : 1.0,
                                      "description" : "fieldLength",
                                      "details" : [ ]
                                    }
                                  ]
                                }
                              ]
                            }
                          ]
                        }
                      ]
                    },
                    "inner_hits" : {
                      "comments.votes" : {
                        "hits" : {
                          "total" : 1,
                          "max_score" : 0.6931472,
                          "hits" : [
                            {
                              "_index" : "test",
                              "_type" : "_doc",
                              "_id" : "1",
                              "_nested" : {
                                "field" : "comments",
                                "offset" : 1,
                                "_nested" : {
                                  "field" : "votes",
                                  "offset" : 0
                                }
                              },
                              "_score" : 0.6931472,
                              "_source" : {
                                "value" : 1,
                                "voter" : "kimchy"
                              }
                            }
                          ]
                        }
                      }
                    }
                  }
                ]
              }
            }
            """.data(using: .utf8)

        let result: Result<SearchResponse<CodableValue>, DecodingError> = serializer.decode(data: data!)

        switch result {
        case let .success(response):
            logger.info("Decoded: \(response)")
            XCTAssertNotNil(response.hits.hits[0].fields)
            XCTAssertNotNil(response.hits.hits[0].innerHits)
            XCTAssertNotNil(response.hits.hits[0].innerHits!["comments.votes"]!.hits[0].nested)
            XCTAssertNotNil(response.hits.hits[0].searchSearchTarget)
            XCTAssertNotNil(response.hits.hits[0].explanation)
        case let .failure(error):
            logger.info("Unexpected Error: \(error)")
            XCTAssert(false, "Encoding Failed!")
        }
    }

    func test_04_search_response_encode_inner_hits() throws {
        let serializer = DefaultSerializer()

        let hit = SearchHit(index: "test", type: "_doc", id: "1", score: 0.2876821, source: ["test": "test"], sort: nil, version: nil, seqNo: nil, primaryTerm: nil, fields: ["test1": .init(name: "test1", values: ["value"])], explanation: nil, matchedQueries: nil, innerHits: ["comments.votes": .init(total: 0, maxScore: 0, hits: [])], node: nil, shard: nil, highlightFields: nil, nested: .init(field: "comments", offset: 1, nested: .init(field: "votes", offset: 0, nested: nil)))
        let searchResponse = SearchResponse(took: 1, timedOut: false, shards: .init(total: 1, successful: 1, skipped: 0, failed: 0, failures: nil), hits: .init(total: 1, maxScore: 1.0, hits: [hit]), scrollId: nil, profile: nil, suggest: nil)

        let result: Result<Data, EncodingError> = serializer.encode(searchResponse)

        switch result {
        case let .success(resposne):
            let encodeStr = String(data: resposne, encoding: .utf8)
            XCTAssertNotNil(encodeStr)
            logger.info("Encoded: \(encodeStr!)")
            let decodeResult: Result<SearchResponse<[String: String]>, DecodingError> = serializer.decode(data: resposne)
            switch decodeResult {
            case let .success(decoded):
                XCTAssertTrue(searchResponse == decoded)
            case let .failure(error):
                logger.info("Unexpected Error: \(error)")
                XCTAssert(false, "Decoding Failed!")
            }
        case let .failure(error):
            logger.info("Unexpected Error: \(error)")
            XCTAssert(false, "Encoding Failed!")
        }
    }

    func test_05_field_capabilities_response_decode() throws {
        let serializer = DefaultSerializer()
        let data = """
        {
            "fields": {
                "rating": {
                    "long": {
                        "searchable": true,
                        "aggregatable": false,
                        "indices": ["index1", "index2"],
                        "non_aggregatable_indices": ["index1"]
                    },
                    "keyword": {
                        "searchable": false,
                        "aggregatable": true,
                        "indices": ["index3", "index4"],
                        "non_searchable_indices": ["index4"]
                    }
                },
                "title": {
                    "text": {
                        "searchable": true,
                        "aggregatable": false

                    }
                }
            }
        }
        """.data(using: .utf8)

        let result: Result<FieldCapabilitiesResponse, DecodingError> = serializer.decode(data: data!)

        switch result {
        case let .success(response):
            logger.info("Decoded: \(response)")
            XCTAssertNotNil(response.fields)
            XCTAssertNotNil(response.fields["rating"])
            XCTAssertNotNil(response.fields["title"])
            XCTAssertNotNil(response.fields["rating"]!["long"])
            XCTAssertTrue(response.fields["rating"]!["long"] == FieldCapabilities(name: "rating", type: "long", isSearchable: true, isAggregatable: false, indices: ["index1", "index2"], nonSearchableIndices: nil, nonAggregatableIndicies: ["index1"]))
            XCTAssertNotNil(response.fields["rating"]!["keyword"])
            XCTAssertTrue(response.fields["rating"]!["keyword"] == FieldCapabilities(name: "rating", type: "keyword", isSearchable: false, isAggregatable: true, indices: ["index3", "index4"], nonSearchableIndices: ["index4"], nonAggregatableIndicies: nil))
            XCTAssertNotNil(response.fields["title"]!["text"])
            XCTAssertTrue(response.fields["title"]!["text"] == FieldCapabilities(name: "title", type: "text", isSearchable: true, isAggregatable: false, indices: nil, nonSearchableIndices: nil, nonAggregatableIndicies: nil))
        case let .failure(error):
            logger.info("Unexpected Error: \(error)")
            XCTAssert(false, "Encoding Failed!")
        }
    }

    func test_06_field_capabilities_response_encode() throws {
        let serializer = DefaultSerializer()

        let fieldCapsResponse = FieldCapabilitiesResponse(fields: [
            "rating": [
                "long": FieldCapabilities(name: "rating", type: "long", isSearchable: true, isAggregatable: false, indices: ["index1", "index2"], nonSearchableIndices: nil, nonAggregatableIndicies: ["index1"]),
                "keyword": FieldCapabilities(name: "rating", type: "keyword", isSearchable: false, isAggregatable: true, indices: ["index3", "index4"], nonSearchableIndices: ["index4"], nonAggregatableIndicies: nil),
            ],
            "title": [
                "text": FieldCapabilities(name: "title", type: "text", isSearchable: true, isAggregatable: false, indices: nil, nonSearchableIndices: nil, nonAggregatableIndicies: nil),
            ],
        ])

        let data = """
        {
            "fields": {
                "rating": {
                    "long": {
                        "type": "long",
                        "searchable": true,
                        "aggregatable": false,
                        "indices": ["index1", "index2"],
                        "non_aggregatable_indices": ["index1"]
                    },
                    "keyword": {
                        "type": "keyword",
                        "searchable": false,
                        "aggregatable": true,
                        "indices": ["index3", "index4"],
                        "non_searchable_indices": ["index4"]
                    }
                },
                "title": {
                    "text": {
                        "type": "text",
                        "searchable": true,
                        "aggregatable": false

                    }
                }
            }
        }
        """.data(using: .utf8)

        let result = serializer.encode(fieldCapsResponse)

        let expectedResult: Result<CodableValue, DecodingError> = serializer.decode(data: data!)

        switch result {
        case let .success(response):
            let encodeStr = String(data: response, encoding: .utf8)
            XCTAssertNotNil(encodeStr)
            logger.info("Encoded: \(encodeStr!)")
            let decodeResult: Result<CodableValue, DecodingError> = serializer.decode(data: response)
            switch decodeResult {
            case let .success(decoded):
                switch expectedResult {
                case let .success(expected):
                    XCTAssertTrue(expected == decoded)
                case let .failure(error):
                    logger.info("Unexpected Error: \(error)")
                    XCTAssert(false, "Expected result Decoding Failed!")
                }
            case let .failure(error):
                logger.info("Unexpected Error: \(error)")
                XCTAssert(false, "Decoding Failed!")
            }
        case let .failure(error):
            logger.info("Unexpected Error: \(error)")
            XCTAssert(false, "Encoding Failed!")
        }
    }
}
