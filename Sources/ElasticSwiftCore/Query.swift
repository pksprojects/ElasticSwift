//
//  Query.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/3/17.
//
//

import Foundation

public protocol Query {
    
    var name: String { get }
    
    func toDic() -> [String: Any]
}
