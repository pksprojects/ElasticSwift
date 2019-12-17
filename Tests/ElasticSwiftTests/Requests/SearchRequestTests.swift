//
//  SearchRequestTests.swift
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


class SearchRequestTests: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.SearchRequestTests", factory: logFactory)
    
    private let client: ElasticClient = {
        let cred = BasicClientCredential(username: esConnection.uname, password: esConnection.passwd)
        let adaptorConfig = AsyncHTTPClientAdaptorConfiguration.default
        let settings = (esConnection.isProtected) ?
            Settings(forHost: esConnection.host, withCredentials: cred, adaptorConfig: adaptorConfig) :
            Settings(forHost: esConnection.host,adaptorConfig: adaptorConfig)
        return ElasticClient(settings: settings)
    }()
    
    private let indexName = "\(TEST_INDEX_PREFIX)_\(SearchRequestTests.self)".lowercased()
    
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
//        let cred = ClientCredential(username: "elastic", password: "elastic")
//        let ssl = SSLConfiguration(certPath: "/usr/local/Cellar/kibana/6.1.2/config/certs/elastic-certificates.der", isSelf: true)
//        let settings = Settings(forHosts: ["https://localhost:9200"], withCredentials: cred, withSSL: true, sslConfig: ssl)
//        self.client = RestClient(settings: settings)
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
    
    func test_01_Search() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<SearchResponse<Message>, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case .success(let response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
            }
            
            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort =  SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .set(sort: sort)
            .build()
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Found \(response.result)")
            }
            self.client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 =  try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        self.client.execute(request: request1, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
}
