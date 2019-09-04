//
//  SpanQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Span Term Query

internal class SpanTermQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanTermQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Multi Term Query

internal class SpanMultiTermQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanMultiTermQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span First Query

internal class SpanFirstQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanFirstQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Near Query

internal class SpanNearQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanNearQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Or Query

internal class SpanOrQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanOrQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Not Query

internal class SpanNotQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanNotQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Containing Query

internal class SpanContainingQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanContainingQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Within Query

internal class SpanWithinQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanWithinQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Span Field Masking Query

internal class SpanFieldMaskingQuery: Query {
    //TODO remove at time of implementation and conform to Equatable
    func isEqualTo(_ other: Query) -> Bool {
        return self.name == other.name
    }
    public let name: String = ""
    
    public init(withBuilder builder: SpanFieldMaskingQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}
