//
//  SerializationTests.swift
//  ElasticSwiftTests
//
//  Created by Prafull Kumar Soni on 7/12/19.
//

import XCTest
import Logging
import UnitTestSettings

@testable import ElasticSwift
@testable import ElasticSwiftCore

class SerializationTests: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Serialization.SerializationTests", factory: logFactory)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        logger.info("====================TEST=END===============================")
    }
    
    func test_01_encode() throws {
        
        let serializer = DefaultSerializer()
        
        let myclass = MyClass("value")
        
        let result = serializer.encode(myclass)
        
        switch result {
        case .success(let data):
            let str = String(data: data, encoding: .utf8)
            logger.info("Encoded: \(String(describing: str))")
            XCTAssertNotNil(str, "Encoded value can't be nil")
            XCTAssert("{\"value\":\"value\"}" == str!, "Validation on Encoded Value Failed")
        case .failure(let error):
            logger.error("Error: \(error)")
            XCTAssert(false, "Encoding Failed!")
        }
        
    }
    
    func test_02_encode_fail() throws {
        
        let serializer = DefaultSerializer()
        
        let myclass = MyFailureClass("value")
        
        let result = serializer.encode(myclass)
        
        switch result {
        case .success(let data):
            let str = String(data: data, encoding: .utf8)
            logger.info("Encoded: \(String(describing: str))")
            XCTAssert(false, "Encoding Failure Failed!")
        case .failure(let error):
            logger.error("Expected Error: \(error)")
            XCTAssert(type(of: error) == EncodingError.self, "Unexpected Error observed: \(error)")
            XCTAssert(type(of: error.value) == MyFailureClass.self, "Unexpected input value \(error.value)")
            XCTAssert(type(of: error.error) == MyError.self, "Unexpected internal Error: \(error.error.self)")
            let err = error.error as! MyError
            XCTAssert(err.localizedDescription == "Error", "Error description validation failed \(err.localizedDescription)")
        }
        
    }
    
    func test_03_decode() throws {
        
        let serializer = DefaultSerializer()
        
        let data = "{\"value\":\"value\"}".data(using: .utf8)
        
        let result: Result<MyClass, DecodingError> = serializer.decode(data: data!)
        
        switch result {
        case .success(let myclass):
            logger.info("Decoded: \(myclass.description)")
            XCTAssert("MyClass[value: value]" == myclass.description, "Validation on Decoded Value Failed")
        case .failure(let error):
            logger.info("Unexpected Error: \(error.localizedDescription)")
            XCTAssert(false, "Encoding Failed!")
        }
        
    }
    
    func test_04_decode_fail() throws {
        
        let serializer = DefaultSerializer()
        
        let data = "badJson".data(using: .utf8)
        
        let result: Result<MyClass, DecodingError> = serializer.decode(data: data!)
        
        switch result {
        case .success(let myclass):
            logger.info("Decoded: \(String(describing: myclass))")
            XCTAssert(false, "Decoding Failure Failed!")
        case .failure(let error):
            logger.error("Expected Error: \(error)")
            XCTAssert(type(of: error) == DecodingError.self, "Unexpected Error observed: \(error)")
            XCTAssert(error.data == data!, "Unexpected input value \(error.data)")
            XCTAssert(error.type == MyClass.self, "Unexpected Type")
            XCTAssert(type(of: error.error) == Swift.DecodingError.self, "Unexpected internal Error: \(error.type)")
        }
        
    }

}

class MyClass: Codable, CustomStringConvertible, CustomDebugStringConvertible {
    
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    var description: String {
        get {
            return "MyClass[value: \(value.description)]"
        }
    }
    
    var debugDescription: String {
        get {
            return "MyClass[value: \(value.debugDescription)]"
        }
    }
}

final class MyFailureClass: CustomStringConvertible, CustomDebugStringConvertible {
    
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    var description: String {
        get {
            return "MyClass[value: \(value.description)]"
        }
    }
    
    var debugDescription: String {
        get {
            return "MyClass[value: \(value.debugDescription)]"
        }
    }
}

extension MyFailureClass: Encodable {
    
    public func encode(to encode: Encoder) throws {
        throw MyError("Error")
    }
    
}

struct MyError: Error {
    
    private let msg: String
    
    public init(_ msg: String) {
        self.msg = msg
    }
    
    public var localizedDescription: String {
        get {
            return msg
        }
    }
}
