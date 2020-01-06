//
//  ResponseConverters.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 7/4/19.
//

import ElasticSwiftCore
import Foundation
import Logging

/// closure that handles `HTTPResponse`
/// - Parameters:
///    - result: result with either a success http response or Error
public typealias HTTPResponseHandler = (_ result: Result<HTTPResponse, Error>) -> Void

/// closure that handles codable result
/// - Parameters:
///    - result: result with either a success T response or Error
public typealias ResultCallback<T: Codable> = (_ result: Result<T, Error>) -> Void

/// closure that handles result of response conversion
/// - Parameters:
///     - serializer: serializer to use for response converstion
///     - callback: closure to be called after conversion.
public typealias ResponseConverter<T: Codable> = (_ serializer: Serializer, _ callback: @escaping ResultCallback<T>) -> HTTPResponseHandler

/// Classs with various response converters
public class ResponseConverters {
    private static let logger = Logger(label: "org.pksprojects.ElasticSwift.Serialization.ResponseConverters")

    /// Utility class private initializer.
    private init() {}

    /// Response Converter with default implementation to handle most common scenarios for response serialization
    /// - Parameters:
    ///   - serializer: serializer to use for response converstion.
    ///   - callback: result callback to be called after conversion.
    public static func defaultConverter<T: Codable>(serializer: Serializer, callback: @escaping ResultCallback<T>) -> HTTPResponseHandler {
        return { result -> Void in

            switch result {
            case let .failure(error):
                return callback(.failure(error))
            case let .success(response):

                if let data = response.body {
                    logger.trace("Converter : defaultConverter; Response body as string: \(String(data: data, encoding: .utf8) ?? "")")
                    guard !response.status.isError() else {
                        /// handle GetResponse 404
                        if response.status == .notFound {
                            let decodedResponse: Result<T, DecodingError> = serializer.decode(data: data)
                            switch decodedResponse {
                            case let .success(result):
                                return callback(.success(result))
                            default:
                                break
                            }
                        }

                        let decodedError: Result<ElasticsearchError, DecodingError> = serializer.decode(data: data)
                        switch decodedError {
                        case let .failure(error):
                            let converterError = ResponseConverterError(message: "Error while converting error response", error: error, response: response)
                            return callback(.failure(converterError))
                        case let .success(elasticError):
                            return callback(.failure(elasticError))
                        }
                    }
                    let decodedResponse: Result<T, DecodingError> = serializer.decode(data: data)
                    switch decodedResponse {
                    case let .failure(error):
                        let converterError = ResponseConverterError(message: "Error while converting response", error: error, response: response)
                        return callback(.failure(converterError))
                    case let .success(decoded):
                        return callback(.success(decoded))
                    }
                }
                let error = UnsupportedResponseError(msg: "Unknown response \(response) in defaultConverter", response: response)
                return callback(.failure(error))
            }
        }
    }

    /// Response Converter to handle index exists responses
    /// - Parameters:
    ///   - serializer: serializer to use for response converstion.
    ///   - callback: result callback to be called after conversion.
    public static func indexExistsResponseConverter(serializer: Serializer, callback: @escaping ResultCallback<IndexExistsResponse>) -> HTTPResponseHandler {
        return { result -> Void in

            switch result {
            case let .failure(error):
                return callback(.failure(error))
            case let .success(response):

                guard response.status.is2xxSuccessful() || response.status == .notFound else {
                    if let data = response.body {
                        let decodedError: Result<ElasticsearchError, DecodingError> = serializer.decode(data: data)
                        switch decodedError {
                        case let .failure(error):
                            let converterError = ResponseConverterError(message: "Error while converting error response", error: error, response: response)
                            return callback(.failure(converterError))
                        case let .success(elasticError):
                            return callback(.failure(elasticError))
                        }
                    }
                    let error = UnsupportedResponseError(msg: "Unknown status code \(response.status) in indexExistsResponseConverter", response: response)
                    return callback(.failure(error))
                }

                if response.status.is2xxSuccessful() {
                    return callback(.success(IndexExistsResponse(true)))
                } else if response.status == .notFound {
                    return callback(.success(IndexExistsResponse(false)))
                }
            }
        }
    }
}
