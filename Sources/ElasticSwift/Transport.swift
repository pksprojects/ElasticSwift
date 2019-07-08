//
//  Transport.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import Foundation

/**
 Class managing connection(URLSession) pool and HTTP requests.
 */
class Transport {
    
    let hosts: [URL]
    
    var sessionPool: SessionPool?
    
    
    init(forHosts urls: [URL], credentials: ClientCredential? = nil, sslConfig: SSLConfiguration? = nil) {
        self.hosts = urls
        self.sessionPool = SessionPool(forHosts: urls, credentials: credentials, sslConfig: sslConfig)
    }
    
    func performRequest(method: HTTPMethod, endPoint: String?, params: [QueryParams:String]?, completionHandler: @escaping (_ response: ESResponse) -> Void) {
        self.sessionPool?.getConnection()?
            .createRequest(method: method, forPath: endPoint!, witParams: params)
            .createDataTask(onCompletion: completionHandler)
            .execute()
    }
    
    func performRequest(method: HTTPMethod, endPoint: String?, params: [QueryParams:String]?, body: Data?, completionHandler: @escaping (_ response: ESResponse) -> Void) {
        debugPrint(method, endPoint, params, body)
        self.sessionPool?.getConnection()?
            .createRequest(method: method, forPath: endPoint!, witParams: params, body: body)
            .createDataTask(onCompletion: completionHandler)
            .execute()
    }
    
    func performRequest(method: HTTPMethod, endPoint: String?, params: [QueryParams:String]?, body: String?, completionHandler: @escaping (_ response: ESResponse) -> Void) {
        debugPrint(method, endPoint, params, body)
        self.sessionPool?.getConnection()?
            .createRequest(method: method, forPath: endPoint!, witParams: params, body: body)
            .createDataTask(onCompletion: completionHandler)
            .execute()
    }
    
}
