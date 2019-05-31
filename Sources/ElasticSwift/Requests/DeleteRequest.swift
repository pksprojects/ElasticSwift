//
//  DeleteRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class DeleteRequestBuilder: RequestBuilder {
    
    let client: ESClient
    var index: String?
    var type: String?
    var id: String?
    var version: Int?
    var completionHandler: ((DeleteResponse?, Error?) -> ())?
    
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
    
    public func set(version: Int) -> Self {
        self.version = version
        return self
    }
    
    public func set(completionHandler: @escaping (DeleteResponse?, Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() throws -> Request {
        return DeleteRequest(withBuilder: self)
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

public class DeleteRequest: Request {
    
    let client: ESClient
    let index: String
    let type: String?
    let id: String
    var version: Int?
    var completionHandler: ((DeleteResponse?, Error?) -> ())?
    
    init(withBuilder builder: DeleteRequestBuilder) {
        self.client = builder.client
        self.index = builder.index!
        self.id = builder.id!
        
        self.type = builder.type
        self.version = builder.version
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
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
    
    public func execute() {
        self.client.execute(request: self, completionHandler: responseHandler)
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
            let decoded = try Serializers.decode(data: data) as DeleteResponse
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

public class DeleteResponse: Codable {
    
    public var shards: Shards
    public var index: String
    public var type: String?
    public var id: String
    public var version: Int?
    public var seqNumber: Int?
    public var primaryTerm: Int?
    public var result: String
    
    enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case seqNumber = "_seq_no"
        case primaryTerm = "_primary_term"
        case result
    }
}
