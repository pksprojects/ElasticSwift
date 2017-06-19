//
//  Request.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import SwiftyJSON

class ESRequest {
    
    var index: String?
    var type: String?
    var id: String?
    var source: String?
    var method: HTTPMethod = .GET
    
    init(method: HTTPMethod) {
        self.method = method
    }
    
    func set(index: String) -> Void {
        self.index = index
    }
    
    func set(type: String) -> Void {
        self.type = type
    }
    
    func set(id: String) -> Void {
        self.id = id
    }
    
    func set(source: String) -> Void {
        self.source = source
    }
    
    func makeEndPoint() -> String {
        preconditionFailure("This method must be overridden")
    }
    
    func makeBody() -> [String: Any] {
        preconditionFailure("This method must be overridden")
    }
    
    var endPoint: String {
        get {
            return self.makeEndPoint()
        }
    }
    
    var body: String {
        get {
            if let req = self as? SearchRequest {
                return JSON(req.makeBody()).rawString()!
            }
            if let req = self as? IndexRequest {
                return req.source!
            }
            return ""
        }
    }
}


class ESRequestBuilder {
    
    var request: ESRequest
    var client: ESClient
    var completionHandler: ((_ response: ESResponse) -> Void)?
    
    init(_ request: ESRequest, withClient client: ESClient) {
        self.client = client
        self.request = request
    }
    
    func set(completionHandler: @escaping (_ response: ESResponse) -> Void) -> ESRequestBuilder {
        self.completionHandler = completionHandler
        return self
    }
    
    func execute() {
        self.client.execute(request: self.request, completionHandler: self.completionHandler!)
    }
    
}
