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
        XCTAssertEqual(request.endPoint, "_cluster/health/test,test1")
    }

    func test_03_clusterHealthRequest() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<ClusterHealthResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.indices != nil, "Indices: \(String(describing: response.indices))")
            }

            e.fulfill()
        }

        var request = ClusterHealthRequest()
        request.level = .shards

        client.cluster.health(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_04_clusterGetSettingsRequestBuilder_noThrow() throws {
        XCTAssertNoThrow(try ClusterGetSettingsRequestBuilder().build())
    }

    func test_05_clusterGetSettingsRequestBuilder() throws {
        let request = try ClusterGetSettingsRequestBuilder()
            .set(timeout: "1m")
            .set(masterTimeout: "1m")
            .set(flatSettings: true)
            .set(includeDefaults: true)
            .build()

        XCTAssertEqual(request.flatSettings, true)
        XCTAssertEqual(request.includeDefaults, true)
        XCTAssertEqual(request.timeout, "1m")
        XCTAssertEqual(request.masterTimeout, "1m")
        XCTAssertEqual(request.queryParams.count, 4)
    }

    func test_06_clusterGetSettingsRequest() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<ClusterGetSettingsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.defaults != nil, "Indices: \(String(describing: response.defaults))")
            }

            e.fulfill()
        }

        var request = ClusterGetSettingsRequest()
        request.includeDefaults = true

        client.cluster.getSettings(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_07_clusterGetSettingsRequest_2() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<ClusterGetSettingsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.defaults != nil, "Indices: \(String(describing: response.defaults))")
            }

            e.fulfill()
        }

        var request = ClusterGetSettingsRequest()
        request.includeDefaults = true
        request.flatSettings = true

        client.cluster.getSettings(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_08_clusterUpdateSettingsRequestBuilder_throw() throws {
        XCTAssertThrowsError(try ClusterUpdateSettingsRequestBuilder().build(), "Should throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .atleastOneFieldRequired(fields):
                    XCTAssertEqual(["persistent", "transient"], fields)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_09_clusterUpdateSettingsRequestBuilder_noThrow() throws {
        XCTAssertNoThrow(try ClusterUpdateSettingsRequestBuilder().set(transient: ["indices.recovery.max_bytes_per_sec": "20mb"]).build())
    }

    func test_10_clusterUpdateSettingsRequestBuilder() throws {
        let request = try ClusterUpdateSettingsRequestBuilder()
            .set(timeout: "1m")
            .set(masterTimeout: "1m")
            .set(flatSettings: true)
            .addTransient("indices.recovery.max_bytes_per_sec", value: "20mb")
            .set(transient: ["indices.recovery.max_bytes_per_sec": "20mb"])
            .addTransient("indices.recovery.max_bytes_per_sec", value: "50mb")
            .addPersistent("indices.recovery.max_bytes_per_sec", value: "20mb")
            .set(persistent: ["indices.recovery.max_bytes_per_sec": "20mb"])
            .addPersistent("indices.recovery.max_bytes_per_sec", value: "30mb")
            .build()

        XCTAssertEqual(request.persistent, ["indices.recovery.max_bytes_per_sec": "30mb"])
        XCTAssertEqual(request.transient, ["indices.recovery.max_bytes_per_sec": "50mb"])
        XCTAssertEqual(request.flatSettings, true)
        XCTAssertEqual(request.timeout, "1m")
        XCTAssertEqual(request.masterTimeout, "1m")
        XCTAssertEqual(request.queryParams.count, 3)
    }

    func test_11_clusterUpdateSettingsRequest_transient() throws {
        let e = expectation(description: "execution complete")

        func handler_2(_ result: Result<ClusterUpdateSettingsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged, "Acknowledged: \(response.acknowledged)")
                XCTAssertTrue(response.persistent.isEmpty, "Persistent: \(response.persistent)")
                XCTAssertTrue(response.transient.isEmpty, "Transient: \(response.transient)")
            }

            e.fulfill()
        }

        var request2 = ClusterUpdateSettingsRequest(transient: ["indices.recovery.max_bytes_per_sec": CodableValue(NilValue.nil)])
        request2.flatSettings = true

        func handler(_ result: Result<ClusterUpdateSettingsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged, "Acknowledged: \(response.acknowledged)")
                XCTAssertTrue(response.persistent.isEmpty, "Persistent: \(response.persistent)")
                XCTAssertFalse(response.transient.isEmpty, "Transient: \(response.transient)")
                client.cluster.putSettings(request2, completionHandler: handler_2)
            }
        }

        var request = ClusterUpdateSettingsRequest(transient: ["indices.recovery.max_bytes_per_sec": "20mb"])
        request.flatSettings = true

        client.cluster.putSettings(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_12_clusterUpdateSettingsRequest_persistent() throws {
        let e = expectation(description: "execution complete")

        func handler_2(_ result: Result<ClusterUpdateSettingsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged, "Acknowledged: \(response.acknowledged)")
                XCTAssertTrue(response.persistent.isEmpty, "Persistent: \(response.persistent)")
                XCTAssertTrue(response.transient.isEmpty, "Transient: \(response.transient)")
            }

            e.fulfill()
        }

        var request2 = ClusterUpdateSettingsRequest(persistent: ["indices.recovery.max_bytes_per_sec": CodableValue(NilValue.nil)])
        request2.flatSettings = true

        func handler(_ result: Result<ClusterUpdateSettingsResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged, "Acknowledged: \(response.acknowledged)")
                XCTAssertFalse(response.persistent.isEmpty, "Persistent: \(response.persistent)")
                XCTAssertTrue(response.transient.isEmpty, "Transient: \(response.transient)")
                client.cluster.putSettings(request2, completionHandler: handler_2)
            }
        }

        var request = ClusterUpdateSettingsRequest(persistent: ["indices.recovery.max_bytes_per_sec": "20mb"])
        request.flatSettings = true

        client.cluster.putSettings(request, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
}
