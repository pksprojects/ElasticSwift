//
//  Errors.swift
//  ElasticSwiftCore
//
//  Created by Prafull Kumar Soni on 7/28/19.
//

import Foundation

/// Error returned by makeBody of a Request
public enum MakeBodyError: Error {
    case noBodyForRequest
    case wrapped(Error)
}

/// Error returned by Serializer's encode function
public class EncodingError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    public let value: Any
    public let error: Error

    public init(value: Any, error: Error) {
        self.value = value
        self.error = error
    }

    public var description: String {
        if let val = value as? CustomStringConvertible {
            return "EncodingError: Unable to encode \(val.description) with Error: \(error.localizedDescription)"
        }
        return "EncodingError: Unable to encode \(String(describing: value)) with Error: \(error.localizedDescription)"
    }

    public var debugDescription: String {
        if let val = value as? CustomDebugStringConvertible {
            return "EncodingError: Unable to encode \(val.debugDescription) with Error: \(error.localizedDescription)"
        } else {
            return description
        }
    }
}

/// Error returned by Serializer's encode function
public class DecodingError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    public let data: Data
    public let error: Error
    public let type: Any.Type

    public init(_ type: Any.Type, data: Data, error: Error) {
        self.data = data
        self.error = error
        self.type = type
    }

    public var description: String {
        return "DecodingError: Unable to decode \(String(describing: type)) from \(String(describing: data)) with Error: \(String(describing: error))"
    }

    public var debugDescription: String {
        return "DecodingError: Unable to decode \(type) from \(String(reflecting: data)) with Error: \(String(reflecting: error))"
    }
}

/// Error thrown by  HTTPRequestBuilder's build function.
public enum HTTPRequestBuilderError: Error {
    case missingRequiredField(String)
}

/// Error thrown by HTTPRequestBuilder's build function.
public enum HTTPResponseBuilderError: Error {
    case missingRequiredField(String)
}

// MARK: - QueryBuilder Error

/// Error(s) thrown by QueryBuilder
public enum QueryBuilderError: Error {
    case missingRequiredField(String)
    case missingRequiredFields([String])
    case atleastOneFieldRequired([String])
    case atlestOneElementRequired(String)
}
