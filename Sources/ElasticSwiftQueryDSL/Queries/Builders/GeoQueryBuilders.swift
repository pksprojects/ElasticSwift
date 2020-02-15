//
//  GeoQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import ElasticSwiftCodableUtils
import Foundation

// MARK: - GeoShape Query Builder

 public class GeoShapeQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _shape: CodableValue?
    
    private var _indexedShapeId: String?
    private var _indexedShapeType: String?
    private var _indexedShapeIndex: String?
    private var _indexedShapePath: String?
    
    private var _relation: ShapeRelation?
    private var _ignoreUnmapped: Bool?
    
    public init() {}
    
    @discardableResult
    public func set(field: String) -> Self {
        _field = field
        return self
    }
    
    @discardableResult
    public func set(shape: CodableValue) -> Self {
        _shape = shape
        return self
    }
    
    @discardableResult
    public func set(indexedShapeId: String) -> Self {
        _indexedShapeId = indexedShapeId
        return self
    }
    
    @discardableResult
    public func set(indexedShapeType: String) -> Self {
        _indexedShapeType = indexedShapeType
        return self
    }
    
    @discardableResult
    public func set(indexedShapeIndex: String) -> Self {
        _indexedShapeIndex = indexedShapeIndex
        return self
    }
    
    @discardableResult
    public func set(indexedShapePath: String) -> Self {
        _indexedShapePath = indexedShapePath
        return self
    }
    
    @discardableResult
    public func set(relation: ShapeRelation) -> Self {
        _relation = relation
        return self
    }
    
    @discardableResult
    public func set(ignoreUnmapped: Bool) -> Self {
        _ignoreUnmapped = ignoreUnmapped
        return self
    }
    
    public var field: String? {
        return self._field
    }
    
    public var shape: CodableValue? {
        return self._shape
    }
    
    public var indexedShapeId: String? {
        return self._indexedShapeId
    }
    public var indexedShapeType: String? {
        return self._indexedShapeType
    }
    public var indexedShapeIndex: String? {
        return self._indexedShapeIndex
    }
    public var indexedShapePath: String? {
        return self._indexedShapePath
    }
    
    public var relation: ShapeRelation? {
        return self._relation
    }
    public var ignoreUnmapped: Bool? {
        return self._ignoreUnmapped
    }
    
    public func build() throws -> GeoShapeQuery {
        return try GeoShapeQuery(withBuilder: self)
    }
 }

// MARK: - Geo Bounding Box Query Builder

// internal class GeoBoundingBoxQueryBuilder: QueryBuilder {
//    public func build() throws -> GeoBoundingBoxQuery {
//        return GeoBoundingBoxQuery(withBuilder: self)
//    }
// }

// MARK: - Geo Distance Query Builder

// internal class GeoDistanceQueryBuilder: QueryBuilder {
//    public func build() throws -> GeoDistanceQuery {
//        return GeoDistanceQuery(withBuilder: self)
//    }
// }

// MARK: - Geo Polygon Query Builder

// internal class GeoPolygonQueryBuilder: QueryBuilder {
//    public func build() throws -> GeoPolygonQuery {
//        return GeoPolygonQuery(withBuilder: self)
//    }
// }
