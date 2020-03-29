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
                    XCTAssertEqual(["shape", "indexedShapeId"], fields)
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

    func test_06_geoBoundingBoxQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.geoBoundingBoxQuery().set(field: "locaion").set(topLeft: .init(lat: 40.10, lon: -74.12)).set(bottomRight: .init(lat: 40.72, lon: -71.10)).build(), "Should not throw")
    }

    func test_07_geoBoundingBoxQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.geoBoundingBoxQuery().set(field: "locaion").set(topLeft: .init(lat: 40.10, lon: -74.12)).set(bottomRight: .init(lat: 40.72, lon: -71.10)).set(type: .memory).set(validationMethod: .ignoreMalformed).build(), "Should not throw")
    }

    func test_08_geoBoundingBoxQueryBuilder_missing_field() throws {
        XCTAssertThrowsError(try QueryBuilders.geoBoundingBoxQuery().set(topLeft: .init(lat: 40.10, lon: -74.12)).set(bottomRight: .init(lat: 40.72, lon: -71.10)).set(type: .memory).set(validationMethod: .ignoreMalformed).build(), "missing field") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_09_geoBoundingBoxQueryBuilder_missing_topLeft() throws {
        XCTAssertThrowsError(try QueryBuilders.geoBoundingBoxQuery().set(field: "location").set(bottomRight: .init(lat: 40.72, lon: -71.10)).set(type: .memory).set(validationMethod: .ignoreMalformed).build(), "missing field") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("topLeft", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_10_geoBoundingBoxQueryBuilder_missing_bottomRight() throws {
        XCTAssertThrowsError(try QueryBuilders.geoBoundingBoxQuery().set(field: "location").set(topLeft: .init(lat: 40.10, lon: -74.12)).set(type: .memory).set(validationMethod: .ignoreMalformed).build(), "missing field") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("bottomRight", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_11_geoBoundingBoxQueryBuilder() throws {
        let query = try QueryBuilders.geoBoundingBoxQuery()
            .set(field: "location")
            .set(topLeft: .init(geoHash: "dr5r9ydj2y73"))
            .set(bottomRight: .init(geoHash: "drj7teegpus6"))
            .set(type: .indexed)
            .set(validationMethod: .strict)
            .set(ignoreUnmapped: true)
            .build()
        XCTAssertEqual(query.field, "location")
        XCTAssertEqual(query.topLeft, GeoPoint(geoHash: "dr5r9ydj2y73"))
        XCTAssertEqual(query.bottomRight, GeoPoint(geoHash: "drj7teegpus6"))
        XCTAssertEqual(query.type, GeoExecType.indexed)
        XCTAssertEqual(query.validationMethod, GeoValidationMethod.strict)
        XCTAssertEqual(query.ignoreUnmapped, true)
        let expectedDic = ["geo_bounding_box": [
            "location": [
                "top_left": "dr5r9ydj2y73",
                "bottom_right": "drj7teegpus6",
            ],
            "type": "indexed",
            "validation_method": "strict",
            "ignore_unmapped": true,
        ]]
        XCTAssertTrue(isEqualDictionaries(lhs: query.toDic(), rhs: expectedDic))
    }
}

func isEqualDictionaries(lhs: [String: Any], rhs: [String: Any]) -> Bool {
    func isEqualAny(lhs: Any, rhs: Any) -> Bool {
        switch (lhs, rhs) {
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as Decimal, rhs as Decimal):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: Bool], rhs as [String: Bool]):
            return lhs == rhs
        case let (lhs as [String: Int], rhs as [String: Int]):
            return lhs == rhs
        case let (lhs as [String: UInt], rhs as [String: UInt]):
            return lhs == rhs
        case let (lhs as [String: Double], rhs as [String: Double]):
            return lhs == rhs
        case let (lhs as [String: Decimal], rhs as [String: Decimal]):
            return lhs == rhs
        case let (lhs as [String: String], rhs as [String: String]):
            return lhs == rhs
        case let (lhs as [String: Any], rhs as [String: Any]):
            return isEqualDictionaries(lhs: lhs, rhs: rhs)
        case let (lhs as [Bool], rhs as [Bool]):
            return lhs == rhs
        case let (lhs as [Int], rhs as [Int]):
            return lhs == rhs
        case let (lhs as [Int8], rhs as [Int8]):
            return lhs == rhs
        case let (lhs as [Int16], rhs as [Int16]):
            return lhs == rhs
        case let (lhs as [Int32], rhs as [Int32]):
            return lhs == rhs
        case let (lhs as [Int64], rhs as [Int64]):
            return lhs == rhs
        case let (lhs as [UInt], rhs as [UInt]):
            return lhs == rhs
        case let (lhs as [UInt8], rhs as [UInt8]):
            return lhs == rhs
        case let (lhs as [UInt16], rhs as [UInt16]):
            return lhs == rhs
        case let (lhs as [UInt32], rhs as [UInt32]):
            return lhs == rhs
        case let (lhs as [UInt64], rhs as [UInt64]):
            return lhs == rhs
        case let (lhs as [Float], rhs as [Float]):
            return lhs == rhs
        case let (lhs as [Double], rhs as [Double]):
            return lhs == rhs
        case let (lhs as [Decimal], rhs as [Decimal]):
            return lhs == rhs
        case let (lhs as [String], rhs as [String]):
            return lhs == rhs
        default:
            return false
        }
    }

    if lhs.keys == rhs.keys {
        for key in lhs.keys {
            let val1 = lhs[key]!
            let val2 = rhs[key]!
            if !isEqualAny(lhs: val1, rhs: val2) {
                return false
            }
        }
        return true
    }
    return false
}
