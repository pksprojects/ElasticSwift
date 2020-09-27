//
//  MultiGetRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 8/23/19.
//

import ElasticSwiftCore
import Foundation
import NIOHTTP1

// MARK: - Multi-Get Request Builder

public class MultiGetRequestBuilder: RequestBuilder {
    public typealias RequestType = MultiGetRequest

    private var _index: String?
    private var _type: String?
    private var _items: [MultiGetRequest.Item] = []

    private var _source: String?
    private var _sourceExcludes: [String]?
    private var _sourceIncludes: [String]?
    private var _realTime: Bool?
    private var _refresh: Bool?
    private var _routing: String?
    private var _preference: String?
    private var _storedFields: [String]?

    public init() {}

    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> MultiGetRequestBuilder {
        _type = type
        return self
    }

    @discardableResult
    public func set(index: String) -> MultiGetRequestBuilder {
        _index = index
        return self
    }

    @discardableResult
    public func set(items: [MultiGetRequest.Item]) -> MultiGetRequestBuilder {
        _items = items
        return self
    }

    @discardableResult
    public func add(item: MultiGetRequest.Item) -> MultiGetRequestBuilder {
        _items.append(item)
        return self
    }

    @discardableResult
    public func set(source: String) -> MultiGetRequestBuilder {
        _source = source
        return self
    }

    @discardableResult
    public func set(sourceExcludes: [String]) -> MultiGetRequestBuilder {
        _sourceExcludes = sourceExcludes
        return self
    }

    @discardableResult
    public func set(sourceIncludes: [String]) -> MultiGetRequestBuilder {
        _sourceIncludes = sourceIncludes
        return self
    }

    @discardableResult
    public func set(realTime: Bool) -> MultiGetRequestBuilder {
        _realTime = realTime
        return self
    }

    @discardableResult
    public func set(refresh: Bool) -> MultiGetRequestBuilder {
        _refresh = refresh
        return self
    }

    @discardableResult
    public func set(routing: String) -> MultiGetRequestBuilder {
        _routing = routing
        return self
    }

    @discardableResult
    public func set(preference: String) -> MultiGetRequestBuilder {
        _preference = preference
        return self
    }

    @discardableResult
    public func set(storedFields: [String]) -> MultiGetRequestBuilder {
        _storedFields = storedFields
        return self
    }

    public var index: String? {
        return _index
    }

    public var type: String? {
        return _type
    }

    public var source: String? {
        return _source
    }

    public var items: [MultiGetRequest.Item] {
        return _items
    }

    public var sourceExcludes: [String]? {
        return _sourceExcludes
    }

    public var sourceIncludes: [String]? {
        return _sourceIncludes
    }

    public var realTime: Bool? {
        return _realTime
    }

    public var refresh: Bool? {
        return _refresh
    }

    public var routing: String? {
        return _routing
    }

    public var preference: String? {
        return _preference
    }

    public var storedFields: [String]? {
        return _storedFields
    }

    public func build() throws -> MultiGetRequest {
        return try MultiGetRequest(withBuilder: self)
    }
}

// MARK: - Multi-Get Request

public struct MultiGetRequest: Request {
    public var headers = HTTPHeaders()

    public let index: String?
    public let type: String?
    public let items: [Item]

    public var source: String?
    public var sourceExcludes: [String]?
    public var sourceIncludes: [String]?
    public var realTime: Bool?
    public var refresh: Bool?
    public var routing: String?
    public var preference: String?
    public var storedFields: [String]?

    public init(index: String? = nil, type: String? = nil, items: [MultiGetRequest.Item], source: String? = nil, sourceExcludes: [String]? = nil, sourceIncludes: [String]? = nil, realTime: Bool? = nil, refresh: Bool? = nil, routing: String? = nil, preference: String? = nil, storedFields: [String]? = nil) {
        self.index = index
        self.type = type
        self.items = items
        self.source = source
        self.sourceExcludes = sourceExcludes
        self.sourceIncludes = sourceIncludes
        self.realTime = realTime
        self.refresh = refresh
        self.routing = routing
        self.preference = preference
        self.storedFields = storedFields
    }

    internal init(withBuilder builder: MultiGetRequestBuilder) throws {
        guard !builder.items.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("item")
        }

        self.init(index: builder.index, type: builder.type, items: builder.items, source: builder.source, sourceExcludes: builder.sourceIncludes, sourceIncludes: builder.sourceExcludes, realTime: builder.realTime, refresh: builder.refresh, routing: builder.routing, preference: builder.preference, storedFields: builder.storedFields)
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let source = self.source {
            params.append(URLQueryItem(name: QueryParams.source.rawValue, value: source))
        }
        if let excludes = sourceExcludes {
            params.append(URLQueryItem(name: QueryParams.sourceExcludes.rawValue, value: excludes.joined(separator: ",")))
        }
        if let includes = sourceIncludes {
            params.append(URLQueryItem(name: QueryParams.sourceIncludes.rawValue, value: includes.joined(separator: ",")))
        }
        if let realTime = self.realTime {
            params.append(URLQueryItem(name: QueryParams.realTime.rawValue, value: String(realTime)))
        }
        if let refresh = self.refresh {
            params.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: String(refresh)))
        }
        if let routing = self.routing {
            params.append(URLQueryItem(name: QueryParams.routing.rawValue, value: routing))
        }
        if let preference = self.preference {
            params.append(URLQueryItem(name: QueryParams.preference.rawValue, value: preference))
        }
        if let storedFields = self.storedFields {
            params.append(URLQueryItem(name: QueryParams.storedFields.rawValue, value: storedFields.joined(separator: ",")))
        }
        return params
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        var _endPoint = "/_mget"
        if let type = self.type {
            _endPoint = "/" + type + _endPoint
        }
        if let index = self.index {
            _endPoint = "/" + index + _endPoint
        }
        return _endPoint
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(docs: items)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            .wrapped(error)
        }
    }

    struct Body: Encodable {
        public let docs: [Item]
    }

    public struct Item: Codable, Equatable {
        public let index: String
        public let type: String?
        public let id: String
        public let routing: String?
        public let parent: String?
        public let fetchSource: Bool?
        public let sourceIncludes: [String]?
        public let sourceExcludes: [String]?
        public let storedFields: [String]?

        public init(index: String, type: String? = nil, id: String, routing: String? = nil, parent: String? = nil, fetchSource: Bool? = nil, sourceIncludes: [String]? = nil, sourceExcludes: [String]? = nil, storedFields: [String]? = nil) {
            self.index = index
            self.type = type
            self.id = id
            self.routing = routing
            self.parent = parent
            self.fetchSource = fetchSource
            self.sourceIncludes = sourceIncludes
            self.sourceExcludes = sourceExcludes
            self.storedFields = storedFields
        }

        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case type = "_type"
            case id = "_id"
            case routing
            case parent
            case source = "_source"
            case storedFields = "stored_fields"
        }

        enum SourceCodingKeys: String, CodingKey {
            case include
            case exclude
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(index, forKey: .index)
            try container.encode(id, forKey: .id)
            try container.encodeIfPresent(type, forKey: .type)
            try container.encodeIfPresent(routing, forKey: .routing)
            try container.encodeIfPresent(parent, forKey: .parent)
            try container.encodeIfPresent(storedFields, forKey: .storedFields)
            if let fetchSource = self.fetchSource, self.sourceIncludes == nil && sourceExcludes == nil {
                try container.encodeIfPresent(fetchSource, forKey: .source)
            } else if sourceIncludes != nil || sourceExcludes != nil {
                var nested = container.nestedContainer(keyedBy: SourceCodingKeys.self, forKey: .source)
                try nested.encodeIfPresent(sourceIncludes, forKey: .include)
                try nested.encodeIfPresent(sourceExcludes, forKey: .exclude)
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            index = try container.decode(String.self, forKey: .index)
            id = try container.decode(String.self, forKey: .id)
            type = try container.decodeIfPresent(String.self, forKey: .type)
            routing = try container.decodeIfPresent(String.self, forKey: .routing)
            parent = try container.decodeIfPresent(String.self, forKey: .parent)
            storedFields = try container.decodeIfPresent([String].self, forKey: .storedFields)
            do {
                fetchSource = try container.decodeIfPresent(Bool.self, forKey: .source)
                sourceIncludes = nil
                sourceExcludes = nil
            } catch {
                do {
                    sourceIncludes = try container.decode([String].self, forKey: .source)
                    fetchSource = nil
                    sourceExcludes = nil
                } catch {
                    let sourceContainer = try container.nestedContainer(keyedBy: SourceCodingKeys.self, forKey: .source)
                    fetchSource = nil
                    sourceIncludes = try sourceContainer.decodeIfPresent([String].self, forKey: .include)
                    sourceExcludes = try sourceContainer.decodeIfPresent([String].self, forKey: .exclude)
                }
            }
        }
    }
}

extension MultiGetRequest: Equatable {
    public static func == (lhs: MultiGetRequest, rhs: MultiGetRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.items == rhs.items
            && lhs.type == rhs.type
            && lhs.headers == rhs.headers
            && lhs.method == rhs.method
            && lhs.queryParams == rhs.queryParams
    }
}
