//
//  GeoQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore


// MARK:- GeoShape Query

public class GeoShapeQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: GeoShapeQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Geo Bounding Box Query

public class GeoBoundingBoxQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: GeoBoundingBoxQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Geo Distance Query

public class GeoDistanceQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: GeoDistanceQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}

// MARK:- Geo Polygon Query

public class GeoPolygonQuery: Query {
    public let name: String = ""
    
    public init(withBuilder builder: GeoPolygonQueryBuilder) {
        
    }
    
    public func toDic() -> [String : Any] {
        let dic: [String: Any] = [:]
        return dic
    }
    
    
}
