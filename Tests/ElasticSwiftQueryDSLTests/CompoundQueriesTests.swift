//
//  CompoundQuriesTests.swift
//  ElasticSwiftQueryDSLTests
//
//  Created by Prafull Kumar Soni on 9/2/19.
//

import XCTest
import Logging
import UnitTestSettings

@testable import ElasticSwiftQueryDSL
@testable import ElasticSwiftCodableUtils


class CompoundQueriesTest: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.CompoundQuriesTest", factory: logFactory)
    
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
    
    func testConstantScoreQuery_encode() throws {
        
        let query = ConstantScoreQuery(MatchAllQuery(), boost: 1.1)
        
        let data = try! JSONEncoder().encode(query)
        
        let encodedStr = String(data: data, encoding: .utf8)!
        
        logger.debug("Script Encode test: \(encodedStr)")
        
        let dic = try JSONDecoder().decode([String:CodableValue].self, from: data)
        
        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"constant_score\":{\"filter\":{\"match_all\":{}},\"boost\":1.1}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
        
    }
    
    func testConstantScoreQuery_decode() throws {
        
        let query = ConstantScoreQuery(MatchAllQuery(1.1), boost: 1.1)
        
        let jsonStr =  "{\"constant_score\":{\"filter\":{\"match_all\":{\"boost\":1.1}},\"boost\":1.1}}"
        
        let decoded = try! JSONDecoder().decode(ConstantScoreQuery.self, from: jsonStr.data(using: .utf8)!)
        
        XCTAssertEqual(query, decoded)
        
    }
    
    func testBoolQuery_encode() throws {
        let query = try BoolQueryBuilder()
            .filter(query: MatchAllQuery())
            .filter(query: MatchNoneQuery())
            .must(query: MatchAllQuery())
            .mustNot(query: MatchNoneQuery())
            .build()
        
        let data = try! JSONEncoder().encode(query)
        
        let encodedStr = String(data: data, encoding: .utf8)!
        
        logger.debug("Script Encode test: \(encodedStr)")
        
        let dic = try JSONDecoder().decode([String:CodableValue].self, from: data)
        
        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"bool\":{\"filter\":[{\"match_all\":{}},{\"match_none\":{}}],\"must\":[{\"match_all\":{}}],\"must_not\":[{\"match_none\":{}}]}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func testBoolQuery_decode() throws {
        
        let query = try BoolQueryBuilder()
            .filter(query: MatchAllQuery())
            .filter(query: MatchNoneQuery())
            .must(query: MatchAllQuery())
            .mustNot(query: MatchNoneQuery())
            .build()
        
        let jsonStr =  "{\"bool\":{\"filter\":[{\"match_all\":{}},{\"match_none\":{}}],\"must\":[{\"match_all\":{}}],\"must_not\":[{\"match_none\":{}}]}}"
        
        let decoded = try! JSONDecoder().decode(BoolQuery.self, from: jsonStr.data(using: .utf8)!)
        
        XCTAssertEqual(query, decoded)
        
    }
    
    func testFunctionScoreQuery_encode() throws {
        
        let scoreFunction =  try LinearDecayFunctionBuilder()
            .set(field: "date")
            .set(origin: "2013-09-17")
            .set(scale: "10d")
            .set(offset: "5d")
            .set(decay: 0.5)
            .build()
        
        let query = try FunctionScoreQueryBuilder()
            .set(query: MatchAllQuery())
            .add(function: scoreFunction)
            .build()
    
        let data = try! JSONEncoder().encode(query)
        
        let encodedStr = String(data: data, encoding: .utf8)!
        
        logger.debug("Script Encode test: \(encodedStr)")
        
        let dic = try JSONDecoder().decode([String:CodableValue].self, from: data)
        
        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"function_score\":{\"query\":{\"match_all\":{}},\"functions\":[{\"linear\":{\"date\":{\"decay\":0.5,\"offset\":\"5d\",\"origin\":\"2013-09-17\",\"scale\":\"10d\"}}}]}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
        
    }
}
