import Foundation
import Logging
import NIOHTTP1
import ElasticSwiftCore
import ElasticSwiftNetworking

public typealias Host = URL


public class ElasticClient {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.RestClient")
    
    let transport: Transport
    
    private let _settings: Settings
    
    private var clusterClient: ClusterClient?
    private var indicesClient: IndicesClient?
    
    public init(settings: Settings) {
        self.transport = Transport(forHosts: settings.hosts, httpSettings: settings.httpSettings)
        self._settings = settings
        self.indicesClient = IndicesClient(withClient: self)
        self.clusterClient = ClusterClient(withClient: self)
    }
    
    public convenience init() {
        self.init(settings: Settings.default)
    }
    
    private var credentials: ClientCredential? {
        get {
            return self._settings.credentials
        }
    }
    
    private var serializer: Serializer {
        get {
            return _settings.serializer
        }
    }
    
}

extension ElasticClient {
    
    public func get<T: Codable>(_ getRequest: GetRequest, completionHandler: @escaping (_ result: Result<GetResponse<T>, Error>) -> Void) -> Void {
        return self.execute(request: getRequest, options: .default, completionHandler: completionHandler)
    }
    
    public func index<T: Codable>(_ indexRequest: IndexRequest<T>, completionHandler: @escaping (_ result: Result<IndexResponse, Error>) -> Void) -> Void {
        return self.execute(request: indexRequest, options: .default, completionHandler: completionHandler)
    }
    
    public func delete(_ deleteRequest: DeleteRequest, completionHandler: @escaping (_ result: Result<DeleteResponse, Error>) -> Void) -> Void {
        return self.execute(request: deleteRequest, options: .default, completionHandler: completionHandler)
    }
    
    public func update(_ updateRequest: UpdateRequest, completionHandler: @escaping (_ result: Result<UpdateResponse, Error>) -> Void) -> Void {
        return self.execute(request: updateRequest, options: .default, completionHandler: completionHandler)
    }
    
    public func search<T: Codable>(_ serachRequest: SearchRequest, completionHandler: @escaping (_ result: Result<SearchResponse<T>, Error>) -> Void) -> Void {
        return self.execute(request: serachRequest, options: .default, completionHandler: completionHandler)
    }
    
    public func deleteByQuery(_ deleteByQueryRequest: DeleteByQueryRequest, completionHandler: @escaping (_ result: Result<DeleteByQueryResponse, Error>) -> Void) -> Void {
        return self.execute(request: deleteByQueryRequest, options: .default, completionHandler: completionHandler)
    }
    
    public func updateByQuery(_ updateByQueryRequest: UpdateByQueryRequest, completionHandler: @escaping (_ result: Result<UpdateByQueryResponse, Error>) -> Void) -> Void {
        return self.execute(request: updateByQueryRequest, options: .default, completionHandler: completionHandler)
    }
}

extension ElasticClient {
    
    public func get<T: Codable>(_ getRequest: GetRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<GetResponse<T>, Error>) -> Void) -> Void {
        return self.execute(request: getRequest, options: options, completionHandler: completionHandler)
    }
    
    public func index<T: Codable>(_ indexRequest: IndexRequest<T>, with options: RequestOptions, completionHandler: @escaping (_ result: Result<IndexResponse, Error>) -> Void) -> Void {
        return self.execute(request: indexRequest, options: options, completionHandler: completionHandler)
    }
    
    public func delete(_ deleteRequest: DeleteRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<DeleteResponse, Error>) -> Void) -> Void {
        return self.execute(request: deleteRequest, options: options, completionHandler: completionHandler)
    }
    
    public func update(_ updateRequest: UpdateRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<UpdateResponse, Error>) -> Void) -> Void {
        return self.execute(request: updateRequest, options: options, completionHandler: completionHandler)
    }
    
    public func search<T: Codable>(_ serachRequest: SearchRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<SearchResponse<T>, Error>) -> Void) -> Void {
        return self.execute(request: serachRequest, options: options, completionHandler: completionHandler)
    }
    
    public func deleteByQuery(_ deleteByQueryRequest: DeleteByQueryRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<DeleteByQueryResponse, Error>) -> Void) -> Void {
        return self.execute(request: deleteByQueryRequest, options: options, completionHandler: completionHandler)
    }
    
    public func updateByQuery(_ updateByQueryRequest: UpdateByQueryRequest, with options: RequestOptions, completionHandler: @escaping (_ result: Result<UpdateByQueryResponse, Error>) -> Void) -> Void {
        return self.execute(request: updateByQueryRequest, options: options, completionHandler: completionHandler)
    }
    
}

extension ElasticClient {
    
    public var indices: IndicesClient {
        get {
            return self.indicesClient!
        }
    }
    
    public var cluster: ClusterClient {
        get {
            return self.clusterClient!
        }
    }
}

//MARK:- Settings

/// Elasticsearch ElasticClient Settings
public class Settings {
    
    /// elasticsearch nodes
    public let hosts: [Host]
    /// elasticsearch credentials
    public let credentials: ClientCredential?
    /// serializer to use for request/response serialization
    public let serializer: Serializer
    /// httpSettings for underlying client
    public let httpSettings: HTTPSettings
    
    public init(forHosts hosts: [Host], withCredentials credentials: ClientCredential? = nil, adaptorConfig: HTTPAdaptorConfiguration, serializer: Serializer = DefaultSerializer()) {
        self.hosts = hosts
        self.credentials = credentials
        self.httpSettings = .managed(adaptorConfig: adaptorConfig)
        self.serializer = serializer
    }
        
    public init(forHosts hosts: [Host], withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor, serializer: Serializer = DefaultSerializer()) {
        self.hosts = hosts
        self.credentials = credentials
        self.httpSettings = .independent(adaptor: clientAdaptor)
        self.serializer = serializer
    }
    
    public convenience init(forHost host: Host, withCredentials credentials: ClientCredential? = nil, adaptorConfig: HTTPAdaptorConfiguration, serializer: Serializer = DefaultSerializer()) {
        self.init(forHosts: [host], withCredentials: credentials, adaptorConfig: adaptorConfig, serializer: serializer)
    }
    
    public convenience init(forHost host: Host, withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor, serializer: Serializer = DefaultSerializer()) {
        self.init(forHosts: [host], withCredentials: credentials, adaptor: clientAdaptor, serializer: serializer)
    }
    
    public convenience init(forHost host: String, withCredentials credentials: ClientCredential? = nil, adaptorConfig: HTTPAdaptorConfiguration, serializer: Serializer = DefaultSerializer()) {
        self.init(forHosts: [URL(string: host)!], withCredentials: credentials, adaptorConfig: adaptorConfig, serializer: serializer)
    }
    
    public convenience init(forHost host: String, withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor, serializer: Serializer = DefaultSerializer()) {
        self.init(forHosts: [URL(string: host)!], withCredentials: credentials, adaptor: clientAdaptor, serializer: serializer)
    }
    
    public convenience init(forHosts hosts: [String], withCredentials credentials: ClientCredential? = nil, adaptorConfig: HTTPAdaptorConfiguration, serializer: Serializer = DefaultSerializer()) {
        self.init(forHosts: hosts.map({ return URL(string: $0)! }), withCredentials: credentials, adaptorConfig: adaptorConfig, serializer: serializer)
    }
    
    public convenience init(forHosts hosts: [String], withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor, serializer: Serializer = DefaultSerializer()) {
        self.init(forHosts: hosts.map({ return URL(string: $0)! }), withCredentials: credentials, adaptor: clientAdaptor, serializer: serializer)
    }
    
    /// default settings for ElasticClient with host
    public static func `default`(_ host: String) -> Settings {
        #if os(iOS) || os(tvOS) || os(watchOS)
          return urlSession(host)
        #else
          return swiftNIO(host)
        #endif
    }
    
    public static func swiftNIO(_ host: String) -> Settings {
        return Settings(forHost: host, adaptorConfig: HTTPClientAdaptorConfiguration.default)
    }
    
    public static func urlSession(_ host: String) -> Settings {
        return Settings(forHost: host, adaptorConfig: URLSessionAdaptorConfiguration.default)
    }
    
    /// default settings for ElasticClient for localhost/development use
    public static var `default`: Settings {
        get {
            return swiftNIO("http://localhost:9200")
        }
    }
    
}


public extension ElasticClient {
    
    final func execute<T: Request>(request: T, options: RequestOptions = .`default`, completionHandler: @escaping (_ result: Result<HTTPResponse, Error>) -> Void) -> Void {
        
        
        let httpRequestResult = createHTTPRequest(for: request, with: options)
        switch httpRequestResult {
        case .failure(let error):
            let wrappedError = RequestConverterError(message: "Unable to create HTTPRequest from \(request)", error: error, request: request)
            return completionHandler(.failure(wrappedError))
        case .success(let httpRequest):
            self.transport.performRequest(request: httpRequest, callback: completionHandler)
        }
        
    }
    
//    final func execute<T: Request>(request: T, options: RequestOptions = .`default`, converter: ResponseConverter<T.ResponseType> = ResponseConverters.defaultConverter, completionHandler: @escaping (_ result: Result<T.ResponseType, Error>) -> Void) -> Void {
//
//        self.execute(request: request, options: options, converter: converter, completionHandler: completionHandler)
//    }
    
    final func execute<T: Request, R: Codable>(request: T, options: RequestOptions = .`default`, converter: ResponseConverter<R> = ResponseConverters.defaultConverter, completionHandler: @escaping (_ result: Result<R, Error>) -> Void) -> Void {
        
        let httpRequestResult = createHTTPRequest(for: request, with: options)
        switch httpRequestResult {
        case .failure(let error):
            let wrappedError = RequestConverterError(message: "Unable to create HTTPRequest from \(request)", error: error, request: request)
            return completionHandler(.failure(wrappedError))
        case .success(let httpRequest):
            self.transport.performRequest(request: httpRequest, callback: converter(self.serializer, completionHandler))
        }
    }
    
    final func execute(request: HTTPRequest, completionHandler: @escaping (_ result: Result<HTTPResponse, Error>) -> Void) -> Void {
        return self.transport.performRequest(request: request, callback: completionHandler)
    }
    
    private func createHTTPRequest<T: Request>(for request: T, with options: RequestOptions) -> Result<HTTPRequest, Error> {
        var headers = HTTPHeaders()
        headers.add(contentsOf: defaultHeaders())
        headers.add(contentsOf: authHeader())
        headers.add(contentsOf: request.headers)
        headers.add(contentsOf: options.headers)
        
        var params = [URLQueryItem]()
        params.append(contentsOf: request.queryParams)
        params.append(contentsOf: options.queryParams)
        
        let bodyResult = request.makeBody(self.serializer)
        switch bodyResult {
        case .success(let data):
            return .success(HTTPRequest(path: request.endPoint, method: request.method, queryParams: params, headers: headers, body: data))
        case .failure(let error):
            switch error {
            case .noBodyForRequest:
                return .success(HTTPRequest(path: request.endPoint, method: request.method, queryParams: params, headers: headers, body: nil))
            default:
                return .failure(error)
            }
        }
    }
    
    private func defaultHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Accept", value: "application/json")
        headers.add(name: "Content-Type", value: "application/json; charset=utf-8")
        return headers
    }
    
    private func authHeader() -> HTTPHeaders {
        var headers = HTTPHeaders()
        if let credentials = self.credentials {
            headers.add(name:"Authorization", value: credentials.token)
        }
        return headers
    }
}


//MARK:- BasicClientCredential

public class BasicClientCredential: ClientCredential {
    
    let username: String
    let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    public var token: String {
        get {
            let token = "\(self.username):\(self.password)".data(using: .utf8)?.base64EncodedString()
            return "Basic \(token!)"
        }
    }
    
}
