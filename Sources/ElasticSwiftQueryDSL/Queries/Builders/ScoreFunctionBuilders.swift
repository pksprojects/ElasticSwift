//
//  ScoreFunctionBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/1/19.
//

import Foundation
import ElasticSwiftCore
import ElasticSwiftCodableUtils

// MARK:- ScoreFunctionBuilders

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

// MARK:- ScoreFunctionBuilder Protocol

public protocol ScoreFunctionBuilder {
    
    associatedtype ScoreFunctionType: ScoreFunction
    
    func build() throws -> ScoreFunctionType
    
}

// MARK:- ScoreFunction Protocol

public protocol ScoreFunction {
    
    var name: String { get }
    
    func toDic() -> [String: Any]
}

// MARK:- Weight Builder

public class WeightBuilder: ScoreFunctionBuilder {
    
    private var _weight: Decimal?
    
    public init() {}
    
    @discardableResult
    public func set(weight: Decimal) -> WeightBuilder {
        self._weight = weight
        return self
    }
    
    public var weight: Decimal? {
        return self._weight
    }
    
    public func build() throws -> WeightScoreFunction {
        return try WeightScoreFunction(withBuilder: self)
    }
    
}

// MARK:- Randon Score Function Builder

public class RandomScoreFunctionBuilder: ScoreFunctionBuilder {
    
    public var _seed: Int?
    public var _field: String?
    
    public init() {}
    
    @discardableResult
    public func set(seed: Int) -> RandomScoreFunctionBuilder {
        self._seed = seed
        return self
    }
    
    @discardableResult
    public func set(field: String) -> RandomScoreFunctionBuilder {
        self._field = field
        return self
    }
    
    public var seed: Int? {
        return self._seed
    }
    public var field: String? {
        return self._field
    }
    
    public func build() throws -> RandomScoreFunction {
        return try RandomScoreFunction(withBuilder: self)
    }
}

// MARK:- ScriptScoreFunction Builder

public class ScriptScoreFunctionBuilder: ScoreFunctionBuilder {
    
    private var _script: Script?
    
    public init() {}
    
    @discardableResult
    public func set(script: Script) -> ScriptScoreFunctionBuilder {
        self._script = script
        return self
    }
    
    public var script: Script? {
        return self._script
    }
    
    public func build() throws -> ScriptScoreFunction {
        return try ScriptScoreFunction(withBuilder: self)
    }
}

// MARK:- Linear Decay Function Builder

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
        self._field = field
        return self
    }
    @discardableResult
    public func set(origin: String) -> LinearDecayFunctionBuilder {
        self._origin = origin
        return self
    }
    @discardableResult
    public func set(scale: String) -> LinearDecayFunctionBuilder {
        self._scale = scale
        return self
    }
    @discardableResult
    public func set(offset: String) -> LinearDecayFunctionBuilder {
        self._offset = offset
        return self
    }
    @discardableResult
    public func set(decay: Decimal) -> LinearDecayFunctionBuilder {
        self._decay = decay
        return self
    }
    @discardableResult
    public func set(multiValudMode: MultiValueMode) -> LinearDecayFunctionBuilder {
        self._multiValueMode = multiValudMode
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var origin: String? {
        return self._origin
    }
    public var scale: String? {
        return self._scale
    }
    public var offset: String? {
        return self._offset
    }
    public var decay: Decimal? {
        return self._decay
    }
    public var multiValueMode: MultiValueMode? {
        return self._multiValueMode
    }
    
    public func build() throws -> LinearDecayScoreFunction {
        return try LinearDecayScoreFunction(withBuilder: self)
    }
}

// MARK:- Gauss Decay Function Builder

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
        self._field = field
        return self
    }
    @discardableResult
    public func set(origin: String) -> GaussDecayFunctionBuilder {
        self._origin = origin
        return self
    }
    @discardableResult
    public func set(scale: String) -> GaussDecayFunctionBuilder {
        self._scale = scale
        return self
    }
    @discardableResult
    public func set(offset: String) -> GaussDecayFunctionBuilder {
        self._offset = offset
        return self
    }
    @discardableResult
    public func set(decay: Decimal) -> GaussDecayFunctionBuilder {
        self._decay = decay
        return self
    }
    @discardableResult
    public func set(multiValudMode: MultiValueMode) -> GaussDecayFunctionBuilder {
        self._multiValueMode = multiValudMode
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var origin: String? {
        return self._origin
    }
    public var scale: String? {
        return self._scale
    }
    public var offset: String? {
        return self._offset
    }
    public var decay: Decimal? {
        return self._decay
    }
    public var multiValueMode: MultiValueMode? {
        return self._multiValueMode
    }
    
    public func build() throws -> GaussScoreFunction {
        return try GaussScoreFunction(withBuilder: self)
    }
}

// MARK:- Exponential Decay Function Builder

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
        self._field = field
        return self
    }
    @discardableResult
    public func set(origin: String) -> ExponentialDecayFunctionBuilder {
        self._origin = origin
        return self
    }
    @discardableResult
    public func set(scale: String) -> ExponentialDecayFunctionBuilder {
        self._scale = scale
        return self
    }
    @discardableResult
    public func set(offset: String) -> ExponentialDecayFunctionBuilder {
        self._offset = offset
        return self
    }
    @discardableResult
    public func set(decay: Decimal) -> ExponentialDecayFunctionBuilder {
        self._decay = decay
        return self
    }
    @discardableResult
    public func set(multiValudMode: MultiValueMode) -> ExponentialDecayFunctionBuilder {
        self._multiValueMode = multiValudMode
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var origin: String? {
        return self._origin
    }
    public var scale: String? {
        return self._scale
    }
    public var offset: String? {
        return self._offset
    }
    public var decay: Decimal? {
        return self._decay
    }
    public var multiValueMode: MultiValueMode? {
        return self._multiValueMode
    }
    
    public func build() throws -> ExponentialDecayScoreFunction {
        return try ExponentialDecayScoreFunction(withBuilder: self)
    }
    
}

// MARK:- Field Value Factor Function Builder

public class FieldValueFactorFunctionBuilder: ScoreFunctionBuilder {
    
    private var _field: String?
    private var _factor: Decimal?
    private var _modifier: FieldValueScoreFunction.Modifier?
    private var _missing: Decimal?
    
    public init() {}
    
    @discardableResult
    public func set(field: String) -> FieldValueFactorFunctionBuilder {
        self._field = field
        return self
    }
    @discardableResult
    public func set(factor: Decimal) -> FieldValueFactorFunctionBuilder {
        self._factor = factor
        return self
    }
    @discardableResult
    public func set(modifier: FieldValueScoreFunction.Modifier) -> FieldValueFactorFunctionBuilder {
        self._modifier = modifier
        return self
    }
    @discardableResult
    public func set(missing: Decimal) -> FieldValueFactorFunctionBuilder {
        self._missing = missing
        return self
    }
    
    public var field: String? {
        return self._field
    }
    public var factor: Decimal? {
        return self._factor
    }
    public var modifier: FieldValueScoreFunction.Modifier? {
        return self._modifier
    }
    public var missing: Decimal? {
        return self._missing
    }
    
    public func build() throws -> FieldValueScoreFunction {
        return try FieldValueScoreFunction(withBuilder: self)
    }
    
}

// MARK:- Weight Score Function

public class WeightScoreFunction: ScoreFunction {
    public var name: String = "weight"
    
    var weight: Decimal
    
    public init(_ weight: Decimal) {
        self.weight = weight
    }
    
    internal init(withBuilder builder: WeightBuilder) throws {
        
        guard builder.weight != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("weight")
        }
        
        self.weight = builder.weight!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: self.weight]
    }
}

// MARK:- Randon Score Function

public class RandomScoreFunction: ScoreFunction {
    
    private static let SEED = "seed"
    private static let FIELD = "field"
    
    public var name: String = "random_score"
    
    var seed: Int
    var field: String
    
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
        
        self.seed = builder.seed!
        self.field = builder.field!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: [RandomScoreFunction.SEED: self.seed,
                            RandomScoreFunction.FIELD: self.field]]
    }
}

// MARK: Script Score Function

public class ScriptScoreFunction: ScoreFunction {
    
    private static let SOURCE = "source"
    private static let LANG = "lang"
    private static let PARAMS = "params"
    private static let SCRIPT = "script"
    
    public var name: String = "script_score"
    
    public let script: Script
    
    public init(source: String, lang: String? = nil, params: [String: CodableValue]? = nil) {
        self.script = Script(source, lang: lang, params: params)
    }
    
    internal init(withBuilder builder: ScriptScoreFunctionBuilder) throws {
        
        guard builder.script != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("script")
        }
        
        self.script = builder.script!
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [:]
        
        dic[ScriptScoreFunction.SOURCE] = self.script.source
        
        if let lang = self.script.lang, !lang.isEmpty {
            dic[ScriptScoreFunction.PARAMS] = lang
        }
        
        if let params = self.script.params, !params.isEmpty {
            dic[ScriptScoreFunction.PARAMS] = params
        }
        return [self.name: [ScriptScoreFunction.SCRIPT: dic]]
    }
}

// MARK:- Linear Decay Score Function

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
}

// MARK:- Gauss Score Function

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
}

// MARK:- Exponential Decay Score Function

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
}

// MARK:- Decay Score Function

public class DecayScoreFunction: ScoreFunction {
    
    private static let ORIGIN = "origin"
    private static let SCALE = "scale"
    private static let OFFSET = "offset"
    private static let DECAY = "decay"
    private static let MULTI_VALUE_MODE = "multi_value_mode"
    
    public let name: String
    public let field: String
    
    public let multiValueMode:  MultiValueMode?
    
    public let origin: String
    public let scale: String
    public let offset: String?
    public let decay: Decimal?
    
    public init(type: DecayScoreFunctionType, field: String, origin: String, scale: String, offset: String? = nil, decay: Decimal? = nil, multiValueMode: MultiValueMode?) {
        self.name = type.rawValue
        self.field = field
        self.origin = origin
        self.scale = scale
        self.offset = offset
        self.decay = decay
        self.multiValueMode = multiValueMode
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [
            self.field: [
                DecayScoreFunction.ORIGIN: self.origin,
                DecayScoreFunction.SCALE: self.scale,
            ]
        ]
        if var subDic = dic[self.field] as? [String: Any] {
            subDic[DecayScoreFunction.OFFSET] = self.offset
        }
        if var subDic = dic[self.field] as? [String: Any] {
            subDic[DecayScoreFunction.DECAY] = self.decay
        }
        
        if let multiValueMode =  self.multiValueMode {
            dic[DecayScoreFunction.MULTI_VALUE_MODE] = multiValueMode
        }
        
        return [self.name: dic]
    }
    
}

public enum DecayScoreFunctionType: String {
    case linear
    case gauss
    case exp
}

public enum MultiValueMode: String {
    case min
    case max
    case avg
    case sum
}

// MARK:- Field Value Score Function

public class FieldValueScoreFunction: ScoreFunction {
    
    private static let FIELD = "field"
    private static let FACTOR = "factor"
    private static let MODIFIER = "modifier"
    private static let MISSING = "missing"
    
    public let name: String = "field_value_factor"
    
    public let field: String
    public let factor: Decimal
    public let modifier: Modifier?
    public let missing: Decimal?
    
    public init(field: String, factor: Decimal, modifier: FieldValueScoreFunction.Modifier? = nil, missing: Decimal? = nil) {
        self.field = field
        self.factor = factor
        self.modifier = modifier
        self.missing = missing
    }
    
    internal convenience init(withBuilder builder: FieldValueFactorFunctionBuilder) throws {
        
        guard builder.field != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("field")
        }
        
        guard builder.factor != nil else {
            throw ScoreFunctionBuilderError.missingRequiredField("factor")
        }
        
        self.init(field: builder.field!, factor: builder.factor!, modifier: builder.modifier, missing: builder.missing)
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [
            FieldValueScoreFunction.FIELD: self.field,
            FieldValueScoreFunction.FACTOR: self.factor
        ]
        if let modifier = self.modifier {
            dic[FieldValueScoreFunction.MODIFIER] = modifier.rawValue
        }
        if let missing = self.missing {
            dic[FieldValueScoreFunction.MISSING] = missing
        }
        return [self.name: dic]
    }
    
    public enum Modifier: String {
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

// MARK:- ScoreFunctionBuilder Error

/// Error(s) thrown by ScoreFunctionBuilder
public enum ScoreFunctionBuilderError: Error {
    case missingRequiredField(String)
}

//public class Script {
//    
//    public let source: String
//    public let params: [String: Any]
//
//    convenience public init(source: String) {
//        self.init(source: source, params: [String: Any]())
//    }
//
//    public init(source: String, params: [String: Any]) {
//        self.source = source
//        self.params = params
//    }
//
//}
