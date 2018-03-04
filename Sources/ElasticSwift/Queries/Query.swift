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

public class BoolQuery: Query {

    public var name: String = "bool"
    private let MUST: String = "must"
    private let MUST_NOT: String = "must_not"
    private let SHOULD: String = "should"
    private let FILTER: String = "filter"
    var mustClauses: [Query]
    var mustNotClauses: [Query]
    var shouldClauses: [Query]
    var filterClauses: [Query]
    
    init(must: [QueryBuilder], mustnot: [QueryBuilder], should: [QueryBuilder], filter: [QueryBuilder]) {
        self.mustClauses = must.map { $0.query }
        self.mustNotClauses = mustnot.map { $0.query }
        self.shouldClauses = should.map { $0.query }
        self.filterClauses = filter.map { $0.query }
    }
    
    public func toDic() -> [String : Any] {
        var dic = [String : Any]()
        var subDic = [String : Any]()
        subDic[MUST] = self.mustClauses.map { $0.toDic() }
        subDic[MUST_NOT] = self.mustNotClauses.map { $0.toDic() }
        subDic[SHOULD] = self.shouldClauses.map { $0.toDic() }
        subDic[FILTER] = self.filterClauses.map { $0.toDic() }
        dic[name] = subDic
        return dic
    }
}

public class MatchQuery: Query {

    public var name: String = "match"
    var field: String
    var value: String
    var isFuzzy: Bool = false
    var `operator`: MatchQueryOperator = .or
    var zeroTermQuery: ZeroTermQuery = .none
    var cutoffFrequency = 0.0
    
    init(field: String, value: String) {
        self.field = field
        self.value = value
    }
    
    init() {
        self.field = ""
        self.value = ""
    }
    
    public func toDic() -> [String : Any] {
        return !(self.isFuzzy) ? [self.name : [self.field : self.value]] :
            [self.name: [self.field: [
                "query": self.value,
                "operator": self.operator.rawValue,
                "zero_terms_query" : self.zeroTermQuery.rawValue,
                "cutoff_frequency" : self.cutoffFrequency
                ]]]
    }
    
}

public class MatchAllQuery: Query {

    public var name: String = "match_all"
    
    public func toDic() -> [String : Any] {
        return [self.name : [:]]
    }
}

public class MatchNoneQuery: Query {
    
    public var name: String = "match_none"
    
    public func toDic() -> [String : Any] {
        return [self.name : [:]]
    }
}

enum MatchQueryOperator: String {
    case and = "and"
    case or = "or"
}

enum ZeroTermQuery: String {
    case none = "none"
    case all = "all"
}
