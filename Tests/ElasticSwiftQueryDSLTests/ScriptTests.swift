//
//  ScriptTests.swift
//  ElasticSwiftQueryDSLTests
//
//  Created by Prafull Kumar Soni on 9/2/19.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class ScriptTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.ScriptTests", factory: logFactory)

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

        let decoded = try JSONDecoder().decode([String: Script].self, from: jsonStr.data(using: .utf8)!)

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
