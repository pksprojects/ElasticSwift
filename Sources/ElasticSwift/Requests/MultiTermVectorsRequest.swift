//
//  MultiTermVectorsRequest.swift
//  
//
//  Created by Prafull Kumar Soni on 10/2/19.
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore
import ElasticSwiftCodableUtils

// MARK:- Multi TermVectors Request Builder

public class MultiTermVectorsRequestBuilder: RequestBuilder {
    
    public typealias RequestType = MultiTermVectorsRequest
    
    private var _index: String?
    private var _type: String?
    private var _requests: [TermVectorsRequest]?
    private var _ids: [String]?
    private var _parameters: MultiTermVectorsRequest.Parameters?
    
    public init() {}
    
    @discardableResult
    public func set(index: String) -> Self {
        self._index = index
        return self
    }
    
    @discardableResult
    public func set(type: String) -> Self {
        self._type = type
        return self
    }
    
    @discardableResult
    public func set(requests: [TermVectorsRequest]) -> Self {
        self._requests = requests
        return self
    }
    
    @discardableResult
    public func add(request: TermVectorsRequest) -> Self {
        if self._requests == nil {
            self._requests = [request]
        } else {
            self._requests?.append(request)
        }
        return self
    }
    
    @discardableResult
    public func set(ids: [String]) -> Self {
        self._ids = ids
        return self
    }
    
    @discardableResult
    public func add(id: String) -> Self {
        if self._ids == nil {
            self._ids = [id]
        } else {
            self._ids?.append(id)
        }
        return self
    }
    
    @discardableResult
    public func set(parameters: MultiTermVectorsRequest.Parameters?) -> Self {
        self._parameters = parameters
        return self
    }
    
    public var index: String? {
        return self._index
    }
    
    public var type: String? {
        return self._type
    }
    
    public var requests: [TermVectorsRequest]? {
        return self._requests
    }
    
    public var ids: [String]? {
        return self._ids
    }
    
    public var parameters: MultiTermVectorsRequest.Parameters? {
        return self._parameters
    }
    
    public func build() throws -> MultiTermVectorsRequest {
        return try MultiTermVectorsRequest(withBuilder: self)
    }
}

// MARK:- Multi TermVectors Request

public struct MultiTermVectorsRequest: Request {
    public var headers: HTTPHeaders = HTTPHeaders()
    
    
    public let index: String?
    public let type: String?
    public let requests: [TermVectorsRequest]?
    public let parameters: Parameters?
    public let ids: [String]?
    
    public var termStatistics: Bool?
    public var fieldStatistics: Bool?
    public var fields: [String]?
    public var offsets: Bool?
    public var positions: Bool?
    public var payloads: Bool?
    public var preference: Bool?
    public var routing: String?
    public var parent: String?
    public var realtime: Bool?
    public var version: Int?
    public var versionType: VersionType?
    
    
    internal init(withBuilder builder: MultiTermVectorsRequestBuilder) throws {
        
        guard builder.requests != nil || builder.ids != nil else {
            throw RequestBuilderError.atleastOneFieldRequired(["id", "reqeusts"])
        }
        
        self.index = builder.index
        self.type = builder.type
        self.requests = builder.requests
        self.ids = builder.ids
        self.parameters = builder.parameters
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var params = [URLQueryItem]()
            if let termStatistics = self.termStatistics {
                params.append(URLQueryItem(name: QueryParams.termStatistics, value: termStatistics))
            }
            if let fieldStatistics = self.fieldStatistics {
                params.append(URLQueryItem(name: QueryParams.fieldStatistics, value: fieldStatistics))
            }
            if let offsets = self.offsets {
                params.append(URLQueryItem(name: QueryParams.offsets, value: offsets))
            }
            if let positions = self.positions {
                params.append(URLQueryItem(name: QueryParams.positions, value: positions))
            }
            if let payloads = self.payloads {
                params.append(URLQueryItem(name: QueryParams.payloads, value: payloads))
            }
            if let preference = self.preference {
                params.append(URLQueryItem(name: QueryParams.preference, value: preference))
            }
            if let routing = self.routing {
                params.append(URLQueryItem(name: QueryParams.routing, value: routing))
            }
            if let parent = self.parent {
                params.append(URLQueryItem(name: QueryParams.parent, value: parent))
            }
            if let realtime = self.realtime {
                params.append(URLQueryItem(name: QueryParams.realTime, value: realtime))
            }
            if let version = self.version {
                params.append(URLQueryItem(name: QueryParams.version, value: version))
            }
            if let versionType = self.versionType {
                params.append(URLQueryItem(name: QueryParams.versionType, value: versionType.rawValue))
            }
            return params
        }
    }
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var endPoint: String {
        return "_mtermvectors"
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let docs = self.requests?.map({ Doc($0) })
        let body =  Body.init(docs: docs, parameters: self.parameters, ids: self.ids)
        let result = serializer.encode(body)
        switch result {
        case .success(let data):
            print("\(String(data: data, encoding: .utf8))")
        case .failure(let error):
            print(error)
        }
        return serializer.encode(body).mapError { error -> MakeBodyError in
            return .wrapped(error)
        }
    }
    
    struct Body: Encodable, Equatable {
        public let docs: [Doc]?
        public let parameters: Parameters?
        public let ids: [String]?
    }
    
    struct Doc: Encodable, Equatable {
        
        public let index: String?
        public let type: String?
        public let id: String?
        public let doc: EncodableValue?
        public let filter: TermVectorsRequest.Filter?
        public let fields: [String]?
        public let perFieldAnalyzer: [String: String]?
        
        public var termStatistics: Bool?
        public var fieldStatistics: Bool?
        public var offsets: Bool?
        public var positions: Bool?
        public var payloads: Bool?
        public var preference: String?
        public var routing: String?
        public var parent: String?
        public var version: Int?
        public var versionType: VersionType?
        
        init(_ request: TermVectorsRequest) {
            self.index = request.index
            self.type = request.type
            self.id = request.id
            self.doc = request.doc
            self.filter = request.filter
            self.fields = request.fields
            self.perFieldAnalyzer = request.perFieldAnalyzer
            self.termStatistics = request.termStatistics
            self.fieldStatistics = request.fieldStatistics
            self.offsets = request.offsets
            self.positions = request.positions
            self.payloads = request.payloads
            self.preference = request.preference
            self.routing = request.routing
            self.parent = request.parent
            self.version = request.version
            self.versionType = request.versionType
        }
        
        enum CodingKeys: String, CodingKey {
            case index = "_index"
            case type = "_type"
            case id = "_id"
            case doc
            case filter
            case fields
            case perFieldAnalyzer = "per_field_analyzer"
            case termStatistics = "term_statistics"
            case fieldStatistics = "field_statistics"
            case offsets
            case positions
            case payloads
            case preference
            case routing
            case parent
            case version
            case versionType = "version_type"
        }
    }
    
    public struct Parameters: Codable, Equatable {
        public var termStatistics: Bool?
        public var fieldStatistics: Bool?
        public var fields: [String]?
        public var offsets: Bool?
        public var positions: Bool?
        public var payloads: Bool?
        public var preference: Bool?
        public var routing: String?
        public var parent: String?
        public var realtime: Bool?
        public var version: Int?
        public var versionType: VersionType?
        
        enum CodingKeys: String, CodingKey {
            case termStatistics = "term_statistics"
            case fieldStatistics = "field_statistics"
            case fields
            case offsets
            case positions
            case payloads
            case preference
            case routing
            case parent
            case realtime
            case version
            case versionType = "version_type"
        }
    }
    
}

extension MultiTermVectorsRequest: Equatable{}
