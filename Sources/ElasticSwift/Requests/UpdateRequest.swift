//
//  UpdateRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

// MARK: - Update Request Builder

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
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(doc: EncodableValue) -> Self {
        _doc = doc
        return self
    }

    @discardableResult
    public func set(upsert: EncodableValue) -> Self {
        _upsert = upsert
        return self
    }

    @discardableResult
    public func set(scriptedUpsert: Bool) -> Self {
        _scriptedUpsert = scriptedUpsert
        return self
    }

    @discardableResult
    public func set(docAsUpsert: Bool) -> Self {
        _docAsUpsert = docAsUpsert
        return self
    }

    @discardableResult
    public func set(detectNoop: Bool) -> Self {
        _detectNoop = detectNoop
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

    public var id: String? {
        return _id
    }

    public var script: Script? {
        return _script
    }

    public var upsert: EncodableValue? {
        return _upsert
    }

    public var detectNoop: Bool? {
        return _detectNoop
    }

    public var docAsUpsert: Bool? {
        return _docAsUpsert
    }

    public var doc: EncodableValue? {
        return _doc
    }

    public var scriptedUpsert: Bool? {
        return _scriptedUpsert
    }

    public func build() throws -> UpdateRequest {
        return try UpdateRequest(withBuilder: self)
    }
}

// MARK: - Update Request

public struct UpdateRequest: Request, BulkableRequest {
    public var headers = HTTPHeaders()

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

        self.init(index: builder.index!, type: builder.type ?? "_doc", id: builder.id!, script: builder.script, upsert: builder.upsert, detectNoop: builder.detectNoop, docAsUpsert: builder.docAsUpsert, doc: builder.doc, scriptedUpsert: builder.scriptedUpsert)
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        return index + "/" + type + "/" + id + "/_update"
    }

    public var queryParams: [URLQueryItem] {
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

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        let body = Body(script: script, upsert: upsert, detectNoop: detectNoop, docAsUpsert: docAsUpsert, doc: doc, scriptedUpsert: scriptedUpsert)
        return serializer.encode(body).mapError { error -> MakeBodyError in
            MakeBodyError.wrapped(error)
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
            try container.encodeIfPresent(script, forKey: .script)
            try container.encodeIfPresent(upsert, forKey: .upsert)
            try container.encodeIfPresent(detectNoop, forKey: .detectNoop)
            try container.encodeIfPresent(docAsUpsert, forKey: .docAsUpsert)
            try container.encodeIfPresent(doc, forKey: .doc)
            try container.encodeIfPresent(scriptedUpsert, forKey: .scriptedUpsert)
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
            && lhs.docAsUpsert == rhs.docAsUpsert
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
