import XCTest

@testable import ElasticSwift

class ElasticSwiftTests: XCTestCase {
    
    var client: RestClient?
    
    override func setUp() {
        super.setUp()
        self.client = RestClient()
//        let cred = ClientCredential(username: "elastic", password: "elastic")
//        let ssl = SSLConfiguration(certPath: "/usr/local/Cellar/kibana/6.1.2/config/certs/elastic-certificates.der", isSelf: true)
//        let settings = Settings(forHosts: ["https://localhost:9200"], withCredentials: cred, withSSL: true, sslConfig: ssl)
//        self.client = RestClient(settings: settings)
        let settings = Settings(forHost:"http://192.168.250.96:9200")
        self.client = RestClient(settings: settings)
        
        do {
            let deleteExpectation = expectation(description: "deleteIndex")
            try deleteIndex { (response, error) in
                deleteExpectation.fulfill()
            }
            wait(for: [deleteExpectation], timeout: 1)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        do {
            let deleteExpectation = expectation(description: "deleteIndex")
            try deleteIndex { (response, error) in
                deleteExpectation.fulfill()
            }
            wait(for: [deleteExpectation], timeout: 1)
        } catch {
            XCTAssertTrue(false)
        }
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
    
    func testClient() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let settings = Settings.default
        let client = RestClient(settings: settings)
        XCTAssertNotNil(client)
    }
    
    func testGetIndexAdmin() {
        
        let createExpectation = expectation(description: "createIndex")
        
        createIndex { (response, error) in
            print("Create Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertTrue(response?.acknowledged ?? false)
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: 1)
        
        let getExpectation = expectation(description: "getIndex")
        
        do {
            try getIndex { (response, error) in
                print("Get Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
                XCTAssertNil(error)
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.settings)
                getExpectation.fulfill()
            }
        } catch {
            XCTAssertTrue(false)
        }
        
        wait(for: [getExpectation], timeout: 1)

    }
    
    func testIndexAdmin() {
        
        let createExpectation = expectation(description: "createIndex")
        
        createIndex { (response, error) in
            print("Create Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertTrue(response?.acknowledged ?? false)
            createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: 1)
        
        let deleteExpectation = expectation(description: "deleteIndex")
        
        do {
            try deleteIndex(withCompletionHandler: { (response, error) in
                print("Delete Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
                XCTAssertNil(error)
                XCTAssertNotNil(response)
                XCTAssertTrue(response?.acknowledged ?? false)
                deleteExpectation.fulfill()
            })
        } catch {
            XCTAssertTrue(false)
        }
            
        wait(for: [deleteExpectation], timeout: 1)
    }
    
    func createIndex(withCompletionHandler completionHandler: @escaping (CreateIndexResponse?,Error?) -> () ) {
        let request = self.client?.admin.indices().create()
            .set(name: "test")
            .set(completionHandler: completionHandler)
            .build()
        request?.execute()
    }
    
    func deleteIndex(withCompletionHandler completionHandler: @escaping (DeleteIndexResponse?,Error?) -> () ) throws {
        let request = try self.client?.admin.indices().delete()
            .set(name: "test")
            .set(completionHandler: completionHandler)
            .build()
        request?.execute()
    }
    
    func getIndex(withCompletionHandler completionHandler: @escaping (GetIndexResponse?,Error?) -> ()) throws {
        let request = try self.client?.admin.indices().get()
            .set(name: "test")
            .set(completionHandler: completionHandler)
            .build()
        request?.execute()
    }
    
    func testIndex() throws {
        
        let indexExpectation = expectation(description: "index")
        
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            print("Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards!.failed == 0)
            XCTAssertTrue(response!.shards!.total ?? 0 > 0)
            XCTAssertNotNil(response!.result)
            XCTAssertTrue(response!.result == "created")
            indexExpectation.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message"
        msg.timestamp = Date().timeIntervalSince1970
        let request = try self.client?.makeIndex()
            .set(index: "test")
//            .set(type: "msg")
            .set(id: "0")
            .set(source: msg)
            .set(completionHandler: handler)
            .set(refresh: .WAIT)
            .build()
        
        request?.execute()
        wait(for: [indexExpectation], timeout: 1)
    }
    
    func testIndexNoId() throws {
        
        let indexExpectation = expectation(description: "index")
        
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            print("Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards!.failed == 0)
            XCTAssertTrue(response!.shards!.total ?? 0 > 0)
            XCTAssertNotNil(response!.result)
            XCTAssertTrue(response!.result == "created")
            indexExpectation.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message No Id"
        msg.timestamp = Date().timeIntervalSince1970 + 100
        let request = try self.client?.makeIndex()
            .set(index: "test")
//            .set(type: "msg")
            .set(source: msg)
            .set(completionHandler: handler)
            .set(refresh: .WAIT)
            .build()
        
        request?.execute()
        wait(for: [indexExpectation], timeout: 1)
    }
    
    func testGet() throws {
        
        try testIndex()
        
        let getExpectation = expectation(description: "get")
        
        func handler(_ response: GetResponse<Message>?, _ error: Error?) -> Void {
            print("Get Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertTrue(response!.found ?? false)
            XCTAssertTrue(response!.id == "0")
            XCTAssertNotNil(response!.source)
            XCTAssertTrue(response!.source!.msg == "Test Message")
            getExpectation.fulfill()
        }
        
        let request = self.client?.makeGet()
            .set(index: "test")
//            .set(type: "msg")
            .set(id: "0")
            .set(completionHandler: handler)
            .build()
        
        request?.execute()
        wait(for: [getExpectation], timeout: 1)
    }
    
    func testDelete() throws {
        
        try testIndex()
        
        let deleteExpectation = expectation(description: "delete")
        
        func handler(_ response: DeleteResponse?, _ error:  Error?) -> Void {
            print("Delete Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards!.failed == 0)
            XCTAssertTrue(response!.shards!.total ?? 0 > 0)
            XCTAssertTrue(response!.result == "deleted")
            deleteExpectation.fulfill()
        }
        
        let request = self.client?.makeDelete()
            .set(index: "test")
//            .set(type: "msg")
            .set(id: "0")
            .set(completionHandler: handler)
            .build()
        
        request?.execute()
        wait(for: [deleteExpectation], timeout: 1)
    }
    
    func testSearch() throws {
        
        try testIndex()
        try testIndexNoId()
        
        sleep(1)
        
        let searchExpectation = expectation(description: "search")
        
        func handler(_ response: SearchResponse<Message>?, _ error: Error?) -> Void {
            print("Search Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards!.failed == 0)
            XCTAssertTrue(response!.shards!.total ?? 0 > 0)
            XCTAssertTrue(response?.timedOut ?? true == false)
            XCTAssertTrue(response?.hits?.total?.value == 2)
            
            let firstResult = response?.hits?.hits[0]
            let secondResult = response?.hits?.hits[1]
            XCTAssertNotNil(firstResult)
            XCTAssertNotNil(secondResult)
            XCTAssertNotNil(firstResult?.source?.timestamp)
            XCTAssertNotNil(secondResult?.source?.timestamp)
            XCTAssertTrue(firstResult!.source!.timestamp! > secondResult!.source!.timestamp!)
            
            searchExpectation.fulfill()
        }
        
        let builder = QueryBuilders.boolQuery()
        let match = QueryBuilders.matchQuery().set(field: "msg").set(value: "Message")
        builder.must(query: match)
        let sort =  SortBuilders.fieldSort("timestamp")
            .set(order: .desc)
            .build()
        let request = try self.client?.makeSearch()
            .set(indices: "test")
//            .set(types: "msg")
            .set(query: builder.query)
            .set(sort: sort)
            .set(completionHandler: handler)
            .build()
        request?.execute()
        wait(for: [searchExpectation], timeout: 10000000)
    }
    
    

    
    static var allTests = [
        ("testPlay", testPlay),
        ("testClient", testClient),
        ("testIndexAdmin", testIndexAdmin),
        ("testIndex", testIndex),
        ("testIndexNoId", testIndexNoId),
        ("testGet", testGet),
        ("testDelete", testDelete)
    ]
}

class Message: Codable {
    var msg: String?
    var timestamp: TimeInterval?
    
    init() {
        
    }
}
