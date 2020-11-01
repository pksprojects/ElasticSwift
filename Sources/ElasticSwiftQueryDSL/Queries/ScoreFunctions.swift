//
//  ScoreFunctions.swift
//
//
//  Created by Prafull Kumar Soni on 2/14/20.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - Weight Score Function

public struct WeightScoreFunction: ScoreFunction {
    public let scoreFunctionType: ScoreFunctionType = .weight

    public let weight: Decimal

    public init(_ weight: Decimal) {
        self.weight = weight
    }

    internal init(withBuilder builder: WeightBuilder) throws {
        guard builder.weight != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("weight")
        }

        self.init(builder.weight!)
    }
}

public extension WeightScoreFunction {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        weight = try container.decodeDecimal(forKey: .key(named: scoreFunctionType))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encode(weight, forKey: .key(named: scoreFunctionType))
    }
}

extension WeightScoreFunction: Equatable {
    public static func == (lhs: WeightScoreFunction, rhs: WeightScoreFunction) -> Bool {
        return lhs.scoreFunctionType == rhs.scoreFunctionType
            && lhs.weight == rhs.weight
    }
}

// MARK: - Randon Score Function

public struct RandomScoreFunction: ScoreFunction {
    public let scoreFunctionType: ScoreFunctionType = .randomScore

    public let seed: Int?
    public let field: String?

    public init(field: String? = nil, seed: Int? = nil) {
        self.seed = seed
        self.field = field
    }

    internal init(withBuilder builder: RandomScoreFunctionBuilder) throws {
//        guard builder.seed != nil else {
//            throw ScoreFunctionBuilderError.missingRequiredField("seed")
//        }
//
//        guard builder.field != nil else {
//            throw ScoreFunctionBuilderError.missingRequiredField("field")
//        }

        self.init(field: builder.field!, seed: builder.seed!)
    }
}

public extension RandomScoreFunction {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: scoreFunctionType))
        seed = try nested.decodeIntIfPresent(forKey: .seed)
        field = try nested.decodeStringIfPresent(forKey: .field)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: scoreFunctionType))
        try nested.encodeIfPresent(seed, forKey: .seed)
        try nested.encodeIfPresent(field, forKey: .field)
    }

    internal enum CodingKeys: String, CodingKey {
        case seed
        case field
    }
}

extension RandomScoreFunction: Equatable {
    public static func == (lhs: RandomScoreFunction, rhs: RandomScoreFunction) -> Bool {
        return lhs.scoreFunctionType == rhs.scoreFunctionType
            && lhs.seed == rhs.seed
            && lhs.field == rhs.field
    }
}

// MARK: Script Score Function

public struct ScriptScoreFunction: ScoreFunction {
    public let scoreFunctionType: ScoreFunctionType = .scriptScore

    public let script: Script

    public init(_ script: Script) {
        self.script = script
    }

    public init(source: String, lang: String? = nil, params: [String: CodableValue]? = nil) {
        self.init(Script(source, lang: lang, params: params))
    }

    internal init(withBuilder builder: ScriptScoreFunctionBuilder) throws {
        guard builder.script != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("script")
        }

        self.init(builder.script!)
    }
}

public extension ScriptScoreFunction {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: scoreFunctionType))
        script = try nested.decode(Script.self, forKey: .script)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: scoreFunctionType))
        try nested.encode(script, forKey: .script)
    }

    internal enum CodingKeys: String, CodingKey {
        case script
    }
}

extension ScriptScoreFunction: Equatable {
    public static func == (lhs: ScriptScoreFunction, rhs: ScriptScoreFunction) -> Bool {
        return lhs.scoreFunctionType == rhs.scoreFunctionType
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

        super.init(type: .linear, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset, decay: builder.decay, multiValueMode: builder.multiValueMode)
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

        super.init(type: .gauss, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset, decay: builder.decay, multiValueMode: builder.multiValueMode)
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

        super.init(type: .exp, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset, decay: builder.decay, multiValueMode: builder.multiValueMode)
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

// MARK: - Decay Score Function

public class DecayScoreFunction: ScoreFunction {
    public let type: DecayScoreFunctionType
    public let field: String

    public let multiValueMode: MultiValueMode?

    public let origin: String
    public let scale: String
    public let offset: String?
    public let decay: Decimal?

    public init(type: DecayScoreFunctionType, field: String, origin: String, scale: String, offset: String? = nil, decay: Decimal? = nil, multiValueMode: MultiValueMode?) {
        self.type = type
        self.field = field
        self.origin = origin
        self.scale = scale
        self.offset = offset
        self.decay = decay
        self.multiValueMode = multiValueMode
    }

    public var scoreFunctionType: ScoreFunctionType {
        return type.scoreFunctionType
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var functionType: DecayScoreFunctionType?

        for type in DecayScoreFunctionType.allCases {
            if container.contains(.key(named: type.scoreFunctionType.rawValue)) {
                functionType = type
            }
        }

        guard functionType != nil else {
            throw Swift.DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unable to identify DecayScoreFunctionType"))
        }

        type = functionType!

        let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: type.scoreFunctionType))

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
        var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: type.scoreFunctionType))
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
        return lhs.type == rhs.type
            && lhs.field == rhs.field
            && lhs.origin == rhs.origin
            && lhs.scale == rhs.scale
            && lhs.offset == rhs.offset
            && lhs.decay == rhs.decay
            && lhs.multiValueMode == rhs.multiValueMode
    }
}

public enum DecayScoreFunctionType: String, Codable, CaseIterable, Equatable {
    case linear
    case gauss
    case exp

    var scoreFunctionType: ScoreFunctionType {
        switch self {
        case .exp:
            return .exp
        case .gauss:
            return .gauss
        case .linear:
            return .linear
        }
    }
}

public enum MultiValueMode: String, Codable {
    case min
    case max
    case avg
    case sum
}

// MARK: - Field Value Score Function

public struct FieldValueFactorScoreFunction: ScoreFunction {
    public let scoreFunctionType: ScoreFunctionType = .fieldValueFactor

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

public extension FieldValueFactorScoreFunction {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: scoreFunctionType))
        field = try nested.decodeString(forKey: .field)
        factor = try nested.decodeDecimal(forKey: .factor)
        missing = try nested.decodeDecimalIfPresent(forKey: .missing)
        modifier = try nested.decodeIfPresent(Modifier.self, forKey: .modifier)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: scoreFunctionType))
        try nested.encode(field, forKey: .field)
        try nested.encode(factor, forKey: .factor)
        try nested.encodeIfPresent(modifier, forKey: .modifier)
        try nested.encodeIfPresent(missing, forKey: .missing)
    }

    internal enum CodingKeys: String, CodingKey {
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
