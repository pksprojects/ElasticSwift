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

public extension KeyedDecodingContainer {
    
    func decodeBool(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        return try decode(Bool.self, forKey: key)
    }
    
    func decodeString(forKey key: KeyedDecodingContainer<K>.Key) throws -> String {
        return try decode(String.self, forKey: key)
    }
    
    func decodeInt(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int {
        return try decode(Int.self, forKey: key)
    }
    
    func decodeInt8(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8 {
        return try decode(Int8.self, forKey: key)
    }
    
    func decodeInt16(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16 {
        return try decode(Int16.self, forKey: key)
    }
    
    func decodeInt32(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32 {
        return try decode(Int32.self, forKey: key)
    }
    
    func decodeInt64(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64 {
        return try decode(Int64.self, forKey: key)
    }
    
    func decodeUInt(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt {
        return try decode(UInt.self, forKey: key)
    }
    
    func decodeUInt8(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8 {
        return try decode(UInt8.self, forKey: key)
    }
    
    func decodeUInt16(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16 {
        return try decode(UInt16.self, forKey: key)
    }
    
    func decodeUInt32(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32 {
        return try decode(UInt32.self, forKey: key)
    }
    
    func decodeUInt64(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64 {
        return try decode(UInt64.self, forKey: key)
    }
    
    func decodeDouble(forKey key: KeyedDecodingContainer<K>.Key) throws -> Double {
        return try decode(Double.self, forKey: key)
    }
    
    func decodeDecimal(forKey key: KeyedDecodingContainer<K>.Key) throws -> Decimal {
        return try decode(Decimal.self, forKey: key)
    }
    
    func decodeFloat(forKey key: KeyedDecodingContainer<K>.Key) throws -> Float {
        return try decode(Float.self, forKey: key)
    }
    
    func decodeDic<k, v: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> Dictionary<k, v> where k: Hashable & Decodable {
        return try decode(Dictionary<k, v>.self, forKey: key)
    }
    
    func decodeArray<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> [T] {
        return try decode([T].self, forKey: key)
    }
    
    func decodeBoolIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool? {
        return try decodeIfPresent(Bool.self, forKey: key)
    }
    
    func decodeStringIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> String? {
        return try decodeIfPresent(String.self, forKey: key)
    }
    
    func decodeIntIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int? {
        return try decodeIfPresent(Int.self, forKey: key)
    }
    
    func decodeInt8IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8? {
        return try decodeIfPresent(Int8.self, forKey: key)
    }
    
    func decodeInt16IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16? {
        return try decodeIfPresent(Int16.self, forKey: key)
    }
    
    func decodeInt32IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32? {
        return try decodeIfPresent(Int32.self, forKey: key)
    }
    
    func decodeInt64IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64? {
        return try decodeIfPresent(Int64.self, forKey: key)
    }
    
    func decodeUIntIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt? {
        return try decodeIfPresent(UInt.self, forKey: key)
    }
    
    func decodeUInt8IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8? {
        return try decodeIfPresent(UInt8.self, forKey: key)
    }
    
    func decodetUInt16IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16? {
        return try decodeIfPresent(UInt16.self, forKey: key)
    }
    
    func decodeUInt32IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32? {
        return try decodeIfPresent(UInt32.self, forKey: key)
    }
    
    func decodeUInt64IfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64? {
        return try decodeIfPresent(UInt64.self, forKey: key)
    }
    
    func decodeDoubleIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Double? {
        return try decodeIfPresent(Double.self, forKey: key)
    }
    
    func decodeDecimalIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Decimal? {
        return try decodeIfPresent(Decimal.self, forKey: key)
    }
    
    func decodeFloatIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Float? {
        return try decodeIfPresent(Float.self, forKey: key)
    }
    
    func decodeDicIfPresent<k, v: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> Dictionary<k, v>? where k: Hashable & Decodable {
        return try decodeIfPresent(Dictionary<k, v>.self, forKey: key)
    }
    
    func decodeArrayIfPresent<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> [T]? {
        return try decodeIfPresent([T].self, forKey: key)
    }
    
}

extension UnkeyedDecodingContainer {
    
    mutating func decodeBool() throws -> Bool {
        return try decode(Bool.self)
    }
    
    mutating func decodeString() throws -> String {
        return try decode(String.self)
    }
    
    mutating func decodeInt() throws -> Int {
        return try decode(Int.self)
    }
    
    mutating func decodeInt8() throws -> Int8 {
        return try decode(Int8.self)
    }
    
    mutating func decodeInt16() throws -> Int16 {
        return try decode(Int16.self)
    }
    
    mutating func decodeInt32() throws -> Int32 {
        return try decode(Int32.self)
    }
    
    mutating func decodeInt64() throws -> Int64 {
        return try decode(Int64.self)
    }
    
    mutating func decodeUInt() throws -> UInt {
        return try decode(UInt.self)
    }
    
    mutating func decodeUInt8() throws -> UInt8 {
        return try decode(UInt8.self)
    }
    
    mutating func decodeUInt16() throws -> UInt16 {
        return try decode(UInt16.self)
    }
    
    mutating func decodeUInt32() throws -> UInt32 {
        return try decode(UInt32.self)
    }
    
    mutating func decodeUInt64() throws -> UInt64 {
        return try decode(UInt64.self)
    }
    
    mutating func decodeDouble() throws -> Double {
        return try decode(Double.self)
    }
    
    mutating func decodeDecimal() throws -> Decimal {
        return try decode(Decimal.self)
    }
    
    mutating func decodeFloat() throws -> Float {
        return try decode(Float.self)
    }
    
    mutating func decodeDic<k, v: Decodable>() throws -> Dictionary<k, v> where k: Hashable & Decodable {
        return try decode(Dictionary<k, v>.self)
    }
    
    mutating func decodeArray<T: Decodable>() throws -> [T] {
        return try decode([T].self)
    }
    
    mutating func decodeBoolIfPresent() throws -> Bool? {
        return try decodeIfPresent(Bool.self)
    }
    
    mutating func decodeStringIfPresent() throws -> String? {
        return try decodeIfPresent(String.self)
    }
    
    mutating func decodeIntIfPresent() throws -> Int? {
        return try decodeIfPresent(Int.self)
    }
    
    mutating func decodeInt8IfPresent() throws -> Int8? {
        return try decodeIfPresent(Int8.self)
    }
    
    mutating func decodeInt16IfPresent() throws -> Int16? {
        return try decodeIfPresent(Int16.self)
    }
    
    mutating func decodeInt32IfPresent() throws -> Int32? {
        return try decodeIfPresent(Int32.self)
    }
    
    mutating func decodeInt64IfPresent() throws -> Int64? {
        return try decodeIfPresent(Int64.self)
    }
    
    mutating func decodeUIntIfPresent() throws -> UInt? {
        return try decodeIfPresent(UInt.self)
    }
    
    mutating func decodeUInt8IfPresent() throws -> UInt8? {
        return try decodeIfPresent(UInt8.self)
    }
    
    mutating func decodeUInt16IfPresent() throws -> UInt16? {
        return try decodeIfPresent(UInt16.self)
    }
    
    mutating func decodeUInt32IfPresent() throws -> UInt32? {
        return try decodeIfPresent(UInt32.self)
    }
    
    mutating func decodeUInt64IfPresent() throws -> UInt64? {
        return try decodeIfPresent(UInt64.self)
    }
    
    mutating func decodeDoubleIfPresent() throws -> Double? {
        return try decodeIfPresent(Double.self)
    }
    
    mutating func decodeDecimalIfPresent() throws -> Decimal? {
        return try decodeIfPresent(Decimal.self)
    }
    
    mutating func decodeIfPresentFloat() throws -> Float? {
        return try decodeIfPresent(Float.self)
    }
    
    mutating func decodeIfPresentDic<k, v: Decodable>() throws -> Dictionary<k, v>? where k: Hashable & Decodable {
        return try decodeIfPresent(Dictionary<k, v>.self)
    }
    
    mutating func decodeIfPresentArray<T: Decodable>() throws -> [T]? {
        return try decodeIfPresent([T].self)
    }
    
}

extension SingleValueDecodingContainer {
    
    /// Decodes a single value of the given type.
    ///
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeBool() throws -> Bool {
        return try decode(Bool.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeString() throws -> String {
        return try decode(String.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeDouble() throws -> Double {
        return try decode(Double.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeFloat() throws -> Float {
        return try decode(Float.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeInt() throws -> Int {
        return try decode(Int.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeInt8() throws -> Int8 {
        return try decode(Int8.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeInt16() throws -> Int16 {
        return try decode(Int16.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeInt32() throws -> Int32 {
        return try decode(Int32.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeInt64() throws -> Int64 {
        return try decode(Int64.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeUInt() throws -> UInt {
        return try decode(UInt.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeUInt8() throws -> UInt8 {
        return try decode(UInt8.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeUInt16() throws -> UInt16 {
        return try decode(UInt16.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeUInt32() throws -> UInt32 {
        return try decode(UInt32.self)
    }

    /// Decodes a single value of the given type.
    ///
    /// - parameter type: The type to decode as.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   cannot be converted to the requested type.
    /// - throws: `DecodingError.valueNotFound` if the encountered encoded value
    ///   is null.
    public func decodeUInt64() throws -> UInt64 {
        return try decode(UInt64.self)
    }
    
}
