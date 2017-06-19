import XCTest
import SwiftyJSON
@testable import ElasticSwift

class ElasticSwiftTests: XCTestCase {
    
    var client: RestClient?
    
    override func setUp() {
        super.setUp()
        self.client = RestClient()
    }
    
    func testPlay() {
        print(JSON(["field":"value"]).rawString()!)
        var query = [String: Any]()
        query["query"] = ["field":"value"]
        print(JSON(query).rawString()!)
        var query2 = [String: Any]()
        query2["query"] = JSON(["field": [:]]).rawString()!
        print(JSON(query2).rawString()!)
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
        func handler(_ response: ESResponse) -> Void {
            print(String(data: response.data!, encoding: .utf8 )!)
        }
        let requestBuilder = self.client?.admin.indices().create()
            .set(name: "test")
            .set(completionHandler: handler)
        requestBuilder?.execute()
        sleep(1)
    }
    
    func testGetIndex() {
        func handler(_ response: ESResponse) -> Void {
            print(String(data: response.data!, encoding: .utf8 )!)
        }
        let requestBuilder = self.client?.admin.indices().get()
            .set(name: "test")
            .set(completionHandler: handler)
        requestBuilder?.execute()
        sleep(1)
    }
    
    func testIndex() {
        func handler(_ response: ESResponse) -> Void {
            print(String(data: response.data!, encoding: .utf8 )!)
        }
        let body: String = JSON(["msg": "test1"]).rawString()!
        print("Body: ", body)
        let requestBuilder = self.client?.prepareIndex()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "1")
            .set(source: body)
            .set(completionHandler: handler)
        requestBuilder?.execute()
        let requestBuilder2 = self.client?.prepareIndex()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "2")
            .set(source: body)
            .set(completionHandler: handler)
        requestBuilder2?.execute()
        sleep(1)
    }
    
    func testGet() {
        func handler(_ response: ESResponse) -> Void {
            print(String(data: response.data!, encoding: .utf8 )!)
        }
        let requestBuilder = self.client?.prepareGet()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "2")
            .set(completionHandler: handler)
        requestBuilder?.execute()
        sleep(1)
    }
    
    func testDelete() {
        func handler(_ response: ESResponse) -> Void {
            print(String(data: response.data!, encoding: .utf8 )!)
            print(response.httpResponse!)
        }
        let requestBuilder = self.client?.prepareDelete()
            .set(index: "test")
            .set(type: "msg")
            .set(id: "2")
            .set(completionHandler: handler)
        requestBuilder?.execute()
        sleep(1)
    }
    
    func testSearch() {
        func handler(_ response: ESResponse) -> Void {
            print(String(data: response.data!, encoding: .utf8 )!)
            print(response.httpResponse!)
        }
        let builder = QueryBuilders.boolQuery()
        let match = QueryBuilders.matchQuery().match(field: "msg", value: "test1")
        builder.must(query: match)
        let requestBuilder = self.client?.prepareSearch()
            .set(index: "test")
            .set(type: "msg")
            .set(builder: builder)
            .set(completionHandler: handler)
        requestBuilder?.execute()
        sleep(1)
    }
    
    func testDeleteIndex() {
        func handler(_ response: ESResponse) -> Void {
            print(String(data: response.data!, encoding: .utf8 )!)
        }
        let requestBuilder = self.client?.admin.indices().delete()
            .set(name: "test")
            .set(completionHandler: handler)
        requestBuilder?.execute()
        sleep(1)
    }

    
    static var allTests = [
        ("testPlay", testPlay),
        ("testClient", testClient),
        ("testCreateIndex", testCreateIndex),
        ("testGetIndex", testGetIndex),
        ("testIndex", testIndex),
        ("testGet", testGet),
        ("testDelete", testDelete),
        ("testDeleteIndex", testDeleteIndex)
    ]
}
