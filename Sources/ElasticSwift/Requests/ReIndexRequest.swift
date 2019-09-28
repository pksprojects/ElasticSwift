//
//  ReIndexRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 9/28/19.
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore
import ElasticSwiftQueryDSL

// MARK:- ReIndex Reqeust Builder

public class ReIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = ReIndexRequest
    
    private var _source: ReIndexRequest.Source?
    private var _destination: ReIndexRequest.Destination?
    private var _script: Script?
    private var _refresh: Bool?
    private var _timeout: String?
    private var _waitForActiveShards: String?
    private var _waitForCompletion: Bool?
    private var _requestsPerSecond: Int?
    private var _slices: Int?
    private var _size: Int?
    
    public init() {}
    
    @discardableResult
    public func set(source: ReIndexRequest.Source) -> Self {
        self._source = source
        return self
    }
    
    @discardableResult
    public func set(destination: ReIndexRequest.Destination) -> Self {
        self._destination = destination
        return self
    }
    
    @discardableResult
    public func set(script: Script) -> Self {
        self._script = script
        return self
    }
    
    @discardableResult
    public func set(refresh: Bool) -> Self {
        self._refresh = refresh
        return self
    }
    
    @discardableResult
    public func set(timeout: String) -> Self {
        self._timeout = timeout
        return self
    }
    
    @discardableResult
    public func set(waitForActiveShards: String) -> Self {
        self._waitForActiveShards = waitForActiveShards
        return self
    }
    
    @discardableResult
    public func set(waitForCompletion: Bool) -> Self {
        self._waitForCompletion = waitForCompletion
        return self
    }
    
    @discardableResult
    public func set(requestsPerSecond: Int) -> Self {
        self._requestsPerSecond = requestsPerSecond
        return self
    }
    
    @discardableResult
    public func set(slices: Int) -> Self {
        self._slices = slices
        return self
    }
    
    @discardableResult
    public func set(size: Int) -> Self {
        self._size = size
        return self
    }
    
    public var source: ReIndexRequest.Source? {
        return self._source
    }
    public var destination: ReIndexRequest.Destination? {
        return self._destination
    }
    public var script: Script? {
        return self._script
    }
    public var refresh: Bool? {
        return self._refresh
    }
    public var timeout: String? {
        return self._timeout
    }
    public var waitForActiveShards: String? {
        return self._waitForActiveShards
    }
    public var waitForCompletion: Bool? {
        return self._waitForCompletion
    }
    public var requestsPerSecond: Int? {
        return self._requestsPerSecond
    }
    public var slices: Int? {
        return self._slices
    }
    public var size: Int? {
        return self._size
    }
    
    public func build() throws -> ReIndexRequest {
        return try ReIndexRequest(withBuilder: self)
    }
}

// MARK:- ReIndex Request

public struct ReIndexRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let source: Source
    public let destination: Destination
    public let script: Script?
    public let size: Int?
    
    public var refresh: Bool?
    public var timeout: String?
    public var waitForActiveShards: String?
    public var waitForCompletion: Bool?
    public var requestsPerSecond: Int?
    public var slices: Int?
    
    public init(source: ReIndexRequest.Source, destination: ReIndexRequest.Destination, script: Script? = nil, size: Int? = nil) {
        self.source = source
        self.destination = destination
        self.script = script
        self.size = size
    }
    
    internal init(withBuilder builder: ReIndexRequestBuilder) throws {
        self.source = builder.source!
        self.destination = builder.destination!
        self.script = builder.script
        self.refresh = builder.refresh
        self.timeout = builder.timeout
        self.waitForActiveShards = builder.waitForActiveShards
        self.waitForCompletion = builder.waitForCompletion
        self.requestsPerSecond = builder.requestsPerSecond
        self.slices = builder.slices
        self.size = builder.size
    }
    
    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let refresh = self.refresh {
            params.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: "\(refresh)"))
        }
        if let timeout = self.timeout {
            params.append(URLQueryItem(name: QueryParams.timeout.rawValue, value: timeout))
        }
        if let waitForActiveShards = self.waitForActiveShards {
            params.append(URLQueryItem(name: QueryParams.waitForActiveShards.rawValue, value: waitForActiveShards))
        }
        if let waitForCompletion = self.waitForCompletion {
            params.append(URLQueryItem(name: QueryParams.waitForCompletion.rawValue, value: "\(waitForCompletion)"))
        }
        if let requestsPerSecond = self.requestsPerSecond {
            params.append(URLQueryItem(name: QueryParams.requestsPerSecond.rawValue, value: "\(requestsPerSecond)"))
        }
        if let slices = self.slices {
            params.append(URLQueryItem(name: QueryParams.slices.rawValue, value: "\(slices)"))
        }
        return params
    }
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var endPoint: String {
        return "_reindex"
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body =  Body(source: self.source, destination: self.destination, script: self.script, size: self.size)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            return MakeBodyError.wrapped(error)
        }
    }
    
    struct Body: Encodable {
        public let source: Source
        public let destination: Destination
        public let script: Script?
        public let size: Int?
    }
    
    public struct Source: Encodable, Equatable {
        
        public let index: String
        public let query: Query?
        public let size: Int?
        public let sort: Sort?
        public let source: [String]?
        public let remote: Remote?
        
        public init(index: String, query: Query? = nil, size: Int? = nil, sort: Sort? = nil, source: [String]? = nil, remote: ReIndexRequest.Remote? = nil) {
            self.index = index
            self.query = query
            self.size = size
            self.sort = sort
            self.source = source
            self.remote = remote
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.index, forKey: .index)
            try container.encodeIfPresent(self.query, forKey: .query)
            try container.encodeIfPresent(self.size, forKey: .size)
            try container.encodeIfPresent(self.sort, forKey: .sort)
            try container.encodeIfPresent(self.source, forKey: .source)
            try container.encodeIfPresent(self.remote, forKey: .remote)
        }
        
        enum CodingKeys: String, CodingKey {
            case index
            case query
            case size
            case sort
            case source = "_source"
            case remote
        }
        
        public static func == (lhs: ReIndexRequest.Source, rhs: ReIndexRequest.Source) -> Bool {
            return lhs.index == rhs.index
                && lhs.size == rhs.size
                && lhs.sort == rhs.sort
                && lhs.source == rhs.source
                && lhs.remote == rhs.remote
                && matchQueries(lhs.query, rhs.query)
        }
        
        private static func matchQueries(_ lhs: Query? , _ rhs: Query?) -> Bool {
            if lhs == nil && rhs == nil {
                return true
            }
            if let lhs = lhs, let rhs = rhs {
                return lhs.isEqualTo(rhs)
            }
            return false
        }
    }
    
    public struct Remote: Codable, Equatable {
        
        public let host: String
        public let username: String?
        public let password: String?
        public let socketTimeout: String?
        public let connectTimeout: String?
        
        public init(host: String, username: String? = nil, password: String? = nil, socketTimeout: String? = nil, connectTimeout: String? = nil) {
            self.host = host
            self.username = username
            self.password = password
            self.socketTimeout = socketTimeout
            self.connectTimeout = connectTimeout
        }
        
        enum CodingKeys: String, CodingKey {
            case host
            case username
            case password
            case socketTimeout = "socket_timeout"
            case connectTimeout = "connect_timeout"
        }
    }
    
    public struct Destination: Codable, Equatable {
        
        public let index: String
        public let versionType: VersionType?
        public let opType: OpType?
        public let type: String?
        public let routing: String?
        public let pipeline: String?
        
        public init(index: String, versionType: VersionType? = nil, opType: OpType? = nil, type: String? = nil, routing: String? = nil, pipeline: String? = nil) {
            self.index = index
            self.versionType = versionType
            self.opType = opType
            self.type = type
            self.routing = routing
            self.pipeline = pipeline
        }
        
        enum CodingKeys: String, CodingKey {
            case index
            case versionType = "version_type"
            case opType = "op_type"
            case type
            case routing
            case pipeline
        }
    }
}

extension ReIndexRequest: Equatable {}

