import XCTest

@testable import ElasticSwift

class ElasticSwiftTests: XCTestCase {
    
    var client: ElasticClient?
    
    override func setUp() {
        super.setUp()
        print("====================TEST=START===============================")
        self.client = ElasticClient()
//        let cred = ClientCredential(username: "elastic", password: "elastic")
//        let ssl = SSLConfiguration(certPath: "/usr/local/Cellar/kibana/6.1.2/config/certs/elastic-certificates.der", isSelf: true)
//        let settings = Settings(forHosts: ["https://localhost:9200"], withCredentials: cred, withSSL: true, sslConfig: ssl)
//        self.client = RestClient(settings: settings)
    }
    
    override func tearDown() {
        super.tearDown()
        
        print("====================TEST=END===============================")
    }
    
    func testPlay() {
        
        //print(JSON(["field":"value"]).rawString()!)
        var query = [String: Any]()
        query["query"] = ["field":"value"]
        //print(JSON(query).rawString()!)
        //var query2 = [String: Any]()
        //query2["query"] = JSON(["field": [:]]).rawString()!
        //print(JSON(query2).rawString()!)
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
                    print("Error", error)
                    XCTAssert(false)
                case .success(let response):
                    print("Response: ", response)
                    XCTAssert(response.acknowledged, "\(response.acknowledged)")
                    XCTAssert(response.index == "test", "\(response.index)")
                    XCTAssert(response.shardsAcknowledged, "\(response.shardsAcknowledged)")
            }
            e.fulfill()
        }
        let createIndexRequest = CreateIndexRequest(name: "test")
        
        func handler1(_ result: Result<AcknowledgedResponse, Error>) -> Void {
            
            switch result {
                case .failure(let error):
                    print("Error", error)
                case .success(let response):
                    print("Response", response)
            }
            
            self.client?.indices.create(createIndexRequest, completionHandler: handler)
        }
        let deleteIndexRequest = DeleteIndexRequest(name: "test")
        
        self.client?.indices.delete(deleteIndexRequest, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_03_GetIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<GetIndexResponse, Error>) -> Void {
            
            switch result {
                case .failure(let error):
                    print("Error", error)
                    XCTAssert(false)
                case .success(let response):
                    print("Response", response)
                    XCTAssert(response.settings.providedName == "test", "Index: \(response.settings.providedName)")
            }
            e.fulfill()
        }
        let request = GetIndexRequest(name: "test")
        
        self.client?.indices.get(request, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_04_Index() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                print("Response: ", response)
                XCTAssert(response.index == "test", "Index: \(response.index)")
                XCTAssert(response.id == "0", "_id \(response.id)")
                XCTAssert(response.type == "_doc", "Type: \(response.type)")
                XCTAssert(!response.result.isEmpty, "Resule: \(response.result)")
            }
            e.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request = try IndexRequestBuilder<Message>() { builder in
            _ = builder.set(index: "test")
                .set(type: "_doc")
                .set(id: "0")
                .set(source: msg)
        }
        .build()
        
        self.client?.execute(request: request, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_05_IndexNoId() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                print("Response: ", response)
                XCTAssert(response.index == "test", "Index: \(response.index)")
                XCTAssert(response.type == "_doc", "Type: \(response.type)")
                XCTAssert(!response.result.isEmpty, "Resule: \(response.result)")
            }
            e.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message No Id"
        let request = try IndexRequestBuilder<Message>() { builder in
            _ = builder.set(index: "test")
                .set(type: "_doc")
                .set(source: msg)
        }
        .build()
        
        self.client?.execute(request: request, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_06_Get() throws {
        
         let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<GetResponse<Message>, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error: ", String(reflecting: error))
                XCTAssert(false, String(reflecting: error))
            case .success(let response):
                print("Response: ", response)
                XCTAssert(response.found, "Found: \(response.found)")
                XCTAssert(response.index == "test", "Index: \(response.index)")
                XCTAssert(response.id == "0", "_id: \(response.id)")
                XCTAssert(response.type == "_doc", "Found: \(response.type)")
            }
            e.fulfill()
        }
        
        let request = try GetRequestBuilder<Message>() { builder in
            builder.set(id: "0")
                .set(index: "test")
                .set(type: "_doc")
            
        }
        .build()
        
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error", error)
            case .success(let response):
                print("Found", response.result)
            }
            client?.execute(request: request, completionHandler: handler)
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request1 = try IndexRequestBuilder<Message>() { builder in
            _ = builder.set(index: "test")
                .set(type: "_doc")
                .set(id: "0")
                .set(source: msg)
            
        } .build()
        
        self.client?.execute(request: request1, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
    
    func test_07_Delete() throws {
        
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<DeleteResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                print("Respone", response)
                XCTAssert(response.result == "deleted", "Result: \(response.result!)")
                XCTAssert(response.id == "0", "_id: \(response.id!)")
                XCTAssert(response.index == "test", "index: \(response.index!)")
                XCTAssert(response.type == "_doc", "Type: \(response.type!)")
            }
            e.fulfill()
        }
        let request = try DeleteRequestBuilder() { builder in
            builder.set(index: "test")
                .set(type: "_doc")
                .set(id: "0")
        } .build()
        
        /// make sure doc exists
        func handler1(_ result: Result<IndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error: ", error)
            case .success(let response):
                print("Result", response.result)
            }
            
            self.client?.execute(request: request, completionHandler: handler)
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request1 =  try IndexRequestBuilder<Message>() { builder in
            _ = builder.set(index: "test")
                .set(type: "_doc")
                .set(id: "0")
                .set(source: msg)
            
        } .build()
        self.client?.execute(request: request1, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_08_Search() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ result: Result<SearchResponse<Message>, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error: ", error)
                XCTAssert(false)
            case .success(let response):
                XCTAssertNotNil(response.hits)
            }
            
            e.fulfill()
        }
        let queryBuilder = QueryBuilders.boolQuery()
        let match = QueryBuilders.matchQuery().set(field: "msg").set(value: "Message")
        queryBuilder.must(query: match)
        let sort =  SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let request: SearchRequest<Message> = try SearchRequestBuilder() { builder in
            builder.set(indices: "test")
                .set(types: "_doc")
                .set(query: queryBuilder.query)
                .set(sort: sort)
        } .build()
        self.client?.execute(request: request, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_09_DeleteIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<AcknowledgedResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error", error)
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                print("Response: ", response)
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            e.fulfill()
        }
        let request = DeleteIndexRequest(name: "test")
        
        /// make sure index exists
        func handler1(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error", error)
            case .success(let response):
                print("Response: ", response)
            }
            self.client?.execute(request: request, completionHandler: handler)
        }
        
        let request1 = CreateIndexRequest(name: "test")
        self.client?.execute(request: request1, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
    
    func test_10_IndexExists() throws {
        let e = expectation(description: "execution complete")
        
        let existsRequest = IndexExistsRequest(name: "test")
        
        let getIndexRequest = GetIndexRequest(name: "test")
        
        func existsFalseHander(_ result: Result<IndexExistsResponse, Error>) -> Void {
            switch result {
            case .failure(let error):
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                print("Response: ", response)
                XCTAssert(!response.exists, "IndexExists: \(response.exists)")
            }
            e.fulfill()
        }
        
        
        func handler(_ result: Result<AcknowledgedResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error", error)
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                print("Response: ", response)
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            self.client?.indices.exists(getIndexRequest, completionHandler: existsFalseHander)
        }
        let deleteRequest = DeleteIndexRequest(name: "test")
        
        func existsTrueHander(_ result: Result<IndexExistsResponse, Error>) -> Void {
            switch result {
            case .failure(let error):
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            case .success(let response):
                print("Response: ", response)
                XCTAssert(response.exists, "IndexExists: \(response.exists)")
            }
            self.client?.indices.delete(deleteRequest, completionHandler: handler)
        }
        
        
        /// make sure index exists
        func createIndexRequestHandler(_ result: Result<CreateIndexResponse, Error>) -> Void {
            
            switch result {
            case .failure(let error):
                print("Error", error)
            case .success(let response):
                print("Response: ", response)
            }
            self.client?.indices.exists(existsRequest, completionHandler: existsTrueHander)
        }
        
        let createIndexRequest = CreateIndexRequest(name: "test")
        self.client?.indices.create(createIndexRequest, completionHandler: createIndexRequestHandler)
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

class Message: Codable {
    var msg: String?
    
    init() {
        
    }
}
