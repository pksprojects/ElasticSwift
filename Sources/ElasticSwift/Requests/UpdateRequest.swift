//
//  UpdateRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import ElasticSwiftCodableUtils

//MARK:- Update Request Builder

public class UpdateRequestBuilder: RequestBuilder {
    
    public typealias RequestType = UpdateRequest
    
    private var _index: String?
    private var _type: String?
    private var _id: String?
    private var _script: Script?
    private var _upsert: EncodableValue?
    private var _detectNoop: Bool?
    private var _docAsUpsert: Bool?
    private var _doc: EncodableValue?
    private var _scriptedUpsert: Bool?
    
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
    public func set(doc: EncodableValue) -> Self {
        self._doc = doc
        return self
    }
    
    @discardableResult
    public func set(upsert: EncodableValue) -> Self {
        self._upsert = upsert
        return self
    }
    
    @discardableResult
    public func set(scriptedUpsert: Bool) -> Self {
        self._scriptedUpsert = scriptedUpsert
        return self
    }
    
    @discardableResult
    public func set(docAsUpsert: Bool) -> Self {
        self._docAsUpsert = docAsUpsert
        return self
    }
    
    @discardableResult
    public func set(detectNoop: Bool) -> Self {
        self._detectNoop = detectNoop
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
    public var id: String? {
        return self._id
    }
    public var script: Script? {
        return self._script
    }
    public var upsert: EncodableValue? {
        return self._upsert
    }
    public var detectNoop: Bool? {
        return self._detectNoop
    }
    public var docAsUpsert: Bool? {
        return self._docAsUpsert
    }
    public var doc: EncodableValue? {
        return self._doc
    }
    public var scriptedUpsert: Bool? {
        return self._scriptedUpsert
    }
    
    public func build() throws -> UpdateRequest {
        return try UpdateRequest(withBuilder: self)
    }
}

//MARK:- Update Request

public struct UpdateRequest: Request, BulkableRequest {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public let index: String
    public let type: String
    public let id: String
    public let script: Script?
    public let upsert: EncodableValue?
    public let detectNoop: Bool?
    public let docAsUpsert: Bool?
    public let doc: EncodableValue?
    public let scriptedUpsert: Bool?
    
    public var version: String?
    /// only internal and force vertionType supported
    public var versionType: VersionType?
    public var refresh: IndexRefresh?
    public var retryOnConflict: Int?
    public var routing: String?
    public var parent: String?
    public var waitForActiveShards: String?
    public var ifSeqNo: Int?
    public var ifPrimaryTerm: Int?
    public var timeout: String?
    public var lang: String?
    /// A comma seperated list of fields to return in response as string
    public var fields: String?
    public var source: Bool?
    
    public init(index: String, type: String = "_doc", id: String, script: Script? = nil, upsert: EncodableValue? = nil, detectNoop: Bool? = nil, docAsUpsert: Bool? = nil, doc: EncodableValue? = nil, scriptedUpsert: Bool? = nil) {
        self.index = index
        self.type = type
        self.id = id
        self.script = script
        self.upsert = upsert
        self.detectNoop = detectNoop
        self.docAsUpsert = docAsUpsert
        self.doc = doc
        self.scriptedUpsert = scriptedUpsert
    }
    
    internal init(withBuilder builder: UpdateRequestBuilder) throws {
        
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard builder.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }
        
        guard builder.doc != nil || builder.script != nil else {
            throw RequestBuilderError.atleastOneFieldRequired(["doc", "script"])
        }
        
        self.index = builder.index!
        self.type = builder.type ?? "_doc"
        self.id = builder.id!
        self.script = builder.script
        self.upsert = builder.upsert
        self.detectNoop = builder.detectNoop
        self.docAsUpsert = builder.docAsUpsert
        self.doc = builder.doc
        self.scriptedUpsert = builder.scriptedUpsert
    }
    
    public var method: HTTPMethod {
        get {
            return .POST
        }
    }
    
    public var endPoint: String {
        get {
            return index + "/" + type + "/" + id + "/_update"
        }
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var params = [URLQueryItem]()
            if let version = self.version {
                params.append(URLQueryItem(name: QueryParams.version.rawValue, value: version))
            }
            if let versionType = self.versionType {
                params.append(URLQueryItem(name: QueryParams.versionType.rawValue, value: versionType.rawValue))
            }
            if let refresh = self.refresh {
                params.append(URLQueryItem(name: QueryParams.refresh.rawValue, value: refresh.rawValue))
            }
            if let retryOnConflict = self.retryOnConflict {
                params.append(URLQueryItem(name: QueryParams.retryOnConflict.rawValue, value: String(retryOnConflict)))
            }
            if let waitForActiveShards = self.waitForActiveShards {
                params.append(URLQueryItem(name: QueryParams.waitForActiveShards.rawValue, value: waitForActiveShards))
            }
            if let parent = self.parent {
                params.append(URLQueryItem(name: QueryParams.parent.rawValue, value: parent))
            }
            if let ifSeqNo = self.ifSeqNo {
                params.append(URLQueryItem(name: QueryParams.ifSeqNo.rawValue, value: String(ifSeqNo)))
            }
            if let ifPrimaryTerm = self.ifPrimaryTerm {
                params.append(URLQueryItem(name: QueryParams.ifPrimaryTerm.rawValue, value: String(ifPrimaryTerm)))
            }
            if let fields = self.fields {
                params.append(URLQueryItem(name: QueryParams.ifPrimaryTerm.rawValue, value: fields))
            }
            if let timeout = self.timeout {
                params.append(URLQueryItem(name: QueryParams.timeout.rawValue, value: timeout))
            }
            if let lang = self.lang {
                params.append(URLQueryItem(name: QueryParams.lang.rawValue, value: lang))
            }
            if let source = self.source {
                params.append(URLQueryItem(name: QueryParams.source.rawValue, value: String(source)))
            }
            return params
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(script: self.script, upsert: self.upsert, detectNoop: self.detectNoop, docAsUpsert: self.docAsUpsert, doc: self.doc, scriptedUpsert: self.scriptedUpsert)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            return MakeBodyError.wrapped(error)
        }
    }
    
    struct Body: Encodable {
        public let script: Script?
        public let upsert: EncodableValue?
        public let detectNoop: Bool?
        public let docAsUpsert: Bool?
        public let doc: EncodableValue?
        public let scriptedUpsert: Bool?
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(self.script, forKey: .script)
            try container.encodeIfPresent(self.upsert, forKey: .upsert)
            try container.encodeIfPresent(self.detectNoop, forKey: .detectNoop)
            try container.encodeIfPresent(self.docAsUpsert, forKey: .docAsUpsert)
            try container.encodeIfPresent(self.doc, forKey: .doc)
            try container.encodeIfPresent(self.scriptedUpsert, forKey: .scriptedUpsert)
        }
        
        private enum CodingKeys: String, CodingKey {
            case script
            case upsert
            case doc
            case detectNoop = "detect_noop"
            case docAsUpsert = "doc_as_upsert"
            case scriptedUpsert = "scripted_upsert"
        }
    }
    
    public var opType: OpType {
        return .update
    }
}

extension UpdateRequest: Equatable {
    public static func == (lhs: UpdateRequest, rhs: UpdateRequest) -> Bool {
        return lhs.index == rhs.index
            && lhs.id == rhs.id
            && lhs.type == rhs.type
            && lhs.doc == rhs.doc
            && lhs.detectNoop == rhs.detectNoop
            && lhs.docAsUpsert ==  rhs.docAsUpsert
            && lhs.fields == rhs.fields
            && lhs.headers == rhs.headers
            && lhs.ifPrimaryTerm == rhs.ifPrimaryTerm
            && lhs.ifSeqNo == rhs.ifSeqNo
            && lhs.lang == rhs.lang
            && lhs.method == rhs.method
            && lhs.parent == rhs.parent
            && lhs.queryParams == rhs.queryParams
            && lhs.refresh == rhs.refresh
            && lhs.retryOnConflict == rhs.retryOnConflict
            && lhs.routing == rhs.routing
            && lhs.script == rhs.script
            && lhs.scriptedUpsert == rhs.scriptedUpsert
            && lhs.source == rhs.source
            && lhs.timeout == rhs.timeout
            && lhs.upsert == rhs.upsert
            && lhs.version == rhs.version
            && lhs.versionType == rhs.versionType
            && lhs.waitForActiveShards == rhs.waitForActiveShards
    }
}

