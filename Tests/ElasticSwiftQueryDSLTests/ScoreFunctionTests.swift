//
//  ScoreFunctionTests.swift
//  ElasticSwiftQueryDSLTests
//
//  Created by Prafull Kumar Soni on 9/2/19.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class ScoreFunctionTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.ScoreFunctionTests", factory: logFactory)

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

    func testWeightScoreFunction_encode() throws {
        let weightFunc = try WeightBuilder().set(weight: 11.234).build()

        let data = try JSONEncoder().encode(weightFunc)

        let dataStr = String(data: data, encoding: .utf8)!

        logger.debug("WeightScoreFunction Encode test: \(dataStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"weight\":11.234}".data(using: .utf8)!)

        XCTAssertEqual(expectedDic, dic)
    }

    func testWeightScoreFunction_decode() throws {
        let weightFunc = WeightScoreFunction(11.234)

        let jsonStr = "{\"weight\":11.234}"

        let decoded = try JSONDecoder().decode(WeightScoreFunction.self, from: jsonStr.data(using: .utf8)!)

        logger.debug("WeightScoreFunction Decode test: \(decoded)")

        XCTAssertEqual(weightFunc.weight, decoded.weight)
    }

    func testRandomScoreFunction_encode() throws {
        let ranFunc = try RandomScoreFunctionBuilder()
            .set(field: "_seq_no")
            .set(seed: 10)
            .build()

        let data = try JSONEncoder().encode(ranFunc)

        let dataStr = String(data: data, encoding: .utf8)!

        logger.debug("RandomScoreFunction Encode test: \(dataStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"random_score\":{\"seed\":10,\"field\":\"_seq_no\"}}".data(using: .utf8)!)

        XCTAssertEqual(expectedDic, dic)
    }

    func testRandomScoreFunction_decode() throws {
        let ranFunc = RandomScoreFunction(field: "_seq_no", seed: 10)

        let jsonStr = "{\"random_score\":{\"seed\":10,\"field\":\"_seq_no\"}}"

        let decoded = try JSONDecoder().decode(RandomScoreFunction.self, from: jsonStr.data(using: .utf8)!)

        logger.debug("RandomScoreFunction Decode test: \(decoded)")

        XCTAssertEqual(ranFunc.seed, decoded.seed)
        XCTAssertEqual(ranFunc.field, decoded.field)
    }

    func testScriptScoreFunction_encode() throws {
        let script = Script("Math.log(2 + doc['likes'].value)")

        let ranFunc = try ScriptScoreFunctionBuilder()
            .set(script: script)
            .build()

        let data = try JSONEncoder().encode(ranFunc)

        let dataStr = String(data: data, encoding: .utf8)!

        logger.debug("ScriptScoreFunction Encode test: \(dataStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"script_score\":{\"script\":\"Math.log(2 + doc['likes'].value)\"}}".data(using: .utf8)!)

        XCTAssertEqual(expectedDic, dic)
    }

    func testScriptScoreFunction_decode() throws {
        let scriptFunc = ScriptScoreFunction(source: "Math.log(2 + doc['likes'].value)")

        let jsonStr = "{\"script_score\":{\"script\":{\"source\":\"Math.log(2 + doc['likes'].value)\"}}}"

        let decoded = try JSONDecoder().decode(ScriptScoreFunction.self, from: jsonStr.data(using: .utf8)!)

        logger.debug("ScriptScoreFunction Decode test: \(decoded)")

        XCTAssertEqual(scriptFunc.script.source, decoded.script.source)
    }

    func testFieldValueFactorScoreFunction_encode() throws {
        let fvfFunc = try FieldValueFactorFunctionBuilder()
            .set(field: "likes")
            .set(factor: 1.2)
            .set(modifier: .sqrt)
            .set(missing: 1)
            .build()

        let data = try JSONEncoder().encode(fvfFunc)

        let dataStr = String(data: data, encoding: .utf8)!

        logger.debug("FieldValueFactorScoreFunction Encode test: \(dataStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"field_value_factor\":{\"missing\":1,\"factor\":1.2,\"field\":\"likes\",\"modifier\":\"sqrt\"}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func testFieldValueFactorScoreFunction_decode() throws {
        let fvfFunc = FieldValueFactorScoreFunction(field: "likes", factor: 1.2, modifier: .sqrt, missing: 1)

        let jsonStr = "{\"field_value_factor\":{\"missing\":1,\"factor\":1.2,\"field\":\"likes\",\"modifier\":\"sqrt\"}}"

        let decoded = try JSONDecoder().decode(FieldValueFactorScoreFunction.self, from: jsonStr.data(using: .utf8)!)

        logger.debug("FieldValueFactorScoreFunction Decode test: \(decoded)")

        XCTAssertEqual(fvfFunc.field, decoded.field)
        XCTAssertEqual(fvfFunc.factor, decoded.factor)
        XCTAssertEqual(fvfFunc.modifier, decoded.modifier)
        XCTAssertEqual(fvfFunc.missing, decoded.missing)
    }

    func testLinearDecayScoreFunction_encode() throws {
        let linear = try LinearDecayFunctionBuilder()
            .set(field: "date")
            .set(origin: "2013-09-17")
            .set(scale: "10d")
            .set(offset: "5d")
            .set(decay: 0.5)
            .build()

        let data = try JSONEncoder().encode(linear)

        let dataStr = String(data: data, encoding: .utf8)!

        logger.debug("LinearDecayScoreFunction Encode test: \(dataStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"linear\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func testLinearDecayScoreFunction_decode() throws {
        let decayFunc = DecayScoreFunction(type: .linear, field: "date", origin: "2013-09-17", scale: "10d", offset: "5d", decay: 0.5, multiValueMode: nil)

        let jsonStr = "{\"linear\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}"

        let decoded = try JSONDecoder().decode(LinearDecayScoreFunction.self, from: jsonStr.data(using: .utf8)!)

        logger.debug("LinearDecayScoreFunction Decode test: \(decoded)")

        XCTAssertEqual(decayFunc.scoreFunctionType, decoded.scoreFunctionType)
        XCTAssertEqual(decayFunc.field, decoded.field)
        XCTAssertEqual(decayFunc.origin, decoded.origin)
        XCTAssertEqual(decayFunc.scale, decoded.scale)
        XCTAssertEqual(decayFunc.offset, decoded.offset)
        XCTAssertEqual(decayFunc.decay, decoded.decay)
    }

    func testGaussDecayScoreFunction_encode() throws {
        let linear = try GaussDecayFunctionBuilder()
            .set(field: "date")
            .set(origin: "2013-09-17")
            .set(scale: "10d")
            .set(offset: "5d")
            .set(decay: 0.5)
            .build()

        let data = try JSONEncoder().encode(linear)

        let dataStr = String(data: data, encoding: .utf8)!

        logger.debug("GaussScoreFunction Encode test: \(dataStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"gauss\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func testGaussDecayScoreFunction_decode() throws {
        let decayFunc = DecayScoreFunction(type: .gauss, field: "date", origin: "2013-09-17", scale: "10d", offset: "5d", decay: 0.5, multiValueMode: nil)

        let jsonStr = "{\"gauss\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}"

        let decoded = try JSONDecoder().decode(GaussScoreFunction.self, from: jsonStr.data(using: .utf8)!)

        logger.debug("GaussScoreFunction Decode test: \(decoded)")

        XCTAssertEqual(decayFunc.scoreFunctionType, decoded.scoreFunctionType)
        XCTAssertEqual(decayFunc.field, decoded.field)
        XCTAssertEqual(decayFunc.origin, decoded.origin)
        XCTAssertEqual(decayFunc.scale, decoded.scale)
        XCTAssertEqual(decayFunc.offset, decoded.offset)
        XCTAssertEqual(decayFunc.decay, decoded.decay)
    }

    func testExponentialDecayScoreFunction_encode() throws {
        let linear = try ExponentialDecayFunctionBuilder()
            .set(field: "date")
            .set(origin: "2013-09-17")
            .set(scale: "10d")
            .set(offset: "5d")
            .set(decay: 0.5)
            .build()

        let data = try JSONEncoder().encode(linear)

        let dataStr = String(data: data, encoding: .utf8)!

        logger.debug("ExponentialDecayScoreFunction Encode test: \(dataStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"exp\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func testExponentialDecayScoreFunction_decode() throws {
        let decayFunc = DecayScoreFunction(type: .exp, field: "date", origin: "2013-09-17", scale: "10d", offset: "5d", decay: 0.5, multiValueMode: nil)

        let jsonStr = "{\"exp\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}"

        let decoded = try JSONDecoder().decode(ExponentialDecayScoreFunction.self, from: jsonStr.data(using: .utf8)!)

        logger.debug("ExponentialDecayScoreFunction Decode test: \(decoded)")

        XCTAssertEqual(decayFunc.scoreFunctionType, decoded.scoreFunctionType)
        XCTAssertEqual(decayFunc.field, decoded.field)
        XCTAssertEqual(decayFunc.origin, decoded.origin)
        XCTAssertEqual(decayFunc.scale, decoded.scale)
        XCTAssertEqual(decayFunc.offset, decoded.offset)
        XCTAssertEqual(decayFunc.decay, decoded.decay)
    }
}
