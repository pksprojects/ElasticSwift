//
//  GeoQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
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
        return _field
    }

    public var shape: CodableValue? {
        return _shape
    }

    public var indexedShapeId: String? {
        return _indexedShapeId
    }

    public var indexedShapeType: String? {
        return _indexedShapeType
    }

    public var indexedShapeIndex: String? {
        return _indexedShapeIndex
    }

    public var indexedShapePath: String? {
        return _indexedShapePath
    }

    public var relation: ShapeRelation? {
        return _relation
    }

    public var ignoreUnmapped: Bool? {
        return _ignoreUnmapped
    }

    public func build() throws -> GeoShapeQuery {
        return try GeoShapeQuery(withBuilder: self)
    }
}

// MARK: - Geo Bounding Box Query Builder

public class GeoBoundingBoxQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _topLeft: GeoPoint?
    private var _bottomRight: GeoPoint?
    private var _type: GeoExecType?
    private var _validationMethod: GeoValidationMethod?
    private var _ignoreUnmapped: Bool?

    public init() {}

    @discardableResult
    public func set(field: String) -> Self {
        _field = field
        return self
    }

    @discardableResult
    public func set(topLeft: GeoPoint) -> Self {
        _topLeft = topLeft
        return self
    }

    @discardableResult
    public func set(bottomRight: GeoPoint) -> Self {
        _bottomRight = bottomRight
        return self
    }

    @discardableResult
    public func set(type: GeoExecType) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(validationMethod: GeoValidationMethod) -> Self {
        _validationMethod = validationMethod
        return self
    }

    @discardableResult
    public func set(ignoreUnmapped: Bool) -> Self {
        _ignoreUnmapped = ignoreUnmapped
        return self
    }

    public var field: String? {
        return _field
    }

    public var topLeft: GeoPoint? {
        return _topLeft
    }

    public var bottomRight: GeoPoint? {
        return _bottomRight
    }

    public var type: GeoExecType? {
        return _type
    }

    public var validationMethod: GeoValidationMethod? {
        return _validationMethod
    }

    public var ignoreUnmapped: Bool? {
        return _ignoreUnmapped
    }

    public func build() throws -> GeoBoundingBoxQuery {
        return try GeoBoundingBoxQuery(withBuilder: self)
    }
}

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
