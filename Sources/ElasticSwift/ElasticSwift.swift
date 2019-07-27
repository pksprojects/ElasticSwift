import Foundation
import Logging
import NIO
import NIOHTTP1
import NIOTLS
#if canImport(NIOSSL)
import NIOSSL
#endif

public typealias Host = URL


public class ElasticClient {

    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.RestClient")

    let transport: Transport

    private let _settings: Settings

    private var clusterClient: ClusterClient?
    private var indicesClient: IndicesClient?

    public init(settings: Settings) {
        self.transport = Transport(forHosts: settings.hosts, credentials: settings.credentials, clientAdaptor: settings.clientAdaptor, adaptorConfig: settings.adaptorConfig)
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

    public func get<T: Codable>(_ getRequest: GetRequest<T>, completionHandler: @escaping (_ result: Result<GetResponse<T>, Error>) -> Void) -> Void {
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

    public func search<T: Codable>(_ serachRequest: SearchRequest<T>, completionHandler: @escaping (_ result: Result<SearchResponse<T>, Error>) -> Void) -> Void {
        return self.execute(request: serachRequest, options: .default, completionHandler: completionHandler)
    }
}

extension ElasticClient {

    public func get<T: Codable>(_ getRequest: GetRequest<T>, with options: RequestOptions, completionHandler: @escaping (_ result: Result<GetResponse<T>, Error>) -> Void) -> Void {
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

    public func search<T: Codable>(_ serachRequest: SearchRequest<T>, with options: RequestOptions, completionHandler: @escaping (_ result: Result<SearchResponse<T>, Error>) -> Void) -> Void {
        return self.execute(request: serachRequest, options: options, completionHandler: completionHandler)
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
    /// configuration that is passed to http adaptor
    public let adaptorConfig: HTTPAdaptorConfiguration
    /// http client adaptor Type
    public let clientAdaptor: HTTPClientAdaptor.Type
    public let serializer: Serializer

    /// convenience initializer for localhost/development use
    private convenience init(forHost host: String = "http://localhost:9200",  withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self) {
        self.init(forHost: Host(string: host)!, withCredentials: credentials)
    }

    public init(forHost host: Host, withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`, serializer: Serializer = DefaultSerializer()) {
        hosts = [host]
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
        self.serializer = serializer
    }

    public init(forHost host: String, withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`, serializer: Serializer = DefaultSerializer()) {
        hosts = [URL(string: host)!]
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
        self.serializer = serializer
    }

    public init(forHosts hosts: [Host], withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`, serializer: Serializer = DefaultSerializer()) {
        self.hosts = hosts
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
        self.serializer = serializer
    }

    public init(forHosts hosts: [String], withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`, serializer: Serializer = DefaultSerializer()) {
        self.hosts = hosts.map({ return URL(string: $0)! })
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
        self.serializer = serializer
    }

    /// default settings for ElasticClient
    public static var `default`: Settings {
        get {
            #if os(iOS) || os(tvOS) || os(watchOS)
              return urlSession
            #else
              return swiftNIO
            #endif
        }
    }

    public static var swiftNIO: Settings {
        get {
            return Settings()
        }
    }

    public static var urlSession: Settings {
        get {
            return Settings(adaptor: URLSessionAdaptor.self)
        }
    }

}


public class HTTPAdaptorConfiguration {

    public let timeouts: Timeouts?

    public let eventLoopProvider: EventLoopProvider

    // ssl config for URLSession based clients
    public let sslConfig: SSLConfiguration?

    #if canImport(NIOSSL)
    // ssl config for swift-nio-ssl based clients
    public let sslcontext: NIOSSLContext?

    public init(eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS, sslConfig: SSLConfiguration? = nil, sslContext: NIOSSLContext? = nil) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
        self.sslConfig = sslConfig
        self.sslcontext = sslContext
    }

    #else

    public init(eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS, sslConfig: SSLConfiguration? = nil) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
        self.sslConfig = sslConfig
    }

    #endif

    public static var `default`: HTTPAdaptorConfiguration {
        get {
            return HTTPAdaptorConfiguration()
        }
    }

}

public class ClientCredential {

    let username: String
    let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

}

public class SSLConfiguration {

    let certPath: String
    let isSelfSigned: Bool

    public init(certPath: String, isSelf isSelfSigned: Bool) {
        self.certPath = certPath
        self.isSelfSigned = isSelfSigned
    }
}

struct ESClientConstants {
    struct Errors  {
        enum ESClientError : Error {
            case InvalidBody
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
            let token = "\(credentials.username):\(credentials.password)".data(using: .utf8)?.base64EncodedString()
            headers.add(name:"Authorization", value: "Basic \(token!)")
        }
        return headers
    }
}
