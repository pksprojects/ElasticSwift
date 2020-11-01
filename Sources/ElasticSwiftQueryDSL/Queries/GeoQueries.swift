//
//  GeoQueries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - GeoShape Query

public struct GeoShapeQuery: Query {
    public let queryType: QueryType = QueryTypes.geoShape

    public let field: String
    public let shape: CodableValue?
    public let indexedShapeId: String?
    public let indexedShapeType: String?
    public let indexedShapeIndex: String?
    public let indexedShapePath: String?
    public let relation: ShapeRelation?
    public let ignoreUnmapped: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, shape: CodableValue?, indexedShapeId: String?, indexedShapeType: String?, indexedShapeIndex: String? = nil, indexedShapePath: String? = nil, relation: ShapeRelation? = nil, ignoreUnmapped: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.shape = shape
        self.relation = relation
        self.ignoreUnmapped = ignoreUnmapped
        self.indexedShapeId = indexedShapeId
        self.indexedShapeType = indexedShapeType
        self.indexedShapeIndex = indexedShapeIndex
        self.indexedShapePath = indexedShapePath
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: GeoShapeQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.shape != nil || builder.indexedShapeId != nil else {
            throw QueryBuilderError.atleastOneFieldRequired(["shape", "indexedShapeId"])
        }

        guard builder.indexedShapeId != nil ? builder.indexedShapeType != nil : true else {
            throw QueryBuilderError.missingRequiredField("indexedShapeType")
        }

        self.init(field: builder.field!, shape: builder.shape, indexedShapeId: builder.indexedShapeId, indexedShapeType: builder.indexedShapeType, indexedShapeIndex: builder.indexedShapeIndex, indexedShapePath: builder.indexedShapePath, relation: builder.relation, ignoreUnmapped: builder.ignoreUnmapped, boost: builder.boost, name: builder.name)
    }
}

extension GeoShapeQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(GeoShapeQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        shape = try fieldContainer.decodeIfPresent(CodableValue.self, forKey: .shape)
        if let indexedShap = try fieldContainer.decodeIfPresent(IndexedShape.self, forKey: .indexedShape) {
            indexedShapeId = indexedShap.id
            indexedShapeType = indexedShap.type
            indexedShapeIndex = indexedShap.index
            indexedShapePath = indexedShap.path
        } else {
            indexedShapeId = nil
            indexedShapeType = nil
            indexedShapeIndex = nil
            indexedShapePath = nil
        }

        relation = try fieldContainer.decodeIfPresent(ShapeRelation.self, forKey: .relation)
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        boost = try nested.decodeDecimalIfPresent(forKey: .key(named: CodingKeys.boost.rawValue))
        name = try nested.decodeStringIfPresent(forKey: .key(named: CodingKeys.name.rawValue))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encodeIfPresent(shape, forKey: .shape)
        if let indexedShapeId = self.indexedShapeId, let indexedShapeType = self.indexedShapeType {
            let indexedShape = IndexedShape(id: indexedShapeId, type: indexedShapeType, index: indexedShapeIndex, path: indexedShapePath)
            try fieldContainer.encode(indexedShape, forKey: .indexedShape)
        }
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        try nested.encodeIfPresent(boost, forKey: .key(named: CodingKeys.boost.rawValue))
        try nested.encodeIfPresent(name, forKey: .key(named: CodingKeys.name.rawValue))
    }

    enum CodingKeys: String, CodingKey {
        case shape
        case strategy
        case relation
        case indexedShape = "indexed_shape"
        case ignoreUnmapped = "ignore_unmapped"
        case boost
        case name
    }

    struct IndexedShape: Codable {
        let id: String
        let type: String
        let index: String?
        let path: String?

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case index
            case path
        }
    }
}

extension GeoShapeQuery: Equatable {
    public static func == (lhs: GeoShapeQuery, rhs: GeoShapeQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.shape == rhs.shape
            && lhs.indexedShapeId == rhs.indexedShapeId
            && lhs.indexedShapeType == rhs.indexedShapeType
            && lhs.indexedShapeIndex == rhs.indexedShapeIndex
            && lhs.indexedShapePath == rhs.indexedShapePath
            && lhs.relation == rhs.relation
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Geo Bounding Box Query

public struct GeoBoundingBoxQuery: Query {
    public let queryType: QueryType = QueryTypes.geoBoundingBox

    public let field: String

    public let topLeft: GeoPoint
    public let bottomRight: GeoPoint
    public let type: GeoExecType?
    public let validationMethod: GeoValidationMethod?
    public let ignoreUnmapped: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, topLeft: GeoPoint, bottomRight: GeoPoint, type: GeoExecType? = nil, validationMethod: GeoValidationMethod? = nil, ignoreUnmapped: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.topLeft = topLeft
        self.bottomRight = bottomRight
        self.type = type
        self.validationMethod = validationMethod
        self.ignoreUnmapped = ignoreUnmapped
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: GeoBoundingBoxQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.topLeft != nil else {
            throw QueryBuilderError.missingRequiredField("topLeft")
        }

        guard builder.bottomRight != nil else {
            throw QueryBuilderError.missingRequiredField("bottomRight")
        }

        self.init(field: builder.field!, topLeft: builder.topLeft!, bottomRight: builder.bottomRight!, type: builder.type, validationMethod: builder.validationMethod, ignoreUnmapped: builder.ignoreUnmapped, boost: builder.boost, name: builder.name)
    }
}

public extension GeoBoundingBoxQuery {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        let fieldKey = nested.allKeys.filter { k in
            if CodingKeys(rawValue: k.stringValue) != nil {
                return false
            }
            return true
        }

        guard fieldKey.count == 1 else {
            throw Swift.DecodingError.typeMismatch(GeoBoundingBoxQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(fieldKey.count)."))
        }

        field = fieldKey.first!.stringValue
        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        topLeft = try fieldContainer.decode(GeoPoint.self, forKey: .topLeft)
        bottomRight = try fieldContainer.decode(GeoPoint.self, forKey: .bottomRight)
        type = try nested.decodeIfPresent(GeoExecType.self, forKey: .key(named: CodingKeys.type.rawValue))
        validationMethod = try nested.decodeIfPresent(GeoValidationMethod.self, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        boost = try nested.decodeDecimalIfPresent(forKey: .key(named: CodingKeys.boost.rawValue))
        name = try nested.decodeStringIfPresent(forKey: .key(named: CodingKeys.name.rawValue))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(topLeft, forKey: .topLeft)
        try fieldContainer.encode(bottomRight, forKey: .bottomRight)
        try nested.encodeIfPresent(type, forKey: .key(named: CodingKeys.type.rawValue))
        try nested.encodeIfPresent(validationMethod, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        try nested.encodeIfPresent(boost, forKey: .key(named: CodingKeys.boost.rawValue))
        try nested.encodeIfPresent(name, forKey: .key(named: CodingKeys.name.rawValue))
    }

    internal enum CodingKeys: String, CodingKey {
        case topLeft = "top_left"
        case bottomRight = "bottom_right"
        case ignoreUnmapped = "ignore_unmapped"
        case validationMethod = "validation_method"
        case type
        case boost
        case name
    }
}

extension GeoBoundingBoxQuery: Equatable {
    public static func == (lhs: GeoBoundingBoxQuery, rhs: GeoBoundingBoxQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.topLeft == rhs.topLeft
            && lhs.bottomRight == rhs.bottomRight
            && lhs.field == rhs.field
            && lhs.type == rhs.type
            && lhs.validationMethod == rhs.validationMethod
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Geo Distance Query

public struct GeoDistanceQuery: Query {
    public let queryType: QueryType = QueryTypes.geoDistance

    public let field: String
    public let point: GeoPoint
    public let distance: String?
    public let distanceType: GeoDistanceType?
    public let validationMethod: GeoValidationMethod?
    public let ignoreUnmapped: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, point: GeoPoint, distance: String? = nil, distanceType: GeoDistanceType? = nil, validationMethod: GeoValidationMethod? = nil, ignoreUnmapped: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.point = point
        self.distance = distance
        self.distanceType = distanceType
        self.validationMethod = validationMethod
        self.ignoreUnmapped = ignoreUnmapped
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: GeoDistanceQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.point != nil else {
            throw QueryBuilderError.missingRequiredField("point")
        }

        self.init(field: builder.field!, point: builder.point!, distance: builder.distance, distanceType: builder.distanceType, validationMethod: builder.validationMethod, ignoreUnmapped: builder.ignoreUnmapped, boost: builder.boost, name: builder.name)
    }
}

extension GeoDistanceQuery: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        let fieldKey = nested.allKeys.filter { k in
            if CodingKeys(rawValue: k.stringValue) != nil {
                return false
            }
            return true
        }

        guard fieldKey.count == 1 else {
            throw Swift.DecodingError.typeMismatch(GeoDistanceQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(fieldKey.count)."))
        }
        field = fieldKey.first!.stringValue
        point = try nested.decode(GeoPoint.self, forKey: fieldKey.first!)
        distance = try nested.decodeStringIfPresent(forKey: .key(named: CodingKeys.distance.rawValue))
        distanceType = try nested.decodeIfPresent(GeoDistanceType.self, forKey: .key(named: CodingKeys.distanceType.rawValue))
        validationMethod = try nested.decodeIfPresent(GeoValidationMethod.self, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        boost = try nested.decodeDecimalIfPresent(forKey: .key(named: CodingKeys.boost.rawValue))
        name = try nested.decodeStringIfPresent(forKey: .key(named: CodingKeys.name.rawValue))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(point, forKey: .key(named: field))
        try nested.encodeIfPresent(distance, forKey: .key(named: CodingKeys.distance.rawValue))
        try nested.encodeIfPresent(distanceType, forKey: .key(named: CodingKeys.distanceType.rawValue))
        try nested.encodeIfPresent(validationMethod, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        try nested.encodeIfPresent(boost, forKey: .key(named: CodingKeys.boost.rawValue))
        try nested.encodeIfPresent(name, forKey: .key(named: CodingKeys.name.rawValue))
    }

    enum CodingKeys: String, CodingKey {
        case distance
        case distanceType = "distance_type"
        case validationMethod = "validation_method"
        case ignoreUnmapped = "ignore_unmapped"
        case boost
        case name
    }
}

extension GeoDistanceQuery: Equatable {
    public static func == (lhs: GeoDistanceQuery, rhs: GeoDistanceQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.point == rhs.point
            && lhs.distance == rhs.distance
            && lhs.distanceType == rhs.distanceType
            && lhs.validationMethod == rhs.validationMethod
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - Geo Polygon Query

public struct GeoPolygonQuery: Query {
    public let queryType: QueryType = QueryTypes.geoPolygon

    public let field: String
    public let points: [GeoPoint]
    public let validationMethod: GeoValidationMethod?
    public let ignoreUnmapped: Bool?
    public var boost: Decimal?
    public var name: String?

    public init(field: String, points: [GeoPoint], validationMethod: GeoValidationMethod? = nil, ignoreUnmapped: Bool? = nil, boost: Decimal? = nil, name: String? = nil) {
        self.field = field
        self.points = points
        self.validationMethod = validationMethod
        self.ignoreUnmapped = ignoreUnmapped
        self.boost = boost
        self.name = name
    }

    internal init(withBuilder builder: GeoPolygonQueryBuilder) throws {
        guard builder.field != nil else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard builder.points != nil, !builder.points!.isEmpty else {
            throw QueryBuilderError.atlestOneElementRequired("points")
        }

        self.init(field: builder.field!, points: builder.points!, validationMethod: builder.validationMethod, ignoreUnmapped: builder.ignoreUnmapped, boost: builder.boost, name: builder.name)
    }
}

extension GeoPolygonQuery: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        let fieldKey = nested.allKeys.filter { k in
            if CodingKeys(rawValue: k.stringValue) != nil {
                return false
            }
            return true
        }

        guard fieldKey.count == 1 else {
            throw Swift.DecodingError.typeMismatch(GeoPolygonQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(fieldKey.count)."))
        }
        field = fieldKey.first!.stringValue
        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: fieldKey.first!)
        points = try fieldContainer.decodeArray(forKey: .points)
        validationMethod = try nested.decodeIfPresent(GeoValidationMethod.self, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        boost = try nested.decodeDecimalIfPresent(forKey: .key(named: CodingKeys.boost.rawValue))
        name = try nested.decodeStringIfPresent(forKey: .key(named: CodingKeys.name.rawValue))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(points, forKey: .points)
        try nested.encodeIfPresent(validationMethod, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
        try nested.encodeIfPresent(boost, forKey: .key(named: CodingKeys.boost.rawValue))
        try nested.encodeIfPresent(name, forKey: .key(named: CodingKeys.name.rawValue))
    }

    enum CodingKeys: String, CodingKey {
        case points
        case validationMethod = "validation_method"
        case ignoreUnmapped = "ignore_unmapped"
        case boost
        case name
    }
}

extension GeoPolygonQuery: Equatable {
    public static func == (lhs: GeoPolygonQuery, rhs: GeoPolygonQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.points == rhs.points
            && lhs.validationMethod == rhs.validationMethod
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.boost == rhs.boost
            && lhs.name == rhs.name
    }
}

// MARK: - GeoPoint

public struct GeoPoint {
    public let lat: Decimal?
    public let lon: Decimal?
    public let geoHash: String?

    internal init(lat: Decimal?, lon: Decimal?, geoHash: String?) {
        self.lat = lat
        self.lon = lon
        self.geoHash = geoHash
    }

    public init(lat: Decimal, lon: Decimal) {
        self.init(lat: lat, lon: lon, geoHash: nil)
    }

    public init(geoHash: String) {
        self.init(lat: nil, lon: nil, geoHash: geoHash)
    }
}

extension GeoPoint: Codable {
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            let lat = try container.decodeDecimal(forKey: .lat)
            let lon = try container.decodeDecimal(forKey: .lon)
            self.init(lat: lat, lon: lon)
        } else {
            let container = try decoder.singleValueContainer()
            let hash = try container.decodeString()
            self.init(geoHash: hash)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if geoHash != nil {
            var container = encoder.singleValueContainer()
            try container.encode(geoHash!)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(lon!, forKey: .lon)
            try container.encode(lat!, forKey: .lat)
        }
    }

    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }

    internal func toQueryDicValue() -> Any {
        if geoHash != nil {
            return geoHash!
        } else {
            return [
                CodingKeys.lat.rawValue: lat!,
                CodingKeys.lon.rawValue: lon!,
            ]
        }
    }
}

extension GeoPoint: Equatable {}

public enum GeoValidationMethod: String, Codable {
    case coerce
    case ignoreMalformed = "ignore_malformed"
    case strict
}

public enum GeoExecType: String, Codable {
    case memory
    case indexed
}

public enum GeoDistanceType: String, Codable {
    case arc
    case plane
}
