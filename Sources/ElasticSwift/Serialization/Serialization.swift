//
//  Serialization.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/5/17.
//
//

import ElasticSwiftCore
import Foundation

// MARK: - DefaultSerializer

/// `JSONEncoder/JSONDecoder` based default implementation of `Serializer`
public class DefaultSerializer: Serializer {
    /// The encoder of the serializer
    public let encoder: JSONEncoder

    /// The decoder of the serializer
    public let decoder: JSONDecoder

    /// Initializes new serializer.
    /// - Parameters:
    ///   - encoder: json encoder for encoding
    ///   - decoder: json decoder for decoding
    public init(encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Decodes data into object of type `T` conforming to `Decodable`
    /// - Parameter data: data to decode
    /// - Returns: result of either success `T` or failure `DecodingError`
    public func decode<T>(data: Data) -> Result<T, DecodingError> where T: Decodable {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(DecodingError(T.self, data: data, error: error))
        }
    }

    /// Decodes data into object of type `T` conforming to `Encodable`
    /// - Parameter value: value to encode
    /// - Returns: result of either success `Data` or failure `DecodingError`
    public func encode<T>(_ value: T) -> Result<Data, EncodingError> where T: Encodable {
        do {
            let encoded = try encoder.encode(value)
            return .success(encoded)
        } catch {
            return .failure(EncodingError(value: value, error: error))
        }
    }
}
