//
//  InnertHitsTests.swift
//  
//
//  Created by Prafull Kumar Soni on 8/1/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class InnertHitsTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.InnertHitsTests", factory: logFactory)

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
    
    func test_01_innertHits_encode() throws {
        let innerHit = InnerHit(sourceFilter: .fetchSource(false), docvalueFields: [.init(field: "comments.text.keyword", format: "use_field_mapping")])
        let expectedJson =
        """
            {
              "_source" : false,
              "docvalue_fields" : [
                {
                  "field": "comments.text.keyword",
                  "format": "use_field_mapping"
                }
              ]
            }
        """
        
        let data = try! JSONEncoder().encode(innerHit)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: expectedJson.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_02_innerHits_decode() throws {
        let innerHit = InnerHit(sourceFilter: .fetchSource(false), docvalueFields: [.init(field: "comments.text.keyword", format: "use_field_mapping")])
        let jsonStr =
        """
            {
              "_source" : false,
              "docvalue_fields" : [
                {
                  "field": "comments.text.keyword",
                  "format": "use_field_mapping"
                }
              ]
            }
        """

        let decoded = try! JSONDecoder().decode(InnerHit.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(innerHit, decoded)
    }
    
    func test_03_innertHits_encode_2() throws {
        let innerHit = InnerHit(sourceFilter: .fetchSource(false), scriptFields: [.init(field: "test1", script: .init("params['_source']['message']"))])
        let expectedJson =
        """
            {
              "_source" : false,
              "script_fields" : {
                  "test1" : {
                      "script" : "params['_source']['message']"
                  }
              }
            }
        """
        
        let data = try! JSONEncoder().encode(innerHit)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: expectedJson.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_04_innerHits_decode_2() throws {
        let innerHit = InnerHit(sourceFilter: .fetchSource(false), scriptFields: [.init(field: "test1", script: .init("params['_source']['message']"))])
        let jsonStr =
        """
            {
              "_source" : false,
              "script_fields" : {
                  "test1" : {
                      "script" : "params['_source']['message']"
                  }
              }
            }
        """

        let decoded = try! JSONDecoder().decode(InnerHit.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(innerHit, decoded)
    }
    
    func test_05_innertHits_encode_3() throws {
        let innerHit = InnerHit(sourceFilter: .fetchSource(false), scriptFields: [
            .init(field: "test1", script: .init("doc['price'].value * 2", lang: "painless", params: nil)),
            .init(field: "test2", script: .init("doc['price'].value * params.factor", lang: "painless", params: ["factor"  : 2]))
        ])
        let expectedJson =
        """
            {
              "_source" : false,
              "script_fields" : {
                  "test1" : {
                      "script" : {
                          "lang": "painless",
                          "source": "doc['price'].value * 2"
                      }
                  },
                  "test2" : {
                      "script" : {
                          "lang": "painless",
                          "source": "doc['price'].value * params.factor",
                          "params" : {
                              "factor"  : 2.0
                          }
                      }
                  }
              }
            }
        """
        
        let data = try! JSONEncoder().encode(innerHit)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: expectedJson.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_05_innerHits_decode_3() throws {
        let innerHit = InnerHit(sourceFilter: .fetchSource(false), scriptFields: [
            .init(field: "test1", script: .init("doc['price'].value * 2", lang: "painless", params: nil)),
            .init(field: "test2", script: .init("doc['price'].value * params.factor", lang: "painless", params: ["factor"  : 2]))
        ])
        let jsonStr =
        """
            {
              "_source" : false,
              "script_fields" : {
                  "test1" : {
                      "script" : {
                          "lang": "painless",
                          "source": "doc['price'].value * 2"
                      }
                  },
                  "test2" : {
                      "script" : {
                          "lang": "painless",
                          "source": "doc['price'].value * params.factor",
                          "params" : {
                              "factor"  : 2
                          }
                      }
                  }
              }
            }
        """

        let decoded = try! JSONDecoder().decode(InnerHit.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(innerHit.sourceFilter, decoded.sourceFilter)
        XCTAssertTrue(innerHit.scriptFields!.map( { decoded.scriptFields!.contains($0) } ).reduce(true, {a, b in a && b}))
    }
    
    func test_06_sourceFilter_encode() throws {
        let innerHit = InnerHit(sourceFilter: .filter("field"))
        let expectedJson =
        """
            {
              "_source" : "field"
            }
        """
        
        let data = try! JSONEncoder().encode(innerHit)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: expectedJson.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_07_sourceFilter_decode() throws {
        let innerHit = InnerHit(sourceFilter: .filter("field"))
        let jsonStr =
        """
            {
              "_source" : "field"
            }
        """

        let decoded = try! JSONDecoder().decode(InnerHit.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(innerHit, decoded)
    }
    
    func test_08_sourceFilter_encode_2() throws {
        let innerHit = InnerHit(sourceFilter: .filters(["field", "field2"]))
        let expectedJson =
        """
            {
              "_source" : ["field", "field2"]
            }
        """
        
        let data = try! JSONEncoder().encode(innerHit)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: expectedJson.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_09_sourceFilter_decode_2() throws {
        let innerHit = InnerHit(sourceFilter: .filters(["field", "field2"]))
        let jsonStr =
        """
            {
              "_source" : ["field", "field2"]
            }
        """

        let decoded = try! JSONDecoder().decode(InnerHit.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(innerHit, decoded)
    }
    
    func test_10_sourceFilter_encode_3() throws {
        let innerHit = InnerHit(sourceFilter: .source(includes: ["field1"], excludes: ["field2"]))
        let expectedJson =
        """
            {
              "_source" : {
                "includes": ["field1"],
                "excludes": ["field2"]
               }
            }
        """
        
        let data = try! JSONEncoder().encode(innerHit)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: expectedJson.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_11_sourceFilter_decode_3() throws {
        let innerHit = InnerHit(sourceFilter: .source(includes: ["field1"], excludes: ["field2"]))
        let jsonStr =
        """
            {
               "_source" : {
                "includes": ["field1"],
                "excludes": ["field2"]
               }
            }
        """

        let decoded = try! JSONDecoder().decode(InnerHit.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(innerHit, decoded)
    }
    
    func test_12_highlightBuilder() throws {
        XCTAssertNoThrow(try HighlightBuilder().set(fields: [.init("Field1")]).add(field: .init("field2")).build(), "Should not throw")
    }

    func test_13_highlightBuilder_missing_fields() throws {
        XCTAssertThrowsError(try HighlightBuilder().set(globalOptions: .init()).build(), "Should throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? HighlightBuilderError {
                switch error {
                case let .atlestOneElementRequired(field):
                    XCTAssertEqual("fields", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_14_highlightBuilder() throws {
        let hightlight = try HighlightBuilder()
            .add(field: .init("field2"))
            .set(fields: [.init("Field1")])
            .set(globalOptions: .init())
            .build()
        XCTAssertEqual(hightlight.fields, [.init("Field1")])
        XCTAssertEqual(hightlight.globalOptions, .init())
    }
    
    func test_15_fieldOptionsBuilder() throws {
        XCTAssertNoThrow(FieldOptionsBuilder().build())
    }
    
    func test_16_fieldOptionsBuilder() throws {
        let fieldOptions = FieldOptionsBuilder()
            .set(fragmenter: "fragmenter")
            .set(numberOfFragments: 3)
            .set(fragmentOffset: 1)
            .set(encoder: .default)
            .set(preTags: ["preTag1"])
            .set(postTags: ["postTag1"])
            .set(scoreOrdered: false)
            .set(requireFieldMatch: true)
            .set(highlighterType: .fvh)
            .set(forceSource: false)
            .set(fragmentSize: 2)
            .set(boundaryScannerType: .chars)
            .set(boundaryMaxScan: 1)
            .set(boundaryChars: ["|"])
            .set(boundaryScannerLocale: "locale")
            .set(highlightQuery: MatchAllQuery())
            .set(noMatchSize: 2)
            .set(matchedFields: ["field1"])
            .set(phraseLimit: 5)
            .set(tagScheme: "schema")
            .set(termVector: "vector")
            .set(indexOptions: "indexOptions")
            .build()
        XCTAssertEqual(fieldOptions.fragmenter, "fragmenter")
        XCTAssertEqual(fieldOptions.numberOfFragments, 3)
        XCTAssertEqual(fieldOptions.fragmentOffset, 1)
        XCTAssertEqual(fieldOptions.encoder, .default)
        XCTAssertEqual(fieldOptions.preTags, ["preTag1"])
        XCTAssertEqual(fieldOptions.postTags, ["postTag1"])
        XCTAssertEqual(fieldOptions.scoreOrdered, false)
        XCTAssertEqual(fieldOptions.requireFieldMatch, true)
        XCTAssertEqual(fieldOptions.highlighterType, .fvh)
        XCTAssertEqual(fieldOptions.forceSource, false)
        XCTAssertEqual(fieldOptions.fragmentSize, 2)
        XCTAssertEqual(fieldOptions.boundaryScannerType, .chars)
        XCTAssertEqual(fieldOptions.boundaryMaxScan, 1)
        XCTAssertEqual(fieldOptions.boundaryChars, ["|"])
        XCTAssertEqual(fieldOptions.boundaryScannerLocale, "locale")
        XCTAssertTrue(fieldOptions.highlightQuery!.isEqualTo(MatchAllQuery()))
        XCTAssertEqual(fieldOptions.noMatchSize, 2)
        XCTAssertEqual(fieldOptions.matchedFields, ["field1"])
        XCTAssertEqual(fieldOptions.phraseLimit, 5)
        XCTAssertEqual(fieldOptions.tagScheme, "schema")
        XCTAssertEqual(fieldOptions.termVector, "vector")
        XCTAssertEqual(fieldOptions.indexOptions, "indexOptions")
    }
    
    func test_17_highlight_decode() throws {
        let highlight = Highlight(fields: [.init("field")])
        let jsonStr =
        """
            {
               "fields" : [{
                    "field": {}
                }]
            }
        """

        let decoded = try! JSONDecoder().decode(Highlight.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(highlight, decoded)
    }
    
    func test_18_highlight_decode() throws {
        let highlight = Highlight(fields: [.init("field"), .init("field2")])
        let jsonStr =
        """
            {
               "fields" : {
                    "field": {},
                    "field2": {}
                }
            }
        """

        let decoded = try! JSONDecoder().decode(Highlight.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(highlight, decoded)
    }
    
    func test_19_filed_decode() throws {
        let field = Highlight.Field.init("field")
        let jsonStr =
        """
            {
               "field": {}
            }
        """

        let decoded = try! JSONDecoder().decode(Highlight.Field.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(field, decoded)
    }
    
    func test_20_filed_decode() throws {
        let fieldOptions = FieldOptionsBuilder()
            .set(fragmenter: "span")
            .set(numberOfFragments: 3)
            .set(fragmentOffset: 1)
            .set(encoder: .default)
            .set(preTags: ["preTag1"])
            .set(postTags: ["postTag1"])
            .set(scoreOrdered: true)
            .set(requireFieldMatch: true)
            .set(highlighterType: .fvh)
            .set(forceSource: false)
            .set(fragmentSize: 2)
            .set(boundaryScannerType: .chars)
            .set(boundaryMaxScan: 1)
            .set(boundaryChars: ["|"])
            .set(boundaryScannerLocale: "locale")
            .set(highlightQuery: MatchAllQuery())
            .set(noMatchSize: 2)
            .set(matchedFields: ["comment", "comment.plain"])
            .set(phraseLimit: 5)
            .set(tagScheme: "schema")
            .set(termVector: "with_positions_offsets")
            .set(indexOptions: "offsets")
            .build()
        let field = Highlight.Field("field", options: fieldOptions)
        let jsonStr =
        """
            {
               "field": {
                    "force_source": false,
                    "matched_fields": ["comment", "comment.plain"],
                    "type": "fvh",
                    "fragment_size" : 2,
                    "no_match_size": 2,
                    "index_options" : "offsets",
                    "term_vector" : "with_positions_offsets",
                    "number_of_fragments" : 3,
                    "fragmenter": "span",
                    "phrase_limit": 5,
                    "tag_schema": "schema",
                    "boundary_chars": ["|"],
                    "boundary_max_scan": 1,
                    "boundary_scanner": "chars",
                    "boundary_scanner_locale": "locale",
                    "fragment_offset": 1,
                    "encoder": "default",
                    "highlight_query": {
                        "match_all": {}
                    },
                    "order": "score",
                    "pre_tags": ["preTag1"],
                    "post_tags": ["postTag1"],
                    "tags_schema": "schema",
                    "require_field_match": true
               }
            }
        """

        let decoded = try! JSONDecoder().decode(Highlight.Field.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(field, decoded)
    }
}
