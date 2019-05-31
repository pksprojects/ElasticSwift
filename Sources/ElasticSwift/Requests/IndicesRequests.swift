//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation

// MARK: -  Builders

public class CreateIndexRequestBuilder: RequestBuilder {
    
    let client: ESClient
    var name: String?
    var completionHandler: ((_ response: CreateIndexResponse?, _ error: Error?) -> ())?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: CreateIndexResponse?, _ error: Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() -> Request {
        return CreateIndexRequest(withBuilder: self)
    }
    
    public func validate() throws {
        if name == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"name")
        }
    }
}

public class DeleteIndexRequestBuilder: RequestBuilder {
    
    let client: ESClient
    var name: String?
    var completionHandler: ((_ response: DeleteIndexResponse?, _ error: Error?) -> ())?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: DeleteIndexResponse?, _ error: Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() throws -> Request {
        return DeleteIndexRequest(withBuilder: self)
    }
    
    public func validate() throws {
        if name == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"name")
        }
    }
}

public class GetIndexRequestBuilder: RequestBuilder {
    
    let client: ESClient
    var name: String?
    var completionHandler: ((_ response: GetIndexResponse?, _ error: Error?) -> ())?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: GetIndexResponse?, _ error: Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() throws -> Request {
        return GetIndexRequest(withBuilder: self)
    }
    
    public func validate() throws {
        if name == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"name")
        }
    }
}

// MARK: - Requests

public class CreateIndexRequest: Request {
    
    let client: ESClient
    let name: String
    var completionHandler: ((_ response: CreateIndexResponse?, _ error: Error?) -> ())?
    
    init(withBuilder builder: CreateIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name!
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod {
        get {
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
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
            let decoded = try Serializers.decode(data: data) as CreateIndexResponse
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

class GetIndexRequest: Request {
    
    let client: ESClient
    let name: String
    var completionHandler: ((_ response: GetIndexResponse?, _ error: Error?) -> ())?
    
    init(withBuilder builder: GetIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name!
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod {
        get {
            return .GET
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
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
            let decoded = try Serializers.decode(data: data) as GetIndexResponse
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

class DeleteIndexRequest: Request {
    
    let client: ESClient
    let name: String
    var completionHandler: ((_ response: DeleteIndexResponse?, _ error: Error?) -> ())?
    
    init(withBuilder builder: DeleteIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name!
        self.completionHandler = builder.completionHandler
    }
    
   
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
    }
    
    public var endPoint: String {
        get {
            return self.name
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
    
    func responseHandler(_ response: ESResponse) -> Void {
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
            let decoded = try Serializers.decode(data: data) as DeleteIndexResponse
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

// MARK: - Response

public class CreateIndexResponse: Codable {
    
    public let acknowledged: Bool
    public let shardsAcknowledged: Bool
    public let index: String
    
    init(acknowledged: Bool, shardsAcknowledged: Bool, index: String) {
        self.acknowledged = acknowledged
        self.shardsAcknowledged = shardsAcknowledged
        self.index = index
    }
    
    enum CodingKeys: String, CodingKey {
        case acknowledged
        case shardsAcknowledged = "shards_acknowledged"
        case index
    }
    
}

public class GetIndexResponse: Codable {
    
    public let aliases: [String: String]
    public let mappings: [String: String]
    public let settings: IndexSettings
    
    init(aliases: [String: String]=[:], mappings: [String: String]=[:], settings: IndexSettings) {
        self.aliases = aliases
        self.mappings = mappings
        self.settings = settings
    }
}

public class DeleteIndexResponse: Codable {
    
    public let acknowledged: Bool
    
    init(acknowledged: Bool) {
        self.acknowledged = acknowledged
    }
}

public class IndexSettings: Codable {
    
    public let creationDate: Date
    public let numberOfShards: String
    public let numberOfReplicas: String
    public let uuid: String
    public let providedName: String
    public let version: IndexVersion
    
    init(creationDate: Date, numberOfShards: String, numberOfReplicas: String, uuid: String, providedName: String, version: IndexVersion) {
        self.creationDate = creationDate
        self.numberOfShards = numberOfShards
        self.numberOfReplicas = numberOfReplicas
        self.uuid = uuid
        self.providedName = providedName
        self.version = version
    }
    
    enum CodingKeys: String, CodingKey {
        case creationDate = "creation_date"
        case numberOfShards = "number_of_shards"
        case numberOfReplicas = "number_of_replicas"
        case uuid
        case providedName = "provided_name"
        case version
    }
    
}

public class IndexVersion: Codable {
    public let created: String
    
    init(created: String) {
        self.created = created
    }
}

