//
//  Transport.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import Foundation
import Alamofire

/**
 Class managing connection(URLSession) pool and HTTP requests.
 */
class Transport {
    
    let hosts: [URL]
    
    var sessionPool: SessionPool?
    
    
    init(forHosts urls: [URL]) {
        self.hosts = urls
        self.sessionPool = SessionPool(forHosts: urls)
    }
    
    func perform_request(method: HTTPMethod, endPoint: String?, params: [QueryParams], completionHandler: @escaping (_ response: ESResponse) -> Void) {
        self.sessionPool?.getConnection()?
            .createRequest(method: method, forPath: endPoint!, witParams: params)
            .createDataTask(onCompletion: completionHandler)
            .execute()
    }
    
    func perform_request(method: HTTPMethod, endPoint: String?, params: [QueryParams], body: String, completionHandler: @escaping (_ response: ESResponse) -> Void) {
        print(method, endPoint!, params, body)
        self.sessionPool?.getConnection()?
            .createRequest(method: method, forPath: endPoint!, witParams: params, body: body)
            .createDataTask(onCompletion: completionHandler)
            .execute()
    }
}
