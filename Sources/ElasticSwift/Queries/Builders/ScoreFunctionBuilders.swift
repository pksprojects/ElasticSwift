//
//  ScoreFunctionBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/1/19.
//

import Foundation

public class ScoreFunctionBuilders {
    
    private init() {}
    
    public static func linearDecayFunction() -> LinearDecayFunctionBuilder {
        return LinearDecayFunctionBuilder()
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


public protocol ScoreFunctionBuilder {
    
    var scoreFunction: ScoreFunction { get }
    
}

public protocol ScoreFunction {
    
    var name: String { get }
    
    func toDic() -> [String: Any]
}


public class WeightBuilder: ScoreFunctionBuilder {
    
    var weight: Float?
    
    public var scoreFunction: ScoreFunction {
        return WeightScoreFunction(withBuilder: self)
    }
    
}

public class RandomScoreFunctionBuilder: ScoreFunctionBuilder {
    
    var seed: Int?
    var field: String?
    
    public var scoreFunction: ScoreFunction {
        return RandomScoreFunction(withBuilder: self)
    }
    
}

public class ScriptScoreFunctionBuilder: ScoreFunctionBuilder {
    
    var script: Script?
    
    public var scoreFunction: ScoreFunction {
        return ScriptScoreFunction(withBuilder: self)
    }
    
}

public class LinearDecayFunctionBuilder: ScoreFunctionBuilder {
    
    public var field: String?
    public var origin: String?
    public var scale: String?
    public var offset: String?
    public var decay: Double?
    public var isMultiValue: Bool = false
    public var multiValueMode: DecayScoreFunction.MultiValueMode = .MIN
    
    public var scoreFunction: ScoreFunction {
        return LinearDecayScoreFunction(withBuilder: self)
    }
    
}

public class GaussDecayFunctionBuilder: ScoreFunctionBuilder {
    
    public var field: String?
    public var origin: String?
    public var scale: String?
    public var offset: String?
    public var decay: Double?
    public var isMultiValue: Bool = false
    public var multiValueMode: DecayScoreFunction.MultiValueMode = .MIN
    
    public var scoreFunction: ScoreFunction {
        return GaussScoreFunction(withBuilder: self)
    }
    
}

public class ExponentialDecayFunctionBuilder: ScoreFunctionBuilder {
    
    public var field: String?
    public var origin: String?
    public var scale: String?
    public var offset: String?
    public var decay: Double?
    public var isMultiValue: Bool = false
    public var multiValueMode: DecayScoreFunction.MultiValueMode = .MIN
    
    public var scoreFunction: ScoreFunction {
        return ExponentialDecayScoreFunction(withBuilder: self)
    }
    
}

public class FieldValueFactorFunctionBuilder: ScoreFunctionBuilder {
    
    var field: String?
    var factor: Float?
    var modifier: FieldValueScoreFunction.Modifier?
    var missing: Double?
    
    public var scoreFunction: ScoreFunction {
        return FieldValueScoreFunction(withBuilder: self)
    }
    
}


public class WeightScoreFunction: ScoreFunction {
    public var name: String = "weight"
    
    var weight: Float
    
    public init(withBuilder builder: WeightBuilder) {
        self.weight = builder.weight!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: self.weight]
    }
}

public class RandomScoreFunction: ScoreFunction {
    public var name: String = "random_score"
    
    var seed: Int
    var field: String
    
    public init(withBuilder builder: RandomScoreFunctionBuilder) {
        self.seed = builder.seed!
        self.field = builder.field!
    }
    
    public func toDic() -> [String : Any] {
        return [self.name: ["seed": self.seed, "field": self.field]]
    }
}

public class ScriptScoreFunction: ScoreFunction {
    public var name: String = "script_score"
    
    var source: String?
    var params: [String: Any] = [String: Any]()
    
    public init(withBuilder builder: ScriptScoreFunctionBuilder) {
        self.source = builder.script?.source
        if let params = builder.script?.params {
            self.params = params
        }
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [String: Any]()
        if let source = self.source {
            dic["source"] = source
        }
        if params.isEmpty {
            dic["params"] = params
        }
        return [self.name: dic]
    }
}

public class LinearDecayScoreFunction: DecayScoreFunction {
    
    public init(withBuilder builder: LinearDecayFunctionBuilder) {
        super.init(type: .Linear, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset!, decay: builder.decay!, isMultiValue: builder.isMultiValue, multiValueMode: builder.multiValueMode)
    }
}

public class GaussScoreFunction: DecayScoreFunction {
    
    public init(withBuilder builder: GaussDecayFunctionBuilder) {
        super.init(type: .Linear, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset!, decay: builder.decay!, isMultiValue: builder.isMultiValue, multiValueMode: builder.multiValueMode)
    }
}

public class ExponentialDecayScoreFunction: DecayScoreFunction {
    
    public init(withBuilder builder: ExponentialDecayFunctionBuilder) {
        super.init(type: .Linear, field: builder.field!, origin: builder.origin!, scale: builder.scale!, offset: builder.offset!, decay: builder.decay!, isMultiValue: builder.isMultiValue, multiValueMode: builder.multiValueMode)
    }
}

public class DecayScoreFunction: ScoreFunction {
    
    private static let ORIGIN = "origin";
    private static let SCALE = "scale";
    private static let OFFSET = "offset";
    private static let DECAY = "decay";
    private static let MULTI_VALUE_MODE = "multi_value_mode";
    
    public var name: String
    public var field: String
    
    public var multiValueMode:  MultiValueMode = .MIN
    
    public var origin: String
    public var scale: String
    public var offset: String
    public var decay: Double
    
    public init(type: DecayScoreFunctionType, field: String, origin: String, scale: String, offset: String, decay: Double, isMultiValue: Bool, multiValueMode: MultiValueMode) {
        self.name = type.rawValue
        self.field = field
        self.origin = origin
        self.scale = scale
        self.offset = offset
        self.decay = decay
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [
            self.field: [
                DecayScoreFunction.ORIGIN: self.origin,
                DecayScoreFunction.SCALE: self.scale,
                DecayScoreFunction.OFFSET: self.offset,
                DecayScoreFunction.DECAY: self.decay,
            ]
        ]
        dic[DecayScoreFunction.MULTI_VALUE_MODE] = self.multiValueMode
        return [self.name: dic]
    }
    
    public enum DecayScoreFunctionType: String {
        case Linear = "linear"
        case Gauss = "gauss"
        case Exponential = "exp"
    }
    
    public enum MultiValueMode: String {
        case MIN = "min"
        case MAX = "max"
        case AVG = "avg"
        case SUM = "sum"
    }
    
}

public class FieldValueScoreFunction: ScoreFunction {
    public var name: String = "field_value_factor"
    
    var field: String
    var factor: Float
    var modifier: Modifier?
    var missing: Double?
    
    public init(withBuilder builder: FieldValueFactorFunctionBuilder) {
        self.field = builder.field!
        self.factor = builder.factor!
        self.modifier = builder.modifier
        self.missing = builder.missing
    }
    
    public func toDic() -> [String : Any] {
        var dic: [String: Any] = [
            "field": self.field,
            "factor": self.factor
        ]
        if let modifier = self.modifier {
            dic["modifier"] = modifier.rawValue
        }
        if let missing = self.missing {
            dic["missing"] = missing
        }
        return [self.name: dic]
    }
    
    public enum Modifier: String {
        case NONE = "none"
        case LOG = "log"
        case LOG1P = "log1p"
        case LOG2P = "log2p"
        case LN = "ln"
        case LN1P = "ln1p"
        case LN2P = "ln2p"
        case SQUARE = "square"
        case SQRT = "sqrt"
        case RECIPROCAL = "reciprocal"
    }
}

public class Script {
    
    public let source: String
    public let params: [String: Any]
    
    convenience public init(source: String) {
        self.init(source: source, params: [String: Any]())
    }
    
    public init(source: String, params: [String: Any]) {
        self.source = source
        self.params = params
    }
    
}
