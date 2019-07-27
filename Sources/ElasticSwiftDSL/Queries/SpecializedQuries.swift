//
//  SpecializedQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- MoreLikeThis Query

public class MoreLikeThisQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: MoreLikeThisQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Script Query

public class ScriptQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: ScriptQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Percolate Query

public class PercoloteQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: PercoloteQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Wrapper Query

public class WrapperQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: WrapperQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}
