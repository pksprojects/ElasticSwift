//
//  ElasticSwiftNetworkingNIO.swift
//  ElasticSwiftNetworkingNIO
//
//  Created by Prafull Kumar Soni on 9/27/19.
//

import AsyncHTTPClient
import ElasticSwiftCore
import Foundation
import Logging
import NIO

// MARK: - Timeouts

public struct Timeouts {
    public static let DEFAULT_TIMEOUTS = Timeouts(read: TimeAmount.milliseconds(5000), connect: TimeAmount.milliseconds(5000))

    public let read: TimeAmount?
    public let connect: TimeAmount?

    public init(read: TimeAmount? = nil, connect: TimeAmount? = nil) {
        self.read = read
        self.connect = connect
    }
}

extension Timeouts: Equatable {}

// MARK: - HTTPAdaptorConfiguration

/// Class holding HTTPAdaptor Config
public class AsyncHTTPClientAdaptorConfiguration: HTTPAdaptorConfiguration {
    public let adaptor: ManagedHTTPClientAdaptor.Type

    public let clientConfig: HTTPClient.Configuration

    public let eventLoopProvider: HTTPClient.EventLoopGroupProvider

    public init(adaptor: ManagedHTTPClientAdaptor.Type = AsyncHTTPClientAdaptor.self, eventLoopProvider: HTTPClient.EventLoopGroupProvider = .createNew, asyncClientConfig: HTTPClient.Configuration) {
        self.eventLoopProvider = eventLoopProvider
        self.adaptor = adaptor
        clientConfig = asyncClientConfig
    }

    public convenience init(adaptor: ManagedHTTPClientAdaptor.Type = AsyncHTTPClientAdaptor.self, eventLoopProvider: HTTPClient.EventLoopGroupProvider = .createNew, timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS) {
        var config = HTTPClient.Configuration()
        config.timeout = .init(connect: timeouts?.connect, read: timeouts?.read)
        self.init(adaptor: adaptor, eventLoopProvider: eventLoopProvider, asyncClientConfig: config)
    }

    public static var `default`: HTTPAdaptorConfiguration {
        return AsyncHTTPClientAdaptorConfiguration()
    }
}
