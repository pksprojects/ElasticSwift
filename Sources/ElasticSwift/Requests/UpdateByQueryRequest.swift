//
//  UpdateByQueryRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 7/30/19.
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore
import ElasticSwiftQueryDSL

// MARK:- Update By Query Request Builder

public class UpdateByQueryRequestBuilder: RequestBuilder {
    
    public typealias RequestType = UpdateByQueryRequest
    
    private var _index: String?
    private var _type: String?
    private var _script: Script?
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
    
    @discardableResult
    public func set(script: Script) -> Self {
        self._script = script
        return self
    }
    
    public var index: String? {
        return self._index
    }
    public var type: String? {
        return self._type
    }
    public var script: Script? {
        return self._script
    }
    public var query: Query? {
        return self._query
    }
    
    public func build() throws -> UpdateByQueryRequest {
        return try UpdateByQueryRequest(withBuilder: self)
    }
}

// MARK:- Update By Query Request

public struct UpdateByQueryRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let index: String
    public let type: String?
    public let script: Script?
    public let query: Query?
    public var refresh: IndexRefresh?
    public var conflicts: ConflictStrategy?
    public var routing: String?
    public var scrollSize: Int?
    public var from: Int?
    public var size: Int?
    
    public init(index: String, type: String? = nil, script: Script?, query: Query?) {
        self.index = index
        self.type = type
        self.script = script
        self.query = query
    }
    
    internal init(withBuilder builder: UpdateByQueryRequestBuilder) throws {
        
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        self.index = builder.index!
        self.type = builder.type
        self.query = builder.query
        self.script = builder.script
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
            return _endPoint + "/" + "_update_by_query"
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        if self.query == nil && self.script == nil {
            return .failure(.noBodyForRequest)
        }
        let body = Body(query: self.query, script: self.script)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            return MakeBodyError.wrapped(error)
        }
    }
    
    struct Body: Codable {
        public let query: Query?
        public let script: Script?
        
        init(query: Query?, script: Script?) {
            self.query = query
            self.script = script
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.query = try container.decodeQueryIfPresent(forKey: .query)
            self.script = try container.decode(Script.self, forKey: .script)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.query, forKey: .query)
            try container.encodeIfPresent(self.script, forKey: .script)
        }
        
        enum CodingKeys: String, CodingKey {
            case query
            case script
        }
    }
}

extension UpdateByQueryRequest: Equatable {
    public static func == (lhs: UpdateByQueryRequest, rhs: UpdateByQueryRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.type == rhs.type
            && lhs.script == rhs.script
            && lhs.refresh == rhs.refresh
            && lhs.conflicts == rhs.conflicts
            && lhs.routing == rhs.routing
            && lhs.scrollSize == rhs.scrollSize
            && lhs.from == rhs.from
            && lhs.size == rhs.size
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
