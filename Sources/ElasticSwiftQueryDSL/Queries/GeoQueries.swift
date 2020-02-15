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
        
        guard (builder.indexedShapeId != nil ? builder.indexedShapeType != nil : true) else {
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
        
        dic[self.field] = fieldDic
        
        return [self.queryType.name: dic]
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(MatchPhraseQuery.self, .init(codingPath: nested.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(nested.allKeys.count)."))
        }

        field = nested.allKeys.first!.stringValue
        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
        self.shape = try fieldContainer.decodeIfPresent(CodableValue.self, forKey: .shape)
        if let indexedShap = try fieldContainer.decodeIfPresent(IndexedShape.self, forKey: .indexedShape) {
            self.indexedShapeId = indexedShap.id
            self.indexedShapeType = indexedShap.type
            self.indexedShapeIndex = indexedShap.index
            self.indexedShapePath = indexedShap.path
        } else {
            self.indexedShapeId = nil
            self.indexedShapeType = nil
            self.indexedShapeIndex = nil
            self.indexedShapePath = nil
        }
        
        self.relation = try fieldContainer.decodeIfPresent(ShapeRelation.self, forKey: .relation)
        self.ignoreUnmapped = try fieldContainer.decodeBoolIfPresent(forKey: .ignoreUnmapped)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: queryType))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encodeIfPresent(self.shape, forKey: .shape)
        if let indexedShapeId = self.indexedShapeId, let indexedShapeType = self.indexedShapeType {
            let indexedShape = IndexedShape.init(id: indexedShapeId, type: indexedShapeType, index: self.indexedShapeIndex, path: self.indexedShapePath)
            try fieldContainer.encode(indexedShape, forKey: .indexedShape)
        }
        try fieldContainer.encodeIfPresent(self.ignoreUnmapped, forKey: .ignoreUnmapped)
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

// internal struct GeoBoundingBoxQuery: Query {
//    // TODO: remove at time of implementation and conform to Equatable
//    func isEqualTo(_ other: Query) -> Bool {
//        return name == other.name
//    }
//
//    public let name: String = ""
//
//    public init(withBuilder _: GeoBoundingBoxQueryBuilder) {}
//
//    public func toDic() -> [String: Any] {
//        let dic: [String: Any] = [:]
//        return dic
//    }
// }

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
