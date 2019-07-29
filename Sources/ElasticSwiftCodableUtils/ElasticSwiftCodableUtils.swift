//
//  CodableUtils.swift
//  ElasticSwiftCodableUtils
//
//  Created by Prafull Kumar Soni on 7/13/19.
//

import Foundation

//MARK:- CodableValue

public protocol CodableWrapper: Codable {
    
    var value: Codable { get }
    
    init<T>(_ value: T) where T: Codable
    
}

extension CodableWrapper {
    
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension CodableWrapper {
    
    public init(nilLiteral: ()) {
        self.init([String: String]())
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

/// Wrapper for `Codable` values similar to `AnyCodable` where value always conforms to `Codable`
public final class CodableValue: CodableWrapper {
    
    public let value: Codable
    
    public init<T>(_ value: T) where T: Codable {
        self.value = value
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.init(nilLiteral: ())
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([CodableValue].self) {
            self.init(array)
        } else if let dictionary = try? container.decode([String: CodableValue].self) {
            self.init(dictionary)
        } else {
            throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "CodableValue cannot be decoded")
        }
    }
}

extension CodableValue: ExpressibleByNilLiteral {}
extension CodableValue: ExpressibleByBooleanLiteral {}
extension CodableValue: ExpressibleByIntegerLiteral {}
extension CodableValue: ExpressibleByFloatLiteral {}
extension CodableValue: ExpressibleByStringLiteral {}
extension CodableValue: ExpressibleByExtendedGraphemeClusterLiteral {}
extension CodableValue: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = CodableValue
    
    public convenience init(arrayLiteral elements: CodableValue...)  {
        self.init(elements)
    }
}
extension CodableValue: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    
    public typealias Value = CodableValue
    
    
    public convenience init(dictionaryLiteral elements: (String, CodableValue)...) {
        self.init([String: CodableValue](elements, uniquingKeysWith: { first, _ in first }))
    }
}


extension CodableValue: CustomStringConvertible {
    public var description: String {
        get {
            if let value = self.value as? CustomStringConvertible {
                return value.description
            }
            return "\(value)"
        }
    }
}

extension CodableValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        get {
            if let value = self.value as? CustomDebugStringConvertible {
                return value.debugDescription
            }
            return self.description
        }
    }
}

extension CodableValue: Equatable {
    
    public static func == (lhs: CodableValue, rhs: CodableValue) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: CodableValue], rhs as [String: CodableValue]):
            return lhs == rhs
        case let (lhs as [CodableValue], rhs as [CodableValue]):
            return lhs == rhs
        default:
            return false
        }
    }
}


//MARK:- DecodableValue

public protocol DecodableWrapper: Decodable {
    
    var value: Decodable { get }
    
    init<T>(_ value: T) where T: Decodable
    
}

extension DecodableWrapper {
    public init(nilLiteral: ()) {
        self.init([String: String]())
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

/// Wrapper for `Decodable` values similar to `AnyDecodable` where value always conforms to `Decodable`
public final class DecodableValue: DecodableWrapper {
    
    public let value: Decodable
    
    public init<T>(_ value: T) where T: Decodable {
        self.value = value
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.init(nilLiteral: ())
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([DecodableValue].self) {
            self.init(array)
        } else if let dictionary = try? container.decode([String: DecodableValue].self) {
            self.init(dictionary)
        } else {
            throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "CodableValue cannot be decoded")
        }
    }
}

extension DecodableValue: ExpressibleByNilLiteral {}
extension DecodableValue: ExpressibleByBooleanLiteral {}
extension DecodableValue: ExpressibleByIntegerLiteral {}
extension DecodableValue: ExpressibleByFloatLiteral {}
extension DecodableValue: ExpressibleByStringLiteral {}
extension DecodableValue: ExpressibleByExtendedGraphemeClusterLiteral {}
extension DecodableValue: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = DecodableValue
    
    public convenience init(arrayLiteral elements: DecodableValue...)  {
        self.init(elements)
    }
}
extension DecodableValue: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    
    public typealias Value = DecodableValue
    
    
    public convenience init(dictionaryLiteral elements: (String, DecodableValue)...) {
        self.init([String: DecodableValue](elements, uniquingKeysWith: { first, _ in first }))
    }
}

extension DecodableValue: CustomStringConvertible {
    public var description: String {
        get {
            if let value = self.value as? CustomStringConvertible {
                return value.description
            }
            return "\(value)"
        }
    }
}

extension DecodableValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        get {
            if let value = self.value as? CustomDebugStringConvertible {
                return value.debugDescription
            }
            return self.description
        }
    }
}

extension DecodableValue: Equatable {
    
    public static func == (lhs: DecodableValue, rhs: DecodableValue) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: DecodableValue], rhs as [String: DecodableValue]):
            return lhs == rhs
        case let (lhs as [DecodableValue], rhs as [DecodableValue]):
            return lhs == rhs
        default:
            return false
        }
    }
}

//MARK:- EncodableValue

public protocol EncodableWrapper: Encodable {
    
    var value: Encodable { get }
    
    init<T>(_ value: T) where T: Encodable
    
}

extension EncodableWrapper {
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension EncodableWrapper {
    
    public init(nilLiteral: ()) {
        self.init([String: String]())
    }
    
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
}

/// Wrapper for `Decodable` values similar to `AnyDecodable` where value always conforms to `Decodable`
public final class EncodableValue: EncodableWrapper {
    
    public let value: Encodable
    
    public init<T>(_ value: T) where T: Encodable {
        self.value = value
    }
}

extension EncodableValue: ExpressibleByNilLiteral {}
extension EncodableValue: ExpressibleByBooleanLiteral {}
extension EncodableValue: ExpressibleByIntegerLiteral {}
extension EncodableValue: ExpressibleByFloatLiteral {}
extension EncodableValue: ExpressibleByStringLiteral {}
extension EncodableValue: ExpressibleByExtendedGraphemeClusterLiteral {}

extension EncodableValue: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = EncodableValue
    
    public convenience init(arrayLiteral elements: EncodableValue...)  {
        self.init(elements)
    }
}

extension EncodableValue: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    
    public typealias Value = EncodableValue
    
    
    public convenience init(dictionaryLiteral elements: (String, EncodableValue)...) {
        self.init([String: EncodableValue](elements, uniquingKeysWith: { first, _ in first }))
    }
}

extension EncodableValue: CustomStringConvertible {
    public var description: String {
        get {
            if let value = self.value as? CustomStringConvertible {
                return value.description
            }
            return "\(value)"
        }
    }
}

extension EncodableValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        get {
            if let value = self.value as? CustomDebugStringConvertible {
                return value.debugDescription
            }
            return self.description
        }
    }
}

extension EncodableValue: Equatable {
    
    public static func == (lhs: EncodableValue, rhs: EncodableValue) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: EncodableValue], rhs as [String: EncodableValue]):
            return lhs == rhs
        case let (lhs as [EncodableValue], rhs as [EncodableValue]):
            return lhs == rhs
        default:
            return false
        }
    }
}
