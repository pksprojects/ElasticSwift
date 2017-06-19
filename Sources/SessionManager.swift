//
//  Connection.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import Foundation

/**
 Class maintaining URLSession for a Host
 */

class SessionManager {

    private let session: URLSession
    private let url: URL
    private var request: URLRequest?
    private var dataTask: URLSessionDataTask?
    
    init(forHost url: URL) {
        let config = URLSessionConfiguration.ephemeral
        config.httpAdditionalHeaders = ["Content-Type": "application/json; charset=UTF-8"]
        self.session = URLSession(configuration: config)
        self.url = url
    }
    
    func createRequest(method: HTTPMethod) -> Self {
        var currRequest = URLRequest(url: self.url)
        currRequest.httpMethod = method.rawValue
        self.request = currRequest
        return self
    }
    
    func createRequest(method: HTTPMethod, forPath pathComponent: String, witParams: Any) -> Self {
        var currRequest = URLRequest(url: self.url.appendingPathComponent(pathComponent))
        currRequest.httpMethod = method.rawValue
        self.request = currRequest
        debugPrint("URLRequest without body created")
        return self
    }
    
    func createRequest(method: HTTPMethod, forPath pathComponent: String, witParams: Any, body: String) -> Self {
        var currRequest = URLRequest(url: self.url.appendingPathComponent(pathComponent))
        currRequest.httpMethod = method.rawValue
        currRequest.httpBody = body.data(using: .utf8)
        self.request = currRequest
        debugPrint("URLRequest with body created")
        return self
    }
    
    func createDataTask(onCompletion callback: @escaping (_ response: ESResponse) -> Void) -> Self {
        self.dataTask = self.session.dataTask(with: self.request!) { data, response, error in
            let response = ESResponse(data: data, httpResponse: response, error: error)
            return callback(response)
        }
        debugPrint("Data Task Created:", self.dataTask!)
        return self
    }
    
    func execute() {
        self.dataTask?.resume()
        debugPrint("DataTask Resumed")
    }
    
    /**
     Closes current URLSession after finishing any outstanding tasks.
    */
    func close() {
        self.session.finishTasksAndInvalidate()
    }
    
    /**
     Terminates current URLSession without finishing any outstanding tasks.
     */
    func forceClose() {
        self.session.invalidateAndCancel()
    }
    
    deinit {
        print("session invalidated")
        self.session.invalidateAndCancel()
    }
}

/**
 Class maintaining pool of Connections for Host(s)
 */
class SessionPool {
    
    var pool: [URL: SessionManager]
    
    init(forHosts hosts: [Host]) {
        self.pool = [:]
        for host in hosts {
            self.pool[host] = SessionManager(forHost: host)
        }
    }
    
    func getConnection(forHost host: Host) -> SessionManager? {
        return self.pool[host]
    }
    
    func getConnection() -> SessionManager? {
        return self.pool.first?.value
    }
    
}
