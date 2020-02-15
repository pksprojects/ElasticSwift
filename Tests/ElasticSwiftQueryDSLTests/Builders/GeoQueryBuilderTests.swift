//
//  GeoQueryBuilderTests.swift
//  
//
//  Created by Prafull Kumar Soni on 2/15/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class GeoQueryBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.GeoQueryBuilderTests", factory: logFactory)

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
    
    func test_01_geoShapeQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try QueryBuilders.geoShapeQuery().set(field: "locaion").set(relation: .contains).set(indexedShapeId: "id").set(indexedShapeType: "_doc").build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }
    
    func test_02_geoShapeQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try QueryBuilders.geoShapeQuery().set(field: "locaion").set(relation: .contains).set(shape: ["type": "envelope", "coordinates": [[13, 53], [14, 52]]]).build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }
    
    func test_03_geoShapeQueryBuilder_missing_indexedShapeType() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try QueryBuilders.geoShapeQuery().set(field: "locaion").set(relation: .contains).set(indexedShapeId: "id").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("indexedShapeType", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    func test_04_geoShapeQueryBuilder_missing_no_shape_no_indexedShapeId() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try QueryBuilders.geoShapeQuery().set(field: "locaion").set(relation: .contains).build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .atleastOneFieldRequired(fields):
                    XCTAssertEqual(["shape","indexedShapeId"], fields)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }
    
    func test_05_geoShapeQueryBuilder_missing_field() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try QueryBuilders.geoShapeQuery().set(relation: .contains).set(indexedShapeId: "id").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }
    
}
