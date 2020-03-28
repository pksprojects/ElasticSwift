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

    public init(field: String, shape: CodableValue?, indexedShapeId: String?, indexedShapeType: String?, indexedShapeIndex: String? = nil, indexedShapePath: String? = nil, relation: ShapeRelation? = nil, ignoreUnmapped: Bool? = nil) {
        self.field = field
        self.shape = shape
        self.relation = relation
        self.ignoreUnmapped = ignoreUnmapped
        self.indexedShapeId = indexedShapeId
        self.indexedShapeType = indexedShapeType
        self.indexedShapeIndex = indexedShapeIndex
        self.indexedShapePath = indexedShapePath
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

        self.init(field: builder.field!, shape: builder.shape, indexedShapeId: builder.indexedShapeId, indexedShapeType: builder.indexedShapeType, indexedShapeIndex: builder.indexedShapeIndex, indexedShapePath: builder.indexedShapePath, relation: builder.relation, ignoreUnmapped: builder.ignoreUnmapped)
    }
}

extension GeoShapeQuery {
    public func toDic() -> [String: Any] {
        var dic = [String: Any]()

        var fieldDic = [String: Any]()

        if let shape = self.shape {
            fieldDic[CodingKeys.shape.rawValue] = shape.value
        }

        if let indexedShapeId = self.indexedShapeId, let indexedShapeType = self.indexedShapeType {
            var indexedShapeDic = [String: Any]()
            indexedShapeDic[IndexedShape.CodingKeys.id.rawValue] = indexedShapeId
            indexedShapeDic[IndexedShape.CodingKeys.type.rawValue] = indexedShapeType
            if let indexedShapeIndex = self.indexedShapeIndex {
                indexedShapeDic[IndexedShape.CodingKeys.index.rawValue] = indexedShapeIndex
            }
            if let indexedShapePath = self.indexedShapePath {
                indexedShapeDic[IndexedShape.CodingKeys.path.rawValue] = indexedShapePath
            }
            fieldDic[CodingKeys.indexedShape.rawValue] = indexedShapeDic
        }

        dic[field] = fieldDic

        return [queryType.name: dic]
    }

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
        ignoreUnmapped = try fieldContainer.decodeBoolIfPresent(forKey: .ignoreUnmapped)
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
        try fieldContainer.encodeIfPresent(ignoreUnmapped, forKey: .ignoreUnmapped)
    }

    enum CodingKeys: String, CodingKey {
        case shape
        case strategy
        case relation
        case indexedShape = "indexed_shape"
        case ignoreUnmapped = "ignore_unmapped"
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

    public init(field: String, topLeft: GeoPoint, bottomRight: GeoPoint, type: GeoExecType? = nil, validationMethod: GeoValidationMethod? = nil, ignoreUnmapped: Bool? = nil) {
        self.field = field
        self.topLeft = topLeft
        self.bottomRight = bottomRight
        self.type = type
        self.validationMethod = validationMethod
        self.ignoreUnmapped = ignoreUnmapped
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

        self.init(field: builder.field!, topLeft: builder.topLeft!, bottomRight: builder.bottomRight!, type: builder.type, validationMethod: builder.validationMethod, ignoreUnmapped: builder.ignoreUnmapped)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [:]
        if let ignoreUnmapped = self.ignoreUnmapped {
            dic[ignoreUnmapped.description] = ignoreUnmapped
        }
        return [queryType.name: dic]
    }
}

extension GeoBoundingBoxQuery {
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
            throw Swift.DecodingError.typeMismatch(GeoBoundingBoxQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = fieldKey.first!.stringValue
        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        topLeft = try fieldContainer.decode(GeoPoint.self, forKey: .topLeft)
        bottomRight = try fieldContainer.decode(GeoPoint.self, forKey: .bottomRight)
        type = try nested.decodeIfPresent(GeoExecType.self, forKey: .key(named: CodingKeys.type.rawValue))
        validationMethod = try nested.decodeIfPresent(GeoValidationMethod.self, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        ignoreUnmapped = try nested.decodeBoolIfPresent(forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(topLeft, forKey: .topLeft)
        try fieldContainer.encode(bottomRight, forKey: .bottomRight)
        try nested.encodeIfPresent(type, forKey: .key(named: CodingKeys.type.rawValue))
        try nested.encodeIfPresent(validationMethod, forKey: .key(named: CodingKeys.validationMethod.rawValue))
        try nested.encodeIfPresent(ignoreUnmapped, forKey: .key(named: CodingKeys.ignoreUnmapped.rawValue))
    }

    enum CodingKeys: String, CodingKey {
        case topLeft = "top_left"
        case bottomRight = "bottom_right"
        case ignoreUnmapped = "ignore_unmapped"
        case validationMethod = "validation_method"
        case type
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
    }
}

// MARK: - Geo Distance Query

// internal struct GeoDistanceQuery: Query {
//    // TODO: remove at time of implementation and conform to Equatable
//    func isEqualTo(_ other: Query) -> Bool {
//        return type == other.type
//    }
//
//    public let type: String = ""
//
//    public init(withBuilder _: GeoDistanceQueryBuilder) {}
//
//    public func toDic() -> [String: Any] {
//        let dic: [String: Any] = [:]
//        return dic
//    }
// }

// MARK: - Geo Polygon Query

// internal struct GeoPolygonQuery: Query {
//    // TODO: remove at time of implementation and conform to Equatable
//    func isEqualTo(_ other: Query) -> Bool {
//        return queryType.isEqualTo(other.queryType)
//    }
//
//    public let queryType: QueryType = QueryTypes.geoPolygon
//
//    public init(withBuilder _: GeoPolygonQueryBuilder) {}
//
//    public func toDic() -> [String: Any] {
//        let dic: [String: Any] = [:]
//        return dic
//    }
// }

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
