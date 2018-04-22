//
//  CompoundQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Constant Score Query

public class ConstantScoreQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: ConstantScoreQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Bool Query

public class BoolQuery: Query {
    
    public let name: String = "bool"
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

// MARK:- Dis Max Query

public class DisMaxQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: DisMaxQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Function Score Query

public class FunctionScoreQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: FunctionScoreQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Boosting Query

public class BoostingQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: BoostingQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}


