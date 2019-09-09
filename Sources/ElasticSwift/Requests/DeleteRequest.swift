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
    
    public typealias RequestType = DeleteRequest
    
    private var _index: String?
    private var _type: String?
    private var _id: String?
    private var _version: String?
    private var _versionType: VersionType?
    private var _refresh: IndexRefresh?
    
    public init() {}
    
    @discardableResult
    public func set(index: String) -> Self {
        self._index = index
        return self
    }
    
    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> Self {
        self._type = type
        return self
    }
    
    @discardableResult
    public func set(id: String) -> Self {
        self._id = id
        return self
    }
    
    @discardableResult
    public func set(version: String) -> Self {
        self._version = version
        return self
    }
    
    @discardableResult
    public func set(versionType: VersionType) -> Self {
        self._versionType = versionType
        return self
    }
    
    @discardableResult
    public func set(refresh: IndexRefresh) -> Self {
        self._refresh = refresh
        return self
    }
    
    public var index: String? {
        return self._index
    }
    public var type: String? {
        return self._type
    }
    public var id: String? {
        return self._id
    }
    public var version: String? {
        return self._version
    }
    public var versionType: VersionType? {
        return self._versionType
    }
    public var refresh: IndexRefresh? {
        return self._refresh
    }
    
    public func build() throws -> RequestType {
        return try DeleteRequest(withBuilder: self)
    }
    
}

//MARK:- Delete Request

public struct DeleteRequest: Request {
    
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
    
    internal init(withBuilder builder: DeleteRequestBuilder) throws {
        
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard builder.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }
        
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

extension DeleteRequest: Equatable {}
