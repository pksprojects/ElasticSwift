//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

import Foundation
import ElasticSwiftCore

public enum VersionType: String, Codable {
    case `internal`
    case external
    case externalGte = "external_gte"
    case force
}

public enum IndexRefresh: String, Codable {
    case `true`
    case `false`
    case waitFor = "wait_for"
}

public enum OpType: String, Codable {
    case index
    case create
}

extension URLQueryItem {
    
    init(name: QueryParams, value: String?) {
        self.init(name: name.rawValue, value: value)
    }
    
    init(name: QueryParams, value: Bool?) {
        self.init(name: name.rawValue, value: String(describing: value))
    }
    
    init(name: QueryParams, value: Int?) {
        self.init(name: name.rawValue, value: String(describing: value))
    }
    
    init(name: QueryParams, value: Float?) {
        self.init(name: name.rawValue, value: String(describing: value))
    }
    
    init(name: QueryParams, value: Double?) {
        self.init(name: name.rawValue, value: String(describing: value))
    }
    
    init(name: QueryParams, value: Decimal?) {
        self.init(name: name.rawValue, value: String(describing: value))
    }
    
}
