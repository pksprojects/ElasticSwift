//
//  index.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation

public class IndexRequestBuilder<T: Codable>: RequestBuilder {
    
    let client: ESClient
    var completionHandler: ((_ response: IndexResponse?, _ error: Error?) -> ())?
    var index: String?
    var type: String?
    var id: String?
    var source: T?
    var routing: String?
    var parent: String?
    var refresh: IndexRefresh?
    
    init(withClient client: ESClient) {
        self.client = client
    }
    
    public func set(index: String) -> Self {
        self.index = index
        return self
    }
    
    public func set(type: String) -> Self {
        self.type = type
        return self
    }
    
    public func set(id: String) -> Self {
        self.id = id
        return self
    }
    
    public func set(routing: String) -> Self {
        self.routing = routing
        return self
    }
    
    public func set(parent: String) -> Self {
        self.parent = parent
        return self
    }
    
    public func set(source: T) -> Self {
        self.source = source
        return self
    }
    
    public func set(refresh: IndexRefresh) -> Self {
        self.refresh = refresh
        return self
    }
    
    public func set(completionHandler: @escaping (_ response: IndexResponse?, _ error: Error?) -> ()) -> Self {
        self.completionHandler = completionHandler
        return self
    }
    
    public func make() throws -> Request {
        return try IndexRequest(withBuilder: self)
    }
    
    public func validate() throws {
        if index == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"index")
        }
        if source == nil {
            throw RequestBuilderConstants.Errors.Validation.MissingField(field:"source")
        }
    }
    
}

public class IndexRequest<T: Codable>: NSObject, Request {
    
    let client: ESClient
    let completionHandler: ((_ response: IndexResponse?, _ error: Error?) -> ())?
    public var method: HTTPMethod  {
        get {
            if self.id == nil {
                return .POST
            }
            return .PUT
        }
    }
    
    var _builtBody: Data?
    var index: String
    var type: String?
    var id: String?
    var source: T
    var routing: String?
    var parent: String?
    var refresh: IndexRefresh?
    
    
    init(withBuilder builder: IndexRequestBuilder<T>) throws {
        self.client = builder.client
        self.completionHandler = builder.completionHandler
        self.index = builder.index!
        self.source = builder.source!
        
        super.init()
        self.type = builder.type
        self.id = builder.id
        self.routing = builder.routing
        self.parent = builder.parent
        self._builtBody = try makeBody()
        self.refresh = builder.refresh
    }
    
    public var parameters: [QueryParams : String]? {
        get {
            if let refresh = self.refresh {
                var result = [QueryParams : String]()
                switch refresh {
                case .FALSE:
                    result[QueryParams.refresh] = "false"
                    break
                case .TRUE:
                    result[QueryParams.refresh] = "true"
                    break
                case .WAIT:
                    result[QueryParams.refresh] = "wait_for"
                    break
                }
                return result
            }
            return nil
        }
    }
    
    public var endPoint: String {
        get {
            var result = self.index + "/"
            
            if let type = self.type {
                result += type + "/"
            } else {
                result += "_doc/"
            }
            
            if let id = self.id {
                result += id
            }
            
            return result
        }
    }
    
    public var body: Data {
        get {
            return _builtBody!
        }
    }
    
    public func makeBody() throws -> Data {
       return try Serializers.encode(self.source)
    }
    
    public func execute() {
        self.client.execute(request: self, completionHandler: responseHandler)
    }
    
    func responseHandler(_ response: ESResponse) -> Void {
        if let error = response.error {
            completionHandler?(nil, error)
            return
        }
        
        guard let data = response.data else {
            completionHandler?(nil,nil)
            return
        }
        
        var decodingError : Error? = nil
        do {
            let decoded = try Serializers.decode(data: data) as IndexResponse
            completionHandler?(decoded, nil)
            return
        } catch {
            decodingError = error
        }
        
        do {
            let esError = try Serializers.decode(data: data) as ElasticsearchError
            completionHandler?(nil, esError)
            return
        } catch {
            let message = "Error decoding response with data: " + (String(bytes: data, encoding: .utf8) ?? "nil") + " Underlying error: " + (decodingError?.localizedDescription ?? "nil")
            let error = RequestConstants.Errors.Response.Deserialization(content: message)
            completionHandler?(nil, error)
            return
        }
        
    }
    
    public override var description: String {
        get {
            var result = "\(self.method) "
            result += self.endPoint
            result += "?" + (self.parameters?.description ?? "") + " "
            result += ((String(bytes: self.body, encoding: .utf8) ?? ""))
            return result
        }
    }
    
}
