//
//  ElasticSwiftNetworkingTests.swift
//  ElasticSwiftNetworkingTests
//
//
//  Created by Prafull Kumar Soni on 3/31/20.
//

import Logging
import NIOHTTP1
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCore
@testable import ElasticSwiftNetworking

class ElasticSwiftNetworkingTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftNetworkingTests.ElasticSwiftNetworkingTests", factory: logFactory)

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

    func test_01_adaptor_init() throws {
        let adaptor = URLSessionAdaptor(forHost: esConnection.host, adaptorConfig: URLSessionAdaptorConfiguration.default)
        XCTAssertNotNil(adaptor)
        XCTAssertEqual(adaptor.host, esConnection.host)
    }

    func test_02_adaptor_execute() throws {
        let e = expectation(description: "execution complete")
        let adaptor = URLSessionAdaptor(forHost: esConnection.host, adaptorConfig: URLSessionAdaptorConfiguration.default)
        let base64 = "\(esConnection.uname):\(esConnection.passwd)".data(using: .utf8)!.base64EncodedString()
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Basic \(base64)")
        let request = try HTTPRequestBuilder()
            .set(path: "/")
            .set(method: .GET)
            .set(headers: headers)
            .build()
        adaptor.performRequest(request) { result in
            switch result {
            case let .failure(error):
                self.logger.error("Error: \(error.localizedDescription)")
                XCTAssert(false)
            case let .success(response):
                self.logger.info("Response: \(response)")
                XCTAssertEqual(response.status, HTTPResponseStatus.ok)
                if let data = response.body {
                    do {
                        let info = try JSONDecoder().decode(ESInfo.self, from: data)
                        self.logger.info("Response Body: \(info)")
                    } catch {
                        self.logger.error("Error: \(error)")
                    }
                }
            }
            e.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

    func test_03_ssl_config() throws {
        let sslConfig = SSLConfiguration(certPath: "/path/to/ssl.cert", isSelf: true)
        XCTAssertNotNil(sslConfig)
        XCTAssertEqual(sslConfig.certPath, "/path/to/ssl.cert")
        XCTAssertEqual(sslConfig.isSelfSigned, true)
    }
}

struct ESInfo: Codable {
    public let name: String?
    public let cluster_name: String?
    public let version: ESVersion?
    public let tagline: String?
}

extension ESInfo {
    struct ESVersion: Codable {
        public let number: String?
        public let build_flavor: String?
        public let build_hash: String?
        public let build_date: String?
        public let build_snapshot: Bool?
        public let lucene_version: String?
        public let minimum_wire_compatibility_version: String?
        public let minimum_index_compatibility_version: String?
    }
}
