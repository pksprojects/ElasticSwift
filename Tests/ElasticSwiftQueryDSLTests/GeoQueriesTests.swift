//
//  GeoQueriesTests.swift
//
//
//  Created by Prafull Kumar Soni on 2/15/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class GeoQueriesTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.GeoQueriesTests", factory: logFactory)

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

    func test_01_geoShapeQuery_encode() throws {
        let query = GeoShapeQuery(field: "locaion", shape: nil, indexedShapeId: "deu", indexedShapeType: "_doc")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"geo_shape\":{\"locaion\":{\"indexed_shape\":{\"id\":\"deu\",\"type\":\"_doc\"}}}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_geoShapeQuery_decode() throws {
        let query = GeoShapeQuery(field: "location", shape: ["type": "envelope", "coordinates": [[13, 53], [14, 52]]], indexedShapeId: nil, indexedShapeType: nil, relation: .within)

        let jsonStr = """
        {
            "geo_shape": {
                "location": {
                    "shape": {
                        "type": "envelope",
                        "coordinates" : [[13, 53], [14, 52]]
                    },
                    "relation": "within"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(GeoShapeQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_03_geoBoundingBoxQuery_encode() throws {
        let query = GeoBoundingBoxQuery(field: "pin.location", topLeft: .init(lat: 40.72, lon: -74.1), bottomRight: .init(lat: 40.10, lon: -71.12), type: .indexed, validationMethod: .coerce, ignoreUnmapped: true)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: "{\"geo_bounding_box\":{\"validation_method\":\"coerce\",\"type\":\"indexed\",\"pin.location\":{\"top_left\":{\"lon\":-74.1,\"lat\":40.72},\"bottom_right\":{\"lon\":-71.12,\"lat\":40.10}},\"ignore_unmapped\":true}}".data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_04_geoBoundingBoxQuery_decode() throws {
        let query = GeoBoundingBoxQuery(field: "pin.location", topLeft: .init(lat: 40.73, lon: -74.1), bottomRight: .init(lat: 40.10, lon: -71.12), type: .indexed)

        let jsonStr = """
        {
            "geo_bounding_box" : {
                "pin.location" : {
                    "top_left" : {
                        "lat" : 40.73,
                        "lon" : -74.1
                    },
                    "bottom_right" : {
                        "lat" : 40.10,
                        "lon" : -71.12
                    }
                },
                "type" : "indexed"
            }
        }
        """

        let decoded = try JSONDecoder().decode(GeoBoundingBoxQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
