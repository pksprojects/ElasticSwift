//
//  Query.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/3/17.
//
//

import Foundation

//MARK:- Query Protocol

/// Protocol that all `Query` conforms to
public protocol Query {
    
    var name: String { get }
    
    func toDic() -> [String: Any]
}

/// Protocol that all Builder for `Query` conforms to
public protocol QueryBuilder {
    
    var query: Query { get }

}
