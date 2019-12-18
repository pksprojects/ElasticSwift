//
//  IndicesRequestsTests.swift
//  ElasticSwiftTests
//  
//
//  Created by Prafull Kumar Soni on 12/15/19.
//

import XCTest
import Logging
import UnitTestSettings

@testable import ElasticSwift
@testable import ElasticSwiftQueryDSL
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO

class IndicesRequestsTests: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.IndicesRequestsTests", factory: logFactory)
    
    private let client = elasticClient
    
    private let indexName = "\(TEST_INDEX_PREFIX)_\(IndicesRequestsTests.self)".lowercased()
    
    override func setUp() {
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
                case .failure(let error):
                    logger.error("Error: \(error)")
                    XCTAssert(false)
                case .success(let response):
                    XCTAssert(response.acknowledged, "\(response.acknowledged)")
                    XCTAssert(response.index == indexName, "\(response.index)")
                    XCTAssert(response.shardsAcknowledged, "\(response.shardsAcknowledged)")
            }
            e.fulfill()
        }
        let createIndexRequest = CreateIndexRequest(indexName)
        
        self.client.indices.create(createIndexRequest, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
        
    override func tearDown() {
        super.tearDown()
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<AcknowledgedResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
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
        func handler(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
                case .failure(let error):
                    logger.error("Error: \(error)")
                    XCTAssert(false)
                case .success(let response):
                    logger.info("Response: \(response)")
                    XCTAssert(response.acknowledged, "\(response.acknowledged)")
                    XCTAssert(response.index == "test", "\(response.index)")
                    XCTAssert(response.shardsAcknowledged, "\(response.shardsAcknowledged)")
            }
            e.fulfill()
        }
        let createIndexRequest = CreateIndexRequest("test")
        
        func handler1(_ result: Result<AcknowledgedResponse, Error>) -> Void {
            
            switch result {
                case .failure(let error):
                    logger.error("Error: \(error)")
                case .success(let response):
                    logger.info("Response: \(response)")
            }
            
            self.client.indices.create(createIndexRequest, completionHandler: handler)
        }
        let deleteIndexRequest = DeleteIndexRequest("test")
        
        self.client.indices.delete(deleteIndexRequest, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_02_GetIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<GetIndexResponse, Error>) -> Void {
            
            switch result {
                case .failure(let error):
                    logger.error("Error: \(error)")
                    XCTAssert(false)
                case .success(let response):
                    logger.info("Response: \(response)")
                    XCTAssert(response.settings.providedName == "test", "Index: \(response.settings.providedName)")
            }
            e.fulfill()
        }
        let request = GetIndexRequest("test")
        
        self.client.indices.get(request, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_03_IndexExists() throws {
        let e = expectation(description: "execution complete")
        
        let existsRequest = IndexExistsRequest("test")
        
        let getIndexRequest = GetIndexRequest("test")
        
        func existsFalseHander(_ result: Result<IndexExistsResponse, Error>) -> Void {
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(!response.exists, "IndexExists: \(response.exists)")
            }
            e.fulfill()
        }
        
        
        func handler(_ result: Result<AcknowledgedResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            self.client.indices.exists(getIndexRequest, completionHandler: existsFalseHander)
        }
        let deleteRequest = DeleteIndexRequest("test")
        
        func existsTrueHander(_ result: Result<IndexExistsResponse, Error>) -> Void {
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.exists, "IndexExists: \(response.exists)")
            }
            self.client.indices.delete(deleteRequest, completionHandler: handler)
        }
        
        
        /// make sure index exists
        func createIndexRequestHandler(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Response: \(response)")
            }
            self.client.indices.exists(existsRequest, completionHandler: existsTrueHander)
        }
        
        let createIndexRequest = CreateIndexRequest("test")
        self.client.indices.create(createIndexRequest, completionHandler: createIndexRequestHandler)
        waitForExpectations(timeout: 10)
    }
    
    func test_999_DeleteIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<AcknowledgedResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            e.fulfill()
        }
        let request = DeleteIndexRequest("test")
        
        /// make sure index exists
        func handler1(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error \(error)")
            case .success(let response):
                logger.info("Response: \(response)")
            }
            self.client.execute(request: request, completionHandler: handler)
        }
        
        let request1 = CreateIndexRequest("test")
        self.client.execute(request: request1, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
}
