//
//  SpanQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Span Term Query Builder

public class SpanTermQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanTermQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span Multi Term Query Builder

public class SpanMultiTermQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanMultiTermQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span First Query Builder

public class SpanFirstQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanFirstQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span Near Query Builder

public class SpanNearQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanNearQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span Or Query Builder

public class SpanOrQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanOrQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span Not Query Builder

public class SpanNotQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanNotQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span Containing Query Builder

public class SpanContainingQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanContainingQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span Within Query Builder

public class SpanWithinQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanWithinQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Span Field Masking Query Builder

public class SpanFieldMaskingQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return SpanFieldMaskingQuery(withBuilder: self)
        }
    }
    
    
}
