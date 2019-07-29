//
//  SpanQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Span Term Query

public class SpanTermQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanTermQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Multi Term Query

public class SpanMultiTermQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanMultiTermQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span First Query

public class SpanFirstQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanFirstQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Near Query

public class SpanNearQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanNearQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Or Query

public class SpanOrQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanOrQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Not Query

public class SpanNotQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanNotQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Containing Query

public class SpanContainingQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanContainingQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Within Query

public class SpanWithinQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanWithinQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Field Masking Query

public class SpanFieldMaskingQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: SpanFieldMaskingQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}
