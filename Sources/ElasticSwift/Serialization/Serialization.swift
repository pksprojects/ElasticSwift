//
//  Serialization.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/5/17.
//
//

import Foundation

public protocol Serializer {
    
    func decode<T>(data: Data) -> Result<T, Error> where T: Decodable
    
    func encode<T>(_ value: T) -> Result<Data, Error> where T: Encodable
    
}

public class DefaultSerializer: Serializer {
    
    public let encoder: JSONEncoder
    public let decoder: JSONDecoder
    
    public init() {
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    public func decode<T>(data: Data) -> Result<T, Error> where T: Decodable {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
    public func encode<T>(_ value: T) -> Result<Data, Error> where T: Encodable {
        do {
            let encoded = try encoder.encode(value)
            return .success(encoded)
        } catch {
            return .failure(error)
        }
    }
}
