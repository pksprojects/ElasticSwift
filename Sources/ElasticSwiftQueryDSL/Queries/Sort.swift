//
//  Sort.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/4/17.
//
//

import Foundation
import ElasticSwiftCore
import ElasticSwiftCodableUtils

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
        self.sortOrder = order
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
        self.sortOrder = order
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

public class Sort: Codable {
    
    private static let ORDER = "order"
    private static let MODE = "mode"
    
    public let field: String
    public let sortOrder: SortOrder
    public let fieldTypeisArray: Bool
    public let mode: SortMode?
    
    init(withBuilder builder: ScoreSortBuilder) {
        self.field = builder.field
        self.sortOrder = builder.sortOrder ?? .desc
        self.fieldTypeisArray = false
        self.mode = nil
    }
    
    init(withBuilder builder: FieldSortBuilder) {
        self.field = builder.field!
        self.mode = builder.mode
        self.sortOrder = builder.sortOrder ?? .desc
        self.fieldTypeisArray = (self.mode != nil) ? true : false
    }
    
    public func toDic() -> [String : Any] {
        return (!self.fieldTypeisArray) ? [self.field: self.sortOrder.rawValue] :
            [self.field : [
                Sort.ORDER : self.sortOrder.rawValue,
                Sort.MODE : self.mode?.rawValue
                ]]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if self.fieldTypeisArray {
            var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: self.field))
            try nested.encode(self.sortOrder, forKey: .key(named: Sort.ORDER))
            try nested.encode(self.mode, forKey: .key(named: Sort.MODE))
        } else {
            try container.encode(self.sortOrder, forKey: .key(named: self.field))
        }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dic = try container.decode([String: CodableValue].self)
        let item = dic.first!
        self.field = item.key
        if let order = item.value.value as? SortOrder {
            self.sortOrder = order
            self.mode = nil
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
                self.mode = nil
            }
        } else {
            throw Swift.DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unable to serialize sort from  \(dic)"))
        }
        
        self.fieldTypeisArray = self.mode != nil
    }
    
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = String(intValue)
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
    case asc = "asc"
    case desc = "desc"
}

public enum SortMode: String, Codable {
    case max = "max"
    case min = "min"
    case avg = "avg"
    case sum = "sum"
    case median = "median"
}
