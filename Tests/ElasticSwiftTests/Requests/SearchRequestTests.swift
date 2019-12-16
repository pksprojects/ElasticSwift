//
//  SearchRequestTests.swift
//  
//
//  Created by Prafull Kumar Soni on 12/15/19.
//

import XCTest
import Logging
import UnitTestSettings

@testable import ElasticSwift
@testable import ElasticSwiftQueryDSL
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO


class SearchRequestTests: XCTestCase {
    
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.SearchRequestTests", factory: logFactory)
    
    var client: ElasticClient?
    
}
