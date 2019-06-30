//
//  UpdateRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import NIOHTTP1

public class UpdateRequestBuilder: RequestBuilder {
    
    public typealias RequestType = UpdateRequest
    
    var index: String?
    var type: String?
    var id: String?
    
    init() {}
    
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
    
    public func build() -> UpdateRequest {
        return UpdateRequest(withBuilder: self)
    }
}

public class UpdateRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var queryParams: [URLQueryItem] = []
    
    public typealias ResponseType = UpdateResponse
    
    let index: String
    let type: String
    let id: String
    var completionHandler: ((_ response: ESResponse?, _ error: Error?) -> Void)?
    
    init(withBuilder builder: UpdateRequestBuilder) {
        self.index = builder.index!
        self.type = builder.type!
        self.id = builder.id!
    }
    
    public var method: HTTPMethod {
        get {
            return .PUT
        }
    }
    
    public var endPoint: String {
        get {
            return index + "/" + type + "/" + id + "/_update"
        }
    }
    
    public var body: Data {
        get {
            return Data()
        }
    }
    
    func responseHandler(_ response: ESResponse) -> Void {
        if let res = response.httpResponse as? HTTPURLResponse {
            if res.statusCode != 200 {
                return self.completionHandler!(nil, ElasticsearchError())
            }
        }
    }
}


// MARK:- UPDATE RESPONSE

public class UpdateResponse: Codable {
    
}
