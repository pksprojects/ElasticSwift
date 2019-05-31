//
//  Request.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

public protocol Request {
    
//    associatedtype ResponseType : Response
    
    var method: HTTPMethod { get }
    
    var endPoint: String { get }
    
    var parameters: [QueryParams:String]? { get }
    
    var body: Data { get }
    
    func execute()
    
//    func decodeResponse(data:Data)-> ResponseType
    
}

public protocol Response : Codable {
    
}

extension Request {
    public var parameters: [QueryParams:String]? {
        return nil
    }
    
//    func decodeResponse<T:Codable>(data:Data)-> T {
//        return try Serializers.decode(data: data)
//    }
}

public struct RequestBuilderConstants {
    public struct Errors {
        public enum Validation : Error {
            case MissingField(field:String)
        }
    }
}

public struct RequestConstants {
    public struct Errors {
        public enum Response : Error {
            case Deserialization(content:String)
        }
    }
}

public protocol RequestBuilder {
    
    
//    var serializer : JSONEncoder? {get}
//    var deserializer : JSONDecoder? {get}
    func validate() throws
    
//    func make<T : Request>() throws -> T
//    func build<T : Request>() throws -> T
    
    func make() throws -> Request
    func build() throws -> Request
}

extension RequestBuilder {
    
    public func build() throws -> Request {
        try self.validate()
        return try make()
    }
    
//    public func build<T : Request>() throws -> T {
//        try self.validate()
//        return try make()
//    }
}

