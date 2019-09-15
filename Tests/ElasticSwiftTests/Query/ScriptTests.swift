//
//  ScriptTests.swift
//  ElasticSwiftTests
//
//  Created by Prafull Kumar Soni on 9/2/19.
//

import XCTest
import Logging

@testable import ElasticSwift
@testable import ElasticSwiftQueryDSL
@testable import ElasticSwiftCodableUtils

class ScriptTests: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.QueryDSL.ScriptTests")
    
    func testScript_encode_short() throws {
        
        let script = Script("ctx._source.likes++")
        
        let dic = ["script": script]
        
        let encoded = try JSONEncoder().encode(dic)
        
        let encodedStr = String(data: encoded, encoding: .utf8)!
        
        logger.debug("Script Encode test: \(encodedStr)")
        
        let decodedDic = try JSONDecoder().decode([String: CodableValue].self, from: encoded)
        
        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"script\":\"ctx._source.likes++\"}".data(using: .utf8)!)
        
        XCTAssertEqual(expectedDic, decodedDic)
    }
    
    func testScript_decode_short() throws {
        
        let jsonStr = "{\"script\":\"ctx._source.likes++\"}"
        
        let decoded = try JSONDecoder().decode(Dictionary<String, Script>.self, from: jsonStr.data(using: .utf8)!)
        
        logger.debug("Script Decode test: \(decoded)")
        
        XCTAssertEqual("ctx._source.likes++", decoded["script"]!.source)
    }
    
    func testScript_encode() throws {
        
        let script = Script("doc['my_field'] * multiplier", lang: "expression", params: ["multiplier": 2])
        
        let encoded = try JSONEncoder().encode(script)
        
        let encodedStr = String(data: encoded, encoding: .utf8)!
        
        logger.debug("Script Encode test: \(encodedStr)")
        
        let decodedDic = try JSONDecoder().decode([String: CodableValue].self, from: encoded)
        
        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"lang\":\"expression\",\"params\":{\"multiplier\":2},\"source\":\"doc['my_field'] * multiplier\"}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, decodedDic)
    }
    
    func testScript_decode() throws {
        
        let jsonStr = "{\"lang\":\"expression\",\"source\":\"doc['my_field'] * multiplier\",\"params\":{\"multiplier\": 2}}"
        
        let decoded = try JSONDecoder().decode(Script.self, from: jsonStr.data(using: .utf8)!)
        
        logger.debug("Script Decode test: \(decoded)")
        
        XCTAssertEqual("doc['my_field'] * multiplier", decoded.source)
        XCTAssertEqual(2, decoded.params!["multiplier"]!)
        XCTAssertEqual("expression", decoded.lang!)
    }
    
}
