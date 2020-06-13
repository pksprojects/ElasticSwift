//
//  SpecializedQueryBuilderTests.swift
//
//
//  Created by Prafull Kumar Soni on 6/7/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class SpecializedQueryBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.SpecializedQueryBuilderTests", factory: logFactory)

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

    func test_01_moreLikeThisQueryBuilder() throws {
        XCTAssertNoThrow(try QueryBuilders.moreLikeThisQuery().set(likeTexts: ["test"]).build(), "Should not throw")
    }
}
