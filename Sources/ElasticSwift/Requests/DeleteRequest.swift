//
//  DeleteRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore

//MARK:- Delete Request Builder

public class DeleteRequestBuilder: RequestBuilder {
    
    public typealias BuilderClosure = (DeleteRequestBuilder) -> Void
    public typealias RequestType = DeleteRequest
    
    var index: String?
    var type: String?
    var id: String?
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
    
    public func build() throws -> RequestType {
        
        guard self.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard self.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }
        
        return try DeleteRequest(withBuilder: self)
    }
    
}

//MARK:- Delete Request

public class DeleteRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let index: String
    public let type: String
    public let id: String
    public var version: String?
    public var versionType: VersionType?
    public var refresh: IndexRefresh?
    
    public init(index: String, type: String = "_doc", id: String) {
        self.index = index
        self.type = type
        self.id = id
    }
    
    init(withBuilder builder: DeleteRequestBuilder) throws {
        self.index = builder.index!
        self.type = builder.type ?? "_doc"
        self.id = builder.id!
        self.version = builder.version
        self.versionType = builder.versionType
        self.refresh = builder.refresh
    }
    
    public var method: HTTPMethod {
        get {
            return .DELETE
        }
    }
    
    public var endPoint: String {
        get {
            return self.index + "/" + self.type + "/" + self.id
        }
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var params = [URLQueryItem]()
            if let version = self.version, let versionType = self.versionType {
                params.append(URLQueryItem(name: QueryParams.version.rawValue, value: version))
                params.append(URLQueryItem(name: QueryParams.versionType.rawValue, value: versionType.rawValue))
            }
            if let refresh = self.refresh {
                params.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: refresh.rawValue))
            }
            return params
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return .failure(.noBodyForRequest)
    }
    
}
