//
//  ClusterRequestsTests.swift
//  ElasticSwiftTests
//
//
//  Created by Prafull Kumar Soni on 12/25/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO
@testable import ElasticSwiftQueryDSL

class ClusterRequestsTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.ClusterRequestsTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(ClusterRequestsTests.self)".lowercased()

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

    func test_01_clusterHealthRequestBuilder_noThrow() throws {
        XCTAssertNoThrow(try ClusterHealthRequestBuilder().build())
    }

    func test_02_clusterHealthRequestBuilder() throws {
        let request = try ClusterHealthRequestBuilder()
            .add(index: "test")
            .set(indices: ["test"])
            .add(index: "test1")
            .set(level: .cluster)
            .set(local: true)
            .set(timeout: "1m")
            .set(masterTimeout: "1m")
            .set(waitForNodes: "node1")
            .set(waitForEvents: .normal)
            .set(waitForStatus: .green)
            .set(waitForActiveShards: "shard1")
            .set(waitForNoRelocatingShards: true)
            .set(waitForNoInitializingShards: true)
            .build()

        XCTAssertEqual(request.indices, ["test", "test1"])
        XCTAssertEqual(request.level, .cluster)
        XCTAssertEqual(request.local, true)
        XCTAssertEqual(request.timeout, "1m")
        XCTAssertEqual(request.masterTimeout, "1m")
        XCTAssertEqual(request.waitForNodes, "node1")
        XCTAssertEqual(request.waitForEvents, .normal)
        XCTAssertEqual(request.waitForStatus, .green)
        XCTAssertEqual(request.waitForActiveShards, "shard1")
        XCTAssertEqual(request.waitForNoRelocatingShards, true)
        XCTAssertEqual(request.waitForNoInitializingShards, true)
        XCTAssertEqual(request.queryParams.count, 10)
    }

    func test_02_clusterHealthRequest() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<ClusterHealthResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.indices != nil, "Indices: \(response.indices)")
            }

            e.fulfill()
        }

        var request = ClusterHealthRequest()
        request.level = .shards

        client.cluster.health(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }
}
