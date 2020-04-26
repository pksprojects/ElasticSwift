//
//  Sort.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/4/17.
//
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

public final class SortBuilders {
    public static func scoreSort() -> ScoreSortBuilder {
        return ScoreSortBuilder()
    }

    public static func fieldSort(_ field: String) -> FieldSortBuilder {
        return FieldSortBuilder(field)
    }
}

public class ScoreSortBuilder: SortBuilder {
    private static let _SCORE = "_score"

    var sortOrder: SortOrder?
    var field = ScoreSortBuilder._SCORE

    init() {}

    public func set(order: SortOrder) -> ScoreSortBuilder {
        sortOrder = order
        return self
    }

    public func build() -> Sort {
        return Sort(withBuilder: self)
    }
}

public class FieldSortBuilder: SortBuilder {
    var field: String?
    var sortOrder: SortOrder?
    var mode: SortMode?

    public init(_ field: String) {
        self.field = field
    }

    public func set(order: SortOrder) -> FieldSortBuilder {
        sortOrder = order
        return self
    }

    public func set(mode: SortMode) -> FieldSortBuilder {
        self.mode = mode
        return self
    }

    public func build() -> Sort {
        return Sort(withBuilder: self)
    }
}

protocol SortBuilder {
    func build() -> Sort
}

public struct Sort {
    private static let ORDER = "order"
    private static let MODE = "mode"

    public let field: String
    public let sortOrder: SortOrder
    public let fieldTypeisArray: Bool
    public let mode: SortMode?

    init(withBuilder builder: ScoreSortBuilder) {
        field = builder.field
        sortOrder = builder.sortOrder ?? .desc
        fieldTypeisArray = false
        mode = nil
    }

    init(withBuilder builder: FieldSortBuilder) {
        field = builder.field!
        mode = builder.mode
        sortOrder = builder.sortOrder ?? .desc
        fieldTypeisArray = (mode != nil) ? true : false
    }
}

extension Sort: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dic = try container.decode([String: CodableValue].self)
        let item = dic.first!
        field = item.key
        if let order = item.value.value as? String {
            if let sortOrder = SortOrder(rawValue: order) {
                self.sortOrder = sortOrder
            } else {
                throw Swift.DecodingError.typeMismatch(SortOrder.self, .init(codingPath: container.codingPath, debugDescription: "Unable to serialize value \(order) as SortOrder"))
            }
            mode = nil
        } else if let subDic = item.value.value as? [String: String] {
            if let order = subDic[Sort.ORDER] {
                if let sortOrder = SortOrder(rawValue: order) {
                    self.sortOrder = sortOrder
                } else {
                    throw Swift.DecodingError.typeMismatch(SortOrder.self, .init(codingPath: container.codingPath, debugDescription: "Unable to serialize value \(order) as SortOrder"))
                }
            } else {
                throw Swift.DecodingError.valueNotFound(SortOrder.self, .init(codingPath: container.codingPath, debugDescription: "No value for SortOrder with key order"))
            }
            if let mode = subDic[Sort.MODE] {
                if let sortMode = SortMode(rawValue: mode) {
                    self.mode = sortMode
                } else {
                    throw Swift.DecodingError.typeMismatch(SortMode.self, .init(codingPath: container.codingPath, debugDescription: "Unable to serialize value \(mode) as SortMode"))
                }
            } else {
                mode = nil
            }
        } else {
            throw Swift.DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unable to serialize sort from  \(dic)"))
        }

        fieldTypeisArray = mode != nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if fieldTypeisArray {
            var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
            try nested.encode(sortOrder, forKey: .key(named: Sort.ORDER))
            try nested.encode(mode, forKey: .key(named: Sort.MODE))
        } else {
            try container.encode(sortOrder, forKey: .key(named: field))
        }
    }

    private struct CodingKeys: CodingKey {
        var stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?

        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = String(intValue)
        }

        public static func key(named name: String) -> CodingKeys {
            return CodingKeys(stringValue: name)!
        }
    }
}

extension Sort: Equatable {
    public static func == (lhs: Sort, rhs: Sort) -> Bool {
        return lhs.field == rhs.field
            && lhs.sortOrder == rhs.sortOrder
            && lhs.mode == rhs.mode
            && lhs.fieldTypeisArray == rhs.fieldTypeisArray
    }
}

public enum SortOrder: String, Codable {
    case asc
    case desc
}

public enum SortMode: String, Codable {
    case max
    case min
    case avg
    case sum
    case median
}
