//
//  TermLevelQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import Foundation

// MARK: - Term Query Builder

public class TermQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> TermQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> TermQueryBuilder {
        _value = value
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> TermQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> TermQueryBuilder {
        _name = name
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> TermQuery {
        return try TermQuery(withBuilder: self)
    }
}

// MARK: - Terms Query Builder

public class TermsQueryBuilder: QueryBuilder {
    public var _field: String?
    public var _values: [String] = []
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> TermsQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(values: String...) -> TermsQueryBuilder {
        _values = values
        return self
    }

    @discardableResult
    public func add(value: String) -> TermsQueryBuilder {
        _values.append(value)
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var field: String? {
        return _field
    }

    public var values: [String] {
        return _values
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> TermsQuery {
        return try TermsQuery(withBuilder: self)
    }
}

// MARK: - Range Query Builder

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
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> RangeQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(gte: String) -> RangeQueryBuilder {
        _gte = gte
        return self
    }

    @discardableResult
    public func set(gt: String) -> RangeQueryBuilder {
        _gt = gt
        return self
    }

    @discardableResult
    public func set(lte: String) -> RangeQueryBuilder {
        _lte = lte
        return self
    }

    @discardableResult
    public func set(lt: String) -> RangeQueryBuilder {
        _lt = lt
        return self
    }

    @discardableResult
    public func set(format: String) -> RangeQueryBuilder {
        _format = format
        return self
    }

    @discardableResult
    public func set(timeZone: String) -> RangeQueryBuilder {
        _timeZone = timeZone
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> RangeQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> RangeQueryBuilder {
        _name = name
        return self
    }

    @discardableResult
    public func set(relation: ShapeRelation) -> RangeQueryBuilder {
        _relation = relation
        return self
    }

    public var field: String? {
        return _field
    }

    public var gte: String? {
        return _gte
    }

    public var gt: String? {
        return _gt
    }

    public var lte: String? {
        return _lte
    }

    public var lt: String? {
        return _lt
    }

    public var format: String? {
        return _format
    }

    public var timeZone: String? {
        return _timeZone
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public var relation: ShapeRelation? {
        return _relation
    }

    public func build() throws -> RangeQuery {
        return try RangeQuery(withBuilder: self)
    }
}

// MARK: - Exists Query Builder

public class ExistsQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    public func set(field: String) -> ExistsQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var field: String? {
        return _field
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> ExistsQuery {
        return try ExistsQuery(withBuilder: self)
    }
}

// MARK: - Prefix Query Builder

public class PrefixQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> PrefixQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> PrefixQueryBuilder {
        _value = value
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> PrefixQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> PrefixQuery {
        return try PrefixQuery(withBuilder: self)
    }
}

// MARK: - Wildcard Query Builder

public class WildCardQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> WildCardQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> WildCardQueryBuilder {
        _value = value
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> WildCardQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> WildCardQuery {
        return try WildCardQuery(withBuilder: self)
    }
}

// MARK: - Regexp Query Builder

public class RegexpQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _regexFlags: [RegexFlag] = []
    private var _maxDeterminizedStates: Int?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> RegexpQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> RegexpQueryBuilder {
        _value = value
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> RegexpQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> RegexpQueryBuilder {
        _name = name
        return self
    }

    @discardableResult
    public func set(maxDeterminizedStates: Int) -> RegexpQueryBuilder {
        _maxDeterminizedStates = maxDeterminizedStates
        return self
    }

    @discardableResult
    public func set(regexFlags: RegexFlag...) -> RegexpQueryBuilder {
        _regexFlags = regexFlags
        return self
    }

    @discardableResult
    public func add(regexFlag: RegexFlag) -> RegexpQueryBuilder {
        _regexFlags.append(regexFlag)
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var boost: Decimal? {
        return _boost
    }

    public var regexFlags: [RegexFlag] {
        return _regexFlags
    }

    public var maxDeterminizedStates: Int? {
        return _maxDeterminizedStates
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> RegexpQuery {
        return try RegexpQuery(withBuilder: self)
    }
}

// MARK: - Fuzzy Query Builder

public class FuzzyQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _value: String?
    private var _boost: Decimal?
    private var _fuzziness: Int?
    private var _prefixLenght: Int?
    private var _maxExpansions: Int?
    private var _transpositions: Bool?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> FuzzyQueryBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(value: String) -> FuzzyQueryBuilder {
        _value = value
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> FuzzyQueryBuilder {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    @discardableResult
    public func set(fuzziness: Int) -> FuzzyQueryBuilder {
        _fuzziness = fuzziness
        return self
    }

    @discardableResult
    public func set(prefixLength: Int) -> FuzzyQueryBuilder {
        _prefixLenght = prefixLength
        return self
    }

    @discardableResult
    public func set(maxExpansions: Int) -> FuzzyQueryBuilder {
        _maxExpansions = maxExpansions
        return self
    }

    @discardableResult
    public func set(transpositions: Bool) -> FuzzyQueryBuilder {
        _transpositions = transpositions
        return self
    }

    public var field: String? {
        return _field
    }

    public var value: String? {
        return _value
    }

    public var boost: Decimal? {
        return _boost
    }

    public var fuzziness: Int? {
        return _fuzziness
    }

    public var prefixLenght: Int? {
        return _prefixLenght
    }

    public var maxExpansions: Int? {
        return _maxExpansions
    }

    public var transpositions: Bool? {
        return _transpositions
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> FuzzyQuery {
        return try FuzzyQuery(withBuilder: self)
    }
}

// MARK: - Type Query Builder

public class TypeQueryBuilder: QueryBuilder {
    private var _type: String?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(type: String) -> TypeQueryBuilder {
        _type = type
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var type: String? {
        return _type
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> TypeQuery {
        return try TypeQuery(withBuilder: self)
    }
}

// MARK: - Ids Query Builder

public class IdsQueryBuilder: QueryBuilder {
    private var _type: String?
    private var _ids: [String] = []
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(ids: String...) -> IdsQueryBuilder {
        _ids = ids
        return self
    }

    @discardableResult
    public func add(id: String) -> IdsQueryBuilder {
        _ids.append(id)
        return self
    }

    @discardableResult
    public func set(type: String) -> IdsQueryBuilder {
        _type = type
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var type: String? {
        return _type
    }

    public var ids: [String] {
        return _ids
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> IdsQuery {
        return try IdsQuery(withBuilder: self)
    }
}
