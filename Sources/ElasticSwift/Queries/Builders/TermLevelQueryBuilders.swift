//
//  TermLevelQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation

// MARK:- Term Query Builder

public class TermQueryBuilder: QueryBuilder {
    
    public var query: Query {
        get {
            return TermQuery(withBuilder: self)
        }
    }
    
}

// MARK:- Terms Query Builder

public class TermsQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return TermsQuery(withBuilder: self)
        }
    }

}

// MARK:- Range Query Builder

public class RangeQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return RangeQuery(withBuilder: self)
        }
    }

    
}

// MARK:- Exists Query Builder

public class ExistsQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return ExistsQuery(withBuilder: self)
        }
    }

    
}

// MARK:- Prefix Query Builder

public class PrefixQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return PrefixQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Wildcard Query Builder

public class WildCardQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return WildCardQuery(withBuilder: self)
        }
    }

}

// MARK:- Regexp Query Builder

public class RegexpQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return RegexpQuery(withBuilder: self)
        }
    }
    
}

// MARK:- Fuzzy Query Builder

public class FuzzyQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return FuzzyQuery(withBuilder: self)
        }
    }

}

// MARK:- Type Query Builder

public class TypeQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return TypeQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Ids Query Builder

public class IdsQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return IdsQuery(withBuilder: self)
        }
    }
    
    
}
