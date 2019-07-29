//
//  Sort.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/4/17.
//
//

import Foundation
import ElasticSwiftCore


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

public class Sort {
    
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
}

public enum SortOrder: String {
    case asc = "asc"
    case desc = "desc"
}

public enum SortMode: String {
    case max = "max"
    case min = "min"
    case avg = "avg"
    case sum = "sum"
    case median = "median"
}
