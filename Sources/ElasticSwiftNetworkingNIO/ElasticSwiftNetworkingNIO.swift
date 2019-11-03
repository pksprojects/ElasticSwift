//
//  ElasticSwiftNetworkingNIO.swift
//  ElasticSwiftNetworkingNIO
//
//  Created by Prafull Kumar Soni on 9/27/19.
//

import Foundation
import Logging
import NIO
import ElasticSwiftCore
import AsyncHTTPClient

//MARK:- Timeouts

public struct Timeouts {
    
    public static let DEFAULT_TIMEOUTS: Timeouts = Timeouts(read: TimeAmount.milliseconds(1000), connect: TimeAmount.milliseconds(3000))
    
    public let read: TimeAmount?
    public let connect: TimeAmount?
    
    public init(read: TimeAmount? = nil, connect: TimeAmount? = nil) {
        self.read = read
        self.connect = connect
    }
    
}

extension Timeouts: Equatable {}

//MARK:- HTTPAdaptorConfiguration

/// Class holding HTTPAdaptor Config
public class AsyncHTTPClientAdaptorConfiguration: HTTPAdaptorConfiguration {
    
    public let adaptor: ManagedHTTPClientAdaptor.Type
    
    public let clientConfig: HTTPClient.Configuration
    
    public let eventLoopProvider: HTTPClient.EventLoopGroupProvider

    public init(adaptor: ManagedHTTPClientAdaptor.Type = AsyncHTTPClientAdaptor.self, eventLoopProvider: HTTPClient.EventLoopGroupProvider = .createNew, timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS) {
        self.eventLoopProvider = eventLoopProvider
        self.adaptor = adaptor
        var config = HTTPClient.Configuration()
        config.timeout = .init(connect: timeouts?.connect, read: timeouts?.read)
        self.clientConfig = config
    }
    
    public init(adaptor: ManagedHTTPClientAdaptor.Type = AsyncHTTPClientAdaptor.self, eventLoopProvider: HTTPClient.EventLoopGroupProvider = .createNew, asyncClientConfig: HTTPClient.Configuration) {
        self.eventLoopProvider = eventLoopProvider
        self.adaptor = adaptor
        self.clientConfig = asyncClientConfig
    }
    
    public static var `default`: HTTPAdaptorConfiguration {
        get {
            return AsyncHTTPClientAdaptorConfiguration()
        }
    }
    
}
