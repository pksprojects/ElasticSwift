import XCTest
import Logging

@testable import ElasticSwift
@testable import ElasticSwiftQueryDSL
@testable import ElasticSwiftCodableUtils

let logFactory: ((String) -> LogHandler) = { label -> LogHandler in
    var handler = StreamLogHandler.standardOutput(label: label)
    handler.logLevel = .debug
    return handler
}

let isLoggingConfigured: Bool = {
    LoggingSystem.bootstrap { label in
        var handler = StreamLogHandler.standardOutput(label: label)
        handler.logLevel = .debug
        return handler
    }
    return true
}()

class ElasticSwiftTests: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.ElasticSwiftTests", factory: logFactory)
    
    var client: ElasticClient?
    
    override func setUp() {
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
        self.client = ElasticClient()
//        let cred = ClientCredential(username: "elastic", password: "elastic")
//        let ssl = SSLConfiguration(certPath: "/usr/local/Cellar/kibana/6.1.2/config/certs/elastic-certificates.der", isSelf: true)
//        let settings = Settings(forHosts: ["https://localhost:9200"], withCredentials: cred, withSSL: true, sslConfig: ssl)
//        self.client = RestClient(settings: settings)
    }
    
    override func tearDown() {
        super.tearDown()
        
        logger.info("====================TEST=END===============================")
    }
    
    func testPlay() {
        
        //logger.info(JSON(["field":"value"]).rawString()!)
        var query = [String: Any]()
        query["query"] = ["field":"value"]
        //logger.info(JSON(query).rawString()!)
        //var query2 = [String: Any]()
        //query2["query"] = JSON(["field": [:]]).rawString()!
        //logger.info(JSON(query2).rawString()!)
        sleep(1)
    }
    
    func test_01_Client() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let settings = Settings.default
        let client = ElasticClient(settings: settings)
        XCTAssertNotNil(client)
    }
    
    func test_02_CreateIndex() throws {
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
            
            self.client?.indices.create(createIndexRequest, completionHandler: handler)
        }
        let deleteIndexRequest = DeleteIndexRequest("test")
        
        self.client?.indices.delete(deleteIndexRequest, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_03_GetIndex() throws {
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
        
        self.client?.indices.get(request, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_04_Index() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.index == "test", "Index: \(response.index)")
                XCTAssert(response.id == "0", "_id \(response.id)")
                XCTAssert(response.type == "_doc", "Type: \(response.type)")
                XCTAssert(!response.result.isEmpty, "Resule: \(response.result)")
            }
            e.fulfill()
        }
        var msg = Message()
        msg.msg = "Test Message"
        let request = try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .set(source: msg)
            .build()
        
        self.client?.execute(request: request, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_05_IndexNoId() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.index == "test", "Index: \(response.index)")
                XCTAssert(response.type == "_doc", "Type: \(response.type)")
                XCTAssert(!response.result.isEmpty, "Resule: \(response.result)")
            }
            e.fulfill()
        }
        var msg = Message()
        msg.msg = "Test Message No Id"
        let request = try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(source: msg)
            .build()
        
        self.client?.execute(request: request, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_06_Get() throws {
        
         let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<GetResponse<Message>, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(String(reflecting: error))")
                XCTAssert(false, String(reflecting: error))
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.found, "Found: \(response.found)")
                XCTAssert(response.index == "test", "Index: \(response.index)")
                XCTAssert(response.id == "0", "_id: \(response.id)")
                XCTAssert(response.type == "_doc", "Found: \(String(describing: response.type))")
            }
            e.fulfill()
        }
        
        let request = try GetRequestBuilder()
            .set(id: "0")
            .set(index: "test")
            .set(type: "_doc")
            .build()
        
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Found \(response.result)")
            }
            client?.execute(request: request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Test Message"
        let request1 = try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .set(source: msg)
            .build()
        
        self.client?.execute(request: request1, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
    
    func test_07_Delete() throws {
        
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<DeleteResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.result == "deleted", "Result: \(response.result)")
                XCTAssert(response.id == "0", "_id: \(response.id)")
                XCTAssert(response.index == "test", "index: \(response.index)")
                XCTAssert(response.type == "_doc", "Type: \(response.type)")
            }
            e.fulfill()
        }
        let request = try DeleteRequestBuilder()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .build()
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Result: \(response.result)")
            }
            
            self.client?.execute(request: request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Test Message"
        let request1 =  try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .set(source: msg)
            .build()
        self.client?.execute(request: request1, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_08_Search() throws {
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
            .set(indices: "test")
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
            self.client?.search(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "Message"
        var request1 =  try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(source: msg)
            .build()
        request1.refresh = .true
        self.client?.execute(request: request1, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_09_IndexExists() throws {
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
            self.client?.indices.exists(getIndexRequest, completionHandler: existsFalseHander)
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
            self.client?.indices.delete(deleteRequest, completionHandler: handler)
        }
        
        
        /// make sure index exists
        func createIndexRequestHandler(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Response: \(response)")
            }
            self.client?.indices.exists(existsRequest, completionHandler: existsTrueHander)
        }
        
        let createIndexRequest = CreateIndexRequest("test")
        self.client?.indices.create(createIndexRequest, completionHandler: createIndexRequestHandler)
        waitForExpectations(timeout: 10)
    }
    
    func test_10_UpdateRequest() throws {
        
        let e = expectation(description: "execution complete")
        
        let params: [String: CodableValue] = ["msg": "Updated Message"]
        let script = Script("ctx._source.msg = params.msg", lang: "painless", params: params)
        let updateRequest = try UpdateRequestBuilder()
            .set(id: "0")
            .set(index: "test")
            .set(script: script)
            .build()
        
        let msg = Message("Test Message")
        let indexRequest = IndexRequest(index: "test", id: "0", source: msg)
        
        self.client?.index(indexRequest) { result in
            switch result {
            case .success(let response):
                self.logger.info("Response: \(response)")
            case .failure(let error):
                self.logger.error("Error: \(error)")
            }
            self.client?.update(updateRequest) { result in
                switch result {
                case .success(let response):
                    self.logger.info("Updated Response: \(response)")
                    XCTAssertTrue(response.id == "0", "id: \(response.id)")
                    XCTAssertTrue(response.result == "updated", "result: \(response.result)")
                case .failure(let error):
                    self.logger.error("Error: \(error)")
                    XCTAssertTrue(false)
                }
                e.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func test_11_UpdateRequest() throws {
            
        let e = expectation(description: "execution complete")
        
        let script = Script("ctx._source.msg = 'hello'")
        let updateRequest = try UpdateRequestBuilder()
            .set(id: "1")
            .set(index: "test")
            .set(script: script)
            .build()
        
        let msg = Message("Test Message")
        let indexRequest = IndexRequest(index: "test", id: "1", source: msg)
        
        self.client?.index(indexRequest) { result in
            switch result {
            case .success(let response):
                self.logger.info("Response: \(response)")
            case .failure(let error):
                self.logger.error("Error: \(error)")
            }
            self.client?.update(updateRequest) { result in
                switch result {
                case .success(let response):
                    self.logger.info("Updated Response: \(response)")
                    XCTAssertTrue(response.id == "1", "id: \(response.id)")
                    XCTAssertTrue(response.result == "updated", "result: \(response.result)")
                case .failure(let error):
                    self.logger.error("Error: \(error)")
                    XCTAssertTrue(false)
                }
                e.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func test_12_UpdateRequest_noop() throws {
                
        let e = expectation(description: "execution complete")
        
        let updateRequest = try UpdateRequestBuilder()
            .set(id: "2")
            .set(index: "test")
            .set(doc: ["msg": "Test Message"])
            .build()
        
        let msg = Message("Test Message")
        let indexRequest = IndexRequest(index: "test", id: "2", source: msg)
        
        self.client?.index(indexRequest) { result in
            switch result {
            case .success(let response):
                self.logger.info("Response: \(response)")
            case .failure(let error):
                self.logger.error("Error: \(error)")
            }
            self.client?.update(updateRequest) { result in
                switch result {
                case .success(let response):
                    self.logger.info("Updated Response: \(response)")
                    XCTAssertTrue(response.id == "2", "id: \(response.id)")
                    XCTAssertTrue(response.result == "noop", "result: \(response.result)")
                case .failure(let error):
                    self.logger.error("Error: \(error)")
                    XCTAssertTrue(false)
                }
                e.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func test_13_UpdateRequest_noop_2() throws {
                    
        let e = expectation(description: "execution complete")
        
        let updateRequest = try UpdateRequestBuilder()
            .set(id: "3")
            .set(index: "test")
            .set(doc: ["msg": "Test Message"])
            .set(detectNoop: false)
            .build()
        
        let msg = Message("Test Message")
        let indexRequest = IndexRequest(index: "test", id: "3", source: msg)
        
        self.client?.index(indexRequest) { result in
            switch result {
            case .success(let response):
                self.logger.info("Response: \(response)")
            case .failure(let error):
                self.logger.error("Error: \(error)")
            }
            self.client?.update(updateRequest) { result in
                switch result {
                case .success(let response):
                    self.logger.info("Updated Response: \(response)")
                    XCTAssertTrue(response.id == "3", "id: \(response.id)")
                    XCTAssertTrue(response.result != "noop", "result: \(response.result)")
                case .failure(let error):
                    self.logger.error("Error: \(error)")
                    XCTAssertTrue(false)
                }
                e.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
    }

    func test_14_UpdateRequest_upsert_script() throws {
                        
        let e = expectation(description: "execution complete")
        
        let script = Script("ctx._source.msg = params.msg", lang: "painless", params: ["msg": "upsert script"])
        let updateRequest = try UpdateRequestBuilder()
            .set(id: "abcdef")
            .set(index: "test")
            .set(script: script)
            .set(upsert: ["msg": "Test Message"])
            .build()
        
        self.client?.update(updateRequest) { result in
            switch result {
            case .success(let response):
                self.logger.info("Updated Response: \(response)")
                XCTAssertTrue(response.id == "abcdef", "id: \(response.id)")
                XCTAssertTrue(response.result == "created", "result: \(response.result)")
            case .failure(let error):
                self.logger.error("Error: \(error)")
                XCTAssertTrue(false)
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func test_15_UpdateRequest_scripted_upsert() throws {
                        
        let e = expectation(description: "execution complete")
        
        let script = Script("ctx._source.msg = params.msg", lang: "painless", params: ["msg": "scripted upsert"])
        
        let updateRequest = try UpdateRequestBuilder()
            .set(id: "abcdefg")
            .set(index: "test")
            .set(script: script)
            .set(scriptedUpsert: true)
            .set(upsert: [:])
            .build()
        
        self.client?.update(updateRequest) { result in
            switch result {
            case .success(let response):
                self.logger.info("Updated Response: \(response)")
                XCTAssertTrue(response.id == "abcdefg", "id: \(response.id)")
                XCTAssertTrue(response.result == "created", "result: \(response.result)")
            case .failure(let error):
                self.logger.error("Error: \(error)")
                XCTAssertTrue(false)
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    
    func test_16_UpdateRequest_doc_as_upsert() throws {
                        
        let e = expectation(description: "execution complete")
        
        let updateRequest = try UpdateRequestBuilder()
            .set(id: "3docAsUpsert")
            .set(index: "test")
            .set(doc: ["msg": "Test Message"])
            .set(docAsUpsert: true)
            .build()
        
        self.client?.update(updateRequest) { result in
            switch result {
            case .success(let response):
                self.logger.info("Updated Response: \(response)")
                XCTAssertTrue(response.id == "3docAsUpsert", "id: \(response.id)")
                XCTAssertTrue(response.result == "created", "result: \(response.result)")
            case .failure(let error):
                self.logger.error("Error: \(error)")
                XCTAssertTrue(false)
            }
            e.fulfill()
        }


        waitForExpectations(timeout: 10)
    }
    
    func test_17_DeleteByQuery() throws {
        
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<DeleteByQueryResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.deleted == 1, "Result: \(response.deleted)")
            }
            e.fulfill()
        }
        
        let query = try! QueryBuilders.matchQuery()
            .set(field: "msg")
            .set(value: "DeleteByQuery")
            .build()
        
        var request = try DeleteByQueryRequestBuilder()
            .set(index: "test")
            .set(query: query)
            .build()
        
        request.refresh = .true
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Result: \(response.result)")
            }
            
            self.client?.deleteByQuery(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "DeleteByQuery"
        var request1 =  try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(source: msg)
            .build()
        request1.refresh = .true
        self.client?.execute(request: request1, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_18_UpdateByQuery() throws {
        
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<UpdateByQueryResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.updated == 1, "Result: \(response.updated)")
            }
            e.fulfill()
        }
        
        let query = try! QueryBuilders.matchQuery()
            .set(field: "msg")
            .set(value: "UpdateByQuery")
            .build()
        
        var request = try UpdateByQueryRequestBuilder()
            .set(index: "test")
            .set(query: query)
            .build()
        
        request.refresh = .true
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Result: \(response.result)")
            }
            
            self.client?.updateByQuery(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "UpdateByQuery"
        var request1 =  try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(source: msg)
            .build()
        request1.refresh = .true
        self.client?.execute(request: request1, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_19_UpdateByQuery_script() throws {
        
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<UpdateByQueryResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.updated == 1, "Result: \(response.updated)")
            }
            e.fulfill()
        }
        
        let query = try! QueryBuilders.matchQuery()
            .set(field: "msg")
            .set(value: "UpdateByQuery2")
            .build()
        let script = Script("ctx._source.msg = 'hello'")
        var request = try UpdateByQueryRequestBuilder()
            .set(index: "test")
            .set(query: query)
            .set(script: script)
            .build()
        
        request.refresh = .true
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Result: \(response.result)")
            }
            
            self.client?.updateByQuery(request, completionHandler: handler)
        }
        var msg = Message()
        msg.msg = "UpdateByQuery2"
        var request1 =  try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(source: msg)
            .build()
        request1.refresh = .true
        self.client?.execute(request: request1, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_20_mget() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<MultiGetResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssertNotNil(response.responses, "Responses: \(response.responses)")
            }
            e.fulfill()
        }
        let request = try MultiGetRequestBuilder()
            .set(index: "test")
            .add(item: .init(index: "test", id: "0"))
            .add(item: .init(index: "test", id: "1000"))
            .add(item: .init(index: "doesntExists", id: "0"))
            .build()
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
            case .success(let response):
                logger.info("Response: \(response)")
            }
            self.client?.mget(request, completionHandler: handler)
        }
        
        var msg = Message()
        msg.msg = "UpdateByQuery2"
        var request1 =  try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .set(source: msg)
            .build()
        request1.refresh = .true
        self.client?.index(request1, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
    
    func test_21_ReIndex() throws {
        let e = expectation(description: "execution complete")
        
        let source =  ReIndexRequest.Source(index: "test")
        let dest = ReIndexRequest.Destination.init(index: "testdest")
        
        let reIndexRequest =  try ReIndexRequestBuilder()
            .set(source: source)
            .set(destination: dest)
            .set(refresh: true)
            .set(timeout: "1m")
            .set(waitForCompletion: true)
            .build()
        
        
        func resultHandler(_ result: Result<ReIndexResponse, Error>) -> Void {
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
            }
            e.fulfill()
        }
        
        /// make sure index exists
        func handler(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
            }
            self.client?.reIndex(reIndexRequest, completionHandler: resultHandler)
        }
        var msg = Message()
        msg.msg = "Test Message No Id"
        let request = try IndexRequestBuilder<Message>()
            .set(index: "test")
            .set(type: "_doc")
            .set(source: msg)
            .build()
        
        self.client?.execute(request: request, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_22_ReIndexRequestBuilder_throws() throws {
        let e = expectation(description: "execution complete")
        
        XCTAssertThrowsError(try ReIndexRequestBuilder().set(size: 100).set(slices: 10).set(requestsPerSecond: 0).set(waitForActiveShards: "all").build(), "missing source", { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case .missingRequiredField(let field):
                    XCTAssertEqual("source", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        })
        
        waitForExpectations(timeout: 10)
    }
    
    func test_23_ReIndexRequestBuilder_throws_2() throws {
        let e = expectation(description: "execution complete")
        
        let source = ReIndexRequest.Source(index: "test")
        let script = Script("if (ctx._source.foo == 'bar') {ctx._version++; ctx._source.remove('foo')}", lang: "painless")
        
        XCTAssertThrowsError(try ReIndexRequestBuilder().set(source: source).set(script: script).build(), "missing destination", { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case .missingRequiredField(let field):
                    XCTAssertEqual("destination", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        })
        
        waitForExpectations(timeout: 10)
    }
    
    func test_24_TermVectorsRequest() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<TermVectorsResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.found, "Found: \(response.found)")
            }
            e.fulfill()
        }
        
        let request = try TermVectorsRequestBuilder()
            .set(doc: ["fullname": "John Doe", "text": "twitter test test test"])
            .set(index: "test")
            .set(type: "_doc")
            .build()
        
        self.client?.termVectors(request, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_25_TermVectorsRequestBuilder_throws() throws {
        let e = expectation(description: "execution complete")
        
        XCTAssertThrowsError(try TermVectorsRequestBuilder().build(), "missing index", { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case .missingRequiredField(let field):
                    XCTAssertEqual("index", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        })
        
        waitForExpectations(timeout: 10)
    }
    
    func test_26_TermVectorsRequestBuilder_throws_2() throws {
        let e = expectation(description: "execution complete")
        
        XCTAssertThrowsError(try TermVectorsRequestBuilder().set(index: "index").build(), "missing type", { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case .missingRequiredField(let field):
                    XCTAssertEqual("type", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        })
        
        waitForExpectations(timeout: 10)
    }
    
    func test_27_TermVectorsRequestBuilder_throws_3() throws {
        let e = expectation(description: "execution complete")
        
        XCTAssertThrowsError(try TermVectorsRequestBuilder().set(index: "index").set(type: "type").build(), "missing id and doc", { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? RequestBuilderError {
                switch error {
                case .missingRequiredField(let field):
                    XCTAssertEqual("id or doc", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        })
        
        waitForExpectations(timeout: 10)
    }
    
    func test_28_TermVectorsRequestBuilder_throws_4() throws {
        let e = expectation(description: "execution complete")
        
        XCTAssertNoThrow(try TermVectorsRequestBuilder().set(index: "index").set(type: "type").set(id: "id").build(), "Should not throw")
        e.fulfill()
        
        waitForExpectations(timeout: 10)
    }
    
    func test_29_TermVectorsRequestBuilder_throws_5() throws {
        let e = expectation(description: "execution complete")
        
        XCTAssertNoThrow(try TermVectorsRequestBuilder().set(index: "index").set(type: "type").set(doc: ["test": "test"]).build(), "Should not throw")
        e.fulfill()
        
        waitForExpectations(timeout: 10)
    }
    
    func test_30_TermVectorsRequest_2() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<TermVectorsResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.found, "Found: \(response.found)")
            }
            e.fulfill()
        }
        
        let request = try TermVectorsRequestBuilder()
            .set(doc: ["fullname": "John Doe", "text": "twitter test test test"])
            .set(index: "test")
            .set(type: "_doc")
            .set(fields: ["fullname", "text"])
            .set(fieldStatistics: false)
            .build()
        
        self.client?.termVectors(request, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_31_TermVectorsRequest_3() throws {
        let e = expectation(description: "execution complete")
        
        let deleteIndexReqeust = try DeleteIndexRequestBuilder().set(name: "twitter").build()
        
        func handler(_ result: Result<TermVectorsResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.found, "Found: \(response.found)")
            }
            self.client?.indices.delete(deleteIndexReqeust) { result in
                switch result {
                case .failure(let error):
                    self.logger.error("Error: \(error)")
                    XCTAssert(false, error.localizedDescription)
                case .success(let response):
                    self.logger.info("Response: \(response)")
                    XCTAssert(response.acknowledged, "Acknowledged: \(response.acknowledged)")
                }
            }
            e.fulfill()
        }
        
        let request = try TermVectorsRequestBuilder()
            .set(id: "1")
            .set(index: "twitter")
            .set(type: "_doc")
            .set(fields: ["text"])
            .build()
        
        var indexRequest = try IndexRequestBuilder<Tweet>()
            .set(index: "twitter")
            .set(type: "_doc")
            .set(source: Tweet(fullname: "John Doe", text: "twitter test test test "))
            .set(id: "1")
            .build()
        
        var indexRequest2 = try IndexRequestBuilder<Tweet>()
            .set(index: "twitter")
            .set(type: "_doc")
            .set(source: Tweet(fullname: "John Doe", text: "Another twitter test ..."))
            .set(id: "2")
            .build()
        indexRequest.refresh = .true
        indexRequest2.refresh = .true
        
        func createIndexHandler(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                logger.info("Response: \(response)")
                XCTAssert(response.acknowledged, "Acknowledged: \(response.acknowledged)")
                self.client?.index(indexRequest) { result in
                    switch result {
                    case .failure(let error):
                        self.logger.error("Error: \(error)")
                        XCTAssert(false, error.localizedDescription)
                    case .success(let response):
                        self.logger.info("Response: \(response)")
                        XCTAssert(response.id == "1", "ID: \(response.id)")
                    }
                }
                self.client?.index(indexRequest2) { result in
                    switch result {
                    case .failure(let error):
                        self.logger.error("Error: \(error)")
                        XCTAssert(false, error.localizedDescription)
                    case .success(let response):
                        self.logger.info("Response: \(response)")
                        XCTAssert(response.id == "2", "ID: \(response.id)")
                        self.client?.termVectors(request, completionHandler: handler)
                    }
                }
            }
        }
        
        let createIndexRequest = try CreateIndexRequestBuilder()
            .set(name: "twitter")
            .set(settings:  [
                "index": [
                    "number_of_shards": 1,
                    "number_of_replicas": 0
                ],
                "analysis": [
                    "analyzer": [
                        "fulltext_analyzer": [
                            "type": "custom",
                            "tokenizer": "whitespace",
                            "filter": ["lowercase", "type_as_payload"]
                        ]
                    ]
                ]
            ])
            .set(mappings:  [
                "_doc": MappingMetaData(type: nil, fields: nil, properties: [
                    "text": MappingMetaData(type: "text", fields: nil, properties: nil),
                    "fullname": MappingMetaData(type: "text", fields: nil, properties: nil)
                ])
            ])
            .build()
        
        
        self.client?.indices.create(createIndexRequest, completionHandler: createIndexHandler)
        
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
            self.client?.execute(request: request, completionHandler: handler)
        }
        
        let request1 = CreateIndexRequest("test")
        self.client?.execute(request: request1, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
    
//    static var allTests = [
//        ("testPlay", testPlay),
//        ("testClient", testClient),
//        ("testCreateIndex", testCreateIndex),
//        ("testGetIndex", testGetIndex),
//        ("testIndex", testIndex),
//        ("testIndexNoId", testIndexNoId),
//        ("testGet", testGet),
//        ("testDelete", testDelete),
//        ("testDeleteIndex", testDeleteIndex)
//    ]
}

struct Message: Codable, Equatable {
    var msg: String?
    
    init() {}
    
    init(_ msg: String) {
        self.msg = msg
    }
}

struct Tweet: Codable, Equatable {
    public let fullname: String
    public let text: String
}
