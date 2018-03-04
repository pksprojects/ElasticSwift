//
//  Sort.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/4/17.
//
//

import Foundation


public final class SortBuilders {
    
    func scoreSort() -> ScoreSortBuilder {
        return ScoreSortBuilder()
    }
    
    func fieldSort(_ field: String) -> FieldSortBuilder {
        return FieldSortBuilder(field)
    }
    
    func geoSort(field: String, latitute: Double, longitute: Double) -> GeoDistanceSortBuilder {
        return GeoDistanceSortBuilder()
    }
}

public class ScoreSortBuilder: SortBuilder {
    
    var sort: Sort
    
    init() {
        self.sort = Sort(field: "_score")
    }
    
    func set(order: SortOrder) -> ScoreSortBuilder {
        self.sort.sortOrder = order
        return self
    }
    
    func build() -> Sort {
        return self.sort
    }

}

public class FieldSortBuilder: SortBuilder {
    var sort: Sort
    
    init(_ field: String) {
        self.sort = Sort(field: field)
    }
    
    func set(order: SortOrder) -> FieldSortBuilder {
        self.sort.sortOrder = order
        return self
    }
    
    func set(mode: SortMode) -> FieldSortBuilder {
        self.sort.mode = mode
        self.sort.fieldTypeisArray = true
        return self
    }
    
    func build() -> Sort {
        return self.sort
    }

}

class GeoDistanceSortBuilder {
    
}

protocol SortBuilder {
    
    func build() -> Sort
}

public class Sort {
    
    let field: String
    var sortOrder: SortOrder = .desc
    var fieldTypeisArray: Bool = false
    var mode: SortMode?
    
    init(field: String) {
        self.field = field
    }
    
    convenience init(field: String, order: SortOrder) {
        self.init(field: field)
        self.sortOrder = order
    }
    
    convenience init(field: String, order: SortOrder, mode: SortMode) {
        self.init(field: field, order: order)
        self.fieldTypeisArray = true
        self.mode = mode
    }
    
    func toDic() -> [String : Any] {
        return (!self.fieldTypeisArray) ? [self.field: self.sortOrder.rawValue] :
            [self.field : [
                "order" : self.sortOrder.rawValue,
                "mode" : self.mode?.rawValue
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
