//
//  index.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore

//MARK:- Index Requet Builder

public class IndexRequestBuilder<T: Codable>: RequestBuilder {
    
    public typealias RequestType = IndexRequest<T>
    public typealias BuilderClosure = (IndexRequestBuilder) -> Void
    
    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var routing: String?
    var parent: String?
    var version: String?
    var versionType: VersionType?
    var refresh: IndexRefresh?
    
    init() {}
    
    public init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
    
    @discardableResult
    public func set(index: String) -> Self {
        self.index = index
        return self
    }
    
    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> Self {
        self.type = type
        return self
    }
    
    @discardableResult
    public func set(id: String) -> Self {
        self.id = id
        return self
    }
    
    @discardableResult
    public func set(routing: String) -> Self {
        self.routing = routing
        return self
    }
    
    @discardableResult
    public func set(parent: String) -> Self {
        self.parent = parent
        return self
    }
    
    @discardableResult
    public func set(source: T) -> Self {
        self.source = source
        return self
    }
    
    @discardableResult
    public func set(version: String) -> Self {
        self.version = version
        return self
    }
    
    @discardableResult
    public func set(versionType: VersionType) -> Self {
        self.versionType = versionType
        return self
    }
    
    @discardableResult
    public func set(refresh: IndexRefresh) -> Self {
        self.refresh = refresh
        return self
    }
    
    public func build() throws -> IndexRequest<T> {
        
        guard self.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard self.source != nil else {
            throw RequestBuilderError.missingRequiredField("source")
        }
        
        guard (self.version != nil && self.versionType != nil) || (self.version == nil && self.versionType == nil) else {
            throw RequestBuilderError.missingRequiredField("source")
        }
        
        return try IndexRequest<T>(withBuilder: self)
    }
    
}

//MARK:- Index Request

public class IndexRequest<T: Codable>: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var method: HTTPMethod  {
        get {
            if self.id == nil {
                return .POST
            }
            return .PUT
        }
    }
    
    public let index: String
    public let type: String
    public let id: String?
    public let source: T
    public var routing: String?
    public var parent: String?
    public var version: String?
    public var versionType: VersionType?
    public var refresh: IndexRefresh?
    
    public init(index: String, type: String = "_doc", id: String?, source: T) {
        self.index = index
        self.type = type
        self.id = id
        self.source = source
    }
    
    public init(index: String, type: String = "_doc", id: String?, source: T, routing: String?, parent: String?, refresh: IndexRefresh?, version: String, versionType: VersionType) {
        self.index = index
        self.type = type
        self.id = id
        self.source = source
        self.routing = routing
        self.parent = parent
        self.refresh = refresh
        self.version = version
        self.versionType = versionType
    }
    
    init(withBuilder builder: IndexRequestBuilder<T>) throws {
        self.index = builder.index!
        self.id = builder.id
        self.type = builder.type ?? "_doc"
        self.source = builder.source!
        self.routing = builder.routing
        self.parent = builder.parent
        self.version = builder.version
        self.versionType = builder.versionType
        self.refresh = builder.refresh
    }
    
    public var endPoint: String {
        get {
            var _endPoint = self.index + "/" + type
            if let id = self.id {
                _endPoint = _endPoint + "/" + id
            }
            return _endPoint
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return serializer.encode(self.source).flatMapError { error in return .failure(.wrapped(error)) }
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var queryItems = [URLQueryItem]()
            if let routing = self.routing {
                queryItems.append(URLQueryItem(name: QueryParams.routing.rawValue, value: routing))
            }
            if let version = self.version, let versionType = self.versionType {
                queryItems.append(URLQueryItem(name: QueryParams.version.rawValue, value: version))
                queryItems.append(URLQueryItem(name: QueryParams.versionType.rawValue, value: versionType.rawValue))
            }
            if let refresh = self.refresh {
                queryItems.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: refresh.rawValue))
            }
            if let parentId = self.parent {
                queryItems.append(URLQueryItem(name: QueryParams.parent.rawValue, value: parentId))
            }
            return queryItems
        }
    }
    
}

