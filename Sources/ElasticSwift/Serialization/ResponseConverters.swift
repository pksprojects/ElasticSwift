//
//  ResponseConverters.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 7/4/19.
//

import Foundation
import ElasticSwiftCore

public typealias HTTPResponseHandler = (_ result: Result<HTTPResponse, Error>) -> Void
public typealias ResultCallback<T: Codable> = (_ result: Result<T, Error>) -> Void
public typealias ResponseConverter<T: Codable> = (_ serializer: Serializer, _ callback: @escaping ResultCallback<T>) -> HTTPResponseHandler

public class ResponseConverters {
    
    private init() {}
    
    public static func defaultConverter<T: Codable>(serializer: Serializer, callback: @escaping ResultCallback<T>) -> HTTPResponseHandler {
        return { result -> Void in
            
            switch result {
            case .failure(let error):
                return callback(.failure(error))
            case .success(let response):
                
                if var body = response.body, let bytes = body.readBytes(length: body.readableBytes) {
                    let data = Data(bytes)
                    guard (!response.status.isError()) else {
                        
                        /// handle GetResponse 404
                        if response.status == .notFound {
                            let decodedResponse: Result<T, DecodingError> = serializer.decode(data: data)
                            switch decodedResponse {
                            case .success(let result):
                                return callback(.success(result))
                            default:
                                break;
                            }
                        }
                        
                        let decodedError: Result<ElasticsearchError, DecodingError> = serializer.decode(data: data)
                        switch decodedError {
                        case .failure(let error):
                            let converterError = ResponseConverterError(message: "Error while converting error response", error: error, response: response)
                            return callback(.failure(converterError))
                        case .success(let elasticError):
                            return callback(.failure(elasticError))
                        }
                    }
                    let decodedResponse: Result<T, DecodingError> = serializer.decode(data: data)
                    switch decodedResponse {
                    case .failure(let error):
                        let converterError = ResponseConverterError(message: "Error while converting response", error: error, response: response)
                        return callback(.failure(converterError))
                    case .success(let decoded):
                        return callback(.success(decoded))
                    }
                }
                let error =  UnsupportedResponseError(msg: "Unknown response \(response) in defaultConverter", response: response)
                return callback(.failure(error))
                
            }
            
        }
    }

    
    public static func indexExistsResponseConverter(serializer: Serializer, callback: @escaping ResultCallback<IndexExistsResponse>) -> HTTPResponseHandler {
        return { result -> Void in
            
            switch result {
            case .failure(let error):
                return callback(.failure(error))
            case .success(let response):
                
                guard (response.status.is2xxSuccessful() || response.status == .notFound) else {
                    if var body = response.body, let bytes = body.readBytes(length: body.readableBytes) {
                        let data = Data(bytes)
                        let decodedError: Result<ElasticsearchError, DecodingError> = serializer.decode(data: data)
                        switch decodedError {
                        case .failure(let error):
                            let converterError = ResponseConverterError(message: "Error while converting error response", error: error, response: response)
                            return callback(.failure(converterError))
                        case .success(let elasticError):
                            return callback(.failure(elasticError))
                        }
                    }
                    let error =  UnsupportedResponseError(msg: "Unknown status code \(response.status) in indexExistsResponseConverter", response: response)
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
