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

    func test_05_geoBoundingBoxQuery_encode_2() throws {
        let query = GeoBoundingBoxQuery(field: "pin.location", topLeft: .init(geoHash: "dr5r9ydj2y73"), bottomRight: .init(geoHash: "drj7teegpus6"))

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "geo_bounding_box" : {
                "pin.location" : {
                    "top_left" : "dr5r9ydj2y73",
                    "bottom_right" : "drj7teegpus6"
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_06_geoBoundingBoxQuery_decode_2() throws {
        let query = GeoBoundingBoxQuery(field: "pin.location", topLeft: .init(geoHash: "dr5r9ydj2y73"), bottomRight: .init(geoHash: "drj7teegpus6"))

        let jsonStr = """
        {
            "geo_bounding_box" : {
                "pin.location" : {
                    "top_left" : "dr5r9ydj2y73",
                    "bottom_right" : "drj7teegpus6"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(GeoBoundingBoxQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_07_geoBoundingBoxQuery_decode_fail() throws {
        let jsonStr = """
        {
            "geo_bounding_box" : {
                "pin.location" : {
                    "top_left" : "dr5r9ydj2y73",
                    "bottom_right" : "drj7teegpus6"
                },
                "invalid_key": "random_value"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(GeoBoundingBoxQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(GeoBoundingBoxQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }

    func test_08_geoDistanceQuery_encode() throws {
        let query = GeoDistanceQuery(field: "pin.location", point: .init(geoHash: "drm3btev3e86"), distance: "12km")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "geo_distance" : {
                "distance" : "12km",
                "pin.location" : "drm3btev3e86"
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_09_geoDistanceQuery_decode() throws {
        let query = GeoDistanceQuery(field: "pin.location", point: .init(lat: 40, lon: -70), distance: "200km", distanceType: .plane)

        let jsonStr = """
        {
            "geo_distance" : {
                "distance" : "200km",
                "pin.location" : {
                    "lat" : 40,
                    "lon" : -70
                },
                "distance_type": "plane"
            }
        }
        """

        let decoded = try JSONDecoder().decode(GeoDistanceQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_10_geoDistanceQuery_decode_fail() throws {
        let jsonStr = """
        {
            "geo_distance" : {
                "distance" : "200km",
                "pin.location" : "drm3btev3e86",
                "invalid_key": "random_value"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(GeoDistanceQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(GeoDistanceQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }

    func test_11_geoPolygonQuery_encode() throws {
        let query = GeoPolygonQuery(field: "person.location", points: [.init(geoHash: "drn5x1g8cu2y")])

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "geo_polygon" : {
                "person.location" : {
                    "points" : [
                        "drn5x1g8cu2y"
                    ]
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_12_geoPolygonQuery_decode() throws {
        let query = GeoPolygonQuery(field: "pin.location", points: [.init(lat: 40, lon: -70), .init(lat: 30, lon: -80), .init(lat: 20, lon: -90)], ignoreUnmapped: true)

        let jsonStr = """
        {
            "geo_polygon" : {
                "pin.location" : {
                    "points" : [
                        {"lat" : 40, "lon" : -70},
                        {"lat" : 30, "lon" : -80},
                        {"lat" : 20, "lon" : -90}
                    ]
                },
                "ignore_unmapped": true
            }
        }
        """

        let decoded = try JSONDecoder().decode(GeoPolygonQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_13_geoPolygonQuery_decode_fail() throws {
        let jsonStr = """
        {
            "geo_polygon" : {
                "pin.location" : {
                    "points" : [
                        {"lat" : 40, "lon" : -70},
                        {"lat" : 30, "lon" : -80},
                        {"lat" : 20, "lon" : -90}
                    ]
                },
                "invalid_key": "random_value"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(GeoPolygonQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(GeoPolygonQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }
}
