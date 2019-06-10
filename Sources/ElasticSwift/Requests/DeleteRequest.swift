//
//  DeleteRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class DeleteRequestBuilder: RequestBuilder {
    
    typealias BuilderClosure = (DeleteRequestBuilder) -> Void
    
    let client: ESClient
    var index: String?
    var type: String?
    var id: String?
    var version: Int?
    var completionHandler: ((DeleteResponse?, Error?) -> Void)?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    convenience init(withClient client: ESClient, builderClosure: BuilderClosure) {
        self.init(withClient: client)
        builderClosure(self)
    }
    
    public func set(index: String) -> Self {
        self.index = index
        return self
    }
    
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
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
    
    public func set(completionHandler: @escaping (DeleteResponse?, Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> Request {
        return DeleteRequest(withBuilder: self)
    }
    
}

public class DeleteRequest: Request {
    
    let client: ESClient
    let index: String
    let type: String
    let id: String
    var version: Int?
    var completionHandler: ((DeleteResponse?, Error?) -> Void)
    
    init(withBuilder builder: DeleteRequestBuilder) {
        self.client = builder.client
        self.index = builder.index!
        self.type = builder.type!
        self.id = builder.id!
        self.version = builder.version
        self.completionHandler = builder.completionHandler!
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
    
    func makeEndPoint() -> String {
        return self.index + "/" + self.type + "/" + self.id
    }
    
    func responseHandler(_ response: ESResponse) -> Void {
        if let error = response.error {
            return completionHandler(nil, error)
        }
        do {
            print(String(data: response.data!, encoding: .utf8)!)
            let decoded: DeleteResponse? = try Serializers.decode(data: response.data!)
            if decoded?.id != nil {
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

public class DeleteResponse: Codable {
    
    public var shards: Shards?
    public var index: String?
    public var type: String?
    public var id: String?
    public var version: Int?
    public var seqNumber: Int?
    public var primaryTerm: Int?
    public var result: String?
    
    init() {
        
    }
    
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
