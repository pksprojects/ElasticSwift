//
//  GeoQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore


// MARK:- GeoShape Query Builder

public class GeoShapeQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return GeoShapeQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Geo Bounding Box Query Builder

public class GeoBoundingBoxQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return GeoBoundingBoxQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Geo Distance Query Builder

public class GeoDistanceQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return GeoDistanceQuery(withBuilder: self)
        }
    }
    
    
}

// MARK:- Geo Polygon Query Builder

public class GeoPolygonQueryBuilder: QueryBuilder {
    public var query: Query {
        get {
            return GeoPolygonQuery(withBuilder: self)
        }
    }
    
    
}
