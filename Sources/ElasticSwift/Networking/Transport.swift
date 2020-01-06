//
//  Transport.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import ElasticSwiftCore
import Foundation
import Logging
import NIOConcurrencyHelpers

// MARK: - Transport

/**
 Class managing connection pool and executes HTTP requests.
 */
internal class Transport {
    private static let logger = Logger(label: "org.pksprojects.ElasticSwfit.Transport")

    let hosts: [URL]

    private let clientsQueue: RoundRobinQueue<HTTPClientAdaptor>

    init(forHosts urls: [URL], httpSettings: HTTPSettings) {
        hosts = urls
        var clients = [HTTPClientAdaptor]()

        switch httpSettings {
        case let .managed(adaptorConfig):
            for url in urls {
                clients.append(adaptorConfig.adaptor.init(forHost: url, adaptorConfig: adaptorConfig))
            }
        case let .independent(adaptor):
            clients.append(adaptor)
        }
        clientsQueue = RoundRobinQueue(clients)
    }

    func performRequest(request: HTTPRequest, callback: @escaping (_ result: Result<HTTPResponse, Error>) -> Void) {
        return clientsQueue.next().performRequest(request, callback: callback)
    }
}

// MARK: - RoundRobinQueue

private class RoundRobinQueue<T> {
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.Transport.RoundRobinQueue")

    private var elements: [T]

    private var index: NIOAtomic<Int>

    private let max: Int

    init(capacity: Int) {
        elements = [T]()
        elements.reserveCapacity(capacity)
        index = NIOAtomic.makeAtomic(value: 0)
        max = capacity
    }

    public init(_ elements: [T]) {
        self.elements = elements
        self.elements.reserveCapacity(elements.count)
        index = NIOAtomic.makeAtomic(value: 0)
        max = self.elements.count
    }

    public func add(_ element: T) {
        if elements.count <= max - 1 {
            elements.append(element)
        } else {
            logger.warning("Max Capacity: \(max) reached count: \(elements.count) Client: \(element) will not be added to pool")
        }
    }

    public func next() -> T {
        let next = nextIndex()
        return elements[next]
    }

    private func nextIndex() -> Int {
        var curr = index.load()
        guard index.compareAndExchange(expected: curr, desired: curr + 1) else {
            return nextIndex()
        }
        curr = index.load()
        if curr > elements.count - 1 {
            guard index.compareAndExchange(expected: curr, desired: 0) else {
                return nextIndex()
            }
            return index.load()
        }
        return curr
    }
}
