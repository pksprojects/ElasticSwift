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
    
    func test_12_moreLikeThisQueryBuilder() throws {
        XCTAssertNoThrow(try HighlightBuilder().set(fields: [.init("Field1")]).add(field: .init("field2")).build(), "Should not throw")
    }

    func test_13_moreLikeThisQueryBuilder_missing_like() throws {
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

    func test_14_moreLikeThisQueryBuilder() throws {
        let hightlight = try HighlightBuilder()
            .add(field: .init("field2"))
            .set(fields: [.init("Field1")])
            .set(globalOptions: .init())
            .build()
        XCTAssertEqual(hightlight.fields, [.init("Field1")])
        XCTAssertEqual(hightlight.globalOptions, .init())
    }
}
