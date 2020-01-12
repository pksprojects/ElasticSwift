//
//  ExplainRequestTests.swift
//  ElasticSwiftTests
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

class ExplainRequestTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.ExplainRequestTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(ExplainRequestTests.self)".lowercased()

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

    func test_01_explain_q() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<ExplainResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertTrue(response.matched == true, "Matched \(response.matched)")
                XCTAssertTrue(response.explanation.description == "weight(name:elasticsearch in 0) [PerFieldSimilarity], result of:")
                XCTAssertTrue(response.explanation.details.count > 0, "explanation.details count \(response.explanation.details.count)")
            }

            e.fulfill()
        }

        let request = ExplainRequest(index: indexName, type: "_doc", id: "0", q: "name:elasticsearch")

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.explain(request, completionHandler: handler)
        }

        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(type: "_doc")
            .set(id: "0")
            .set(source: ["name": "elasticsearch"])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_02_explain_query() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<ExplainResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertTrue(response.matched == true, "Matched \(response.matched)")
                XCTAssertTrue(response.explanation.description == "weight(name:elasticsearch in 0) [PerFieldSimilarity], result of:")
                XCTAssertTrue(response.explanation.details.count > 0, "explanation.details count \(response.explanation.details.count)")
            }

            e.fulfill()
        }

        let request = try ExplainRequestBuilder()
            .set(index: indexName)
            .set(type: "_doc")
            .set(id: "0")
            .set(query: MatchQuery(field: "name", value: "elasticsearch"))
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.explain(request, completionHandler: handler)
        }

        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(type: "_doc")
            .set(id: "0")
            .set(source: ["name": "elasticsearch"])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_03_explain_Equatable() throws {
        let request = try ExplainRequestBuilder()
            .set(index: indexName)
            .set(type: "_doc")
            .set(id: "0")
            .set(query: MatchAllQuery())
            .set(df: "df")
            .set(parent: "parent")
            .set(lenient: "lenient")
            .set(routing: "routing")
            .set(analyzer: "analyzer")
            .set(preference: "preference")
            .set(sourceFilter: .fetchSource(true))
            .set(analyzeWildcard: true)
            .set(defaultOperator: .and)
            .add(storedField: "storedField1")
            .set(storedFields: ["storedField1"])
            .add(storedField: "storedField2")
            .build()
        var request1 = ExplainRequest(index: indexName, type: "_doc", id: "0", query: MatchAllQuery())
        request1.df = "df"
        request1.parent = "parent"
        request1.lenient = "lenient"
        request1.routing = "routing"
        request1.analyzer = "analyzer"
        request1.preference = "preference"
        request1.sourceFilter = .fetchSource(true)
        request1.analyzeWildcard = true
        request1.defaultOperator = .and
        request1.storedFields = ["storedField1", "storedField2"]
        XCTAssertTrue(request == request1)
        XCTAssert(request.endPoint == "\(indexName)/_doc/0/_explain")
        XCTAssert(request.method == .POST)
        XCTAssert(request.queryParams.count == 10, "Count \(request.queryParams.count)")
        XCTAssert(request.queryParams.first { $0.name == "_source" }!.value == "true")
        XCTAssert(request.headers.count == 0)
    }

    func test_04_explainRequestBuilder_fail_index() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ExplainRequestBuilder().set(type: "type").build(), "missing index") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("index", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_05_explainRequestBuilder_fail_type() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ExplainRequestBuilder().set(index: "index").build(), "missing type") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("type", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_06_explainRequestBuilder_fail_id() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ExplainRequestBuilder().set(index: "index").set(type: "type").build(), "missing id") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("id", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_07_explainRequestBuilder_fail_query_q() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ExplainRequestBuilder().set(index: "index").set(type: "type").set(id: "id").build(), "missing query or q") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case let .atleastOneFieldRequired(fields):
                    XCTAssertEqual(["query", "q"], fields)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_08_explain_query_matched_false() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<ExplainResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertTrue(response.matched == false, "Matched \(response.matched)")
                XCTAssertTrue(response.explanation.description == "no matching term")
                XCTAssertTrue(response.explanation.details.count == 0, "explanation.details count \(response.explanation.details.count)")
            }

            e.fulfill()
        }

        let request = try ExplainRequestBuilder()
            .set(index: indexName)
            .set(type: "_doc")
            .set(id: "0")
            .set(query: MatchQuery(field: "name", value: "noMatch"))
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.explain(request, completionHandler: handler)
        }

        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(type: "_doc")
            .set(id: "0")
            .set(source: ["name": "elasticsearch"])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }
}
