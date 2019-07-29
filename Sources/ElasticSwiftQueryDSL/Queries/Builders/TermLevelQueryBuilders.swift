//
//  TermLevelQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Term Query Builder

public class TermQueryBuilder: QueryBuilder {
    public var field: String?
    public var value: String?
    public var boost: Decimal?
    
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
    
    public var field: String?
    public var value: [String]?
    
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
    
    public var field: String?
    public var gte: String?
    public var gt: String?
    public var lte: String?
    public var lt: String?
    public var format: String?
    public var timeZone: String?
    public var boost: Decimal?
    public var relation: ShapeRelation?
    
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
    
    public var field: String?
    
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
    
    public var field: String?
    public var value: String?
    public var boost: Decimal?
    
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
    
    public var field: String?
    public var value: String?
    public var boost: Decimal?
    
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
    
    public var field: String?
    public var value: String?
    public var boost: Decimal?
    public var regexFlags: [RegexFlag]?
    public var maxDeterminizedStates: Int?
    
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
    
    public var field: String?
    public var value: String?
    public var boost: Decimal?
    public var fuzziness: Int?
    public var prefixLenght: Int?
    public var maxExpansions: Int?
    public var transpositions: Bool?
    
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
    
    public var type: String?
    
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
    
    public var type: String?
    public var ids: [String]?
    
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
