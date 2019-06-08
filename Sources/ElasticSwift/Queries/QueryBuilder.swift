//
//  QueryBuilder.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/3/17.
//
//

import Foundation


public protocol QueryBuilder {
    
    var query: Query { get }
    
    func set(boost: Float) -> Self

}
