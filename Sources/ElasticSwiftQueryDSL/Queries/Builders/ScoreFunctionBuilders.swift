//
//  ScoreFunctionBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/1/19.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - ScoreFunctionBuilders

public class ScoreFunctionBuilders {
    private init() {}

    public static func linearDecayFunction() -> LinearDecayFunctionBuilder {
        return LinearDecayFunctionBuilder()
    }

    public static func gaussDecayFunction() -> GaussDecayFunctionBuilder {
        return GaussDecayFunctionBuilder()
    }

    public static func exponentialDecayFunction() -> ExponentialDecayFunctionBuilder {
        return ExponentialDecayFunctionBuilder()
    }

    public static func scriptFunction() -> ScriptScoreFunctionBuilder {
        return ScriptScoreFunctionBuilder()
    }

    public static func randomFunction() -> RandomScoreFunctionBuilder {
        return RandomScoreFunctionBuilder()
    }

    public static func weightFactorFunction() -> WeightBuilder {
        return WeightBuilder()
    }

    public static func fieldValueFactorFunction() -> FieldValueFactorFunctionBuilder {
        return FieldValueFactorFunctionBuilder()
    }
}

// MARK: - ScoreFunctionBuilder Protocol

public protocol ScoreFunctionBuilder {
    associatedtype ScoreFunctionType: ScoreFunction

    func build() throws -> ScoreFunctionType
}

// MARK: - ScoreFunction Protocol

public protocol ScoreFunction: Codable {
    var scoreFunctionType: ScoreFunctionType { get }

    func isEqualTo(_ other: ScoreFunction) -> Bool
}

public extension ScoreFunction where Self: Equatable {
    func isEqualTo(_ other: ScoreFunction) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

// MARK: - Weight Builder

public class WeightBuilder: ScoreFunctionBuilder {
    private var _weight: Decimal?

    public init() {}

    @discardableResult
    public func set(weight: Decimal) -> WeightBuilder {
        _weight = weight
        return self
    }

    public var weight: Decimal? {
        return _weight
    }

    public func build() throws -> WeightScoreFunction {
        return try WeightScoreFunction(withBuilder: self)
    }
}

// MARK: - Randon Score Function Builder

public class RandomScoreFunctionBuilder: ScoreFunctionBuilder {
    public var _seed: Int?
    public var _field: String?

    public init() {}

    @discardableResult
    public func set(seed: Int) -> RandomScoreFunctionBuilder {
        _seed = seed
        return self
    }

    @discardableResult
    public func set(field: String) -> RandomScoreFunctionBuilder {
        _field = field
        return self
    }

    public var seed: Int? {
        return _seed
    }

    public var field: String? {
        return _field
    }

    public func build() throws -> RandomScoreFunction {
        return try RandomScoreFunction(withBuilder: self)
    }
}

// MARK: - ScriptScoreFunction Builder

public class ScriptScoreFunctionBuilder: ScoreFunctionBuilder {
    private var _script: Script?

    public init() {}

    @discardableResult
    public func set(script: Script) -> ScriptScoreFunctionBuilder {
        _script = script
        return self
    }

    public var script: Script? {
        return _script
    }

    public func build() throws -> ScriptScoreFunction {
        return try ScriptScoreFunction(withBuilder: self)
    }
}

// MARK: - Linear Decay Function Builder

public class LinearDecayFunctionBuilder: ScoreFunctionBuilder {
    private var _field: String?
    private var _origin: String?
    private var _scale: String?
    private var _offset: String?
    private var _decay: Decimal?
    private var _multiValueMode: MultiValueMode?

    public init() {}

    @discardableResult
    public func set(field: String) -> LinearDecayFunctionBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(origin: String) -> LinearDecayFunctionBuilder {
        _origin = origin
        return self
    }

    @discardableResult
    public func set(scale: String) -> LinearDecayFunctionBuilder {
        _scale = scale
        return self
    }

    @discardableResult
    public func set(offset: String) -> LinearDecayFunctionBuilder {
        _offset = offset
        return self
    }

    @discardableResult
    public func set(decay: Decimal) -> LinearDecayFunctionBuilder {
        _decay = decay
        return self
    }

    @discardableResult
    public func set(multiValudMode: MultiValueMode) -> LinearDecayFunctionBuilder {
        _multiValueMode = multiValudMode
        return self
    }

    public var field: String? {
        return _field
    }

    public var origin: String? {
        return _origin
    }

    public var scale: String? {
        return _scale
    }

    public var offset: String? {
        return _offset
    }

    public var decay: Decimal? {
        return _decay
    }

    public var multiValueMode: MultiValueMode? {
        return _multiValueMode
    }

    public func build() throws -> LinearDecayScoreFunction {
        return try LinearDecayScoreFunction(withBuilder: self)
    }
}

// MARK: - Gauss Decay Function Builder

public class GaussDecayFunctionBuilder: ScoreFunctionBuilder {
    private var _field: String?
    private var _origin: String?
    private var _scale: String?
    private var _offset: String?
    private var _decay: Decimal?
    private var _multiValueMode: MultiValueMode?

    public init() {}

    @discardableResult
    public func set(field: String) -> GaussDecayFunctionBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(origin: String) -> GaussDecayFunctionBuilder {
        _origin = origin
        return self
    }

    @discardableResult
    public func set(scale: String) -> GaussDecayFunctionBuilder {
        _scale = scale
        return self
    }

    @discardableResult
    public func set(offset: String) -> GaussDecayFunctionBuilder {
        _offset = offset
        return self
    }

    @discardableResult
    public func set(decay: Decimal) -> GaussDecayFunctionBuilder {
        _decay = decay
        return self
    }

    @discardableResult
    public func set(multiValudMode: MultiValueMode) -> GaussDecayFunctionBuilder {
        _multiValueMode = multiValudMode
        return self
    }

    public var field: String? {
        return _field
    }

    public var origin: String? {
        return _origin
    }

    public var scale: String? {
        return _scale
    }

    public var offset: String? {
        return _offset
    }

    public var decay: Decimal? {
        return _decay
    }

    public var multiValueMode: MultiValueMode? {
        return _multiValueMode
    }

    public func build() throws -> GaussScoreFunction {
        return try GaussScoreFunction(withBuilder: self)
    }
}

// MARK: - Exponential Decay Function Builder

public class ExponentialDecayFunctionBuilder: ScoreFunctionBuilder {
    private var _field: String?
    private var _origin: String?
    private var _scale: String?
    private var _offset: String?
    private var _decay: Decimal?
    private var _multiValueMode: MultiValueMode?

    public init() {}

    @discardableResult
    public func set(field: String) -> ExponentialDecayFunctionBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(origin: String) -> ExponentialDecayFunctionBuilder {
        _origin = origin
        return self
    }

    @discardableResult
    public func set(scale: String) -> ExponentialDecayFunctionBuilder {
        _scale = scale
        return self
    }

    @discardableResult
    public func set(offset: String) -> ExponentialDecayFunctionBuilder {
        _offset = offset
        return self
    }

    @discardableResult
    public func set(decay: Decimal) -> ExponentialDecayFunctionBuilder {
        _decay = decay
        return self
    }

    @discardableResult
    public func set(multiValudMode: MultiValueMode) -> ExponentialDecayFunctionBuilder {
        _multiValueMode = multiValudMode
        return self
    }

    public var field: String? {
        return _field
    }

    public var origin: String? {
        return _origin
    }

    public var scale: String? {
        return _scale
    }

    public var offset: String? {
        return _offset
    }

    public var decay: Decimal? {
        return _decay
    }

    public var multiValueMode: MultiValueMode? {
        return _multiValueMode
    }

    public func build() throws -> ExponentialDecayScoreFunction {
        return try ExponentialDecayScoreFunction(withBuilder: self)
    }
}

// MARK: - Field Value Factor Function Builder

public class FieldValueFactorFunctionBuilder: ScoreFunctionBuilder {
    private var _field: String?
    private var _factor: Decimal?
    private var _modifier: FieldValueFactorScoreFunction.Modifier?
    private var _missing: Decimal?

    public init() {}

    @discardableResult
    public func set(field: String) -> FieldValueFactorFunctionBuilder {
        _field = field
        return self
    }

    @discardableResult
    public func set(factor: Decimal) -> FieldValueFactorFunctionBuilder {
        _factor = factor
        return self
    }

    @discardableResult
    public func set(modifier: FieldValueFactorScoreFunction.Modifier) -> FieldValueFactorFunctionBuilder {
        _modifier = modifier
        return self
    }

    @discardableResult
    public func set(missing: Decimal) -> FieldValueFactorFunctionBuilder {
        _missing = missing
        return self
    }

    public var field: String? {
        return _field
    }

    public var factor: Decimal? {
        return _factor
    }

    public var modifier: FieldValueFactorScoreFunction.Modifier? {
        return _modifier
    }

    public var missing: Decimal? {
        return _missing
    }

    public func build() throws -> FieldValueFactorScoreFunction {
        return try FieldValueFactorScoreFunction(withBuilder: self)
    }
}

// MARK: - ScoreFunctionBuilder Error

/// Error(s) thrown by ScoreFunctionBuilder
public enum ScoreFunctionBuilderError: Error {
    case missingRequiredField(String)
}
