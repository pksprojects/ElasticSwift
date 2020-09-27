//
//  UpdateByQueryRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 7/30/19.
//

import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

// MARK: - Update By Query Request Builder

public class UpdateByQueryRequestBuilder: RequestBuilder {
    public typealias RequestType = UpdateByQueryRequest

    private var _index: String?
    private var _type: String?
    private var _script: Script?
    private var _query: Query?

    public init() {}

    @discardableResult
    public func set(index: String) -> Self {
        _index = index
        return self
    }

    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(query: Query) -> Self {
        _query = query
        return self
    }

    @discardableResult
    public func set(script: Script) -> Self {
        _script = script
        return self
    }

    public var index: String? {
        return _index
    }

    public var type: String? {
        return _type
    }

    public var script: Script? {
        return _script
    }

    public var query: Query? {
        return _query
    }

    public func build() throws -> UpdateByQueryRequest {
        return try UpdateByQueryRequest(withBuilder: self)
    }
}

// MARK: - Update By Query Request

public struct UpdateByQueryRequest: Request {
    public var headers = HTTPHeaders()

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

        self.init(index: builder.index!, type: builder.type, script: builder.script, query: builder.query)
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let refresh = self.refresh {
            params.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: refresh.rawValue))
        }
        if let startegy = conflicts {
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

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        var _endPoint = index
        if let type = self.type {
            _endPoint += "/" + type
        }
        return _endPoint + "/" + "_update_by_query"
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        if query == nil, script == nil {
            return .failure(.noBodyForRequest)
        }
        let body = Body(query: query, script: script)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            MakeBodyError.wrapped(error)
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
            query = try container.decodeQueryIfPresent(forKey: .query)
            script = try container.decode(Script.self, forKey: .script)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(query, forKey: .query)
            try container.encodeIfPresent(script, forKey: .script)
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

    private static func matchQueries(_ lhs: Query?, _ rhs: Query?) -> Bool {
        if lhs == nil, rhs == nil {
            return true
        }
        if let lhs = lhs, let rhs = rhs {
            return lhs.isEqualTo(rhs)
        }
        return false
    }
}
