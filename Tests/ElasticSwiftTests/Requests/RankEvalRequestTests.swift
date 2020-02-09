//
//  RankEvalRequestTests.swift
//
//
//  Created by Prafull Kumar Soni on 2/8/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO
@testable import ElasticSwiftQueryDSL

class RankEvalRequestTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.SearchRequestTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(RankEvalRequestTests.self)".lowercased()

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
//        let cred = ClientCredential(username: "elastic", password: "elastic")
//        let ssl = SSLConfiguration(certPath: "/usr/local/Cellar/kibana/6.1.2/config/certs/elastic-certificates.der", isSelf: true)
//        let settings = Settings(forHosts: ["https://localhost:9200"], withCredentials: cred, withSSL: true, sslConfig: ssl)
//        self.client = RestClient(settings: settings)
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

    func test_01_rankEvalRequest_precision() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<RankEvalResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response)
                logger.info("\(response)")
            }

            e.fulfill()
        }
        
        var searchSource = SearchSource()
        searchSource.query = MatchAllQuery()

        let request = try RankEvalRequestBuilder()
            .set(rankEvalSpec: .init(request: [
                .init(id: "Test 01", summaryFields: [], ratedDocs: [], templateId: nil, params: [:], evaluationRequest: searchSource),
            ], metric: PrecisionAtK(threshold: nil, ignoreUnlabeled: nil, k: nil), maxConcurrentSearches: nil, templates: []))
            .build()

        client.rankEval(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_02_rankEvalRequest_mrr() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<RankEvalResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response)
                logger.info("\(response)")
            }

            e.fulfill()
        }
        
        var searchSource = SearchSource()
        searchSource.query = MatchAllQuery()

        let request = try RankEvalRequestBuilder()
            .set(rankEvalSpec: .init(request: [
                .init(id: "Test 01", summaryFields: [], ratedDocs: [], templateId: nil, params: [:], evaluationRequest: searchSource),
            ], metric: MeanReciprocalRank(k: nil, relevantRatingThreshhold: nil), maxConcurrentSearches: nil, templates: []))
            .build()

        client.rankEval(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_03_rankEvalRequest_dcg() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<RankEvalResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response)
                logger.info("\(response)")
            }

            e.fulfill()
        }
        
        var searchSource = SearchSource()
        searchSource.query = MatchAllQuery()

        let request = try RankEvalRequestBuilder()
            .set(rankEvalSpec: .init(request: [
                .init(id: "Test 01", summaryFields: [], ratedDocs: [], templateId: nil, params: [:], evaluationRequest: searchSource),
            ], metric: DiscountedCumulativeGain(k: nil, normalize: true, unknownDocRating: nil), maxConcurrentSearches: nil, templates: []))
            .build()

        client.rankEval(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_04_rankEvalRequest_err() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<RankEvalResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response)
                logger.info("\(response)")
            }

            e.fulfill()
        }
        
        var searchSource = SearchSource()
        searchSource.query = MatchAllQuery()

        let request = try RankEvalRequestBuilder()
            .set(rankEvalSpec: .init(request: [
                .init(id: "Test 01", summaryFields: [], ratedDocs: [], templateId: nil, params: [:], evaluationRequest: searchSource),
            ], metric: ExpectedReciprocalRank(k: nil, maxRelevance: 3), maxConcurrentSearches: nil, templates: []))
            .build()

        client.rankEval(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }
}
