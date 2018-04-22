//
//  TermLevelQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Term Query

public class TermQuery: Query {
    
    public let name: String = "term"
    
    public init(withBuilder builder: TermQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
}

// MARK:- Terms Query

public class TermsQuery: Query {
    public let name: String = "terms"
    
    public init(withBuilder builder: TermsQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Range Query

public class RangeQuery: Query {
    public let name: String = "range"
    
    public init(withBuilder builder: RangeQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Exists Query

public class ExistsQuery: Query {
    public let name: String = "exists"
    
    public init(withBuilder builder: ExistsQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Prefix Query

public class PrefixQuery: Query {
    public let name: String = "prefix"
    
    public init(withBuilder builder: PrefixQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- WildCard Query

public class WildCardQuery: Query {
    public let name: String = "wildcard"
    
    public init(withBuilder builder: WildCardQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Regexp Query

public class RegexpQuery: Query {
    public let name: String = "regexp"
    
    public init(withBuilder builder: RegexpQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Fuzzy Query

public class FuzzyQuery: Query {
    public let name: String = "fuzzy"
    
    public init(withBuilder builder: FuzzyQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Type Query

public class TypeQuery: Query {
    public let name: String = "type"
    
    public init(withBuilder builder: TypeQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Ids Query

public class IdsQuery: Query {
    public let name: String = "ids"
    
    public init(withBuilder builder: IdsQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}


