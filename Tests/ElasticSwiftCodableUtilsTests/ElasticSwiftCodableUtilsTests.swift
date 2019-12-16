//
//  ElasticSwiftCodableUtilsTests.swift
//  ElasticSwiftCodableUtilsTests
//
//
//  Created by Prafull Kumar Soni on 9/15/19.
//

import XCTest
import Logging
import UnitTestSettings

@testable import ElasticSwiftCodableUtils

class ElasticSwiftCodableUtilsTests: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftCodableUtilsTests.CodableUtilsTests", factory: logFactory)
    
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
    
    func test_01_CodableValue_decode() throws {
        let json = """
        {
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            }
        }
        """.data(using: .utf8)!
        
        let dictionary = try JSONDecoder().decode([String: CodableValue].self, from: json)

        XCTAssertEqual(dictionary["boolean"]?.value as! Bool, true)
        XCTAssertEqual(dictionary["integer"]?.value as! Int, 1)
        XCTAssertEqual(dictionary["double"]?.value as! Double, 3.14159265358979323846, accuracy: 0.001)
        XCTAssertEqual(dictionary["string"]?.value as! String, "string")
        XCTAssertEqual(dictionary["array"]?.value as! [Int], [1, 2, 3])
        XCTAssertEqual(dictionary["nested"]?.value as! [String: String], ["a": "alpha", "b": "bravo", "c": "charlie"])
    }
    
    func test_02_CodableValue_encode() throws {
        let dictionary: [String: CodableValue] = [
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": [
                "a": "alpha",
                "b": "bravo",
                "c": "charlie",
            ],
        ]
        
        let json = try JSONEncoder().encode(dictionary)
        let encodedJSON = try JSONDecoder().decode(CodableValue.self, from: json)

        let expected = """
        {
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            }
        }
        """.data(using: .utf8)!
        let expectedJSON = try JSONDecoder().decode(CodableValue.self, from: expected)

        XCTAssertEqual(encodedJSON, expectedJSON)
    }
    
    func test_03_DecodableValue_decode() throws {
        let json = """
        {
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            }
        }
        """.data(using: .utf8)!
        
        let dictionary = try JSONDecoder().decode([String: DecodableValue].self, from: json)

        XCTAssertEqual(dictionary["boolean"]?.value as! Bool, true)
        XCTAssertEqual(dictionary["integer"]?.value as! Int, 1)
        XCTAssertEqual(dictionary["double"]?.value as! Double, 3.14159265358979323846, accuracy: 0.001)
        XCTAssertEqual(dictionary["string"]?.value as! String, "string")
        XCTAssertEqual(dictionary["array"]?.value as! [Int], [1, 2, 3])
        XCTAssertEqual(dictionary["nested"]?.value as! [String: String], ["a": "alpha", "b": "bravo", "c": "charlie"])
    }
    
    func test_04_EncodableValue_encode() throws {
        let dictionary: [String: EncodableValue] = [
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": [
                "a": "alpha",
                "b": "bravo",
                "c": "charlie",
            ],
        ]
        
        let json = try JSONEncoder().encode(dictionary)
        let encodedJSON = try JSONDecoder().decode(DecodableValue.self, from: json)

        let expected = """
        {
            "boolean": true,
            "integer": 1,
            "double": 3.14159265358979323846,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            }
        }
        """.data(using: .utf8)!
        let expectedJSON = try JSONDecoder().decode(DecodableValue.self, from: expected)

        XCTAssertEqual(encodedJSON, expectedJSON)
    }
    
    func test_05_CodableValue_decode() throws {
        let json = """
        {
            "nilVal": null
        }
        """.data(using: .utf8)!
        
        let expectdNil = try JSONDecoder().decode([String: CodableValue].self, from: json)
        
        expectdNil.forEach { k, v in
            print("Key: ", k)
            print("Value: ", v)
        }
        
        XCTAssertEqual(expectdNil["nilVal"]!.value as! NilValue, .nil)
    }
    
    func test_06_CodableValue_decode() throws {
        let json = """
        {
            "nilVal": null
        }
        """.data(using: .utf8)!
        
        let expectdNil = try JSONDecoder().decode([String: CodableValue?].self, from: json)
        
        XCTAssertEqual(expectdNil["nilVal"]!, nil)
    }
    
    func test_07_EncodableValue_encode() throws {
        let dictionary: [String: DecodableValue] = [
            "boolean": true,
            "integer": 1,
            "string": "string",
            "array": [1, 2, 3],
            "nested": [
                "a": "alpha",
                "b": "bravo",
                "c": "charlie",
                "d": nil
            ],
        ]

        let expected = """
        {
            "boolean": true,
            "integer": 1,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie",
                "d": null
            }
        }
        """.data(using: .utf8)!
        let expectedJSON = try JSONDecoder().decode([String: DecodableValue].self, from: expected)

        XCTAssertEqual(dictionary, expectedJSON)
    }
}
