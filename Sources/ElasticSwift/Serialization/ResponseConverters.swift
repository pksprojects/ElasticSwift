//
//  ResponseConverters.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 7/4/19.
//

import Foundation

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
                
                var data: Data?
                if let bytes = response.body!.readBytes(length: response.body!.readableBytes) {
                    data = Data(bytes)
                }
                
                guard (!response.status.isError()) else {
                    let decodedError: Result<ElasticsearchError, Error> = serializer.decode(data: data!)
                    switch decodedError {
                        case .failure(let error):
                            let converterError = ResponseConverterError(message: "Error while converting error response", error: error, response: response)
                            return callback(.failure(converterError))
                        case .success(let elasticError):
                            return callback(.failure(elasticError))
                    }
                }
                let decodedResponse: Result<T, Error> = serializer.decode(data: data!)
                switch decodedResponse {
                    case .failure(let error):
                        let converterError = ResponseConverterError(message: "Error while converting response", error: error, response: response)
                        return callback(.failure(converterError))
                    case .success(let decoded):
                        return callback(.success(decoded))
                }
            }
            
        }
    }

    
}
