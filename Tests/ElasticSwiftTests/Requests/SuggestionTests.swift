//
//  SuggestionTests.swift
//  
//
//  Created by Prafull Kumar Soni on 11/26/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO
@testable import ElasticSwiftQueryDSL

class SuggestionTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.SuggestionTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(SuggestionTests.self)".lowercased()

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
    
    
    func test_01_termSuggestionBuilder() throws {
        let termSuggestion = try TermSuggestionBuilder()
            .set(text: "text")
            .set(size: 10)
            .set(sort: .frequency)
            .set(field: "field")
            .set(regex: "regex")
            .set(prefix: "prefix")
            .set(analyzer: "analyzer")
            .set(accuracy: 1.0)
            .set(maxEdits: 10)
            .set(maxInspections: 2)
            .set(shardSize: 5)
            .set(prefixLength: 3)
            .set(stringDistance: .damerauLevenshtein)
            .set(suggestMode: .always)
            .set(minDocFreq: 10)
            .set(maxTermFreq: 10)
            .set(minWordLength: 3)
            .build()
        
        XCTAssertEqual(termSuggestion.text, "text")
        XCTAssertEqual(termSuggestion.size, 10)
        XCTAssertEqual(termSuggestion.sort, .frequency)
        XCTAssertEqual(termSuggestion.field, "field")
        XCTAssertEqual(termSuggestion.regex, "regex")
        XCTAssertEqual(termSuggestion.prefix, "prefix")
        XCTAssertEqual(termSuggestion.analyzer, "analyzer")
        XCTAssertEqual(termSuggestion.accuracy, 1.0)
        XCTAssertEqual(termSuggestion.maxEdits, 10)
        XCTAssertEqual(termSuggestion.maxInspections, 2)
        XCTAssertEqual(termSuggestion.shardSize, 5)
        XCTAssertEqual(termSuggestion.prefixLength, 3)
        XCTAssertEqual(termSuggestion.stringDistance, .damerauLevenshtein)
        XCTAssertEqual(termSuggestion.suggestMode, .always)
        XCTAssertEqual(termSuggestion.minDocFreq, 10)
        XCTAssertEqual(termSuggestion.maxTermFreq, 10)
        XCTAssertEqual(termSuggestion.minWordLength, 3)
    }
    
    func test_02_termSuggestionBuilder_missing_field() throws {
        XCTAssertThrowsError(try TermSuggestionBuilder().build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? SuggestionBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }
    
    func test_03_termSuggestionBuilder() throws {
        XCTAssertNoThrow(try TermSuggestionBuilder().set(field: "field").build(), "Should not throw")
    }
    
    func test_04_termSuggestion_decode() throws {
        let suggestion = try TermSuggestionBuilder()
            .set(field: "message")
            .set(text: "tring out Elasticsearch")
            .build()
        let jsonStr = """
            {
              "text" : "tring out Elasticsearch",
              "term" : {
                "field" : "message"
              }
            }
        """
        
        let decoded = try JSONDecoder().decode(TermSuggestion.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(suggestion, decoded)
    }
    
    func test_05_termSuggestion_encode() throws {
        let suggestion = try TermSuggestionBuilder()
            .set(field: "message")
            .set(text: "tring out Elasticsearch")
            .build()
        
        let data = try JSONEncoder().encode(suggestion)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
          "text" : "tring out Elasticsearch",
          "term" : {
            "field" : "message"
          }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
}
