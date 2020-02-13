import XCTest

import ElasticSwiftCodableUtilsTests
import ElasticSwiftCoreTests
import ElasticSwiftQueryDSLTests
import ElasticSwiftTests

var tests = [XCTestCaseEntry]()
tests += ElasticSwiftCodableUtilsTests.__allTests()
tests += ElasticSwiftCoreTests.__allTests()
tests += ElasticSwiftQueryDSLTests.__allTests()
tests += ElasticSwiftTests.__allTests()

XCTMain(tests)
