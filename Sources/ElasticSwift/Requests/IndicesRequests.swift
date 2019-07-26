//
//  IndicesRequests.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation

// MARK: -  Builders

public class CreateIndexRequestBuilder: RequestBuilder {
    
    typealias BuilderClosure = (CreateIndexRequestBuilder) -> Void

    public typealias RequestType = CreateIndexRequest
    
    let client: ESClient
    var name: String
    var mappings : CreateIndexMappings?
    var settings : CreateIndexSettings?
    
    public var completionHandler: ((CreateIndexResponse?,Error?) -> ())?
    
    init(withClient client: ESClient, name : String) {
        self.client = client
        self.name = name
    }
    
    convenience init(withClient client: ESClient, name : String, builderClosure: BuilderClosure) {
        self.init(withClient: client, name: name)
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (CreateIndexResponse?,Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func set(mappings: CreateIndexMappings) -> Self {
        self.mappings = mappings
        return self
    }
    
    public func set(settings: CreateIndexSettings) -> Self {
        self.settings = settings
        return self
    }
    
    public func build() -> CreateIndexRequest {
        return CreateIndexRequest(withBuilder: self)
    }
    
}

public class DeleteIndexRequestBuilder: RequestBuilder {
    
    typealias BuilderClosure = (DeleteIndexRequestBuilder) -> Void

    public typealias RequestType = DeleteIndexRequest
    
    public var completionHandler: ((DeleteIndexResponse?,Error?) -> ())?
    
    let client: ESClient
    var name: String
    
    init(withClient client: ESClient, name : String) {
        self.client = client
        self.name = name
    }
    
    convenience init(withClient client: ESClient, name : String, builderClosure: BuilderClosure) {
        self.init(withClient: client, name: name)
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (DeleteIndexResponse?,Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> DeleteIndexRequest {
        return DeleteIndexRequest(withBuilder: self)
    }

}

public class GetIndexRequestBuilder: RequestBuilder {
    
    public typealias RequestType = GetIndexRequest
    
    typealias BuilderClosure = (GetIndexRequestBuilder) -> Void
    
    let client: ESClient
    var name: String
    public var completionHandler: ((GetIndexResponse?,Error?) -> ())?
    
    
    init(withClient client: ESClient, name : String) {
        self.client = client
        self.name = name
    }
    
    convenience init(withClient client: ESClient, name : String, builderClosure: BuilderClosure) {
        self.init(withClient: client, name: name)
        builderClosure(self)
    }
    
    public func set(name: String) -> Self {
        self.name = name
        return self
    }
    
    public func set(completionHandler: @escaping (GetIndexResponse?,Error?) -> Void) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func build() -> GetIndexRequest {
        return GetIndexRequest(withBuilder: self)
    }

}

public class CreateIndexRequest: Request {
    
    public typealias ResponseType = CreateIndexResponse
    
    public var completionHandler: ((CreateIndexResponse?,Error?) -> ())?
    
    public let client: ESClient
    let name: String
    let mappings : CreateIndexMappings?
    let settings : CreateIndexSettings?
    
    init(withBuilder builder: CreateIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name
        self.mappings = builder.mappings
        self.settings = builder.settings
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod = .PUT
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
    public func getBody() throws -> Data? {
        let body = CreateIndexBody(mappings: self.mappings, settings: self.settings)
        return try self.serializer.encode(body)
    }

}

public struct CreateIndexBody : Codable {
    
    public let mappings : CreateIndexMappings?
    public let settings : CreateIndexSettings?
    
    public init(mappings: CreateIndexMappings?, settings: CreateIndexSettings?) {
        self.mappings = mappings
        self.settings = settings
    }
}

public struct CreateIndexSettings : Codable {
    
    public let analysis : IndexSettingsAnalysis
    
    public init(analysis: IndexSettingsAnalysis) {
        self.analysis = analysis
    }

}

public struct IndexSettingsAnalysis : Codable {
    public let analyzer : [String:IndexSettingsAnalyzer]
    public let tokenizer : [String:IndexSettingsTokenizer]
    
    public init(analyzer: [String : IndexSettingsAnalyzer], tokenizer: [String : IndexSettingsTokenizer]) {
        self.analyzer = analyzer
        self.tokenizer = tokenizer
    }
}

public struct IndexSettingsAnalyzer : Codable {
    public let type : String
    public let stopwords : String?
    public let filter : [String]?
    public let tokenizer : String?
    
    public init(type: String, stopwords: String?, filter: [String]?, tokenizer: String?) {
        self.type = type
        self.stopwords = stopwords
        self.filter = filter
        self.tokenizer = tokenizer
    }
}

public struct IndexSettingsTokenizer : Codable {
    public let type : String
    public let pattern : String?
    
    public init(type: String, pattern: String?) {
        self.type = type
        self.pattern = pattern
    }
}

public struct CreateIndexMappings : Codable {
    public let properties : [String:IndexMappingProperty]
    
    public init(properties: [String : IndexMappingProperty]) {
        self.properties = properties
    }
}

public struct IndexMappingProperty : Codable {
    
    public let properties : [String:IndexMappingProperty]?
    public let type : FieldType?
    public let format : String?
    public let fields : [String:IndexMappingMultiField]?
    
    public init(properties: [String : IndexMappingProperty]?, type: FieldType?, format: String?, fields: [String : IndexMappingMultiField]?) {
        self.properties = properties
        self.type = type
        self.format = format
        self.fields = fields
    }
}

public enum FieldType : String, Codable {
    case text
    case keyword
    case date
    case date_nanos
    case long
    case integer
    case double
    case short
    case half_float
    case scaled_float
    case byte
    case binary
    case integer_range
    case float_range
    case long_range
    case double_range
    case date_range
    case object
    case nested
    case geo_shape
    
    case boolean
    case ip
    
    case completion
    case token_count
    case murmur3
    case annotated

}



public struct IndexMappingMultiField : Codable {
    
    public let type : FieldType
    public let ignore_above : Int?
    public let analyzer : String?
    public let fielddata : Bool?
    
    public init(type: FieldType, ignore_above: Int?, analyzer: String?, fielddata: Bool?) {
        self.type = type
        self.ignore_above = ignore_above
        self.analyzer = analyzer
        self.fielddata = fielddata
    }
}


public class GetIndexRequest: Request {
    
    public typealias ResponseType = GetIndexResponse
    
    public var completionHandler: ((GetIndexResponse?,Error?) -> ())?
    
    public let client: ESClient
    let name: String
    
    init(withBuilder builder: GetIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name
        self.completionHandler = builder.completionHandler
    }
    
    public var method: HTTPMethod = .GET
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
}

public class DeleteIndexRequest: Request {
    
    public typealias ResponseType = DeleteIndexResponse
    
    public var completionHandler: ((DeleteIndexResponse?,Error?) -> ())?
    
    public let client: ESClient
    let name: String
    
    init(withBuilder builder: DeleteIndexRequestBuilder) {
        self.client = builder.client
        self.name = builder.name
        self.completionHandler = builder.completionHandler
    }
    
   
    public var method: HTTPMethod = .DELETE
    
    public var endPoint: String {
        get {
            return self.name
        }
    }
    
}
