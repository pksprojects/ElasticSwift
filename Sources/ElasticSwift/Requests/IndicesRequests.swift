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
    var completionHandler: ((_ response: CreateIndexResponse?, _ error: Error?) -> Void)?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: CreateIndexResponse?, _ error: Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> Request {
        return CreateIndexRequest(withBuilder: self)
    }
}

public class DeleteIndexRequestBuilder: RequestBuilder {
    
    let client: ESClient
    var name: String?
    var completionHandler: ((_ response: DeleteIndexResponse?, _ error: Error?) -> Void)?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: DeleteIndexResponse?, _ error: Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() throws -> Request {
        return DeleteIndexRequest(withBuilder: self)
    }
}

public class GetIndexRequestBuilder: RequestBuilder {
    
    let client: ESClient
    var name: String?
    var completionHandler: ((_ response: GetIndexResponse?, _ error: Error?) -> Void)?
    
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
    
    public func build() throws -> Request {
        return GetIndexRequest(withBuilder: self)
    }
}

// MARK: - Requests

public class CreateIndexRequest: Request {
    
    let client: ESClient
    let name: String
    var completionHandler: ((_ response: CreateIndexResponse?, _ error: Error?) -> Void)
    
    init(withBuilder builder: CreateIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name!
        self.completionHandler = builder.completionHandler!
    }
    
    func makeEndPoint() -> String {
        return self.name
    }
    
    public var method: HTTPMethod {
        get {
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
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
            return completionHandler(nil, error)
        }
        do {
            print(String(data: response.data!, encoding: .utf8)!)
            let decoded: CreateIndexResponse? = try Serializers.decode(data: response.data!)
            if decoded?.index != nil {
                return completionHandler(decoded, nil)
            } else {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            }
        } catch {
            do {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            } catch {
                return completionHandler(nil, error)
            }
        }
    }
}

class GetIndexRequest: Request {
    
    let client: ESClient
    let name: String
    var completionHandler: ((_ response: GetIndexResponse?, _ error: Error?) -> Void)
    
    init(withBuilder builder: GetIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name!
        self.completionHandler = builder.completionHandler!
    }
    
    func makeEndPoint() -> String {
        return self.name
    }
    
    public var method: HTTPMethod {
        get {
            return .GET
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
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
            return completionHandler(nil, error)
        }
        do {
            print(String(data: response.data!, encoding: .utf8)!)
            let decoded: GetIndexResponse? = try Serializers.decode(data: response.data!)
            if decoded?.settings != nil {
                return completionHandler(decoded, nil)
            } else {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            }
        } catch {
            do {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            } catch {
                return completionHandler(nil, error)
            }
        }
    }
}

class DeleteIndexRequest: Request {
    
    let client: ESClient
    let name: String
    var completionHandler: ((_ response: DeleteIndexResponse?, _ error: Error?) -> Void)
    
    init(withBuilder builder: DeleteIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name!
        self.completionHandler = builder.completionHandler!
    }
    
    func makeEndPoint() -> String {
        return self.name
    }
    
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
    }
    
    public var endPoint: String {
        get {
            return makeEndPoint()
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
            return completionHandler(nil, error)
        }
        do {
            print(String(data: response.data!, encoding: .utf8)!)
            let decoded: DeleteIndexResponse? = try Serializers.decode(data: response.data!)
            if decoded?.acknowledged != nil {
                return completionHandler(decoded, nil)
            } else {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            }
        } catch {
            do {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            } catch {
                return completionHandler(nil, error)
            }
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

