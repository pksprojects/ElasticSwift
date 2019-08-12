//
//  JoiningQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore


// MARK:- Nested Query

internal class NestedQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: NestedQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- HasChild Query

internal class HasChildQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: HasChildQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- HasParent Query

internal class HasParentQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: HasParentQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- ParentId Query

internal class ParentIdQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: ParentIdQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}
