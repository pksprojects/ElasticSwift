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
    
    public func build() throws -> SpanTermQuery {
        return SpanTermQuery(withBuilder: self)
    }
    
}

// MARK:- Span Multi Term Query Builder

public class SpanMultiTermQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanMultiTermQuery {
        return SpanMultiTermQuery(withBuilder: self)
    }
    
}

// MARK:- Span First Query Builder

public class SpanFirstQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanFirstQuery {
        return SpanFirstQuery(withBuilder: self)
    }
}

// MARK:- Span Near Query Builder

public class SpanNearQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanNearQuery {
        return SpanNearQuery(withBuilder: self)
    }
    
}

// MARK:- Span Or Query Builder

public class SpanOrQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanOrQuery {
        return SpanOrQuery(withBuilder: self)
    }
}

// MARK:- Span Not Query Builder

public class SpanNotQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanNotQuery {
        return SpanNotQuery(withBuilder: self)
    }
    
}

// MARK:- Span Containing Query Builder

public class SpanContainingQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanContainingQuery {
        return SpanContainingQuery(withBuilder: self)
    }
    
}

// MARK:- Span Within Query Builder

public class SpanWithinQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanWithinQuery {
        return SpanWithinQuery(withBuilder: self)
    }
}

// MARK:- Span Field Masking Query Builder

public class SpanFieldMaskingQueryBuilder: QueryBuilder {
    
    public func build() throws -> SpanFieldMaskingQuery {
        return SpanFieldMaskingQuery(withBuilder: self)
    }
}
