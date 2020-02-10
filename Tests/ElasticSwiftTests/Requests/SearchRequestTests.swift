//
//  SearchRequestTests.swift
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

class SearchRequestTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.SearchRequestTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(SearchRequestTests.self)".lowercased()

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

    func test_01_Search() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
            }

            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort = SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .add(sort: sort)
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.execute(request: request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_02_Search_Scroll_Request() throws {
        let e = expectation(description: "execution complete")

        let docs: [Message] = {
            var arr = [Message]()
            for i in 1 ... 10 {
                arr.append(Message("Message no: \(i)"))
            }
            return arr
        }()

        let scroll = Scroll.ONE_MINUTE
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort = SortBuilders.fieldSort("msg.keyword").set(order: .asc).build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .add(sort: sort)
            .set(scroll: scroll)
            .set(size: 1)
            .build()

        var hits: [Message] = []

        func clearScrollHandler(_ result: Result<ClearScrollResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("clearScrollHandler Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                logger.info("clearScrollHandler Response: \(response)")
                XCTAssertTrue(response.succeeded, "Clear Scroll Succeeded: \(response.succeeded)")
            }
            XCTAssert(docs.count == hits.count, "Counts didn't match Docs: \(docs.count) Hits: \(hits.count)")
            e.fulfill()
        }

        func scrollHandler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("scrollHandler Error: \(error)")
                XCTAssert(false)
                e.fulfill()
            case let .success(response):
                logger.info("scrollHandler Response: \(response)")
                XCTAssert(response.scrollId != nil, "Scroll Id is missing")
                if response.hits.hits.count == 0 {
                    let clearScrollRequest = ClearScrollRequest(scrollId: response.scrollId!)
                    client.clearScroll(clearScrollRequest, completionHandler: clearScrollHandler)
                } else {
                    let searchHits = response.hits.hits.filter { $0.source != nil }.map { $0.source! }
                    hits.append(contentsOf: searchHits)
                    let scrollRequest = SearchScrollRequest(scrollId: response.scrollId!, scroll: scroll)
                    client.scroll(scrollRequest, completionHandler: scrollHandler)
                }
            }
        }

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("handler Error: \(error)")
                XCTAssert(false)
                e.fulfill()
            case let .success(response):
                logger.info("handler Response: \(response)")
                XCTAssertNotNil(response.scrollId)
                let searchHits = response.hits.hits.filter { $0.source != nil }.map { $0.source! }
                hits.append(contentsOf: searchHits)
                var scrollRequest = SearchScrollRequest(scrollId: response.scrollId!, scroll: scroll)
                scrollRequest.restTotalHitsAsInt = true
                client.scroll(scrollRequest, completionHandler: scrollHandler)
            }
        }

        /// make sure doc exists

        func indexDocs(_ docs: [Message], curr: Int, callback: @escaping () -> Void) {
            if curr >= 0 {
                var request = IndexRequest(index: indexName, id: "\(curr)", source: docs[curr])
                request.refresh = .true
                client.index(request) { result in
                    switch result {
                    case let .failure(error):
                        self.logger.error("Error: \(error)")
                    case let .success(response):
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

    func test_03_Search_No_Source_Explicit_Search_Type() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNil(hit.source, "Source is not nil \(hit)")
                }
            }

            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort = SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .set(sourceFilter: .fetchSource(false))
            .set(searchType: .dfs_query_then_fetch)
            .add(sort: sort)
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.execute(request: request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_04_Search_track_scores() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.score, "Score is nil \(hit)")
                }
            }

            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort = SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .set(trackScores: true)
            .add(sort: sort)
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.execute(request: request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_05_Search_multiple_sorts() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.score, "Score is nil \(hit)")
                }
            }

            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort = SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let scoreSort = SortBuilders.scoreSort().build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .set(trackScores: true)
            .set(sorts: [sort, scoreSort])
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_06_Search_index_boost() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.score, "Score is nil \(hit)")
                }
            }

            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let sort = SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let scoreSort = SortBuilders.scoreSort().build()
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .set(trackScores: true)
            .add(sort: sort)
            .add(sort: scoreSort)
            .add(indexBoost: IndexBoost(index: "random will be replaced", boost: 1.3))
            .set(indicesBoost: [IndexBoost(index: "\(TEST_INDEX_PREFIX)*", boost: 1.4)])
            .add(indexBoost: IndexBoost(index: indexName, boost: 1.3))
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_07_Search_preference_version_seqNoPrimaryTerm() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.seqNo, "seqNo is nil \(hit)")
                    XCTAssertNotNil(hit.version, "version is nil \(hit)")
                    XCTAssertNotNil(hit.primaryTerm, "primaryTerm is nil \(hit)")
                }
            }

            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build()
        queryBuilder.must(query: match)
        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(types: "_doc")
            .set(query: try! queryBuilder.build())
            .set(seqNoPrimaryTerm: true)
            .set(version: true)
            .set(preference: "_local")
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_08_Search_script_fields_explain_true() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.fields, "seqNo is nil \(hit)")
                }
            }

            e.fulfill()
        }

        let test1Script = ScriptField(field: "test1", script: Script("2", lang: "painless", params: nil))
        let test2Script = ScriptField(field: "test2", script: Script("params['_source']['msg'] + params.text", lang: "painless", params: ["text": "test Text"]))

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchAllQuery())
            .set(explain: true)
            .set(scriptFields: [test1Script])
            .add(scriptField: test2Script)
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_09_Search_script_fields_shard_failed() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count == 0, "Count \(response.hits.hits.count)")
                XCTAssert(response.shards.failed == 1, "Expected shard failure didn't happened \(response.shards.failed)")
                XCTAssert(response.shards.failures?.count == 1, "Expected failure count didn't match count: \(response.shards.failures?.count ?? -1)")
            }

            e.fulfill()
        }

        let test1Script = ScriptField(field: "test1", script: Script("doc['msg'] + params.text", lang: "painless", params: ["text": "test Text"]))

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchAllQuery())
            .add(scriptField: test1Script)
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_10_Search_stored_fields() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNil(hit.id, "id is not nil \(hit)")
                    XCTAssertNil(hit.type, "type is not nil \(hit)")
                    XCTAssertNil(hit.source, "source is not nil \(hit)")
                }
            }

            e.fulfill()
        }

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchAllQuery())
            .set(storedFields: "_none_")
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_11_Search_stored_fields_empty_array() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.id, "id is not nil \(hit)")
                    XCTAssertNotNil(hit.type, "type is not nil \(hit)")
                    XCTAssertNil(hit.source, "source is not nil \(hit)")
                }
            }

            e.fulfill()
        }

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchAllQuery())
            .set(storedFields: [])
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_12_Search_stored_fields_star() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.id, "id is not nil \(hit)")
                    XCTAssertNotNil(hit.type, "type is not nil \(hit)")
                    XCTAssertNil(hit.source, "source is not nil \(hit)")
                }
            }

            e.fulfill()
        }

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchAllQuery())
            .set(storedFields: "*")
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_13_Search_docvalue_fields() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.id, "id is nil \(hit)")
                    XCTAssertNotNil(hit.type, "type is nil \(hit)")
                    XCTAssertNotNil(hit.fields, "fields is \(hit)")
                    XCTAssertNotNil(hit.source, "source is nil \(hit)")
                }
            }

            e.fulfill()
        }

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchAllQuery())
            .add(docvalueField: .init(field: "msg.keyword", format: "use_field_mapping"))
            .add(docvalueField: .init(field: "msg.keyword", format: "use_field_mapping"))
            .set(docvalueFields: [.init(field: "msg.keyword", format: "use_field_mapping")])
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_14_Search_post_filter() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Shirt>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count == 1, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.id, "id is nil \(hit)")
                    XCTAssertNotNil(hit.type, "type is nil \(hit)")
                    XCTAssertNotNil(hit.source, "source is nil \(hit)")
                }
            }

            e.fulfill()
        }

        let postFilter = try QueryBuilders.termQuery()
            .set(field: "color")
            .set(value: "red")
            .build()

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchAllQuery())
            .set(postFilter: postFilter)
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var shirt = Shirt()
        shirt.brand = "gucci"
        shirt.color = "red"
        shirt.model = "slim"
        var request1 = try IndexRequestBuilder<Shirt>()
            .set(index: indexName)
            .set(source: shirt)
            .set(id: "1")
            .build()
        request1.refresh = .true

        shirt.color = "blue"
        var request2 = try IndexRequestBuilder<Shirt>()
            .set(index: indexName)
            .set(source: shirt)
            .set(id: "2")
            .build()
        request1.refresh = .true

        func createIndexHandler(_ result: Result<CreateIndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.acknowledged)")
            }
            client.index(request1) { _ in
                self.client.index(request2, completionHandler: handler1)
            }
        }

        let createIndexRequest = try CreateIndexRequestBuilder()
            .set(name: indexName)
            .set(mappings: [
                "_doc": MappingMetaData(type: nil, fields: nil, analyzer: nil, store: nil, termVector: nil, properties: [
                    "brand": MappingMetaData(type: "keyword", fields: nil, analyzer: nil, store: true, termVector: nil, properties: nil),
                    "color": MappingMetaData(type: "keyword", fields: nil, analyzer: nil, store: true, termVector: nil, properties: nil),
                    "model": MappingMetaData(type: "keyword", fields: nil, analyzer: nil, store: true, termVector: nil, properties: nil),
                ]),
            ])
            .build()

        client.indices.create(createIndexRequest, completionHandler: createIndexHandler)

        waitForExpectations(timeout: 10)
    }

    func test_15_Search_highlight() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.id, "id is nil \(hit)")
                    XCTAssertNotNil(hit.type, "type is nil \(hit)")
                    XCTAssertNotNil(hit.highlightFields, "highlightFields is \(hit)")
                    XCTAssertNotNil(hit.source, "source is nil \(hit)")
                }
            }

            e.fulfill()
        }

        let fieldOptions = FieldOptionsBuilder()
            .set(highlighterType: .plain)
            .set(scoreOrdered: true)
            .build()

        let globalOptions = FieldOptionsBuilder()
            .set(encoder: .html)
            .set(tagScheme: "styled")
            .build()

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchQuery(field: "msg", value: "to test"))
            .set(highlight: .init(fields: [.init("msg", options: fieldOptions)], globalOptions: globalOptions))
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message to test"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_16_Search_rescoring() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count > 0, "Count \(response.hits.hits.count)")
                for hit in response.hits.hits {
                    XCTAssertNotNil(hit.id, "id is nil \(hit)")
                    XCTAssertNotNil(hit.type, "type is nil \(hit)")
                    XCTAssertNotNil(hit.source, "source is nil \(hit)")
                }
            }

            e.fulfill()
        }

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchQuery(field: "msg", value: "the quick brown", operator: .or))
            .add(rescore: .init(query: RescoreQuery(MatchPhraseQuery(field: "msg", value: "the quick brown"), queryWeight: 0.7, rescoreQueryWeight: 1.2)))
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message to test the quick brown fox"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_16_Search_rescoring_2() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<Message>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count == 0, "Count \(response.hits.hits.count)")
            }

            e.fulfill()
        }

        let rescorer = QueryRescorer(query: RescoreQuery(MatchPhraseQuery(field: "msg", value: "the quick brown"), scoreMode: .TOTAL, queryWeight: 0.7, rescoreQueryWeight: 1.2), windowSize: 100)

        let scoreFunction = try ScoreFunctionBuilders.scriptFunction()
            .set(script: Script("Math.log10(doc.likes.value + 2)"))
            .build()

        let functionScore = try FunctionScoreQueryBuilder()
            .add(function: scoreFunction)
            .set(query: MatchAllQuery())
            .build()

        let rescorer1 = QueryRescorer(query: RescoreQuery(functionScore, scoreMode: .MULTIPLY), windowSize: 10)

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchQuery(field: "msg", value: "the quick brown", operator: .or))
            .set(rescore: [rescorer])
            .add(rescore: rescorer1)
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message to test the quick brown fox"
        var request1 = try IndexRequestBuilder<Message>()
            .set(index: indexName)
            .set(source: msg)
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_17_Search_field_collapse() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<CodableValue>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count == 1, "Count \(response.hits.hits.count)")
            }

            e.fulfill()
        }

        let sort = FieldSortBuilder("date").set(order: .asc).build()

        var innerHit = InnerHit()
        innerHit.name = "last_tweets"
        innerHit.size = 5
        innerHit.sort = [sort]

        let collapse = Collapse(field: "user.keyword", innerHits: [innerHit], maxConcurrentGroupRequests: 4)

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchQuery(field: "message", value: "elasticsearch"))
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(source: ["message": "This is elasticsearch", "user": "random_user", "date": CodableValue(Date().timeIntervalSince1970), "likes": 10])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_17_Search_field_collapse_2() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<CodableValue>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count == 1, "Count \(response.hits.hits.count)")
            }

            e.fulfill()
        }

        let sort = FieldSortBuilder("date").set(order: .asc).build()

        var innerHit = InnerHit()
        innerHit.name = "last_tweets"
        innerHit.size = 5
        innerHit.sort = [sort]
        innerHit.collapse = Collapse(field: "user.keyword", innerHits: nil, maxConcurrentGroupRequests: nil)

        let collapse = Collapse(field: "country.keyword", innerHits: [innerHit], maxConcurrentGroupRequests: 4)

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchQuery(field: "message", value: "elasticsearch"))
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(source: ["message": "This is elasticsearch", "user": "random_user", "date": CodableValue(Date().timeIntervalSince1970), "likes": 10, "country": "US"])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_18_Search_searchAfter() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<CodableValue>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count == 1, "Count \(response.hits.hits.count)")
            }

            e.fulfill()
        }

        let request = try SearchRequestBuilder()
            .set(indices: indexName)
            .set(query: MatchQuery(field: "message", value: "elasticsearch"))
            .add(sort: FieldSortBuilder("date").set(order: .asc).build())
            .add(sort: FieldSortBuilder("tie_breaker_id.keyword").set(order: .asc).build())
            .set(searchAfter: [1_463_538_857, "654323"])
            .build()

        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
            case let .success(response):
                logger.info("Found \(response.result)")
            }
            client.search(request, completionHandler: handler)
        }
        var request1 = try IndexRequestBuilder<CodableValue>()
            .set(index: indexName)
            .set(source: ["message": "This is elasticsearch", "tie_breaker_id": "654325", "date": CodableValue(Date().timeIntervalSince1970), "likes": 10, "country": "US"])
            .build()
        request1.refresh = .true
        client.index(request1, completionHandler: handler1)

        waitForExpectations(timeout: 10)
    }

    func test_19_Search_search() throws {
        let e = expectation(description: "execution complete")

        func handler(_ result: Result<SearchResponse<CodableValue>, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssertNotNil(response.hits)
                XCTAssertTrue(response.hits.hits.count == 0, "Count \(response.hits.hits.count)")
            }

            e.fulfill()
        }

        let request = SearchRequest(indices: indexName)

        client.search(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
    }

    func test_20_searchSource() throws {
        var s1 = SearchSource()
        s1.query = MatchAllQuery()
        s1.rescore = [.init(query: .init(MatchAllQuery(), scoreMode: .AVG, queryWeight: 1.0, rescoreQueryWeight: 1.3))]
        s1.sorts = [FieldSortBuilder("test_field").build()]
        s1.scriptFields = [.init(field: "test", script: Script("test script"))]

        let encoded = try JSONEncoder().encode(s1)

        logger.info("Encoded: \(String(data: encoded, encoding: .utf8) ?? "nil")")

        let decoded = try JSONDecoder().decode(SearchSource.self, from: encoded)

        logger.info("Decoded: \(decoded)")

        XCTAssert(s1 == decoded)
    }
}

struct Shirt: Codable, Equatable {
    var brand: String?
    var color: String?
    var model: String?

    init() {}
}
