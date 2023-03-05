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

    func test_04_index_open_and_close() throws {
        let e = expectation(description: "execution complete")

        let openRequest = try OpenIndexRequestBuilder()
            .set(indices: indexName)
            .build()

        let closeRequest = try CloseIndexRequestBuilder()
            .set(indices: indexName)
            .build()

        func handlerOpen(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Open Response: \(response)")
                XCTAssert(response.acknowledged == true, "Open Acknowledged: \(response.acknowledged)")
            }
            e.fulfill()
        }

        func handlerClose(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("Close Response: \(response)")
                XCTAssert(response.acknowledged == true, "Acknowledged: \(response.acknowledged)")
                client.indices.open(openRequest, completionHandler: handlerOpen)
            }
        }

        client.indices.close(closeRequest, completionHandler: handlerClose)

        waitForExpectations(timeout: 10)
    }

    func test_05_resizeRequestBuilder() throws {
        XCTAssertThrowsError(try ResizeRequestBuilder().build(), "Should throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("sourceIndex", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_06_resizeRequestBuilder() throws {
        XCTAssertThrowsError(try ResizeRequestBuilder().set(sourceIndex: "source").build(), "Should throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("targetIndexRequest", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_07_resizeRequestBuilder() throws {
        XCTAssertThrowsError(try ResizeRequestBuilder().set(sourceIndex: "source").set(targetIndexRequest: CreateIndexRequest("target")).build(), "Should throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("resizeType", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_08_resizeRequestBuilder() throws {
        XCTAssertNoThrow(try ResizeRequestBuilder()
            .set(sourceIndex: "source")
            .set(targetIndexRequest: CreateIndexRequest("target"))
            .set(resizeType: .shrink)
            .build(), "Should not throw")
    }

    func test_09_resizeRequestBuilder() throws {
        let request = try ResizeRequestBuilder()
            .set(sourceIndex: "source")
            .set(targetIndexRequest: CreateIndexRequest("target"))
            .set(resizeType: .split)
            .set(copySettings: true)
            .set(masterTimeout: "mTimeout")
            .set(timeout: "timeout")
            .set(waitForActiveShards: "waitForActiveShards")
            .build()

        XCTAssertEqual(request.sourceIndex, "source")
        XCTAssertEqual(request.targetIndexRequest, CreateIndexRequest("target"))
        XCTAssertEqual(request.resizeType, .split)
        XCTAssertEqual(request.copySettings, true)
        XCTAssertEqual(request.masterTimeout, "mTimeout")
        XCTAssertEqual(request.timeout, "timeout")
        XCTAssertEqual(request.waitForActiveShards, "waitForActiveShards")
        XCTAssertEqual(request.endPoint, "source/_split/target")
        XCTAssertEqual(request.queryParams.count, 4)
    }

    func test_10_shrink_request() throws {
        let e = expectation(description: "execution complete")
        let sourceIndex = CreateIndexRequest(String("\(indexName)_\(#function)".dropLast(2)),
                                             settings: [
                                                 "index.routing.allocation.require._name": CodableValue(NilValue.nil),
                                                 "index.blocks.write": true,
                                                 "index.number_of_shards": 2,
                                             ])
        let targetIndex = CreateIndexRequest("\(sourceIndex.name)_target",
                                             aliases: [IndexAlias(name: "my_search_indices", metaData: AliasMetaData())],
                                             settings: [
                                                 "index.number_of_replicas": 1,
                                                 "index.number_of_shards": 1,
                                                 "index.codec": "best_compression",
                                             ])

        let shrinkRequest = try ResizeRequestBuilder()
            .set(sourceIndex: sourceIndex.name)
            .set(targetIndexRequest: targetIndex)
            .set(resizeType: .shrink)
            .set(copySettings: true)
            .build()

        func handleDeleteResult(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error \(error)")
                XCTAssertTrue(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged)
            }
            e.fulfill()
        }

        func handleShrinkResult(_ result: Result<ResizeResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error \(error)")
                XCTAssertTrue(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged)
            }
            client.indices.delete(DeleteIndexRequest("\(sourceIndex.name),\(targetIndex.name)"), completionHandler: handleDeleteResult)
        }

        client.indices.create(sourceIndex) { result in
            switch result {
            case let .failure(error):
                self.logger.error("Error \(error)")
                if !"\(error)".contains("already exists") {
                    XCTAssertTrue(false)
                    e.fulfill()
                    break
                }
            case let .success(response):
                self.logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged)
            }
            self.client.indices.shrink(shrinkRequest, completionHandler: handleShrinkResult)
        }

        waitForExpectations(timeout: 10)
    }

    func test_11_split_request() throws {
        let e = expectation(description: "execution complete")
        let sourceIndex = CreateIndexRequest(String("\(indexName)_\(#function)".dropLast(2)),
                                             settings: [
                                                 "index.blocks.write": true,
                                                 "index.number_of_shards": 1,
                                                 "index.number_of_routing_shards": 2,
                                             ])
        let targetIndex = CreateIndexRequest("\(sourceIndex.name)_target",
                                             aliases: [IndexAlias(name: "my_search_indices", metaData: AliasMetaData())],
                                             settings: [
                                                 "index.number_of_shards": 2,
                                             ])

        let splitRequest = try ResizeRequestBuilder()
            .set(sourceIndex: sourceIndex.name)
            .set(targetIndexRequest: targetIndex)
            .set(resizeType: .split)
            .set(copySettings: true)
            .build()

        func handleDeleteResult(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error \(error)")
                XCTAssertTrue(false)
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged)
            }
            e.fulfill()
        }

        func handleSplitResult(_ result: Result<ResizeResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error \(error)")
                XCTAssertTrue(false)
                e.fulfill()
            case let .success(response):
                logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged)
                client.indices.delete(DeleteIndexRequest("\(sourceIndex.name),\(targetIndex.name)"), completionHandler: handleDeleteResult)
            }
        }

        client.indices.create(sourceIndex) { result in
            switch result {
            case let .failure(error):
                self.logger.error("Error \(error)")
                if !"\(error)".contains("already exists") {
                    XCTAssertTrue(false)
                    e.fulfill()
                    break
                }
            case let .success(response):
                self.logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged)
            }
            self.client.indices.split(splitRequest, completionHandler: handleSplitResult)
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_12_rollver_request() throws {
        let e = expectation(description: "execution complete")
        
        let sourceIndex = CreateIndexRequest("\(indexName)-000001", aliases: [
        IndexAlias(name: "\(indexName)-alias", metaData: AliasMetaData())])
        
        let docIndexReq = IndexRequest(index: "\(indexName)-alias", id: "1", source: [
            "message": "a dummy log"
        ])
        
        var docIndexReq2 = IndexRequest(index: "\(indexName)-alias", id: "2", source: [
            "message": "a dummy log"
        ])
        
        docIndexReq2.refresh = IndexRefresh.true
        
        let rolloverReq = RolloverRequest(alias: "\(indexName)-alias", conditions: [
            "max_docs":   "1"
        ], waitForActiveShards: "1")
        
        func handleRolloverResponse(_ result: Result<RolloverResponse, Error>) {
            switch result {
            case let .failure(error):
                self.logger.error("Error \(error)")
                XCTAssertTrue(false)
                e.fulfill()
                break
            case let .success(response):
                self.logger.info("Response: \(response)")
                XCTAssertEqual(response.newIndex, "\(indexName)-000002")
                XCTAssertTrue(response.acknowledged)
            }
            self.client.indices.delete(DeleteIndexRequest("\(indexName)-*")) { result in
                switch result {
                case let .failure(error):
                    self.logger.error("Error \(error)")
                    e.fulfill()
                    break
                case let .success(response):
                    self.logger.info("Response: \(response)")
                    e.fulfill()
                }
            }
        }
        
        var isSecond = false
        func handleDocIndex(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                self.logger.error("Error \(error)")
                if !"\(error)".contains("already exists") {
                    XCTAssertTrue(false)
                    e.fulfill()
                    break
                }
            case let .success(response):
                self.logger.info("Response: \(response)")
                XCTAssertTrue(response.result == "created")
            }
            if (isSecond) {
                self.client.indices.rollover(rolloverReq, completionHandler: handleRolloverResponse)
            } else {
                isSecond = true
                self.client.index(docIndexReq2, completionHandler: handleDocIndex)
            }
            
        }
        
        client.indices.create(sourceIndex) { result in
            switch result {
            case let .failure(error):
                self.logger.error("Error \(error)")
                if !"\(error)".contains("already exists") {
                    XCTAssertTrue(false)
                    e.fulfill()
                    break
                }
            case let .success(response):
                self.logger.info("Response: \(response)")
                XCTAssertTrue(response.acknowledged)
            }
            self.client.index(docIndexReq, completionHandler: handleDocIndex)
        }
        
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
