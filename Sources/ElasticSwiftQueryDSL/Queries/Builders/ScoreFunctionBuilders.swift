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
    var name: String { get }

    func isEqualTo(_ other: ScoreFunction) -> Bool

    func toDic() -> [String: Any]
}

extension ScoreFunction where Self: Equatable {
    public func isEqualTo(_ other: ScoreFunction) -> Bool {
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

// MARK: - Weight Score Function

public struct WeightScoreFunction: ScoreFunction {
    public let name: String = "weight"

    public let weight: Decimal

    public init(_ weight: Decimal) {
        self.weight = weight
    }

    internal init(withBuilder builder: WeightBuilder) throws {
        guard builder.weight != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("weight")
        }

        weight = builder.weight!
    }

    public func toDic() -> [String: Any] {
        return [self.name: self.weight]
    }
}

extension WeightScoreFunction {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        weight = try container.decodeDecimal(forKey: .key(named: name))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encode(weight, forKey: .key(named: name))
    }
}

extension WeightScoreFunction: Equatable {
    public static func == (lhs: WeightScoreFunction, rhs: WeightScoreFunction) -> Bool {
        return lhs.name == rhs.name
            && lhs.weight == rhs.weight
    }
}

// MARK: - Randon Score Function

public struct RandomScoreFunction: ScoreFunction {
    public let name: String = "random_score"

    public let seed: Int
    public let field: String

    public init(field: String, seed: Int) {
        self.seed = seed
        self.field = field
    }

    internal init(withBuilder builder: RandomScoreFunctionBuilder) throws {
        guard builder.seed != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("seed")
        }

        guard builder.field != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("field")
        }

        seed = builder.seed!
        field = builder.field!
    }

    public func toDic() -> [String: Any] {
        return [self.name: [CodingKeys.seed.rawValue: self.seed,
                            CodingKeys.field.rawValue: self.field]]
    }
}

extension RandomScoreFunction {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
        seed = try nested.decodeInt(forKey: .seed)
        field = try nested.decodeString(forKey: .field)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
        try nested.encode(seed, forKey: .seed)
        try nested.encode(field, forKey: .field)
    }

    enum CodingKeys: String, CodingKey {
        case seed
        case field
    }
}

extension RandomScoreFunction: Equatable {
    public static func == (lhs: RandomScoreFunction, rhs: RandomScoreFunction) -> Bool {
        return lhs.name == rhs.name
            && lhs.seed == rhs.seed
            && lhs.field == rhs.field
    }
}

// MARK: Script Score Function

public struct ScriptScoreFunction: ScoreFunction {
    public let name: String = "script_score"

    public let script: Script

    public init(source: String, lang: String? = nil, params: [String: CodableValue]? = nil) {
        script = Script(source, lang: lang, params: params)
    }

    internal init(withBuilder builder: ScriptScoreFunctionBuilder) throws {
        guard builder.script != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("script")
        }

        script = builder.script!
    }

    public func toDic() -> [String: Any] {
        return [self.name: [CodingKeys.script.rawValue: self.script.toDic()]]
    }
}

extension ScriptScoreFunction {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
        script = try nested.decode(Script.self, forKey: .script)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
        try nested.encode(script, forKey: .script)
    }

    enum CodingKeys: String, CodingKey {
        case script
    }
}

extension ScriptScoreFunction: Equatable {
    public static func == (lhs: ScriptScoreFunction, rhs: ScriptScoreFunction) -> Bool {
        return lhs.name == rhs.name
            && lhs.script == rhs.script
    }
}

// MARK: - Linear Decay Score Function

public class LinearDecayScoreFunction: DecayScoreFunction {
    internal init(withBuilder builder: LinearDecayFunctionBuilder) throws {
        guard builder.field != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("field")
        }

        guard builder.origin != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("origin")
        }

        guard builder.scale != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("scale")
        }

        super.init(type: .linear, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset!, decay: builder.decay!, multiValueMode: builder.multiValueMode)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

// MARK: - Gauss Score Function

public class GaussScoreFunction: DecayScoreFunction {
    internal init(withBuilder builder: GaussDecayFunctionBuilder) throws {
        guard builder.field != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("field")
        }

        guard builder.origin != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("origin")
        }

        guard builder.scale != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("scale")
        }

        super.init(type: .gauss, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset!, decay: builder.decay!, multiValueMode: builder.multiValueMode)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

// MARK: - Exponential Decay Score Function

public class ExponentialDecayScoreFunction: DecayScoreFunction {
    internal init(withBuilder builder: ExponentialDecayFunctionBuilder) throws {
        guard builder.field != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("field")
        }

        guard builder.origin != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("origin")
        }

        guard builder.scale != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("scale")
        }

        super.init(type: .exp, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset!, decay: builder.decay!, multiValueMode: builder.multiValueMode)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

// MARK: - Decay Score Function

public class DecayScoreFunction: ScoreFunction {
    public let name: String
    public let field: String

    public let multiValueMode: MultiValueMode?

    public let origin: String
    public let scale: String
    public let offset: String?
    public let decay: Decimal?

    public init(type: DecayScoreFunctionType, field: String, origin: String, scale: String, offset: String? = nil, decay: Decimal? = nil, multiValueMode: MultiValueMode?) {
        name = type.rawValue
        self.field = field
        self.origin = origin
        self.scale = scale
        self.offset = offset
        self.decay = decay
        self.multiValueMode = multiValueMode
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [
            self.field: [
                CodingKeys.origin.rawValue: self.origin,
                CodingKeys.scale.rawValue: self.scale,
            ],
        ]
        if let offset = self.offset {
            if var subDic = dic[self.field] as? [String: Any] {
                subDic[CodingKeys.offset.rawValue] = offset
            }
        }

        if let decay = self.decay {
            if var subDic = dic[self.field] as? [String: Any] {
                subDic[CodingKeys.decay.rawValue] = decay
            }
        }

        if let multiValueMode = self.multiValueMode {
            dic[CodingKeys.multiValueMode.rawValue] = multiValueMode
        }

        return [self.name: dic]
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var name: String?

        for type in DecayScoreFunctionType.allCases {
            if container.contains(.key(named: type.rawValue)) {
                name = type.rawValue
            }
        }

        guard name != nil else {
            throw Swift.DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unable to identify name"))
        }

        self.name = name!

        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: self.name))

        guard nested.allKeys.count == 1 else {
            throw Swift.DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unable to identify field"))
        }

        field = nested.allKeys.first!.stringValue

        let fieldContainer = try nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))

        origin = try fieldContainer.decodeString(forKey: .origin)
        scale = try fieldContainer.decodeString(forKey: .scale)
        offset = try fieldContainer.decodeStringIfPresent(forKey: .offset)
        decay = try fieldContainer.decodeDecimalIfPresent(forKey: .decay)

        multiValueMode = try nested.decodeIfPresent(MultiValueMode.self, forKey: .key(named: CodingKeys.multiValueMode.rawValue))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: name))
        var fieldContainer = nested.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try fieldContainer.encode(origin, forKey: .origin)
        try fieldContainer.encode(scale, forKey: .scale)
        try fieldContainer.encodeIfPresent(offset, forKey: .offset)
        try fieldContainer.encodeIfPresent(decay, forKey: .decay)
        try nested.encodeIfPresent(multiValueMode, forKey: .key(named: CodingKeys.multiValueMode.rawValue))
    }

    enum CodingKeys: String, CodingKey {
        case origin
        case scale
        case offset
        case decay
        case multiValueMode = "multi_value_mode"
    }
}

extension DecayScoreFunction: Equatable {
    public static func == (lhs: DecayScoreFunction, rhs: DecayScoreFunction) -> Bool {
        return lhs.name == rhs.name
            && lhs.field == rhs.field
            && lhs.origin == rhs.origin
            && lhs.scale == rhs.origin
            && lhs.offset == rhs.offset
            && lhs.decay == rhs.decay
            && lhs.multiValueMode == rhs.multiValueMode
    }
}

public enum DecayScoreFunctionType: String, Codable, CaseIterable {
    case linear
    case gauss
    case exp
}

public enum MultiValueMode: String, Codable {
    case min
    case max
    case avg
    case sum
}

// MARK: - Field Value Score Function

public struct FieldValueFactorScoreFunction: ScoreFunction {
    public let name: String = "field_value_factor"

    public let field: String
    public let factor: Decimal
    public let modifier: Modifier?
    public let missing: Decimal?

    public init(field: String, factor: Decimal, modifier: FieldValueFactorScoreFunction.Modifier? = nil, missing: Decimal? = nil) {
        self.field = field
        self.factor = factor
        self.modifier = modifier
        self.missing = missing
    }

    internal init(withBuilder builder: FieldValueFactorFunctionBuilder) throws {
        guard builder.field != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("field")
        }

        guard builder.factor != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("factor")
        }

        self.init(field: builder.field!, factor: builder.factor!, modifier: builder.modifier, missing: builder.missing)
    }

    public func toDic() -> [String: Any] {
        var dic: [String: Any] = [
            CodingKeys.field.rawValue: self.field,
            CodingKeys.factor.rawValue: self.factor,
        ]
        if let modifier = self.modifier {
            dic[CodingKeys.modifier.rawValue] = modifier.rawValue
        }
        if let missing = self.missing {
            dic[CodingKeys.missing.rawValue] = missing
        }
        return [self.name: dic]
    }

    public enum Modifier: String, Codable {
        case none
        case log
        case log1p
        case log2p
        case ln
        case ln1p
        case ln2p
        case square
        case sqrt
        case reciprocal
    }
}

extension FieldValueFactorScoreFunction {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
        field = try nested.decodeString(forKey: .field)
        factor = try nested.decodeDecimal(forKey: .factor)
        missing = try nested.decodeDecimalIfPresent(forKey: .missing)
        modifier = try nested.decodeIfPresent(Modifier.self, forKey: .modifier)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: name))
        try nested.encode(field, forKey: .field)
        try nested.encode(factor, forKey: .factor)
        try nested.encodeIfPresent(modifier, forKey: .modifier)
        try nested.encodeIfPresent(missing, forKey: .missing)
    }

    enum CodingKeys: String, CodingKey {
        case field
        case factor
        case modifier
        case missing
    }
}

extension FieldValueFactorScoreFunction: Equatable {
    public static func == (lhs: FieldValueFactorScoreFunction, rhs: FieldValueFactorScoreFunction) -> Bool {
        return lhs.field == rhs.field
            && lhs.factor == rhs.factor
            && lhs.modifier == rhs.modifier
            && lhs.missing == rhs.missing
    }
}

// MARK: - ScoreFunctionBuilder Error

/// Error(s) thrown by ScoreFunctionBuilder
public enum ScoreFunctionBuilderError: Error {
    case missingRequiredField(String)
}
