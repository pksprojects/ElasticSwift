//
//  Transport.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import Foundation
import Logging
import NIOConcurrencyHelpers
import ElasticSwiftCore
import ElasticSwiftNetworking

// MARK: - Transport

/**
 Class managing connection pool and executes HTTP requests.
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
    
    func performRequest(request: HTTPRequest, callback: @escaping (_ result: Result<HTTPResponse, Error>) -> Void) -> Void {
        return self.clientsQueue.next().performRequest(request, callback: callback)
    }
}

// MARK: - RoundRobinQueue

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
