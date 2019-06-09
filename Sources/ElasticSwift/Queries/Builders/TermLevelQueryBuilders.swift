//
//  TermLevelQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Term Query Builder

public class TermQueryBuilder: QueryBuilder {
    var field: String?
    var value: String?
    var boost: Decimal?
    
    typealias BuilderClosure = (TermQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return TermQuery(withBuilder: self)
        }
    }
    
}

// MARK:- Terms Query Builder

public class TermsQueryBuilder: QueryBuilder {
    
    var field: String?
    var value: [String]?
    
    typealias BuilderClosure = (TermsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return TermsQuery(withBuilder: self)
        }
    }

}

// MARK:- Range Query Builder

public class RangeQueryBuilder: QueryBuilder {
    
    var field: String?
    var gte: String?
    var gt: String?
    var lte: String?
    var lt: String?
    var format: String?
    var timeZone: String?
    var boost: Decimal?
    var relation: ShapeRelation?
    
    typealias BuilderClosure = (RangeQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    
    public var query: Query {
        get {
            return RangeQuery(withBuilder: self)
        }
    }

    
}

// MARK:- Exists Query Builder

public class ExistsQueryBuilder: QueryBuilder {
    
    var field: String?
    
    typealias BuilderClosure = (ExistsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return ExistsQuery(withBuilder: self)
        }
    }

    
}

// MARK:- Prefix Query Builder

public class PrefixQueryBuilder: QueryBuilder {
    
    var field: String?
    var value: String?
    var boost: Decimal?
    
    typealias BuilderClosure = (PrefixQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return PrefixQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Wildcard Query Builder

public class WildCardQueryBuilder: QueryBuilder {
    
    var field: String?
    var value: String?
    var boost: Decimal?
    
    typealias BuilderClosure = (WildCardQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return WildCardQuery(withBuilder: self)
        }
    }

}

// MARK:- Regexp Query Builder

public class RegexpQueryBuilder: QueryBuilder {
    
    var field: String?
    var value: String?
    var boost: Decimal?
    var regexFlags: [RegexFlag]?
    var maxDeterminizedStates: Int?
    
    typealias BuilderClosure = (RegexpQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return RegexpQuery(withBuilder: self)
        }
    }
    
}

// MARK:- Fuzzy Query Builder

public class FuzzyQueryBuilder: QueryBuilder {
    
    var field: String?
    var value: String?
    var boost: Decimal?
    var fuzziness: Int?
    var prefixLenght: Int?
    var maxExpansions: Int?
    var transpositions: Bool?
    
    typealias BuilderClosure = (FuzzyQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return FuzzyQuery(withBuilder: self)
        }
    }

}

// MARK:- Type Query Builder

public class TypeQueryBuilder: QueryBuilder {
    
    var type: String?
    
    typealias BuilderClosure = (TypeQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return TypeQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Ids Query Builder

public class IdsQueryBuilder: QueryBuilder {
    
    var type: String?
    var ids: [String]?
    
    typealias BuilderClosure = (IdsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public var query: Query {
        get {
            return IdsQuery(withBuilder: self)
        }
    }
    
    
}
