//
//  CountRequestTests.swift
//  ElasticSwiftTests
//  
//
//  Created by Prafull Kumar Soni on 1/11/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO
@testable import ElasticSwiftQueryDSL

class CountRequestTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.CountRequestTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(CountRequestTests.self)".lowercased()

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
    
    func test_01_Count_on_empty_index() throws {
        
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<CountResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertTrue(response.count == 0, "Count \(response.count)")
            }

            e.fulfill()
        }
        
        let request = CountRequest(indices: indexName)
        
        self.client.count(request, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_02_Count_type_query() throws {
        
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<CountResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertTrue(response.count == 1, "Count \(response.count)")
            }

            e.fulfill()
        }
        
        let request = CountRequest(indices: indexName, types: ["_doc"], query: MatchQuery(field: "name", value: "elasticsearch"))
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            self.client.count(request, completionHandler: handler)
        }
        
        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(type: "_doc")
            .set(source: [ "name": "elasticsearch" ])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        
        waitForExpectations(timeout: 10)
    }
    
    func test_03_Count_q() throws {
        
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<CountResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertTrue(response.count == 1, "Count \(response.count)")
            }

            e.fulfill()
        }
        
        let request = try CountRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(q: "name:elasticsearch")
            .build()
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            self.client.count(request, completionHandler: handler)
        }
        
        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(type: "_doc")
            .set(source: [ "name": "elasticsearch" ])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        
        waitForExpectations(timeout: 10)
    }
    
    func test_04_equatable() throws {
        let request = try CountRequestBuilder()
            .add(index: indexName)
            .set(indices: indexName)
            .add(index: "index2")
            .add(type: "_doc")
            .set(types: "_doc")
            .add(type: "_doc2")
            .set(query: MatchAllQuery())
            .set(ignoreUnavailable: true)
            .set(ignoreThrottled: true)
            .set(allowNoIndices: false)
            .set(expandWildcards: .all)
            .set(minScore: 1.0)
            .set(preference: "local")
            .set(routing: "routing")
            .set(analyzer: "analyzer")
            .set(analyzeWildcard: false)
            .set(defaultOperator: .and)
            .set(df: "df")
            .set(lenient: "lenient")
            .set(terminateAfter: 10)
            .build()
        var request1 = CountRequest(indices: indexName, "index2", types: ["_doc", "_doc2"], query: MatchAllQuery())
        request1.ignoreUnavailable = true
        request1.ignoreThrottled = true
        request1.allowNoIndices = false
        request1.expandWildcards = .all
        request1.minScore = 1.0
        request1.preference = "local"
        request1.routing = "routing"
        request1.analyzer = "analyzer"
        request1.analyzeWildcard = false
        request1.defaultOperator = .and
        request1.df = "df"
        request1.lenient = "lenient"
        request1.terminateAfter = 10
        XCTAssert(request == request1)
        XCTAssert(request.endPoint == "\(indexName),index2/_doc,_doc2/_count")
        XCTAssert(request.method == .POST)
        XCTAssert(request.queryParams.count == 13)
        XCTAssert(request.headers.count == 0)
    }
}

