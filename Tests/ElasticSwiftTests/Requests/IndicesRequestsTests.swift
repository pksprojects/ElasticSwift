//
//  IndicesRequestsTests.swift
//  ElasticSwiftTests
//
//
//  Created by Prafull Kumar Soni on 12/15/19.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO
@testable import ElasticSwiftQueryDSL

class IndicesRequestsTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.IndicesRequestsTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(IndicesRequestsTests.self)".lowercased()

    override func setUp() {
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<CreateIndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssert(response.acknowledged, "\(response.acknowledged)")
                XCTAssert(response.index == indexName, "\(response.index)")
                XCTAssert(response.shardsAcknowledged, "\(response.shardsAcknowledged)")
            }
            e.fulfill()
        }
        let createIndexRequest = CreateIndexRequest(indexName)

        client.indices.create(createIndexRequest, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    override func tearDown() {
        super.tearDown()
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case let .success(response):
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            e.fulfill()
        }
        let request = DeleteIndexRequest(indexName)

        client.indices.delete(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
        logger.info("====================TEST=END===============================")
    }

    func test_01_CreateIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<CreateIndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssert(response.acknowledged, "\(response.acknowledged)")
                XCTAssert(response.index == "test", "\(response.index)")
                XCTAssert(response.shardsAcknowledged, "\(response.shardsAcknowledged)")
            }
            e.fulfill()
        }
        let createIndexRequest = CreateIndexRequest("test")

        func handler1(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Response: \(response)")
            }

            client.indices.create(createIndexRequest, completionHandler: handler)
        }
        let deleteIndexRequest = DeleteIndexRequest("test")

        client.indices.delete(deleteIndexRequest, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_02_GetIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<GetIndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssert(response.settings.providedName == "test", "Index: \(response.settings.providedName)")
            }
            e.fulfill()
        }
        let request = GetIndexRequest("test")

        client.indices.get(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_03_IndexExists() throws {
        let e = expectation(description: "execution complete")

        let existsRequest = IndexExistsRequest("test")

        let getIndexRequest = GetIndexRequest("test")

        func existsFalseHander(_ result: Result<IndexExistsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssert(!response.exists, "IndexExists: \(response.exists)")
            }
            e.fulfill()
        }

        func handler(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            client.indices.exists(getIndexRequest, completionHandler: existsFalseHander)
        }
        let deleteRequest = DeleteIndexRequest("test")

        func existsTrueHander(_ result: Result<IndexExistsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssert(response.exists, "IndexExists: \(response.exists)")
            }
            client.indices.delete(deleteRequest, completionHandler: handler)
        }

        /// make sure index exists
        func createIndexRequestHandler(_ result: Result<CreateIndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Response: \(response)")
            }
            client.indices.exists(existsRequest, completionHandler: existsTrueHander)
        }

        let createIndexRequest = CreateIndexRequest("test")
        client.indices.create(createIndexRequest, completionHandler: createIndexRequestHandler)
        waitForExpectations(timeout: 10)
    }

    func test_999_DeleteIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            e.fulfill()
        }
        let request = DeleteIndexRequest("test")

        /// make sure index exists
        func handler1(_ result: Result<CreateIndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error \(error)")
            case let .success(response):
                logger.info("Response: \(response)")
            }
            client.execute(request: request, completionHandler: handler)
        }

        let request1 = CreateIndexRequest("test")
        client.execute(request: request1, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
}
