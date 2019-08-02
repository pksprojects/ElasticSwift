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
    
    public func build() throws -> GeoShapeQuery {
        return GeoShapeQuery(withBuilder: self)
    }
}

// MARK:- Geo Bounding Box Query Builder

public class GeoBoundingBoxQueryBuilder: QueryBuilder {
    
    public func build() throws -> GeoBoundingBoxQuery {
        return GeoBoundingBoxQuery(withBuilder: self)
    }
}

// MARK:- Geo Distance Query Builder

public class GeoDistanceQueryBuilder: QueryBuilder {
    
    public func build() throws -> GeoDistanceQuery {
        return GeoDistanceQuery(withBuilder: self)
    }
    
}

// MARK:- Geo Polygon Query Builder

public class GeoPolygonQueryBuilder: QueryBuilder {
    
    public func build() throws -> GeoPolygonQuery {
        return GeoPolygonQuery(withBuilder: self)
    }
    
}
