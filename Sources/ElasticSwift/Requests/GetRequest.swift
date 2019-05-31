//
//  GetRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class GetRequestBuilder<T: Codable>: RequestBuilder {
    
    var client: ESClient
    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var method: HTTPMethod = .GET
    var completionHandler: ((_ response: GetResponse<T>?, _ error: Error?) -> ())?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(index: String) -> Self {
        self.index = index
        return self
    }
    
    public func set(type: String) -> Self {
        self.type = type
        return self
    }
    
    public func set(id: String) -> Self {
        self.id = id
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: GetResponse<T>?, _ error: Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() throws -> Request {
        return GetRequest<T>(withBuilder: self)
    }
    
    public func validate() throws {
        if index == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"index")
        }
        if id == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"id")
        }
    }
    
    
}

public class GetRequest<T: Codable>: Request {
    
    let client: ESClient
    let completionHandler: ((_ response: GetResponse<T>?, _ error: Error?) -> ())?
    var index: String
    var type: String?
    var id: String
    
    public var method: HTTPMethod = .GET
    
    init(withBuilder builder: GetRequestBuilder<T>) {
        self.client = builder.client
        self.completionHandler = builder.completionHandler
        self.index = builder.index!
        self.type = builder.type
        self.id =  builder.id!
    }
    
    public func execute() {
        self.client.execute(request: self, completionHandler: responseHandler)
    }
    
    public var endPoint: String {
        get {
            var result = self.index + "/"
            
            if let type = self.type {
                result += type + "/"
            } else {
                result += "_doc/"
            }
            
            result += self.id
            
            return result
        }
    }
    
    public var body: Data {
        get {
            return Data()
        }
    }
    
    func responseHandler(_ response: ESResponse) {
        if let error = response.error {
            completionHandler?(nil, error)
            return
        }
        
        guard let data = response.data else {
            completionHandler?(nil,nil)
            return
        }
        
        var decodingError : Error? = nil
        do {
            let decoded = try Serializers.decode(data: data) as GetResponse<T>
            completionHandler?(decoded, nil)
            return
        } catch {
             decodingError = error
        }
        
        do {
            let esError = try Serializers.decode(data: data) as ElasticsearchError
            completionHandler?(nil, esError)
            return
        } catch {
            let message = "Error decoding response with data: " + (String(bytes: data, encoding: .utf8) ?? "nil") + " Underlying error: " + (decodingError?.localizedDescription ?? "nil")
            let error = RequestConstants.Errors.Response.Deserialization(content: message)
            completionHandler?(nil, error)
            return
        }
    }
}
