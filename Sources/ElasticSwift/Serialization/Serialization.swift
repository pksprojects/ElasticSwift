//
//  Serialization.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/5/17.
//
//

import Foundation

public protocol Serializer {
    
    func decode<T: Codable>(data: Data) -> Result<T, Error>
    
    func encode<T: Codable>(_ value: T) -> Result<Data, Error>
    
}

public class DefaultSerializer: Serializer {
    
    public let encoder: JSONEncoder
    public let decoder: JSONDecoder
    
    public init() {
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    public func decode<T: Codable>(data: Data) -> Result<T, Error> {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
    public func encode<T: Codable>(_ value: T) -> Result<Data, Error> {
        do {
            let encoded = try encoder.encode(value)
            return .success(encoded)
        } catch {
            return .failure(error)
        }
    }
}
