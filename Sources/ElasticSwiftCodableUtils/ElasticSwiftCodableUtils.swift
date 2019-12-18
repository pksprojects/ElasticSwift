//
//  CodableUtils.swift
//  ElasticSwiftCodableUtils
//
//  Created by Prafull Kumar Soni on 7/13/19.
//

import Foundation

// MARK: - ValueWrapper

/// Protocol for wraping a value for the associated type.
public protocol ValueWrapper {
    associatedtype ValueType

    var value: ValueType { get }

    init(_ value: ValueType)
}

extension ValueWrapper {
    public init(nilLiteral _: ()) {
        self.init(NilValue.nil as! Self.ValueType)
    }

    public init(booleanLiteral value: Bool) {
        self.init(value as! Self.ValueType)
    }

    public init(integerLiteral value: Int) {
        self.init(value as! Self.ValueType)
    }

    public init(floatLiteral value: Double) {
        self.init(value as! Self.ValueType)
    }

    public init(stringLiteral value: String) {
        self.init(value as! Self.ValueType)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value as! Self.ValueType)
    }
}

extension ValueWrapper where Self: Encodable {
    public func encode(to encoder: Encoder) throws {
        if let value = self.value as? Encodable {
            try value.encode(to: encoder)
        } else {
            throw Swift.EncodingError.invalidValue(value, .init(codingPath: encoder.codingPath, debugDescription: "Value is not Encodable"))
        }
    }
}

extension ValueWrapper where Self: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.init(NilValue.nil as! Self.ValueType)
        } else if let bool = try? container.decodeBool() {
            self.init(bool as! Self.ValueType)
        } else if let int = try? container.decodeInt() {
            self.init(int as! Self.ValueType)
        } else if let uint = try? container.decodeUInt() {
            self.init(uint as! Self.ValueType)
        } else if let double = try? container.decodeDouble() {
            self.init(double as! Self.ValueType)
        } else if let decimal = try? container.decodeDecimal() {
            self.init(decimal as! Self.ValueType)
        } else if let string = try? container.decodeString() {
            self.init(string as! Self.ValueType)
        } else if let array: [Bool] = try? container.decodeArray() {
            self.init(array as! Self.ValueType)
        } else if let array: [Int] = try? container.decodeArray() {
            self.init(array as! Self.ValueType)
        } else if let array: [UInt] = try? container.decodeArray() {
            self.init(array as! Self.ValueType)
        } else if let array: [Double] = try? container.decodeArray() {
            self.init(array as! Self.ValueType)
        } else if let array: [Decimal] = try? container.decodeArray() {
            self.init(array as! Self.ValueType)
        } else if let array: [String] = try? container.decodeArray() {
            self.init(array as! Self.ValueType)
        } else if let array: [Self] = try? container.decodeArray() {
            self.init(array as! Self.ValueType)
        } else if let dictionary: [String: Bool] = try? container.decodeDic() {
            self.init(dictionary as! Self.ValueType)
        } else if let dictionary: [String: Int] = try? container.decodeDic() {
            self.init(dictionary as! Self.ValueType)
        } else if let dictionary: [String: UInt] = try? container.decodeDic() {
            self.init(dictionary as! Self.ValueType)
        } else if let dictionary: [String: Double] = try? container.decodeDic() {
            self.init(dictionary as! Self.ValueType)
        } else if let dictionary: [String: Decimal] = try? container.decodeDic() {
            self.init(dictionary as! Self.ValueType)
        } else if let dictionary: [String: String] = try? container.decodeDic() {
            self.init(dictionary as! Self.ValueType)
        } else if let dictionary: [String: Self] = try? container.decodeDic() {
            self.init(dictionary as! Self.ValueType)
        } else {
            throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "DecodableValue cannot be decoded")
        }
    }
}

extension ValueWrapper where Self: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Self

    public init(arrayLiteral elements: Self...) {
        if let elements = elements.map({ $0.value as? Bool }) as? [Bool] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Int }) as? [Int] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Int8 }) as? [Int8] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Int16 }) as? [Int16] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Int32 }) as? [Int32] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Int64 }) as? [Int64] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? UInt }) as? [UInt] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? UInt8 }) as? [UInt8] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? UInt16 }) as? [UInt16] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? UInt32 }) as? [UInt32] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? UInt64 }) as? [UInt64] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Float }) as? [Float] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Double }) as? [Double] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? Decimal }) as? [Decimal] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? String }) as? [String] {
            self.init(elements as! Self.ValueType)
        } else if let elements = elements.map({ $0.value as? NilValue }) as? [NilValue] {
            self.init(elements as! Self.ValueType)
        } else {
            self.init(elements as! Self.ValueType)
        }
    }
}

extension ValueWrapper where Self: ExpressibleByDictionaryLiteral {
    public typealias Key = String

    public typealias Value = Self

    public init(dictionaryLiteral elements: (String, Self)...) {
        if let elements = elements.map({ ($0.0, $0.1.value as? Bool) }) as? [(String, Bool)] {
            self.init([String: Bool](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        } else if let elements = elements.map({ ($0.0, $0.1.value as? Int) }) as? [(String, Int)] {
            self.init([String: Int](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        } else if let elements = elements.map({ ($0.0, $0.1.value as? UInt) }) as? [(String, UInt)] {
            self.init([String: UInt](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        } else if let elements = elements.map({ ($0.0, $0.1.value as? Double) }) as? [(String, Double)] {
            self.init([String: Double](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        } else if let elements = elements.map({ ($0.0, $0.1.value as? Decimal) }) as? [(String, Decimal)] {
            self.init([String: Decimal](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        } else if let elements = elements.map({ ($0.0, $0.1.value as? String) }) as? [(String, String)] {
            self.init([String: String](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        } else if let elements = elements.map({ ($0.0, $0.1.value as? NilValue) }) as? [(String, NilValue)] {
            self.init([String: NilValue](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        } else {
            self.init([String: Self](elements, uniquingKeysWith: { first, _ in first }) as! Self.ValueType)
        }
    }
}

extension ValueWrapper where Self: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
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
        case let (lhs as Decimal, rhs as Decimal):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as NilValue, rhs as NilValue):
            return lhs == rhs
        case let (lhs as [String: Bool], rhs as [String: Bool]):
            return lhs == rhs
        case let (lhs as [String: Int], rhs as [String: Int]):
            return lhs == rhs
        case let (lhs as [String: UInt], rhs as [String: UInt]):
            return lhs == rhs
        case let (lhs as [String: Double], rhs as [String: Double]):
            return lhs == rhs
        case let (lhs as [String: Decimal], rhs as [String: Decimal]):
            return lhs == rhs
        case let (lhs as [String: String], rhs as [String: String]):
            return lhs == rhs
        case let (lhs as [String: Self], rhs as [String: Self]):
            return lhs == rhs
        case let (lhs as [Bool], rhs as [Bool]):
            return lhs == rhs
        case let (lhs as [Int], rhs as [Int]):
            return lhs == rhs
        case let (lhs as [Int8], rhs as [Int8]):
            return lhs == rhs
        case let (lhs as [Int16], rhs as [Int16]):
            return lhs == rhs
        case let (lhs as [Int32], rhs as [Int32]):
            return lhs == rhs
        case let (lhs as [Int64], rhs as [Int64]):
            return lhs == rhs
        case let (lhs as [UInt], rhs as [UInt]):
            return lhs == rhs
        case let (lhs as [UInt8], rhs as [UInt8]):
            return lhs == rhs
        case let (lhs as [UInt16], rhs as [UInt16]):
            return lhs == rhs
        case let (lhs as [UInt32], rhs as [UInt32]):
            return lhs == rhs
        case let (lhs as [UInt64], rhs as [UInt64]):
            return lhs == rhs
        case let (lhs as [Float], rhs as [Float]):
            return lhs == rhs
        case let (lhs as [Double], rhs as [Double]):
            return lhs == rhs
        case let (lhs as [Decimal], rhs as [Decimal]):
            return lhs == rhs
        case let (lhs as [String], rhs as [String]):
            return lhs == rhs
        case let (lhs as [NilValue], rhs as [NilValue]):
            return lhs == rhs
        case let (lhs as [Self], rhs as [Self]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension ValueWrapper where Self: CustomStringConvertible {
    public var description: String {
        if let value = self.value as? CustomStringConvertible {
            return value.description
        }
        return "\(value)"
    }
}

extension ValueWrapper where Self: CustomDebugStringConvertible {
    public var debugDescription: String {
        if let value = self.value as? CustomDebugStringConvertible {
            return value.debugDescription
        } else if let self = self as? CustomStringConvertible {
            return self.description
        } else {
            return "\(value)"
        }
    }
}

// MARK: - CodableValue

/// Wrapper for `Codable` values similar to `AnyCodable` where value always conforms to `Codable`
public struct CodableValue: ValueWrapper, Codable {
    public typealias ValueType = Codable

    public let value: Codable

    public init(_ value: Codable) {
        self.value = value
    }

    init<T>(_ value: T) where T: Codable {
        self.value = value
    }
}

extension CodableValue: ExpressibleByNilLiteral {}
extension CodableValue: ExpressibleByStringLiteral {}
extension CodableValue: ExpressibleByBooleanLiteral {}
extension CodableValue: ExpressibleByIntegerLiteral {}
extension CodableValue: ExpressibleByFloatLiteral {}

extension CodableValue: ExpressibleByArrayLiteral {}
extension CodableValue: ExpressibleByDictionaryLiteral {}

extension CodableValue: Equatable {}

extension CodableValue: CustomStringConvertible {}

extension CodableValue: CustomDebugStringConvertible {}

// MARK: - DecodableValue

/// Wrapper for `Decodable` values similar to `AnyDecodable` where value always conforms to `Decodable`
public struct DecodableValue: ValueWrapper, Decodable {
    public typealias ValueType = Decodable

    public let value: Decodable

    public init(_ value: Decodable) {
        self.value = value
    }

    init<T>(_ value: T) where T: Decodable {
        self.value = value
    }
}

extension DecodableValue: ExpressibleByNilLiteral {}
extension DecodableValue: ExpressibleByStringLiteral {}
extension DecodableValue: ExpressibleByBooleanLiteral {}
extension DecodableValue: ExpressibleByIntegerLiteral {}
extension DecodableValue: ExpressibleByFloatLiteral {}

extension DecodableValue: ExpressibleByArrayLiteral {}
extension DecodableValue: ExpressibleByDictionaryLiteral {}

extension DecodableValue: Equatable {}

extension DecodableValue: CustomStringConvertible {}

extension DecodableValue: CustomDebugStringConvertible {}

// MARK: - EncodableValue

/// Wrapper for `Decodable` values similar to `AnyDecodable` where value always conforms to `Decodable`
public struct EncodableValue: ValueWrapper, Encodable {
    public typealias ValueType = Encodable

    public let value: Encodable

    public init(_ value: Encodable) {
        self.value = value
    }

    init<T>(_ value: T) where T: Encodable {
        self.value = value
    }
}

extension EncodableValue: ExpressibleByNilLiteral {}
extension EncodableValue: ExpressibleByStringLiteral {}
extension EncodableValue: ExpressibleByBooleanLiteral {}
extension EncodableValue: ExpressibleByIntegerLiteral {}
extension EncodableValue: ExpressibleByFloatLiteral {}

extension EncodableValue: ExpressibleByArrayLiteral {}
extension EncodableValue: ExpressibleByDictionaryLiteral {}

extension EncodableValue: Equatable {}

extension EncodableValue: CustomStringConvertible {}

extension EncodableValue: CustomDebugStringConvertible {}

// MARK: - NilValue

public enum NilValue: Codable, ExpressibleByNilLiteral, Equatable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .nil
        }
        throw Swift.DecodingError.dataCorruptedError(in: container, debugDescription: "Non null value can't be used to decode Nil")
    }

    public func encode(to encoder: Encoder) throws {
        var contianer = encoder.singleValueContainer()
        try contianer.encodeNil()
    }

    public init(nilLiteral _: ()) {
        self = .nil
    }

    case `nil`
}

// MARK: - Codable Helper Extensions

public extension KeyedDecodingContainer {
    /// Decodes a value of `Bool` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Bool` type, if present for the given key
    ///   and convertible to the `Bool` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Bool` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeBool(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        return try decode(Bool.self, forKey: key)
    }

    /// Decodes a value of `String` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `String` type, if present for the given key
    ///   and convertible to the `String` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `String` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeString(forKey key: KeyedDecodingContainer<K>.Key) throws -> String {
        return try decode(String.self, forKey: key)
    }

    /// Decodes a value of `Int` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Int` type, if present for the given key
    ///   and convertible to the `Int` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Int` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeInt(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int {
        return try decode(Int.self, forKey: key)
    }

    /// Decodes a value of `Int8` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Int8` type, if present for the given key
    ///   and convertible to the `Int8` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Int8` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeInt8(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8 {
        return try decode(Int8.self, forKey: key)
    }

    /// Decodes a value of `Int16` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Int16` type, if present for the given key
    ///   and convertible to the `Int16` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Int16` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeInt16(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16 {
        return try decode(Int16.self, forKey: key)
    }

    /// Decodes a value of `Int32` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Int32` type, if present for the given key
    ///   and convertible to the `Int32` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Int32` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeInt32(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32 {
        return try decode(Int32.self, forKey: key)
    }

    /// Decodes a value of `Int64` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Int64` type, if present for the given key
    ///   and convertible to the `Int64` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Int64` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeInt64(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64 {
        return try decode(Int64.self, forKey: key)
    }

    /// Decodes a value of `UInt` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `UInt` type, if present for the given key
    ///   and convertible to the `UInt` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `UInt` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeUInt(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt {
        return try decode(UInt.self, forKey: key)
    }

    /// Decodes a value of `UInt8` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `UInt8` type, if present for the given key
    ///   and convertible to the `UInt8` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `UInt8` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeUInt8(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8 {
        return try decode(UInt8.self, forKey: key)
    }

    /// Decodes a value of `UInt16` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `UInt16` type, if present for the given key
    ///   and convertible to the `UInt16` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `UInt16` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeUInt16(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16 {
        return try decode(UInt16.self, forKey: key)
    }

    /// Decodes a value of `UInt32` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `UInt32` type, if present for the given key
    ///   and convertible to the `UInt32` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `UInt32` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeUInt32(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32 {
        return try decode(UInt32.self, forKey: key)
    }

    /// Decodes a value of `UInt64` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `UInt64` type, if present for the given key
    ///   and convertible to the `UInt64` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `UInt64` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeUInt64(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64 {
        return try decode(UInt64.self, forKey: key)
    }

    /// Decodes a value of `Double` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Double` type, if present for the given key
    ///   and convertible to the `Double` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Double` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeDouble(forKey key: KeyedDecodingContainer<K>.Key) throws -> Double {
        return try decode(Double.self, forKey: key)
    }

    /// Decodes a value of `Decimal` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Decimal` type, if present for the given key
    ///   and convertible to the `Decimal` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Decimal` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeDecimal(forKey key: KeyedDecodingContainer<K>.Key) throws -> Decimal {
        return try decode(Decimal.self, forKey: key)
    }

    /// Decodes a value of `Float` type for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Float` type, if present for the given key
    ///   and convertible to the `Float` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Float` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeFloat(forKey key: KeyedDecodingContainer<K>.Key) throws -> Float {
        return try decode(Float.self, forKey: key)
    }

    /// Decodes a value of `Dictionary<k, v>` type  where `k: Hashable & Decodable`  and `v: Decodable` for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Dictionary<k, v>` type, if present for the given key
    ///   and convertible to the `Dictionary<k, v>` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Dictionary<k, v>` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeDic<k, v: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> [k: v] where k: Hashable & Decodable {
        return try decode([k: v].self, forKey: key)
    }

    /// Decodes a value of `Array<T>` type where `T: Decodable` for the given key.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A value of the `Array<T>` type, if present for the given key
    ///   and convertible to the `Array<T>` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the `Array<T>` type.
    /// - throws: `DecodingError.keyNotFound` if `self` does not have an entry
    ///   for the given key.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for
    ///   the given key.
    func decodeArray<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> [T] {
        return try decode([T].self, forKey: key)
    }
}

public extension KeyedDecodingContainer {
    /// Decodes a value of `Bool` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Bool`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Bool`  type.
    func decodeBoolIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool? {
        return try decodeIfPresent(Bool.self, forKey: key)
    }

    /// Decodes a value of `String` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `String`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `String`  type.
    func decodeStringIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> String? {
        return try decodeIfPresent(String.self, forKey: key)
    }

    /// Decodes a value of `Int` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Int`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int`  type.
    func decodeIntIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int? {
        return try decodeIfPresent(Int.self, forKey: key)
    }

    /// Decodes a value of `Int8` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Int8`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int8`  type.
    func decodeInt8IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8? {
        return try decodeIfPresent(Int8.self, forKey: key)
    }

    /// Decodes a value of `Int16` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Int16`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int16`  type.
    func decodeInt16IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16? {
        return try decodeIfPresent(Int16.self, forKey: key)
    }

    /// Decodes a value of `Int32` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Int32`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int32`  type.
    func decodeInt32IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32? {
        return try decodeIfPresent(Int32.self, forKey: key)
    }

    /// Decodes a value of `Int64` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Int64`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int64`  type.
    func decodeInt64IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64? {
        return try decodeIfPresent(Int64.self, forKey: key)
    }

    /// Decodes a value of `UInt` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `UInt`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt`  type.
    func decodeUIntIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt? {
        return try decodeIfPresent(UInt.self, forKey: key)
    }

    /// Decodes a value of `UInt8` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `UInt8`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt8`  type.
    func decodeUInt8IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8? {
        return try decodeIfPresent(UInt8.self, forKey: key)
    }

    /// Decodes a value of `UInt16` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `UInt16`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt16`  type.
    func decodetUInt16IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16? {
        return try decodeIfPresent(UInt16.self, forKey: key)
    }

    /// Decodes a value of `UInt32` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `UInt32`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt32`  type.
    func decodeUInt32IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32? {
        return try decodeIfPresent(UInt32.self, forKey: key)
    }

    /// Decodes a value of `UInt64` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `UInt64`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt64`  type.
    func decodeUInt64IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64? {
        return try decodeIfPresent(UInt64.self, forKey: key)
    }

    /// Decodes a value of `Double` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Double`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Double`  type.
    func decodeDoubleIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Double? {
        return try decodeIfPresent(Double.self, forKey: key)
    }

    /// Decodes a value of `Decimal` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Decimal`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Decimal`  type.
    func decodeDecimalIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Decimal? {
        return try decodeIfPresent(Decimal.self, forKey: key)
    }

    /// Decodes a value of `Float` type for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Float`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Float`  type.
    func decodeFloatIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Float? {
        return try decodeIfPresent(Float.self, forKey: key)
    }

    /// Decodes a value of `Dictionary<k, v>` type where `k: Hashable & Decodable`  and `v: Decodable` for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Dictionary<k, v>`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Dictionary<k, v>`  type.
    func decodeDicIfPresent<k, v: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> [k: v]? where k: Hashable & Decodable {
        return try decodeIfPresent([k: v].self, forKey: key)
    }

    /// Decodes a value of `Array<T>` type where `T: Decodable` for the given key, if present.
    ///
    /// This method returns `nil` if the container does not have a value
    /// associated with `key`, or if the value is null. The difference between
    /// these states can be distinguished with a `contains(_:)` call.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - returns: A decoded value of `Array<T>`  type, or `nil` if the
    ///   `Decoder` does not have an entry associated with the given key, or if
    ///   the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Array<T>`  type.
    func decodeArrayIfPresent<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> [T]? {
        return try decodeIfPresent([T].self, forKey: key)
    }
}

public extension UnkeyedDecodingContainer {
    /// Decodes a value of `Bool` type.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A value of `Bool` type, if present for the given key
    ///   and convertible to `Bool` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Bool`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeBool() throws -> Bool {
        return try decode(Bool.self)
    }

    /// Decodes a value of `String` type.
    ///
    /// - returns: A value of `Bool` type, if present for the given key
    ///   and convertible to `String` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `String`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeString() throws -> String {
        return try decode(String.self)
    }

    /// Decodes a value of `Int` type.
    ///
    /// - returns: A value of `Int` type, if present for the given key
    ///   and convertible to `Int` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeInt() throws -> Int {
        return try decode(Int.self)
    }

    /// Decodes a value of `Int8` type.
    ///
    /// - returns: A value of `Int8` type, if present for the given key
    ///   and convertible to `Int8` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int8`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeInt8() throws -> Int8 {
        return try decode(Int8.self)
    }

    /// Decodes a value of `Int16` type.
    ///
    /// - returns: A value of `Int16` type, if present for the given key
    ///   and convertible to `Int16` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int16`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeInt16() throws -> Int16 {
        return try decode(Int16.self)
    }

    /// Decodes a value of `Int32` type.
    ///
    /// - returns: A value of `Int32` type, if present for the given key
    ///   and convertible to `Int32` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int32`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeInt32() throws -> Int32 {
        return try decode(Int32.self)
    }

    /// Decodes a value of `Int64` type.
    ///
    /// - returns: A value of `Int64` type, if present for the given key
    ///   and convertible to `Int64` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int64`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeInt64() throws -> Int64 {
        return try decode(Int64.self)
    }

    /// Decodes a value of `UInt` type.
    ///
    /// - returns: A value of `UInt` type, if present for the given key
    ///   and convertible to `UInt` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeUInt() throws -> UInt {
        return try decode(UInt.self)
    }

    /// Decodes a value of `UInt8` type.
    ///
    /// - returns: A value of `UInt8` type, if present for the given key
    ///   and convertible to `UInt8` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt8`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeUInt8() throws -> UInt8 {
        return try decode(UInt8.self)
    }

    /// Decodes a value of `UInt16` type.
    ///
    /// - returns: A value of `UInt16` type, if present for the given key
    ///   and convertible to `UInt16` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt16`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeUInt16() throws -> UInt16 {
        return try decode(UInt16.self)
    }

    /// Decodes a value of `UInt32` type.
    ///
    /// - returns: A value of `UInt32` type, if present for the given key
    ///   and convertible to `UInt32` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt32`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeUInt32() throws -> UInt32 {
        return try decode(UInt32.self)
    }

    /// Decodes a value of `UInt64` type.
    ///
    /// - returns: A value of `UInt64` type, if present for the given key
    ///   and convertible to `UInt64` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt64`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeUInt64() throws -> UInt64 {
        return try decode(UInt64.self)
    }

    /// Decodes a value of `Double` type.
    ///
    /// - returns: A value of `Double` type, if present for the given key
    ///   and convertible to `Double` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Double`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeDouble() throws -> Double {
        return try decode(Double.self)
    }

    /// Decodes a value of `Decimal` type.
    ///
    /// - returns: A value of `Decimal` type, if present for the given key
    ///   and convertible to `Decimal` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Decimal`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeDecimal() throws -> Decimal {
        return try decode(Decimal.self)
    }

    /// Decodes a value of `Float` type.
    ///
    /// - returns: A value of `Float` type, if present for the given key
    ///   and convertible to `Float` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Float`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeFloat() throws -> Float {
        return try decode(Float.self)
    }

    /// Decodes a value of `Dictionary<k, v>` type where `k: Hashable & Decodable` and `v: Decodable`.
    ///
    /// - returns: A value of `Dictionary<k, v>` type, if present for the given key
    ///   and convertible to `Dictionary<k, v>` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Dictionary<k, v>`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeDic<k, v: Decodable>() throws -> [k: v] where k: Hashable & Decodable {
        return try decode([k: v].self)
    }

    /// Decodes a value of `Array<T>` type where `T: Decodable`.
    ///
    /// - returns: A value of `Array<T>` type, if present for the given key
    ///   and convertible to `Array<T>` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Array<T>`type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null, or of there are no more values to decode.
    mutating func decodeArray<T: Decodable>() throws -> [T] {
        return try decode([T].self)
    }
}

public extension UnkeyedDecodingContainer {
    /// Decodes a value of `Bool` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A decoded value of `Bool` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Bool`  type.
    mutating func decodeBoolIfPresent() throws -> Bool? {
        return try decodeIfPresent(Bool.self)
    }

    /// Decodes a value of `String` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `String` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `String`  type.
    mutating func decodeStringIfPresent() throws -> String? {
        return try decodeIfPresent(String.self)
    }

    /// Decodes a value of `Int` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Int` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int`  type.
    mutating func decodeIntIfPresent() throws -> Int? {
        return try decodeIfPresent(Int.self)
    }

    /// Decodes a value of `Int8` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Int8` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int8`  type.
    mutating func decodeInt8IfPresent() throws -> Int8? {
        return try decodeIfPresent(Int8.self)
    }

    /// Decodes a value of `Int16` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Int16` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int16`  type.
    mutating func decodeInt16IfPresent() throws -> Int16? {
        return try decodeIfPresent(Int16.self)
    }

    /// Decodes a value of `Int32` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Int32` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int32`  type.
    mutating func decodeInt32IfPresent() throws -> Int32? {
        return try decodeIfPresent(Int32.self)
    }

    /// Decodes a value of `Int64` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Int64` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Int64`  type.
    mutating func decodeInt64IfPresent() throws -> Int64? {
        return try decodeIfPresent(Int64.self)
    }

    /// Decodes a value of `UInt` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `UInt` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt`  type.
    mutating func decodeUIntIfPresent() throws -> UInt? {
        return try decodeIfPresent(UInt.self)
    }

    /// Decodes a value of `UInt8` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `UInt8` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt8`  type.
    mutating func decodeUInt8IfPresent() throws -> UInt8? {
        return try decodeIfPresent(UInt8.self)
    }

    /// Decodes a value of `UInt16` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `UInt16` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt16`  type.
    mutating func decodeUInt16IfPresent() throws -> UInt16? {
        return try decodeIfPresent(UInt16.self)
    }

    /// Decodes a value of `UInt32` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `UInt32` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt32`  type.
    mutating func decodeUInt32IfPresent() throws -> UInt32? {
        return try decodeIfPresent(UInt32.self)
    }

    /// Decodes a value of `UInt64` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `UInt64` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `UInt64`  type.
    mutating func decodeUInt64IfPresent() throws -> UInt64? {
        return try decodeIfPresent(UInt64.self)
    }

    /// Decodes a value of `Double` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Double` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Double`  type.
    mutating func decodeDoubleIfPresent() throws -> Double? {
        return try decodeIfPresent(Double.self)
    }

    /// Decodes a value of `Decimal` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Decimal` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Decimal`  type.
    mutating func decodeDecimalIfPresent() throws -> Decimal? {
        return try decodeIfPresent(Decimal.self)
    }

    /// Decodes a value of `Float` type, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Float` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Float`  type.
    mutating func decodeIfPresentFloat() throws -> Float? {
        return try decodeIfPresent(Float.self)
    }

    /// Decodes a value of `Dictionary<k, v>` type where `k: Hashable & Decodable` and `v: Decodable`, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Dictionary<k, v>` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Dictionary<k, v>`  type.
    mutating func decodeIfPresentDic<k, v: Decodable>() throws -> [k: v]? where k: Hashable & Decodable {
        return try decodeIfPresent([k: v].self)
    }

    /// Decodes a value of `Array<T>` type where `T: Decodable`, if present.
    ///
    /// This method returns `nil` if the container has no elements left to
    /// decode, or if the value is null. The difference between these states can
    /// be distinguished by checking `isAtEnd`.
    ///
    /// - returns: A decoded value of `Array<T>` type, or `nil` if the value
    ///   is a null value, or if there are no more elements to decode.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to `Array<T>`  type.
    mutating func decodeIfPresentArray<T: Decodable>() throws -> [T]? {
        return try decodeIfPresent([T].self)
    }
}

public extension SingleValueDecodingContainer {
    /// Decodes a single value of `Bool` type.
    ///
    /// - returns: A value of `Bool` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Bool` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeBool() throws -> Bool {
        return try decode(Bool.self)
    }

    /// Decodes a single value of `String` type.
    ///
    /// - returns: A value of `String` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `String` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeString() throws -> String {
        return try decode(String.self)
    }

    /// Decodes a single value of `Double` type.
    ///
    /// - returns: A value of `Double` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Double` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeDouble() throws -> Double {
        return try decode(Double.self)
    }

    /// Decodes a single value of `Float` type.
    ///
    /// - returns: A value of `Float` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Float` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeFloat() throws -> Float {
        return try decode(Float.self)
    }

    /// Decodes a single value of `Int` type.
    ///
    /// - returns: A value of `Int` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Int` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeInt() throws -> Int {
        return try decode(Int.self)
    }

    /// Decodes a single value of `Int8` type.
    ///
    /// - returns: A value of `Int8` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Int8` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeInt8() throws -> Int8 {
        return try decode(Int8.self)
    }

    /// Decodes a single value of `Int16` type.
    ///
    /// - returns: A value of `Int16` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Int16` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeInt16() throws -> Int16 {
        return try decode(Int16.self)
    }

    /// Decodes a single value of `Int32` type.
    ///
    /// - returns: A value of `Int32` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Int32` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeInt32() throws -> Int32 {
        return try decode(Int32.self)
    }

    /// Decodes a single value of `Int64` type.
    ///
    /// - returns: A value of `Int64` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Int64` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeInt64() throws -> Int64 {
        return try decode(Int64.self)
    }

    /// Decodes a single value of `UInt` type.
    ///
    /// - returns: A value of `UInt` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `UInt` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeUInt() throws -> UInt {
        return try decode(UInt.self)
    }

    /// Decodes a single value of `UInt8` type.
    ///
    /// - returns: A value of `UInt8` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `UInt8` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeUInt8() throws -> UInt8 {
        return try decode(UInt8.self)
    }

    /// Decodes a single value of `UInt16` type.
    ///
    /// - returns: A value of `UInt16` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `UInt16` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeUInt16() throws -> UInt16 {
        return try decode(UInt16.self)
    }

    /// Decodes a single value of `UInt32` type.
    ///
    /// - returns: A value of `UInt32` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `UInt32` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeUInt32() throws -> UInt32 {
        return try decode(UInt32.self)
    }

    /// Decodes a single value of `UInt64` type.
    ///
    /// - returns: A value of `UInt64` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `UInt64` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeUInt64() throws -> UInt64 {
        return try decode(UInt64.self)
    }

    /// Decodes a single value of `Decimal` type.
    ///
    /// - returns: A value of `Decimal` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Decimal` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeDecimal() throws -> Decimal {
        return try decode(Decimal.self)
    }

    /// Decodes a single value of `Dictionary<k, v>` type where `k: Hashable & Decodable`  and `v: Decodable`.
    ///
    /// - returns: A value of `Dictionary<k, v>` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Dictionary<k, v>` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeDic<k, v: Decodable>() throws -> [k: v] where k: Hashable & Decodable {
        return try decode([k: v].self)
    }

    /// Decodes a single value of `Array<T>` type where `T: Decodable`.
    ///
    /// - returns: A value of `Array<T>` type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to `Array<T>` type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    func decodeArray<T: Decodable>() throws -> [T] {
        return try decode([T].self)
    }
}
