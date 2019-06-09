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
    
    
    public var query: Query {
        get {
            return RangeQuery(withBuilder: self)
        }
    }

    
}

// MARK:- Exists Query Builder

public class ExistsQueryBuilder: QueryBuilder {
    
    var field: String?
    
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
    
    public var query: Query {
        get {
            return FuzzyQuery(withBuilder: self)
        }
    }

}

// MARK:- Type Query Builder

public class TypeQueryBuilder: QueryBuilder {
    
    var type: String?
    
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
    
    public var query: Query {
        get {
            return IdsQuery(withBuilder: self)
        }
    }
    
    
}
