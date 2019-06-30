import XCTest

@testable import ElasticSwift

class ElasticSwiftTests: XCTestCase {
    
    var client: RestClient?
    
    override func setUp() {
        super.setUp()
        print("====================TEST=START===============================")
        self.client = RestClient()
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
        let client = RestClient(settings: settings)
        XCTAssertNotNil(client)
    }
    
    func test_02_CreateIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ response: CreateIndexResponse?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
                XCTAssert(false)
            }
            if let response = response {
                print("Response: ", response)
                XCTAssert(response.acknowledged, "\(response.acknowledged)")
                XCTAssert(response.index == "test", "\(response.index)")
                XCTAssert(response.shardsAcknowledged, "\(response.shardsAcknowledged)")
            }
            e.fulfill()
        }
        let request = self.client?.indices().createIndex()
            .set(name: "test")
            .build()
        
        
        func handler1(_ response: AcknowledgedResponse?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
            }
            if let response = response {
                print("Response: ", response)
            }
            self.client?.execute(request: request!, completionHandler: handler)
        }
        let request1 = try self.client?.indices().deleteIndex()
            .set(name: "test")
            .build()
        
        self.client?.execute(request: request1!, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_03_GetIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ response: GetIndexResponse?, _ error: Error?) -> Void {
            print("Error: ", error ?? "nil")
            XCTAssertNil(error)
            if let response = response {
                print("Response: ", response)
                XCTAssert(response.settings.providedName == "test", "Index: \(response.settings.providedName)")
            }
            e.fulfill()
        }
        let request = try self.client?.indices().getIndex()
            .set(name: "test")
            .build()
        
        self.client?.execute(request: request!, completionHandler: handler)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_04_Index() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            }
            if let response = response {
                print("Response: ", response)
                XCTAssert(response.index == "test", "Index: \(response.index!)")
                XCTAssert(response.id == "0", "_id \(response.id!)")
                XCTAssert(response.type == "_doc", "Type: \(response.type!)")
                XCTAssert(response.result != nil, "Resule: \(response.result!)")
            }
            e.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request = try self.client?.makeIndex()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .set(source: msg)
            .build()
        
        self.client?.execute(request: request!, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_05_IndexNoId() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            }
            if let response = response {
                print("Response: ", response)
                XCTAssert(response.index == "test", "Index: \(response.index!)")
                XCTAssert(response.type == "_doc", "Type: \(response.type!)")
                XCTAssert(response.result != nil, "Resule: \(response.result!)")
            }
            e.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message No Id"
        let request = try self.client?.makeIndex()
            .set(index: "test")
            .set(type: "_doc")
            .set(source: msg)
            .build()
        
        self.client?.execute(request: request!, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_06_Get() throws {
        
         let e = expectation(description: "execution complete")
        
        func handler(_ response: GetResponse<Message>?, _ error: Error?) -> Void {
            if let error = error {
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            }
            if let response = response {
                print("Response: ", response)
                XCTAssert(response.found!, "Found: \(response.found!)")
                XCTAssert(response.index! == "test", "Index: \(response.index!)")
                XCTAssert(response.id! == "0", "_id: \(response.id!)")
                XCTAssert(response.type! == "_doc", "Found: \(response.type!)")
            }
            e.fulfill()
        }
        
        let request: GetRequest<Message>? = self.client?.makeGet()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .build()
        
        
        /// make sure doc exists
        func handler1(_ response: IndexResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print(error)
            }
            if let response = response {
                print("Found", response.result!)
            }
            client?.execute(request: request!, completionHandler: handler)
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request1 = try self.client?.makeIndex()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .set(source: msg)
            .build()
        
        self.client?.execute(request: request1!, completionHandler: handler1)
        waitForExpectations(timeout: 10)
    }
    
    func test_07_Delete() throws {
        
        let e = expectation(description: "execution complete")
        
        func handler(_ response: DeleteResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print("Error: ", error)
                XCTAssert(false, error.localizedDescription)
            }
            if let response = response {
                print("Respone", response)
                XCTAssert(response.result == "deleted", "Result: \(response.result!)")
                XCTAssert(response.id == "0", "_id: \(response.id!)")
                XCTAssert(response.index == "test", "index: \(response.index!)")
                XCTAssert(response.type == "_doc", "Type: \(response.type!)")
            }
            e.fulfill()
        }
        let request = try self.client?.makeDelete()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .build()
        
        /// make sure doc exists
        func handler1(_ response: IndexResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print("Error: ", error)
            }
            if let response = response {
                print("Result", response.result!)
            }
            self.client?.execute(request: request!, completionHandler: handler)
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request1 = try self.client?.makeIndex()
            .set(index: "test")
            .set(type: "_doc")
            .set(id: "0")
            .set(source: msg)
            .build()

        self.client?.execute(request: request1!, completionHandler: handler1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_08_Search() throws {
        let e = expectation(description: "execution complete")
        
        func handler(_ response: SearchResponse<Message>?, _ error: Error?) -> Void {
            print("Error: ", error ?? "nil")
            XCTAssertNil(error)
            XCTAssertNotNil(response?.hits)
            e.fulfill()
        }
        let builder = QueryBuilders.boolQuery()
        let match = QueryBuilders.matchQuery().set(field: "msg").set(value: "Message")
        builder.must(query: match)
        let sort =  SortBuilders.fieldSort("msg.keyword")
            .set(order: .asc)
            .build()
        let request: SearchRequest<Message>? = try self.client?.makeSearch()
            .set(indices: "test")
            .set(types: "_doc")
            .set(query: builder.query)
            .set(sort: sort)
            .build()
        self.client?.execute(request: request!, completionHandler: handler)
        waitForExpectations(timeout: 10)
    }
    
    func test_09_DeleteIndex() throws {
        let e = expectation(description: "execution complete")
        func handler(_ response: AcknowledgedResponse?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
                XCTAssert(false, error.localizedDescription)
            }
            if let response = response {
                print("Response: ", response)
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            e.fulfill()
        }
        let request = try self.client?.indices().deleteIndex()
            .set(name: "test")
            .build()
        
        /// make sure index exists
        func handler1(_ response: CreateIndexResponse?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
            }
            if let response = response {
                print("Response: ", response)
            }
            self.client?.execute(request: request!, completionHandler: handler)
        }
        
        let request1 = self.client?.indices().createIndex()
            .set(name: "test")
            .build()
        self.client?.execute(request: request1!, completionHandler: handler1)
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
