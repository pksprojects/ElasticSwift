//
//  ElasticSwiftCoreTests.swift
//  ElasticSwiftCoreTests
//
//
//  Created by Prafull Kumar Soni on 2/11/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCore
@testable import NIOHTTP1

class ElasticSwiftCoreTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftCoreTests.ElasticSwiftCoreTests", factory: logFactory)

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

    func test_01_httpRequestBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try HTTPRequestBuilder().set(method: .GET).set(path: "path").build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_02_httpRequestBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(
            try HTTPRequestBuilder()
                .set(method: .GET)
                .set(path: "path")
                .set(body: "Hello Wordl!".data(using: .utf8)!)
                .set(version: HTTPVersion(major: 2, minor: 0))
                .set(headers: ["header1": "headerVal"])
                .build(), "Should not throw"
        )
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_03_httpRequestBuilder_fail() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HTTPRequestBuilder().set(path: "path").build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? HTTPRequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("method", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_04_httpRequestBuilder_fail_2() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HTTPRequestBuilder().set(method: .GET).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? HTTPRequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("path", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_05_httpRequest() throws {
        let request = try HTTPRequestBuilder()
            .set(method: .GET)
            .set(path: "path")
            .build()

        XCTAssertEqual(request.path, request.pathWitQuery)
    }

    func test_05_httpRequest_queryPath() throws {
        let request = try HTTPRequestBuilder()
            .set(method: .GET)
            .set(path: "path")
            .set(queryParams: [.init(name: "test", value: "testVal")])
            .build()

        XCTAssertEqual("path", request.path)
        XCTAssertEqual("?test=testVal", request.query)
        XCTAssertNotEqual(request.path, request.pathWitQuery)
        XCTAssertEqual("path?test=testVal", request.pathWitQuery)
    }

    func test_06_httpResponseBuilder_fail() throws {
        let e = expectation(description: "execution complete")

        let request = HTTPRequest(path: "path", method: .GET)

        XCTAssertThrowsError(try HTTPResponseBuilder().set(request: request).set(status: .accepted).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? HTTPResponseBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("headers", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_07_httpResponseBuilder_fail_2() throws {
        let e = expectation(description: "execution complete")

        let request = HTTPRequest(path: "path", method: .GET)

        XCTAssertThrowsError(try HTTPResponseBuilder().set(request: request).set(headers: .init()).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? HTTPResponseBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("status", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_08_httpResponseBuilder_fail_3() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HTTPResponseBuilder().set(headers: .init()).set(status: .accepted).build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? HTTPResponseBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("request", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_09_httpResponseBuilder() throws {
        let e = expectation(description: "execution complete")

        let request = HTTPRequest(path: "path", method: .GET)

        XCTAssertNoThrow(try HTTPResponseBuilder()
            .set(request: request)
            .set(status: .ok)
            .set(headers: ["Content-Type": "text/plain"])
            .set(body: "Hello World!".data(using: .utf8)!)
            .build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_10_HTTPResponseStatus_extension_test() throws {
        XCTAssertTrue(HTTPResponseStatus.ok.is2xxSuccessful())
        XCTAssertTrue(HTTPResponseStatus.processing.is1xxInformational())
        XCTAssertTrue(HTTPResponseStatus.seeOther.is3xxRedirection())
        XCTAssertTrue(HTTPResponseStatus.unauthorized.is4xxClientError())
        XCTAssertTrue(HTTPResponseStatus.internalServerError.is5xxServerError())
        XCTAssertTrue(HTTPResponseStatus.badGateway.isError())
        XCTAssertTrue(HTTPResponseStatus.badRequest.isError())
    }

    func test_11_dynamic_coding_keys() throws {
        let data = "{ \"1\": \"Test\"}".data(using: .utf8)!
        let test = try JSONDecoder().decode(Test.self, from: data)

        XCTAssertTrue(test.str == "Test")
    }

    func test_12_dynamic_coding_keys() throws {
        let key = DynamicCodingKeys(stringValue: "test")

        XCTAssertNotNil(key)
        XCTAssertNil(key?.intValue)
        XCTAssertEqual("test", key?.stringValue)
    }

    func test_13_query_type() throws {
        let queryType1 = MyQueryType.query1
        let queryType2 = MyTestQueryType.random1

        XCTAssertFalse(queryType1.isEqualTo(queryType2))
        XCTAssertTrue(queryType2.isEqualTo(MyTestQueryType.random1))
        XCTAssertNil(MyTestQueryType("NOT VALUE"))
    }

    func test_14_query() throws {
        let query1 = MyTestQuery()
        let query2 = MyTestQuery2()

        XCTAssertFalse(query1.isEqualTo(query2))
        XCTAssertTrue(query2.isEqualTo(query2))
    }
}

struct Test {
    let str: String
}

extension Test: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        str = try container.decode(String.self, forKey: .key(indexed: 1))
    }
}

enum MyQueryType: String, QueryType {
    case query1
    case query2

    var metaType: Query.Type {
        return MyTestQuery.self
    }
}

enum MyTestQueryType: String, QueryType {
    case random1
    case random2

    var metaType: Query.Type {
        return MyTestQuery.self
    }
}

struct MyTestQuery: Query, Equatable {
    static func == (lhs: MyTestQuery, rhs: MyTestQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
    }

    var queryType: QueryType = MyTestQueryType.random1

    func toDic() -> [String: Any] {
        return [:]
    }

    init() {}

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(queryType.name, forKey: .queryType)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .queryType)
        queryType = MyTestQueryType(type)!
    }

    enum CodingKeys: String, CodingKey {
        case queryType
    }
}

struct MyTestQuery2: Query, Equatable {
    static func == (lhs: MyTestQuery2, rhs: MyTestQuery2) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
    }

    var queryType: QueryType = MyQueryType.query2

    init() {}

    func toDic() -> [String: Any] {
        return [:]
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(queryType.name, forKey: .queryType)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .queryType)
        queryType = MyQueryType(type)!
    }

    enum CodingKeys: String, CodingKey {
        case queryType
    }
}
