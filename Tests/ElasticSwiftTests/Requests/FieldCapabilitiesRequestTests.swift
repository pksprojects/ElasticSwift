//
//  FieldCapabilitiesRequestTests.swift
//
//
//  Created by Prafull Kumar Soni on 1/12/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO
@testable import ElasticSwiftQueryDSL

class FieldCapabilitiesRequestTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.FieldCapabilitiesRequestTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(FieldCapabilitiesRequestTests.self)".lowercased()

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

    func test_01_field_caps_empty_index() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<FieldCapabilitiesResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertTrue(response.fields.count == 0, "Count \(response.fields.count)")
            }

            e.fulfill()
        }

        let request = FieldCapabilitiesRequest(indices: [indexName], fields: "field1")

        client.fieldCaps(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_02_fieldCapabilitiesRequestBuilder_fail_missing_fields() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try FieldCapabilitiesRequestBuilder().add(index: indexName).build(), "missing fields") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("fields", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_03_fieldCapabilitiesRequestBuilder_fail_empty_fields() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try FieldCapabilitiesRequestBuilder().add(index: indexName).set(fields: []).build(), "empty fields") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .atlestOneElementRequired(field):
                    XCTAssertEqual("fields", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_04_field_caps_request_equataable() throws {
        let request = try FieldCapabilitiesRequestBuilder()
            .add(index: indexName)
            .set(indices: [indexName])
            .set(indices: indexName)
            .add(index: "index2")
            .add(field: "field2")
            .set(fields: ["field2"])
            .set(fields: "field1")
            .add(field: "field2")
            .set(allowNoIndices: false)
            .set(ignoreUnavailable: true)
            .set(expandWildcards: .all)
            .build()
        var request1 = FieldCapabilitiesRequest(indices: [indexName, "index2"], fields: ["field1", "field2"])
        request1.allowNoIndices = false
        request1.expandWildcards = .all
        request1.ignoreUnavailable = true
        XCTAssertTrue(request == request1)
        XCTAssertTrue(request.queryParams.count == 4)
        XCTAssertTrue(request.endPoint == "\(indexName),index2/_field_caps")
        XCTAssert(request.queryParams.first { $0.name == "allow_no_indices" }!.value == "false")
        XCTAssert(request.queryParams.first { $0.name == "ignore_unavailable" }!.value == "true")
        XCTAssert(request.queryParams.first { $0.name == "expand_wildcards" }!.value == "all")
        XCTAssert(request.queryParams.first { $0.name == "fields" }!.value == "field1,field2")
    }

    func test_05_field_caps_with_fields() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<FieldCapabilitiesResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.debug("Response: \(response)")
                XCTAssertTrue(response.fields.count == 1, "Count \(response.fields.count)")
                XCTAssertNotNil(response.fields["name"])
                XCTAssertNotNil(response.fields["name"]!["text"])
                XCTAssertTrue(response.fields["name"]!["text"] == FieldCapabilities(name: "name", type: "text", isSearchable: true, isAggregatable: false, indices: nil, nonSearchableIndices: nil, nonAggregatableIndicies: nil))
            }

            e.fulfill()
        }

        let request = FieldCapabilitiesRequest(indices: [indexName], fields: "name")

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.fieldCaps(request, completionHandler: handler)
        }

        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(source: ["name": "elasticsearch"])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_06_field_caps_with_fields_no_index() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<FieldCapabilitiesResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.debug("Response: \(response)")
                XCTAssertTrue(response.fields.count == 1, "Count \(response.fields.count)")
                XCTAssertNotNil(response.fields["test_06_field_caps_with_fields_no_index"])
                XCTAssertNotNil(response.fields["test_06_field_caps_with_fields_no_index"]!["text"])
                XCTAssertTrue(response.fields["test_06_field_caps_with_fields_no_index"]!["text"] == FieldCapabilities(name: "test_06_field_caps_with_fields_no_index", type: "text", isSearchable: true, isAggregatable: false, indices: nil, nonSearchableIndices: nil, nonAggregatableIndicies: nil))
            }

            e.fulfill()
        }

        let request = FieldCapabilitiesRequest(fields: "test_06_field_caps_with_fields_no_index")

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.fieldCaps(request, completionHandler: handler)
        }

        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(source: ["test_06_field_caps_with_fields_no_index": "elasticsearch"])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }
}
