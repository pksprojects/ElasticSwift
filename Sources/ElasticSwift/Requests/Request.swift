//
//  Request.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

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
    
    associatedtype RequestType : Request
    associatedtype ResponseType : Response
    
    var completionHandler: ((_ response: ResponseType?, _ error: Error?) -> ())? { get }
    
    func validate() throws
    
    func make() throws -> RequestType
    func build() throws -> RequestType
 
}

extension RequestBuilder {

    public func build() throws -> RequestType {
        try self.validate()
        return try make()
    }
    
    public func validate() throws {
        
    }
}

public protocol Request {

    associatedtype ResponseType : Response
    
    var client: ESClient { get }
    
    var serializer : Serializer { get }
    
    var method: HTTPMethod { get }
    
    var endPoint: String { get }
    
    var parameters: [QueryParams:String]? { get }
    
    func getBody() throws -> Data?
    
    var completionHandler: ((_ response: ResponseType?, _ error: Error?) -> ())? { get }
    
    func execute() throws
    
}

extension Request {
    
    public var serializer : Serializer {
        return DefaultSerializer()
    }
    
    public var parameters: [QueryParams:String]? {
        return nil
    }
    
    public func getBody() throws -> Data? {
        return nil
    }
    
    public func execute() throws {
        try self.client.execute(request: self, completionHandler: responseHandler)
    }
    
    func responseHandler(_ response: ESResponse) {
        
        do {
            let decoded = try ResponseType.create(fromESResponse: response, withSerializer: self.serializer)
            completionHandler?(decoded, nil)
            return
        } catch {
            completionHandler?(nil,error)
            return
        }
    }
}




