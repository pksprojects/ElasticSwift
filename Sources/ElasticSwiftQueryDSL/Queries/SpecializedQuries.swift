//
//  SpecializedQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- MoreLikeThis Query

internal class MoreLikeThisQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: MoreLikeThisQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Script Query

internal class ScriptQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: ScriptQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Percolate Query

internal class PercoloteQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: PercoloteQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Wrapper Query

internal class WrapperQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: WrapperQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}
