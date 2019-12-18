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
    
    private let client = elasticClient
    
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
    
    func test_02_Search_Scroll_Request() throws {
        let e = expectation(description: "execution complete")
        
        let docs: [Message] = {
            var arr = [Message]()
            for i in 1...10 {
                arr.append(Message("Message no: \(i)"))
            }
            return arr
        }()
        
        let scroll = Scroll.ONE_MINUTE
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort =  SortBuilders.fieldSort("msg.keyword").set(order: .asc).build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .set(sort: sort)
            .set(scroll: scroll)
            .set(size: 1)
            .build()
        
        var hits: [Message] = []
        
        func clearScrollHandler(_ result: Result<ClearScrollResponse, Error>) -> Void {
            switch result {
            case .failure(let error):
                logger.error("clearScrollHandler Error: \(error)")
                XCTAssert(false)
            case .success(let response):
                logger.info("clearScrollHandler Response: \(response)")
                XCTAssertTrue(response.succeeded, "Clear Scroll Succeeded: \(response.succeeded)")
            }
            XCTAssert(docs.count == hits.count, "Counts didn't match Docs: \(docs.count) Hits: \(hits.count)")
            e.fulfill()
        }
        
        func scrollHandler(_ result: Result<SearchResponse<Message>, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("scrollHandler Error: \(error)")
                XCTAssert(false)
                e.fulfill()
            case .success(let response):
                logger.info("scrollHandler Response: \(response)")
                XCTAssert(response.scrollId != nil, "Scroll Id is missing")
                if response.hits.hits.count == 0 {
                    let clearScrollRequest = ClearScrollRequest(scrollId: response.scrollId!)
                    self.client.clearScroll(clearScrollRequest, completionHandler: clearScrollHandler)
                } else {
                    let searchHits = response.hits.hits.filter { $0.source != nil }.map { $0.source! }
                    hits.append(contentsOf: searchHits)
                    let scrollRequest = SearchScrollRequest(scrollId: response.scrollId!, scroll: scroll)
                    self.client.scroll(scrollRequest, completionHandler: scrollHandler)
                }
            }
        }
        
        func handler(_ result: Result<SearchResponse<Message>, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("handler Error: \(error)")
                XCTAssert(false)
                e.fulfill()
            case .success(let response):
                logger.info("handler Response: \(response)")
                XCTAssertNotNil(response.scrollId)
                let searchHits = response.hits.hits.filter { $0.source != nil }.map { $0.source! }
                hits.append(contentsOf: searchHits)
                var scrollRequest = SearchScrollRequest(scrollId: response.scrollId!, scroll: scroll)
                scrollRequest.restTotalHitsAsInt = true
                self.client.scroll(scrollRequest, completionHandler: scrollHandler)
            }
        }
        
        /// make sure doc exists
        
        func indexDocs(_ docs: [Message], curr: Int, callback: @escaping () -> Void) {
            if curr >= 0 {
                var request = IndexRequest(index: indexName, id: "\(curr)", source: docs[curr])
                request.refresh = .true
                self.client.index(request) { result in
                    switch result {
                    case .failure(let error):
                        self.logger.error("Error: \(error)")
                    case .success(let response):
                        self.logger.info("Found \(response.result)")
                    }
                    return indexDocs(docs, curr: curr - 1, callback: callback)
                }
            } else {
                return callback()
            }
        }
        
        func indexDocs(_ docs: [Message], callback: @escaping () -> Void) {
            return indexDocs(docs, curr: docs.count - 1, callback: callback)
        }
        
        indexDocs(docs) {
            self.client.search(request, completionHandler: handler)
        }
        
        waitForExpectations(timeout: 45)
    }
    
}
