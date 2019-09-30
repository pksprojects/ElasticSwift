//
//  TermVectorsRequest.swift
//  
//
//  Created by Prafull Kumar Soni on 9/29/19.
//

import Foundation
import ElasticSwiftCore
import NIOHTTP1
import ElasticSwiftCodableUtils

// MARK:- TermVectors Request Builder

public class TermVectorsRequestBuilder: RequestBuilder {
    
    public typealias RequestType = TermVectorsRequest
    
    private var _index: String?
    private var _type: String?
    private var _id: String?
    private var _doc: EncodableValue?
    private var _filter: TermVectorsRequest.Filter?
    private var _fields: [String]?
    private var _perFieldAnalyzer: [String: String]?
    
    private var _termStatistics: Bool?
    private var _fieldStatistics: Bool?
    private var _offsets: Bool?
    private var _positions: Bool?
    private var _payloads: Bool?
    private var _preference: String?
    private var _routing: String?
    private var _parent: String?
    private var _realtime: Bool?
    private var _version: Int?
    private var _versionType: VersionType?
    
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
    public func set(id: String) -> Self {
        self._id = id
        return self
    }
    
    @discardableResult
    public func set(doc: EncodableValue) -> Self {
        self._doc = doc
        return self
    }
    
    @discardableResult
    public func set(filter: TermVectorsRequest.Filter) -> Self {
        self._filter = filter
        return self
    }
    
    @discardableResult
    public func set(fields: [String]) -> Self {
        self._fields = fields
        return self
    }
    
    @discardableResult
    public func set(perFieldAnalyzer: [String: String]) -> Self {
        self._perFieldAnalyzer = perFieldAnalyzer
        return self
    }
    
    @discardableResult
    public func set(termStatistics: Bool) -> Self {
        self._termStatistics = termStatistics
        return self
    }
    
    @discardableResult
    public func set(fieldStatistics: Bool) -> Self {
        self._fieldStatistics = fieldStatistics
        return self
    }
    
    @discardableResult
    public func set(offsets: Bool) -> Self {
        self._offsets = offsets
        return self
    }
    
    @discardableResult
    public func set(positions: Bool) -> Self {
        self._positions = positions
        return self
    }
    
    @discardableResult
    public func set(payloads: Bool) -> Self {
        self._payloads = payloads
        return self
    }
    
    @discardableResult
    public func set(preference: String) -> Self {
        self._preference = preference
        return self
    }
    
    @discardableResult
    public func set(routing: String) -> Self {
        self._routing = routing
        return self
    }
    
    @discardableResult
    public func set(parent: String) -> Self {
        self._parent = parent
        return self
    }
    
    @discardableResult
    public func set(realtime: Bool) -> Self {
        self._realtime = realtime
        return self
    }
    
    @discardableResult
    public func set(version: Int) -> Self {
        self._version = version
        return self
    }
    
    @discardableResult
    public func set(versionType: VersionType) -> Self {
        self._versionType = versionType
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
    public var doc: EncodableValue? {
        return self._doc
    }
    public var filter: TermVectorsRequest.Filter? {
        return self._filter
    }
    public var fields: [String]? {
        return self._fields
    }
    public var perFieldAnalyzer: [String: String]? {
        return self._perFieldAnalyzer
    }
    public var termStatistics: Bool? {
        return self._termStatistics
    }
    public var fieldStatistics: Bool? {
        return self._fieldStatistics
    }
    public var offsets: Bool? {
        return self._offsets
    }
    public var positions: Bool? {
        return self._positions
    }
    public var payloads: Bool? {
        return self._payloads
    }
    public var preference: String? {
        return self._preference
    }
    public var routing: String? {
        return self._routing
    }
    public var parent: String? {
        return self._parent
    }
    public var realtime: Bool? {
        return self._realtime
    }
    public var version: Int? {
        return self._version
    }
    public var versionType: VersionType? {
        return self._versionType
    }
    
    public func build() throws -> TermVectorsRequest {
        try TermVectorsRequest(withBuilder: self)
    }
}

// MARK:- TermVectors Request

public struct TermVectorsRequest: Request {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let index: String
    public let type: String
    public let id: String?
    public let doc: EncodableValue?
    public let filter: Filter?
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
    public var realtime: Bool?
    public var version: Int?
    public var versionType: VersionType?
    
    public init(index: String, type: String = "_doc", id: String, filter: Filter? = nil, fields: [String]? = nil, perFieldAnalyzer: [String: String]? = nil) {
        self.index = index
        self.type = type
        self.id = id
        self.doc = nil
        self.filter = filter
        self.fields = fields
        self.perFieldAnalyzer = perFieldAnalyzer
    }
    
    public init(index: String, type: String = "_doc", doc: EncodableValue, filter: Filter? = nil, fields: [String]? = nil, perFieldAnalyzer: [String: String]? = nil) {
        self.index = index
        self.type = type
        self.id = nil
        self.doc = doc
        self.filter = filter
        self.fields = fields
        self.perFieldAnalyzer = perFieldAnalyzer
    }
    
    internal init(withBuilder builder: TermVectorsRequestBuilder) throws {
        
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard builder.type != nil else {
            throw RequestBuilderError.missingRequiredField("type")
        }
        
        guard builder.id != nil || builder.doc != nil else {
            throw RequestBuilderError.missingRequiredField("id or doc")
        }
        
        if let id = builder.id {
            self.init(index: builder.index!, type: builder.type!, id: id, filter: builder.filter, fields: builder.fields, perFieldAnalyzer: builder.perFieldAnalyzer)
        } else {
            self.init(index: builder.index!, type: builder.type!, doc: builder.doc!, filter: builder.filter, fields: builder.fields, perFieldAnalyzer: builder.perFieldAnalyzer)
        }
        
        self.termStatistics = builder.termStatistics
        self.fieldStatistics = builder.fieldStatistics
        self.offsets = builder.offsets
        self.positions = builder.positions
        self.payloads = builder.payloads
        self.preference = builder.preference
        self.routing = builder.routing
        self.parent = builder.parent
        self.realtime = builder.realtime
        self.version = builder.version
        self.versionType = builder.versionType
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
        get {
            var _endPoint = self.index + "/" + self.type
            if let id = self.id {
                _endPoint += "/" + id
            }
            return  _endPoint + "/_termvectors"
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        if self.doc == nil && self.filter == nil && self.fields == nil && self.perFieldAnalyzer == nil {
         return .failure(.noBodyForRequest)
        }
        let body =  Body.init(doc: self.doc, filter: self.filter, fields: self.fields, perFieldAnalyzer: self.perFieldAnalyzer)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            return .wrapped(error)
        }
    }
    
    struct Body: Encodable {
        public let doc: EncodableValue?
        public let filter: Filter?
        public let fields: [String]?
        public let perFieldAnalyzer: [String: String]?
        
        enum CodingKeys: String, CodingKey {
            case doc
            case filter
            case fields
            case perFieldAnalyzer = "per_field_analyzer"
        }
    }
    
    
    public struct Filter: Codable, Equatable {
        public let maxNumTerms: Int?
        public let minTermFreq: Int?
        public let maxTermFreq: Int?
        public let minDocFreq: Int?
        public let maxDocFreq: Int?
        public let minWordLength: Int?
        public let maxWordLength: Int?
        
        enum CodingKeys: String, CodingKey {
            case maxNumTerms = "max_num_terms"
            case minTermFreq = "min_term_freq"
            case maxTermFreq = "max_term_freq"
            case minDocFreq = "min_doc_freq"
            case maxDocFreq = "max_doc_freq"
            case minWordLength = "min_word_length"
            case maxWordLength = "max_word_length"
        }
    }
    
}

extension TermVectorsRequest: Equatable{}
