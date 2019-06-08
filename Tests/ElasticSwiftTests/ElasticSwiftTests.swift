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
    
    func testCreateIndex() {
        func handler(_ response: CreateIndexResponse?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
                return
            }
            print(response?.acknowledged as Any)
        }
        let request = self.client?.admin.indices().create()
            .set(name: "test")
            .set(completionHandler: handler)
            .build()
        request?.execute()
        sleep(1)
    }
    
    func testGetIndex() throws {
        func handler(_ response: GetIndexResponse?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
                return
            }
            print(response?.settings as Any)
        }
        let request = try self.client?.admin.indices().get()
            .set(name: "test")
            .set(completionHandler: handler)
            .build()
        request?.execute()
        sleep(1)
    }
    
    func testIndex() throws {
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print(error)
            }
            if let response = response {
                print("Found", response.result!)
            }
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request = try self.client?.makeIndex()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "0")
            .set(source: msg)
            .set(completionHandler: handler)
            .build()
        
        request?.execute()
        sleep(1)
    }
    
    func testIndexNoId() throws {
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print(error)
            }
            if let response = response {
                print("Found", response.result!)
            }
        }
        let msg = Message()
        msg.msg = "Test Message No Id"
        let request = try self.client?.makeIndex()
            .set(index: "test")
            .set(type: "msg")
            .set(source: msg)
            .set(completionHandler: handler)
            .build()
        
        request?.execute()
        sleep(1)
    }
    
    func testGet() throws {
        
        try testIndex()
        
        func handler(_ response: GetResponse<Message>?, _ error: Error?) -> Void {
            if let error = error {
                print(error)
            }
            if let response = response {
                print("Found", response.found!)
            }
        }
        
        let request = self.client?.makeGet()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "0")
            .set(completionHandler: handler)
            .build()
        
        request?.execute()
        sleep(1)
    }
    
    func testDelete() throws {
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print(error)
            }
            if let response = response {
                print("Found", response.result!)
            }
        }
        let msg = Message()
        msg.msg = "Test Message"
        let request = try self.client?.makeIndex()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "0")
            .set(source: msg)
            .set(completionHandler: handler)
            .build()

        request?.execute()
        sleep(1)
        func handler1(_ response: DeleteResponse?, _ error:  Error?) -> Void {
            if let error = error {
                print(error)
            }
            if let response = response {
                print("Found", response.result!)
            }
        }
        let request1 = self.client?.makeDelete()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "0")
            .set(completionHandler: handler1)
            .build()
        
        request1?.execute()
        sleep(1)
    }
    
    func testSearch() throws {
        func handler(_ response: SearchResponse<Message>?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
                return
            }
            print(response?.hits as Any)
        }
        let builder = QueryBuilders.boolQuery()
        let match = QueryBuilders.matchQuery().set(field: "msg").set(value: "Message")
        builder.must(query: match)
        let sort =  SortBuilders.fieldSort("msg")
            .set(order: .asc)
            .build()
        let request = try self.client?.makeSearch()
            .set(indices: "test")
            .set(types: "msg")
            .set(query: builder.query)
            .set(sort: sort)
            .set(completionHandler: handler)
            .build()
        request?.execute()
        sleep(1)
    }
    
    func testDeleteIndex() throws {
        func handler(_ response: DeleteIndexResponse?, _ error: Error?) -> Void {
            if let error = error {
                print("Error", error)
                return
            }
            print(response?.acknowledged as Any)
        }
        let request = try self.client?.admin.indices().delete()
            .set(name: "test")
            .set(completionHandler: handler)
            .build()
        request?.execute()
        sleep(1)
    }

    
    static var allTests = [
        ("testPlay", testPlay),
        ("testClient", testClient),
        ("testCreateIndex", testCreateIndex),
        ("testGetIndex", testGetIndex),
        ("testIndex", testIndex),
        ("testIndexNoId", testIndexNoId),
        ("testGet", testGet),
        ("testDelete", testDelete),
        ("testDeleteIndex", testDeleteIndex)
    ]
}

class Message: Codable {
    var msg: String?
    
    init() {
        
    }
}
