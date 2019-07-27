//
//  Serialization.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/5/17.
//
//

import Foundation

public protocol Serializer {
    
    func decode<T>(data: Data) -> Result<T, DecodingError> where T: Decodable
    
    func encode<T>(_ value: T) -> Result<Data, EncodingError> where T: Encodable
    
}

public class DefaultSerializer: Serializer {
    
    public let encoder: JSONEncoder
    public let decoder: JSONDecoder
    
    public init() {
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    public func decode<T>(data: Data) -> Result<T, DecodingError> where T: Decodable {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(DecodingError(T.self, data: data, error: error))
        }
    }
    
    public func encode<T>(_ value: T) -> Result<Data, EncodingError> where T: Encodable {
        do {
            let encoded = try encoder.encode(value)
            return .success(encoded)
        } catch {
            return .failure(EncodingError(value: value, error: error))
        }
    }
}
