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
    public typealias BuilderClosure = (UpdateByQueryRequestBuilder) -> Void
    
    var index: String?
    var type: String?
    var script: Script?
    var query: Query?
    
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
    
    @discardableResult
    public func set(script: Script) -> Self {
        self.script = script
        return self
    }
    
    public func build() throws -> UpdateByQueryRequest {
        return try UpdateByQueryRequest(withBuilder: self)
    }
}

// MARK:- Update By Query Request

public class UpdateByQueryRequest: Request {
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
    
    init(withBuilder builder: UpdateByQueryRequestBuilder) throws {
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
        var dic = [String: Any]()
        /// TODO: Need to look for alternate for encoding, decoding and again encoding for script
        if let script = self.script {
            let result = serializer.encode(script)
            switch result {
            case .success(let data):
                do {
                dic["script"] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                } catch {
                    return .failure(.wrapped(error))
                }
            case .failure(let error):
                return .failure(.wrapped(error))
            }
        }
        
        if let query = self.query {
            dic["query"] = query.toDic()
        }
        
        if dic.isEmpty {
            return .failure(.noBodyForRequest)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: [])
            return .success(data)
        } catch {
            return .failure(.wrapped(error))
        }
    }
    
    
}
