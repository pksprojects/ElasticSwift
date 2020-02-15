//
//  BulkRequest.swift
//
//
//  Created by Prafull Kumar Soni on 11/3/19.
//

import ElasticSwiftCore
import Foundation
import NIOHTTP1

// MARK: - Bulk Request Builder

public class BulkRequestBuilder: RequestBuilder {
    public typealias RequestType = BulkRequest

    private var _index: String?
    private var _type: String?
    private var _requests: [BulkableRequest] = []

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
    public func set(requests: [BulkableRequest]) -> Self {
        _requests = requests
        return self
    }

    @discardableResult
    public func add(request: BulkableRequest) -> Self {
        _requests.append(request)
        return self
    }

    public var index: String? {
        return _index
    }

    public var type: String? {
        return _type
    }

    public var requests: [BulkableRequest] {
        return _requests
    }

    public func build() throws -> BulkRequest {
        return try BulkRequest(withBuilder: self)
    }
}

// MARK: - Bulk Request

public struct BulkRequest: Request {
    public let index: String?
    public let type: String?
    public let requests: [BulkableRequest]

    public var waitForActiveShards: String?
    public var refresh: IndexRefresh?
    public var routing: String?
    public var timeout: String?
    public var fields: [String]?
    public var source: [String]?
    public var sourceExcludes: [String]?
    public var sourceIncludes: [String]?
    public var pipeline: String?

    internal init(index: String? = nil, type: String? = nil, requests: [BulkableRequest], waitForActiveShards: String? = nil, refresh: IndexRefresh? = nil, routing: String? = nil, timeout: String? = nil, fields: [String]? = nil, source: [String]? = nil, sourceExcludes: [String]? = nil, sourceIncludes: [String]? = nil, pipeline: String? = nil) {
        self.index = index
        self.type = type
        self.requests = requests
        self.waitForActiveShards = waitForActiveShards
        self.refresh = refresh
        self.routing = routing
        self.timeout = timeout
        self.fields = fields
        self.source = source
        self.sourceExcludes = sourceExcludes
        self.sourceIncludes = sourceIncludes
        self.pipeline = pipeline
    }

    internal init(withBuilder builder: BulkRequestBuilder) throws {
        guard !builder.requests.isEmpty else {
            throw RequestBuilderError.atlestOneElementRequired("requests")
        }

        self.init(index: builder.index, type: builder.type, requests: builder.requests)
    }

    public var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/x-ndjson")
        return headers
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let waitForActiveShards = self.waitForActiveShards {
            params.append(URLQueryItem(name: QueryParams.waitForActiveShards, value: waitForActiveShards))
        }
        if let refresh = self.refresh {
            params.append(URLQueryItem(name: QueryParams.refresh, value: refresh.rawValue))
        }
        if let routing = self.routing {
            params.append(URLQueryItem(name: QueryParams.routing, value: routing))
        }
        if let timeout = self.timeout {
            params.append(URLQueryItem(name: QueryParams.timeout, value: timeout))
        }
        if let fields = self.fields {
            params.append(URLQueryItem(name: QueryParams.fields, value: fields))
        }
        if let source = self.source {
            params.append(URLQueryItem(name: QueryParams.source, value: source))
        }
        if let sourceExcludes = self.sourceExcludes {
            params.append(URLQueryItem(name: QueryParams.sourceExcludes, value: sourceExcludes))
        }
        if let sourceIncludes = self.sourceIncludes {
            params.append(URLQueryItem(name: QueryParams.sourceIncludes, value: sourceIncludes))
        }
        if let pipeline = self.pipeline {
            params.append(URLQueryItem(name: QueryParams.pipeline, value: pipeline))
        }
        return params
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        var _endPoint = "_bulk"
        if let type = self.type {
            _endPoint = type + "/" + _endPoint
        }
        if let index = self.index {
            _endPoint = index + "/" + _endPoint
        }
        return _endPoint
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        var data = Data()
        let newLineData = "\n".data(using: .utf8)!
        for request in requests {
            let id: String?
            if request.id == "ID WILL BE GENERATED BY ELASTICSEARCH" {
                id = nil
            } else {
                id = request.id
            }
            let meta = ActionAndMetaData(opType: request.opType, index: request.index, type: request.type, id: id)
            let result = serializer.encode(meta)
            switch result {
            case let .success(metaPart):
                data.append(metaPart)
                data.append(newLineData)
            case let .failure(error):
                return .failure(.wrapped(error))
            }
            let body = request.makeBody(serializer)
            switch body {
            case let .success(bodyPart):
                data.append(bodyPart)
                data.append(newLineData)
            case let .failure(error):
                switch error {
                case .noBodyForRequest:
                    continue
                case let .wrapped(error):
                    return .failure(.wrapped(error))
                }
            }
        }
        return .success(data)
    }

    struct ActionAndMetaData: Encodable {
        public let opType: OpType
        public let index: String
        public let type: String
        public let id: String?

        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case type = "_type"
            case id = "_id"
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: DynamicCodingKeys.self)
            var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: opType.rawValue))
            try nested.encode(index, forKey: .index)
            try nested.encode(type, forKey: .type)
            try nested.encodeIfPresent(id, forKey: .id)
        }
    }
}

extension BulkRequest: Equatable {
    public static func == (lhs: BulkRequest, rhs: BulkRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.type == rhs.type
            && lhs.headers == rhs.headers
            && lhs.queryParams == rhs.queryParams
    }
}

public protocol BulkableRequest: Request {
    var opType: OpType { get }

    var index: String { get }

    var type: String { get }

    var id: String { get }
}
