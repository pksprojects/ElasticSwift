//
//  ClusterRequests.swift
//
//
//  Created by Prafull Kumar Soni on 12/25/20.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation
import NIOHTTP1

public class ClusterHealthRequestBuilder: RequestBuilder {
    public typealias ElasticSwiftType = ClusterHealthRequest

    private var _indices: [String]?

    private var _level: ClusterHealthRequest.Level?
    private var _local: Bool?
    private var _timeout: String?
    private var _masterTimeout: String?
    private var _waitForActiveShards: String?
    private var _waitForNodes: String?
    private var _waitForEvents: Priority?
    private var _waitForNoRelocatingShards: Bool?
    private var _waitForNoInitializingShards: Bool?
    private var _waitForStatus: ClusterHealthStatus?

    public init() {}

    @discardableResult
    public func set(indices: [String]) -> Self {
        _indices = indices
        return self
    }

    @discardableResult
    public func add(index: String) -> Self {
        if _indices != nil {
            _indices?.append(index)
        } else {
            _indices = [index]
        }
        return self
    }

    @discardableResult
    public func set(level: ClusterHealthRequest.Level) -> Self {
        _level = level
        return self
    }

    @discardableResult
    public func set(local: Bool) -> Self {
        _local = local
        return self
    }

    @discardableResult
    public func set(timeout: String) -> Self {
        _timeout = timeout
        return self
    }

    @discardableResult
    public func set(masterTimeout: String) -> Self {
        _masterTimeout = masterTimeout
        return self
    }

    @discardableResult
    public func set(waitForActiveShards: String) -> Self {
        _waitForActiveShards = waitForActiveShards
        return self
    }

    @discardableResult
    public func set(waitForNodes: String) -> Self {
        _waitForNodes = waitForNodes
        return self
    }

    @discardableResult
    public func set(waitForEvents: Priority) -> Self {
        _waitForEvents = waitForEvents
        return self
    }

    @discardableResult
    public func set(waitForNoRelocatingShards: Bool) -> Self {
        _waitForNoRelocatingShards = waitForNoRelocatingShards
        return self
    }

    @discardableResult
    public func set(waitForNoInitializingShards: Bool) -> Self {
        _waitForNoInitializingShards = waitForNoInitializingShards
        return self
    }

    @discardableResult
    public func set(waitForStatus: ClusterHealthStatus) -> Self {
        _waitForStatus = waitForStatus
        return self
    }

    public var indices: [String]? {
        return _indices
    }

    public var level: ClusterHealthRequest.Level? {
        return _level
    }

    public var local: Bool? {
        return _local
    }

    public var timeout: String? {
        return _timeout
    }

    public var masterTimeout: String? {
        return _masterTimeout
    }

    public var waitForActiveShards: String? {
        return _waitForActiveShards
    }

    public var waitForNodes: String? {
        return _waitForNodes
    }

    public var waitForEvents: Priority? {
        return _waitForEvents
    }

    public var waitForNoRelocatingShards: Bool? {
        return _waitForNoRelocatingShards
    }

    public var waitForNoInitializingShards: Bool? {
        return _waitForNoInitializingShards
    }

    public var waitForStatus: ClusterHealthStatus? {
        return _waitForStatus
    }

    public func build() throws -> ClusterHealthRequest {
        return try ClusterHealthRequest(withBuilder: self)
    }
}

public struct ClusterHealthRequest: Request {
    public var headers = HTTPHeaders()

    public let indices: [String]?

    public var level: Level?
    public var local: Bool?
    public var timeout: String?
    public var masterTimeout: String?
    public var waitForActiveShards: String?
    public var waitForNodes: String?
    public var waitForEvents: Priority?
    public var waitForNoRelocatingShards: Bool?
    public var waitForNoInitializingShards: Bool?
    public var waitForStatus: ClusterHealthStatus?

    public init(indices: [String]? = nil, level: ClusterHealthRequest.Level? = nil, local: Bool? = nil, timeout: String? = nil, masterTimeout: String? = nil, waitForActiveShards: String? = nil, waitForNodes: String? = nil, waitForEvents: Priority? = nil, waitForNoRelocatingShards: Bool? = nil, waitForNoInitializingShards: Bool? = nil, waitForStatus: ClusterHealthStatus? = nil) {
        self.indices = indices
        self.level = level
        self.local = local
        self.timeout = timeout
        self.masterTimeout = masterTimeout
        self.waitForActiveShards = waitForActiveShards
        self.waitForNodes = waitForNodes
        self.waitForEvents = waitForEvents
        self.waitForNoRelocatingShards = waitForNoRelocatingShards
        self.waitForNoInitializingShards = waitForNoInitializingShards
        self.waitForStatus = waitForStatus
    }

    internal init(withBuilder builder: ClusterHealthRequestBuilder) throws {
        self.init(indices: builder.indices, level: builder.level, local: builder.local, timeout: builder.timeout, masterTimeout: builder.masterTimeout, waitForActiveShards: builder.waitForActiveShards, waitForNodes: builder.waitForNodes, waitForEvents: builder.waitForEvents, waitForNoRelocatingShards: builder.waitForNoRelocatingShards, waitForNoInitializingShards: builder.waitForNoInitializingShards, waitForStatus: builder.waitForStatus)
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let level = self.level {
            queryItems.append(URLQueryItem(name: QueryParams.level, value: level.rawValue))
        }
        if let local = self.local {
            queryItems.append(URLQueryItem(name: QueryParams.local, value: local))
        }
        if let timeout = self.timeout {
            queryItems.append(URLQueryItem(name: QueryParams.timeout, value: timeout))
        }
        if let masterTimeout = self.masterTimeout {
            queryItems.append(URLQueryItem(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        if let waitForActiveShards = self.waitForActiveShards {
            queryItems.append(URLQueryItem(name: QueryParams.waitForActiveShards, value: waitForActiveShards))
        }
        if let waitForNodes = self.waitForNodes {
            queryItems.append(URLQueryItem(name: QueryParams.waitForNodes, value: waitForNodes))
        }
        if let waitForEvents = self.waitForEvents {
            queryItems.append(URLQueryItem(name: QueryParams.waitForEvents, value: waitForEvents.rawValue))
        }
        if let waitForNoRelocatingShards = self.waitForNoRelocatingShards {
            queryItems.append(URLQueryItem(name: QueryParams.waitForNoRelocatingShards, value: waitForNoRelocatingShards))
        }
        if let waitForNoInitializingShards = self.waitForNoInitializingShards {
            queryItems.append(URLQueryItem(name: QueryParams.waitForNoInitializingShards, value: waitForNoInitializingShards))
        }
        if let waitForStatus = self.waitForStatus {
            queryItems.append(URLQueryItem(name: QueryParams.waitForStatus, value: waitForStatus.rawValue))
        }
        return queryItems
    }

    public var method: HTTPMethod {
        return .GET
    }

    public var endPoint: String {
        var _endPoint = "_cluster/health"
        if let indices = self.indices, !indices.isEmpty {
            _endPoint = _endPoint + "/" + indices.joined(separator: ",")
        }
        return _endPoint
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(MakeBodyError.noBodyForRequest)
    }
}

extension ClusterHealthRequest: Equatable {}

public extension ClusterHealthRequest {
    enum Level: String, Codable, CaseIterable {
        case cluster
        case indices
        case shards
    }
}

public enum ClusterHealthStatus: String, Codable, CaseIterable {
    case green
    case yellow
    case red
}

public enum Priority: String, Codable, CaseIterable {
    case immediate
    case urgent
    case high
    case normal
    case low
    case languid
}

// MARK: - Get Cluster Settings

public class ClusterGetSettingsRequestBuilder: RequestBuilder {
    public typealias ElasticSwiftType = ClusterGetSettingsRequest

    private var _includeDefaults: Bool?
    private var _flatSettings: Bool?
    private var _timeout: String?
    private var _masterTimeout: String?

    public init() {}

    @discardableResult
    public func set(includeDefaults: Bool) -> Self {
        _includeDefaults = includeDefaults
        return self
    }

    @discardableResult
    public func set(flatSettings: Bool) -> Self {
        _flatSettings = flatSettings
        return self
    }

    @discardableResult
    public func set(timeout: String) -> Self {
        _timeout = timeout
        return self
    }

    @discardableResult
    public func set(masterTimeout: String) -> Self {
        _masterTimeout = masterTimeout
        return self
    }

    public var includeDefaults: Bool? {
        return _includeDefaults
    }

    public var flatSettings: Bool? {
        return _flatSettings
    }

    public var timeout: String? {
        return _timeout
    }

    public var masterTimeout: String? {
        return _masterTimeout
    }

    public func build() throws -> ClusterGetSettingsRequest {
        return try ClusterGetSettingsRequest(withBuilder: self)
    }
}

public struct ClusterGetSettingsRequest: Request {
    public var headers = HTTPHeaders()

    public var includeDefaults: Bool?
    public var flatSettings: Bool?
    public var timeout: String?
    public var masterTimeout: String?

    public init(includeDefaults: Bool? = nil, flatSettings: Bool? = nil, timeout: String? = nil, masterTimeout: String? = nil) {
        self.includeDefaults = includeDefaults
        self.flatSettings = flatSettings
        self.timeout = timeout
        self.masterTimeout = masterTimeout
    }

    internal init(withBuilder builder: ClusterGetSettingsRequestBuilder) throws {
        self.init(includeDefaults: builder.includeDefaults, flatSettings: builder.flatSettings, timeout: builder.timeout, masterTimeout: builder.masterTimeout)
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let includeDefaults = self.includeDefaults {
            queryItems.append(URLQueryItem(name: QueryParams.includeDefaults, value: includeDefaults))
        }
        if let flatSettings = self.flatSettings {
            queryItems.append(URLQueryItem(name: QueryParams.flatSettings, value: flatSettings))
        }
        if let timeout = self.timeout {
            queryItems.append(URLQueryItem(name: QueryParams.timeout, value: timeout))
        }
        if let masterTimeout = self.masterTimeout {
            queryItems.append(URLQueryItem(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        return queryItems
    }

    public var method: HTTPMethod {
        return .GET
    }

    public var endPoint: String {
        return "_cluster/settings"
    }

    public func makeBody(_: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
}

extension ClusterGetSettingsRequest: Equatable {}

// MARK: - Cluster Update Settings

public class ClusterUpdateSettingsRequestBuilder: RequestBuilder {
    public typealias ElasticSwiftType = ClusterUpdateSettingsRequest

    private var _persistent: [String: CodableValue]?
    private var _transient: [String: CodableValue]?

    private var _flatSettings: Bool?
    private var _timeout: String?
    private var _masterTimeout: String?

    public init() {}

    @discardableResult
    public func set(persistent: [String: CodableValue]) -> Self {
        _persistent = persistent
        return self
    }

    @discardableResult
    public func addPersistent(_ setting: String, value: CodableValue) -> Self {
        if _persistent != nil {
            _persistent?[setting] = value
        } else {
            _persistent = [setting: value]
        }
        return self
    }

    @discardableResult
    public func set(transient: [String: CodableValue]) -> Self {
        _transient = transient
        return self
    }

    @discardableResult
    public func addTransient(_ setting: String, value: CodableValue) -> Self {
        if _transient != nil {
            _transient?[setting] = value
        } else {
            _transient = [setting: value]
        }
        return self
    }

    @discardableResult
    public func set(flatSettings: Bool) -> Self {
        _flatSettings = flatSettings
        return self
    }

    @discardableResult
    public func set(timeout: String) -> Self {
        _timeout = timeout
        return self
    }

    @discardableResult
    public func set(masterTimeout: String) -> Self {
        _masterTimeout = masterTimeout
        return self
    }

    public var persistent: [String: CodableValue]? {
        return _persistent
    }

    public var transient: [String: CodableValue]? {
        return _transient
    }

    public var flatSettings: Bool? {
        return _flatSettings
    }

    public var timeout: String? {
        return _timeout
    }

    public var masterTimeout: String? {
        return _masterTimeout
    }

    public func build() throws -> ClusterUpdateSettingsRequest {
        return try ClusterUpdateSettingsRequest(withBuilder: self)
    }
}

public struct ClusterUpdateSettingsRequest: Request {
    public var headers = HTTPHeaders()

    public let persistent: [String: CodableValue]?
    public let transient: [String: CodableValue]?

    public var flatSettings: Bool?
    public var timeout: String?
    public var masterTimeout: String?

    public init(persistent: [String: CodableValue], flatSettings: Bool? = nil, timeout: String? = nil, masterTimeout: String? = nil) {
        self.init(persistent: persistent, transient: nil, flatSettings: flatSettings, timeout: timeout, masterTimeout: masterTimeout)
    }

    public init(transient: [String: CodableValue], flatSettings: Bool? = nil, timeout: String? = nil, masterTimeout: String? = nil) {
        self.init(persistent: nil, transient: transient, flatSettings: flatSettings, timeout: timeout, masterTimeout: masterTimeout)
    }

    internal init(persistent: [String: CodableValue]?, transient: [String: CodableValue]?, flatSettings: Bool? = nil, timeout: String? = nil, masterTimeout: String? = nil) {
        self.persistent = persistent
        self.transient = transient
        self.flatSettings = flatSettings
        self.timeout = timeout
        self.masterTimeout = masterTimeout
    }

    internal init(withBuilder builder: ClusterUpdateSettingsRequestBuilder) throws {
        if builder.persistent == nil, builder.transient == nil {
            throw RequestBuilderError.atleastOneFieldRequired(["persistent", "transient"])
        }

        self.init(persistent: builder.persistent, transient: builder.transient, flatSettings: builder.flatSettings, timeout: builder.timeout, masterTimeout: builder.masterTimeout)
    }

    public var queryParams: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        if let flatSettings = self.flatSettings {
            queryItems.append(URLQueryItem(name: QueryParams.flatSettings, value: flatSettings))
        }
        if let timeout = self.timeout {
            queryItems.append(URLQueryItem(name: QueryParams.timeout, value: timeout))
        }
        if let masterTimeout = self.masterTimeout {
            queryItems.append(URLQueryItem(name: QueryParams.masterTimeout, value: masterTimeout))
        }
        return queryItems
    }

    public var method: HTTPMethod {
        return .PUT
    }

    public var endPoint: String {
        return "_cluster/settings"
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(persistent: persistent, transient: transient)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            MakeBodyError.wrapped(error)
        }
    }

    private struct Body: Encodable {
        public var persistent: [String: CodableValue]?
        public var transient: [String: CodableValue]?

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(persistent, forKey: .persistent)
            try container.encodeIfPresent(transient, forKey: .transient)
        }

        enum CodingKeys: String, CodingKey {
            case persistent
            case transient
        }
    }
}

extension ClusterUpdateSettingsRequest: Equatable {}
