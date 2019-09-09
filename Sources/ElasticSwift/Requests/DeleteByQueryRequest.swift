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
    
    private var _index: String?
    private var _type: String?
    private var _query: Query?
    
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
    public func set(query: Query) -> Self {
        self._query = query
        return self
    }
    
    public var index: String? {
        return self._index
    }
    public var type: String? {
        return self._type
    }
    public var query: Query? {
        return self._query
    }
    
    public func build() throws -> DeleteByQueryRequest {
        return try DeleteByQueryRequest(withBuilder: self)
    }
}


// MARK:- Delete By Query Request

/// Class representing `_delete_by_query` request
public struct DeleteByQueryRequest: Request {
    
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
    
    internal init(withBuilder builder: DeleteByQueryRequestBuilder) throws {
        
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        guard builder.query != nil else {
            throw RequestBuilderError.missingRequiredField("query")
        }
        
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
        let body = Body(query: self.query)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            return MakeBodyError.wrapped(error)
        }
    }
    
    struct Body: Encodable {
        let query: Query
        
        init(query: Query) {
            self.query = query
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodinKeys.self)
            try container.encode(self.query, forKey: .query)
        }
        
        enum CodinKeys: String, CodingKey {
            case query
        }
    }
    
}

extension DeleteByQueryRequest: Equatable {
    public static func == (lhs: DeleteByQueryRequest, rhs: DeleteByQueryRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.type == rhs.type
            && lhs.query.isEqualTo(rhs.query)
            && lhs.refresh == rhs.refresh
            && lhs.conflicts == rhs.conflicts
            && lhs.routing == rhs.routing
            && lhs.scrollSize == rhs.scrollSize
            && lhs.from == rhs.from
            && lhs.size == rhs.size
    }
}

public enum ConflictStrategy: String {
    case abort
    case proceed
}
