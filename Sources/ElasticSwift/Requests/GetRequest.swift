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
    var completionHandler: ((_ response: GetResponse<T>?, _ error: Error?) -> Void)?
    
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
    
    public func set(completionHandler: @escaping (_ response: GetResponse<T>?, _ error: Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> Request {
        return GetRequest<T>(withBuilder: self)
    }
    
    
}

public class GetRequest<T: Codable>: Request {
    
    let client: ESClient
    let completionHandler: ((_ response: GetResponse<T>?, _ error: Error?) -> Void)
    var index: String?
    var type: String?
    var id: String?
    
    public var method: HTTPMethod = .GET
    
    init(withBuilder builder: GetRequestBuilder<T>) {
        self.client = builder.client
        self.completionHandler = builder.completionHandler!
        self.index = builder.index
        self.type = builder.type
        self.id =  builder.id
    }
    
    public func execute() -> Void {
        self.client.execute(request: self, completionHandler: responseHandler)
    }
    
    func makeEndPoint() -> String {
        return self.index! + "/" + self.type! + "/" + self.id!
    }
    
    public var endPoint: String {
        get {
            return self.makeEndPoint()
        }
    }
    
    public var body: Data {
        get {
            return Data()
        }
    }
    
    func responseHandler(_ response: ESResponse) -> Void {
        if let error = response.error {
            return completionHandler(nil, error)
        }
        do {
            let decoded: GetResponse<T>? = try Serializers.decode(data: response.data!)
            if let decoded = decoded {
                return completionHandler(decoded, nil)
            } else {
                let decodedError: ElasticsearchError? = try Serializers.decode(data: response.data!)
                if let decoded = decodedError {
                    return completionHandler(nil, decoded)
                }
            }
        } catch {
            return completionHandler(nil, error)
        }
    }
}
