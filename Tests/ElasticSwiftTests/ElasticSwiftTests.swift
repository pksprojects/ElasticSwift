import XCTest

@testable import ElasticSwift

class ElasticSwiftTests: XCTestCase {
    
    var client: RestClient?
    let restExpectationTimeout = 3.0
    
    override func setUp() {
        super.setUp()
        self.client = RestClient()
//        let cred = ClientCredential(username: "elastic", password: "elastic")
//        let ssl = SSLConfiguration(certPath: "/usr/local/Cellar/kibana/6.1.2/config/certs/elastic-certificates.der", isSelf: true)
//        let settings = Settings(forHosts: ["https://localhost:9200"], withCredentials: cred, withSSL: true, sslConfig: ssl)
//        self.client = RestClient(settings: settings)
//        let settings = Settings(forHost:"http://192.168.1.53:9200")
//        self.client = RestClient(settings: settings)
//
        do {
            let deleteExpectation = expectation(description: "deleteIndex")
            try deleteIndex { (response, error) in
                deleteExpectation.fulfill()
            }
            wait(for: [deleteExpectation], timeout: self.restExpectationTimeout)
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
            wait(for: [deleteExpectation], timeout: self.restExpectationTimeout)
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
        
        do {
            try createIndex { (response, error) in
                print("Create Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
                XCTAssertNil(error)
                XCTAssertNotNil(response)
                XCTAssertTrue(response?.acknowledged ?? false)
                createExpectation.fulfill()
            }
        } catch {
            XCTAssertTrue(false)
        }
        
        wait(for: [createExpectation], timeout: self.restExpectationTimeout)
        
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
        
        wait(for: [getExpectation], timeout: self.restExpectationTimeout)

    }
    
    func testIndexAdmin() {
        
        let createExpectation = expectation(description: "createIndex")
        
        do {
            try createIndex { (response, error) in
                print("Create Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
                XCTAssertNil(error)
                XCTAssertNotNil(response)
                XCTAssertTrue(response?.acknowledged ?? false)
                createExpectation.fulfill()
            }
        } catch {
            XCTAssertTrue(false)
        }
        
        wait(for: [createExpectation], timeout: self.restExpectationTimeout)

        //FIXME: The creation_date is a String and not a Double as expected. Verify and fix. (ES 6.x and 7.X)
//        let getExpectation = expectation(description: "getIndex")
//
//        do {
//            try getIndex { (response, error) in
//                print("Get Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
//                XCTAssertNil(error)
//                XCTAssertNotNil(response)
//                XCTAssertNotNil(response?.settings)
//                getExpectation.fulfill()
//            }
//        } catch {
//            XCTAssertTrue(false)
//        }
//
//        wait(for: [getExpectation], timeout: self.restExpectationTimeout)
        
        
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
            
        wait(for: [deleteExpectation], timeout: self.restExpectationTimeout)
    }
    
    func createIndex(withCompletionHandler completionHandler: @escaping (CreateIndexResponse?,Error?) -> () ) throws {
        let request = self.client?.admin.indices().createIndex(withName: "test")
            .set(mappings: setupIndexMapping())
            .set(settings: setupIndexSettings())
            .set(completionHandler: completionHandler)
            .build()
        try request?.execute()
    }
    
    func setupIndexMapping() -> CreateIndexMappings {
        let keywordMultifieldProperty = IndexMappingMultiField(type: .keyword, ignore_above: 256, analyzer: nil, fielddata: nil)
        let listMultifieldProperty = IndexMappingMultiField(type: .text, ignore_above: nil, analyzer: "custom_list_analyzer", fielddata: true)
        let textMultifieldProperty = IndexMappingMultiField(type: .text, ignore_above: nil, analyzer: "custom_words", fielddata: true)
        
        let identifierProperty = IndexMappingProperty(properties: nil, type: .text, format: nil, fields: ["keyword":keywordMultifieldProperty])
        let startDateProperty = IndexMappingProperty(properties: nil, type: .date, format: "basic_date_time", fields: nil)
        let endDateProperty = IndexMappingProperty(properties: nil, type: .date, format: "basic_date_time", fields: nil)
        let actionProperty = IndexMappingProperty(properties: nil, type: .text, format: nil, fields: ["keyword":keywordMultifieldProperty])
        let typeProperty = IndexMappingProperty(properties: nil, type: .text, format: nil, fields: ["keyword":keywordMultifieldProperty])
        let userProperty = IndexMappingProperty(properties: nil, type: .text, format: nil, fields: ["keyword":keywordMultifieldProperty])
        let valueProperty = IndexMappingProperty(properties: nil, type: .text, format: nil, fields: ["keyword":keywordMultifieldProperty,"list":listMultifieldProperty,"text":textMultifieldProperty])
        let valueDoubleProperty = IndexMappingProperty(properties: nil, type: .double, format: nil, fields: nil)
        let valueIndexProperty = IndexMappingProperty(properties: nil, type: .integer, format: nil, fields: nil)
        
        let mappings = CreateIndexMappings(properties: ["identifier":identifierProperty,"startDate":startDateProperty,"endDate":endDateProperty,"action":actionProperty,"type":typeProperty,"user":userProperty,"value":valueProperty,"valueDouble":valueDoubleProperty,"valueIndex":valueIndexProperty])
        return mappings
    }
    
    func setupIndexSettings() -> CreateIndexSettings {
        let custom_list_analyzer = IndexSettingsAnalyzer(type: "custom", stopwords: nil, filter: ["trim"], tokenizer: "pipe")
        let custom_words = IndexSettingsAnalyzer(type: "standard", stopwords: "_italian_", filter: nil, tokenizer: nil)
        let pipe_tokenizer = IndexSettingsTokenizer(type: "simple_pattern_split", pattern: "|")
        let analysis = IndexSettingsAnalysis(analyzer: ["custom_words":custom_words,"custom_list_analyzer":custom_list_analyzer], tokenizer: ["pipe":pipe_tokenizer])
        let settings = CreateIndexSettings(analysis: analysis)
        return settings
    }
    
    func deleteIndex(withCompletionHandler completionHandler: @escaping (DeleteIndexResponse?,Error?) -> () ) throws {
        let request = self.client?.admin.indices().deleteIndex(withName: "test")
            .set(completionHandler: completionHandler)
            .build()
        try request?.execute()
    }
    
    func getIndex(withCompletionHandler completionHandler: @escaping (GetIndexResponse?,Error?) -> ()) throws {
        let request = self.client?.admin.indices().getIndex(withName: "test")
            .set(completionHandler: completionHandler)
            .build()
        try request?.execute()
    }
    
    func testIndex() throws {
        
        let indexExpectation = expectation(description: "index")
        
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            print("Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards.failed == 0)
            XCTAssertTrue(response!.shards.total > 0)
            XCTAssertNotNil(response!.result)
            XCTAssertTrue(response!.result == "created")
            indexExpectation.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message"
        msg.timestamp = Date().timeIntervalSince1970
        let request = self.client?.makeIndex(toIndex: "test", source: msg)
//            .set(type: "msg")
            .set(id: "0")
            .set(completionHandler: handler)
            .set(refresh: .WAIT)
            .build()
        
        try request?.execute()
        wait(for: [indexExpectation], timeout: self.restExpectationTimeout)
    }
    
    func testIndexNoId() throws {
        
        let indexExpectation = expectation(description: "index")
        
        func handler(_ response: IndexResponse?, _ error:  Error?) -> Void {
            print("Index Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards.failed == 0)
            XCTAssertTrue(response!.shards.total > 0)
            XCTAssertNotNil(response!.result)
            XCTAssertTrue(response!.result == "created")
            indexExpectation.fulfill()
        }
        let msg = Message()
        msg.msg = "Test Message No Id"
        msg.timestamp = Date().timeIntervalSince1970 + 100
        let request = self.client?.makeIndex(toIndex: "test", source: msg)
//            .set(type: "msg")
            .set(completionHandler: handler)
            .set(refresh: .WAIT)
            .build()
        
        try request?.execute()
        wait(for: [indexExpectation], timeout: self.restExpectationTimeout)
    }
    
    func testGet() throws {
        
        try testIndex()
        
        let getExpectation = expectation(description: "get")
        
        func handler(_ response: GetResponse<Message>?, _ error: Error?) -> Void {
            print("Get Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            guard let responseNN = response else {
                return
            }
            
            XCTAssertTrue(responseNN.found)
            XCTAssertTrue(responseNN.id == "0")
            XCTAssertNotNil(responseNN.source)
            
            guard let sourceNN = responseNN.source else {
                return
            }
            
            XCTAssertTrue(sourceNN.msg == "Test Message")
            getExpectation.fulfill()
        }
        
        let request = self.client?.makeGet(fromIndex: "test", id: "0")
//            .set(type: "msg")
            .set(completionHandler: handler)
            .build()
        try request?.execute()
        
        wait(for: [getExpectation], timeout: self.restExpectationTimeout)
    }
    
    func testDelete() throws {
        
        try testIndex()
        
        let deleteExpectation = expectation(description: "delete")
        
        func handler(_ response: DeleteResponse?, _ error:  Error?) -> Void {
            print("Delete Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards.failed == 0)
            XCTAssertTrue(response!.shards.total > 0)
            XCTAssertTrue(response!.result == "deleted")
            deleteExpectation.fulfill()
        }
        
        let request = self.client?.makeDelete(fromIndex: "test", id: "0")
//            .set(type: "msg")
            .set(completionHandler: handler)
            .build()
        
        try request?.execute()
        wait(for: [deleteExpectation], timeout: self.restExpectationTimeout)
    }
    
    func testSearch() throws {
        
        try testIndex()
        try testIndexNoId()
        
        
        let searchExpectation = expectation(description: "search")
        
        func handler(_ response: SearchResponse<Message>?, _ error: Error?) -> Void {
            print("Search Handler: \(String(describing: response)) Error: \(String(describing: error))")
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.shards)
            XCTAssertTrue(response!.shards.failed == 0)
            XCTAssertTrue(response!.shards.total > 0)
            XCTAssertTrue(response?.timedOut ?? true == false)
            XCTAssertTrue(response?.hits?.total == 2)
            
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
        let request = self.client?.makeSearch(fromIndex: "test")
//            .set(types: "msg")
            .set(query: builder.query)
            .set(sort: sort)
            .set(completionHandler: handler)
            .build()
        try request?.execute()
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
