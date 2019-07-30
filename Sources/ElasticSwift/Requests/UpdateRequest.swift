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
    
    public typealias BuilderClosure = (UpdateRequestBuilder) -> Void
    
    var index: String?
    var type: String?
    var id: String?
    var script: Script?
    var upsert: EncodableValue?
    var detectNoop: Bool?
    var docAsUpsert: Bool?
    var doc: EncodableValue?
    var scriptedUpsert: Bool?
    
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
    public func set(id: String) -> Self {
        self.id = id
        return self
    }
    
    @discardableResult
    public func set(doc: EncodableValue) -> Self {
        self.doc = doc
        return self
    }
    
    @discardableResult
    public func set(upsert: EncodableValue) -> Self {
        self.upsert = upsert
        return self
    }
    
    @discardableResult
    public func set(scriptedUpsert: Bool) -> Self {
        self.scriptedUpsert = scriptedUpsert
        return self
    }
    
    @discardableResult
    public func set(docAsUpsert: Bool) -> Self {
        self.docAsUpsert = docAsUpsert
        return self
    }
    
    @discardableResult
    public func set(detectNoop: Bool) -> Self {
        self.detectNoop = detectNoop
        return self
    }
    
    @discardableResult
    public func set(script: Script) -> Self {
        self.script = script
        return self
    }
    
    public func build() throws -> UpdateRequest {
        guard self.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard self.id != nil else {
            throw RequestBuilderError.missingRequiredField("id")
        }
        
        guard self.doc != nil || self.script != nil else {
            throw RequestBuilderError.atleastOneFieldRequired(["doc", "script"])
        }
        
        return UpdateRequest(withBuilder: self)
    }
}

//MARK:- Update Request

public class UpdateRequest: Request, Encodable {
    
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
    
    init(withBuilder builder: UpdateRequestBuilder) {
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
        return serializer.encode(self).mapError { error -> MakeBodyError in
            return MakeBodyError.wrapped(error)
        }
    }
    
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


// MARK:- UPDATE RESPONSE

public struct UpdateResponse: Codable {
    
    public let shards: Shards
    public let index: String
    public let type: String
    public let id: String
    public let version: Int
    public let result: String
    
    
    private enum CodingKeys: String, CodingKey {
        case shards = "_shards"
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case version = "_version"
        case result
    }
}
