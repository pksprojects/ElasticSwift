//
//  TermLevelQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import Foundation
import ElasticSwiftCore

// MARK:- Term Query Builder

public class TermQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    
    typealias BuilderClosure = (TermQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> TermQueryBuilder {
        self._field = field
        return self
    }
    
    public func set(value: String) -> TermQueryBuilder {
        self._value = value
        return self
    }
    
    public func set(boost: Decimal) -> TermQueryBuilder {
        self._boost = boost
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var value: String? {
        return self._value
    }
    public var boost: Decimal? {
        return self._boost
    }
    
    public func build() throws -> TermQuery {
        return try TermQuery(withBuilder: self)
    }
}

// MARK:- Terms Query Builder

public class TermsQueryBuilder: QueryBuilder {
    
    public var _field: String?
    public var _values: [String] = []
    
    typealias BuilderClosure = (TermsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> TermsQueryBuilder {
        self._field = field
        return self
    }
    
    public func set(values: String...) -> TermsQueryBuilder {
        self._values = values
        return self
    }
    
    public func add(value: String) -> TermsQueryBuilder {
        self._values.append(value)
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var values: [String] {
        return self._values
    }
    
    public func build() throws -> TermsQuery {
        return try TermsQuery(withBuilder: self)
    }

}

// MARK:- Range Query Builder

public class RangeQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _gte: String?
    private var _gt: String?
    private var _lte: String?
    private var _lt: String?
    private var _format: String?
    private var _timeZone: String?
    private var _boost: Decimal?
    private var _relation: ShapeRelation?
    
    typealias BuilderClosure = (RangeQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> RangeQueryBuilder {
        self._field = field
        return self
    }
    
    public func set(gte: String) -> RangeQueryBuilder {
        self._gte = gte
        return self
    }
    
    public func set(gt: String) -> RangeQueryBuilder {
        self._gt = gt
        return self
    }
    
    public func set(lte: String) -> RangeQueryBuilder {
        self._lte = lte
        return self
    }
    
    public func set(lt: String) -> RangeQueryBuilder {
        self._lt = lt
        return self
    }
    
    public func set(format: String) -> RangeQueryBuilder {
        self._format = format
        return self
    }
    
    public func set(timeZone: String) -> RangeQueryBuilder {
        self._timeZone = timeZone
        return self
    }
    
    public func set(boost: Decimal) -> RangeQueryBuilder {
        self._boost = boost
        return self
    }
    
    public func set(relation: ShapeRelation) -> RangeQueryBuilder {
        self._relation = relation
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var gte: String? {
        return self._gte
    }
    public var gt: String? {
        return self._gt
    }
    public var lte: String? {
        return self._lte
    }
    public var lt: String? {
        return self._lt
    }
    public var format: String? {
        return self._format
    }
    public var timeZone: String? {
        return self._timeZone
    }
    public var boost: Decimal? {
        return self._boost
    }
    public var relation: ShapeRelation? {
        return self._relation
    }
    

    public func build() throws -> RangeQuery {
        return try RangeQuery(withBuilder: self)
    }
}

// MARK:- Exists Query Builder

public class ExistsQueryBuilder: QueryBuilder {
    
    private var _field: String?
    
    typealias BuilderClosure = (ExistsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> ExistsQueryBuilder {
        self._field = field
        return self
    }
    
    public var field: String? {
        return self._field
    }

    public func build() throws -> ExistsQuery {
        return try ExistsQuery(withBuilder: self)
    }
}

// MARK:- Prefix Query Builder

public class PrefixQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    
    typealias BuilderClosure = (PrefixQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> PrefixQueryBuilder {
        self._field = field
        return self
    }
    
    public func set(value: String) -> PrefixQueryBuilder {
        self._value = value
        return self
    }
    
    public func set(boost: Decimal) -> PrefixQueryBuilder {
        self._boost = boost
        return self
    }
    
    public var field: String? {
        return self._field
    }
    
    public var value: String? {
        return self._value
    }
    public var boost: Decimal? {
        return self._boost
    }
    
    public func build() throws -> PrefixQuery {
        return try PrefixQuery(withBuilder: self)
    }
}

// MARK:- Wildcard Query Builder

public class WildCardQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    
    typealias BuilderClosure = (WildCardQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> WildCardQueryBuilder {
        self._field = field
        return self
    }
    
    public func set(value: String) -> WildCardQueryBuilder {
        self._value = value
        return self
    }
    
    public func set(boost: Decimal) -> WildCardQueryBuilder {
        self._boost = boost
        return self
    }
    
    public var field: String? {
        return self._field
    }
    
    public var value: String? {
        return self._value
    }
    public var boost: Decimal? {
        return self._boost
    }
    
    public func build() throws -> WildCardQuery {
        return try WildCardQuery(withBuilder: self)
    }

}

// MARK:- Regexp Query Builder

public class RegexpQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _regexFlags: [RegexFlag] = []
    private var _maxDeterminizedStates: Int?
    
    typealias BuilderClosure = (RegexpQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> RegexpQueryBuilder {
        self._field = field
        return self
    }
    
    public func set(value: String) -> RegexpQueryBuilder {
        self._value = value
        return self
    }
    
    public func set(boost: Decimal) -> RegexpQueryBuilder {
        self._boost = boost
        return self
    }
    
    public func set(maxDeterminizedStates: Int) -> RegexpQueryBuilder {
        self._maxDeterminizedStates = maxDeterminizedStates
        return self
    }
    
    public func set(regexFlags: RegexFlag...) -> RegexpQueryBuilder {
        self._regexFlags = regexFlags
        return self
    }
    
    public func add(regexFlag: RegexFlag) -> RegexpQueryBuilder {
        self._regexFlags.append(regexFlag)
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var value: String? {
        return self._value
    }
    public var boost: Decimal? {
        return self._boost
    }
    public var regexFlags: [RegexFlag] {
        return self._regexFlags
    }
    public var maxDeterminizedStates: Int? {
        return self._maxDeterminizedStates
    }
    
    public func build() throws -> RegexpQuery {
        return try RegexpQuery(withBuilder: self)
    }
}

// MARK:- Fuzzy Query Builder

public class FuzzyQueryBuilder: QueryBuilder {
    
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _fuzziness: Int?
    private var _prefixLenght: Int?
    private var _maxExpansions: Int?
    private var _transpositions: Bool?
    
    typealias BuilderClosure = (FuzzyQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(field: String) -> FuzzyQueryBuilder {
        self._field = field
        return self
    }
    
    public func set(value: String) -> FuzzyQueryBuilder {
        self._value = value
        return self
    }
    
    public func set(boost: Decimal) -> FuzzyQueryBuilder {
        self._boost = boost
        return self
    }
    
    public func set(fuzziness: Int) -> FuzzyQueryBuilder {
        self._fuzziness = fuzziness
        return self
    }
    
    public func set(prefixLength: Int) -> FuzzyQueryBuilder {
        self._prefixLenght = prefixLength
        return self
    }
    
    public func set(maxExpansions: Int) -> FuzzyQueryBuilder {
        self._maxExpansions = maxExpansions
        return self
    }
    
    public func set(transpositions: Bool) -> FuzzyQueryBuilder {
        self._transpositions = transpositions
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var value: String? {
        return self._value
    }
    public var boost: Decimal? {
        return self._boost
    }
    public var fuzziness: Int? {
        return self._fuzziness
    }
    public var prefixLenght: Int? {
        return self._prefixLenght
    }
    public var maxExpansions: Int? {
        return self._maxExpansions
    }
    public var transpositions: Bool? {
        return self._transpositions
    }
    
    public func build() throws -> FuzzyQuery {
        return try FuzzyQuery(withBuilder: self)
    }

}

// MARK:- Type Query Builder

public class TypeQueryBuilder: QueryBuilder {
    
    private var _type: String?
    
    typealias BuilderClosure = (TypeQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(type: String) -> TypeQueryBuilder {
        self._type = type
        return self
    }
    
    public var type: String? {
        return self._type
    }
    
    public func build() throws -> TypeQuery {
        return try TypeQuery(withBuilder: self)
    }
}

// MARK:- Ids Query Builder

public class IdsQueryBuilder: QueryBuilder {
    
    private var _type: String?
    private var _ids: [String] = []
    
    typealias BuilderClosure = (IdsQueryBuilder) -> Void
    
    init() {}
    
    convenience init(builderClosure: BuilderClosure) {
        self.init()
        builderClosure(self)
    }
    
    public func set(ids: String...) -> IdsQueryBuilder {
        self._ids = ids
        return self
    }
    
    public func add(id: String) -> IdsQueryBuilder {
        self._ids.append(id)
        return self
    }
    public func set(type: String) -> IdsQueryBuilder {
        self._type = type
        return self
    }
    
    public var type: String? {
        return self._type
    }
    
    public var ids: [String] {
        return self._ids
    }
    
    public func build() throws -> IdsQuery {
        return try IdsQuery(withBuilder: self)
    }
}
