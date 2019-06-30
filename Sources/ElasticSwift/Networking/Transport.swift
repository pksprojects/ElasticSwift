//
//  Transport.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import Foundation
import Logging
import NIOHTTP1
import NIOConcurrencyHelpers
import NIO

/**
 Class managing connection(URLSession) pool and HTTP requests.
 */
internal class Transport {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Transport")
    
    let hosts: [URL]
    
    private let clientsQueue: RoundRobinQueue<HTTPClientAdaptor>
    
    init(forHosts urls: [URL], credentials: ClientCredential? = nil, clientAdaptor: HTTPClientAdaptor.Type, adaptorConfig: HTTPAdaptorConfiguration) {
        self.hosts = urls
        var clients = [HTTPClientAdaptor]()
        for url in urls {
            clients.append(clientAdaptor.init(forHost: url, adaptorConfig: adaptorConfig))
        }
        self.clientsQueue = RoundRobinQueue(clients)
    }
    
    func performRequest(request: HTTPRequest, callback: @escaping (_ response: HTTPResponse?, _ error: Error?) -> Void) -> Void {
        return self.clientsQueue.next().performRequest(request, callback: callback)
    }
}

// MARK: - HTTPClientAdaptor

public protocol HTTPClientAdaptor {
    
    init(forHost host: URL, adaptorConfig: HTTPAdaptorConfiguration)
    
    func performRequest(_ request: HTTPRequest, callback: @escaping (_ response: HTTPResponse?, _ error: Error?) -> Void)
}


// MARK: - DefaultHTTPClientAdaptor

public class DefaultHTTPClientAdaptor: HTTPClientAdaptor {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Networking.DefaultHTTPClientAdaptor")
    
    let client: HTTPClient
    
    public required init(forHost host: URL, adaptorConfig: HTTPAdaptorConfiguration =  HTTPAdaptorConfiguration()) {
        let httpClientConfig = DefaultHTTPClientAdaptor.createHttpClientConfig(from: adaptorConfig)
        self.client = HTTPClient(forHost: host, configuration: httpClientConfig)
    }
    
    public func performRequest(_ request: HTTPRequest, callback: @escaping (_ response: HTTPResponse?, _ error: Error?) -> Void) {
        self.client.execute(request: request).map { parts in
            var responseHead: HTTPResponseHead? = nil
            var responseBody: ByteBuffer? = nil
            for part in parts {
                switch part {
                case .head(let head):
                    responseHead = head
                case .body(let buffer):
                    responseBody = buffer
                case .end(_):
                    let response = HTTPResponse(request: request, status: responseHead!.status, headers: responseHead!.headers, body: responseBody)
                    callback(response, nil)
                }
            }
            
            }.recover { error  in
                callback(nil, error)
            }.whenSuccess({})
    }
    
    
    private static func createHttpClientConfig(from adaptorConfig: HTTPAdaptorConfiguration) -> HTTPClientConfiguration {
        return HTTPClientConfiguration.init(eventLoopProvider: adaptorConfig.eventLoopProvider, sslContext: adaptorConfig.sslContext, timeouts: adaptorConfig.timeouts)
    }
    
}



private class RoundRobinQueue<T> {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Transport.RoundRobinQueue")
    
    private var elements: [T]
    
    private var index: Atomic<Int>
    
    private let max: Int
    
    init(capacity: Int) {
        self.elements = Array<T>()
        self.elements.reserveCapacity(capacity)
        self.index = Atomic(value: 0)
        self.max = capacity
    }
    
    public init(_ elements: [T]) {
        self.elements = elements
        self.elements.reserveCapacity(elements.count)
        self.index = Atomic(value: 0)
        self.max = self.elements.count
    }
    
    
    public func add(_ element: T) {
        if self.elements.count <= max - 1 {
            self.elements.append(element)
        } else {
            logger.warning("Max Capacity: \(max) reached count: \(elements.count) Client: \(element) will not be added to pool")
        }
    }
    
    public func next() -> T {
        let next = self.nextIndex()
        return self.elements[next]
    }
    
    private func nextIndex() -> Int {
        var curr = self.index.load()
        guard self.index.compareAndExchange(expected: curr, desired: curr + 1) else {
            return nextIndex()
        }
        curr = self.index.load()
        if curr > self.elements.count - 1 {
            guard self.index.compareAndExchange(expected: curr, desired: 0) else {
                return nextIndex()
            }
            return self.index.load()
        }
        return curr
    }
    
}