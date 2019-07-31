//
//  DeleteByQuery.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 7/30/19.
//

import Foundation
import ElasticSwiftCore
import NIOHTTP1

// MARK:- Delete By Query Reqeuest Builder

/// Builder for `DeleteByQueryRequest`
public class DeleteByQueryRequestBuilder: RequestBuilder {
    
    public typealias RequestType = DeleteByQueryRequest
    public typealias BuilderClosure = (DeleteByQueryRequestBuilder) -> Void
    
    fileprivate var index: String?
    fileprivate var type: String?
    fileprivate var query: Query?
    
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
    public func set(query: Query) -> Self {
        self.query = query
        return self
    }
    
    public func build() throws -> DeleteByQueryRequest {
        
        guard self.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        guard self.query != nil else {
            throw RequestBuilderError.missingRequiredField("query")
        }
        
        return try DeleteByQueryRequest(withBuilder: self)
    }
}


// MARK:- Delete By Query Request

/// Class representing `_delete_by_query` request
public class DeleteByQueryRequest: Request {
    
    public typealias ResponseType = DeleteByQueryResponse
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let index: String
    public let type: String?
    public let query: Query
    public var refresh: IndexRefresh?
    public var conflicts: ConflictStrategy?
    public var routing: String?
    public var scrollSize: Int?
    public var from: Int?
    public var size: Int?
    
    /// Init new DeleteByQueryRequest
    /// - Parameter index: `String` index on which request needs to be executed
    /// - Parameter type: `Optional String` type on which request need to be executed
    /// - Parameter query: `Query` query to use for identifying docs
    public init(index: String, type: String? = nil, query: Query) {
        self.index = index
        self.type = type
        self.query = query
    }
    
    init(withBuilder builder: DeleteByQueryRequestBuilder) throws {
        self.index = builder.index!
        self.type = builder.type
        self.query = builder.query!
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var params = [URLQueryItem]()
            if let refresh = self.refresh {
                params.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: refresh.rawValue))
            }
            if let startegy = self.conflicts {
                params.append(URLQueryItem(name: QueryParams.conflicts.rawValue, value: startegy.rawValue))
            }
            if let routing = self.routing {
                params.append(URLQueryItem(name: QueryParams.routing.rawValue, value: routing))
            }
            if let scrollSize = self.scrollSize {
                params.append(URLQueryItem(name: QueryParams.scrollSize.rawValue, value: String(scrollSize)))
            }
            if let from = self.from {
                params.append(URLQueryItem(name: QueryParams.from.rawValue, value: String(from)))
            }
            if let size = self.size {
                params.append(URLQueryItem(name: QueryParams.size.rawValue, value: String(size)))
            }
            return params
        }
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            var _endPoint = self.index
            if let type = self.type {
                _endPoint += "/" + type
            }
            return _endPoint + "/" + "_delete_by_query"
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        
        let dic = ["query": self.query.toDic()]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: [])
            return .success(data)
        } catch {
            return .failure(.wrapped(error))
        }
    }
    
}

public enum ConflictStrategy: String {
    case abort
    case proceed
}
