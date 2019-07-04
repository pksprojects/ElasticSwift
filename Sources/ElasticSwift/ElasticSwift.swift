import Foundation
import Logging
import NIO
import NIOHTTP1
import NIOTLS

public typealias Host = URL


public class RestClient: ESClient {
    
    private let logger = Logger(label: "org.pksprojects.ElasticSwfit.RestClient")
    
    private var clusterClient: ClusterClient?
    private var indicesClient: IndicesClient?
    
    public init(settings: Settings) {
        super.init(hosts: settings.hosts, credentials: settings.credentials, clienAdaptor: settings.clientAdaptor, adaptorConfig: settings.adaptorConfig)
        self.indicesClient = IndicesClient(withClient: self)
        self.clusterClient = ClusterClient(withClient: self)
    }
    
    public convenience init() {
        self.init(settings: Settings.default)
    }
    
    public func makeGet<T: Codable>() -> GetRequestBuilder<T> {
        return GetRequestBuilder<T>()
    }
    
    public func makeIndex<T: Codable>() -> IndexRequestBuilder<T> {
        return IndexRequestBuilder<T>()
    }
    
    public func makeDelete() -> DeleteRequestBuilder {
        return DeleteRequestBuilder()
    }
    
    public func makeUpdate() -> UpdateRequestBuilder {
        return UpdateRequestBuilder()
    }

    public func makeSearch<T: Codable>() -> SearchRequestBuilder<T> {
        return SearchRequestBuilder<T>()
    }
    
}

extension RestClient {
    
    public func makeGet<T: Codable>(closure: (GetRequestBuilder<T>) -> Void) -> GetRequestBuilder<T> {
        return GetRequestBuilder<T>(builderClosure: closure)
    }
    
    public func makeIndex<T: Codable>(closure: (IndexRequestBuilder<T>) -> Void) -> IndexRequestBuilder<T> {
        return IndexRequestBuilder<T>(builderClosure: closure)
    }
    
    public func makeSearch<T: Codable>(closure: (SearchRequestBuilder<T>) -> Void) -> SearchRequestBuilder<T> {
        return SearchRequestBuilder<T>(builderClosure: closure)
    }
    
}

extension RestClient {
    
    public func indices() -> IndicesClient {
        return self.indicesClient!
    }
    
    public func cluster() -> ClusterClient {
        return self.clusterClient!
    }
}


public class Settings {
    
    public let hosts: [Host]
    public let credentials: ClientCredential?
    public let adaptorConfig: HTTPAdaptorConfiguration
    public let clientAdaptor: HTTPClientAdaptor.Type
    
    private convenience init(forHost host: String = "http://localhost:9200",  withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self) {
        self.init(forHost: Host(string: host)!, withCredentials: credentials)
    }
    
    public init(forHost host: Host, withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`) {
        hosts = [host]
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
    }
    
    public init(forHost host: String, withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`) {
        hosts = [URL(string: host)!]
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
    }
    
    public init(forHosts hosts: [Host], withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`) {
        self.hosts = hosts
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
    }
    
    public init(forHosts hosts: [String], withCredentials credentials: ClientCredential? = nil, adaptor clientAdaptor: HTTPClientAdaptor.Type = DefaultHTTPClientAdaptor.self, adaptorConfig: HTTPAdaptorConfiguration = .`default`) {
        self.hosts = hosts.map({ return URL(string: $0)! })
        self.credentials = credentials
        self.adaptorConfig = adaptorConfig
        self.clientAdaptor = clientAdaptor
    }
    
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
    public var sslConfig: SSLConfiguration?
    
    public init(eventLoopProvider: EventLoopProvider = .create(threads: 1), timeouts: Timeouts? = Timeouts.DEFAULT_TIMEOUTS, sslConfig: SSLConfiguration? = nil) {
        self.eventLoopProvider = eventLoopProvider
        self.timeouts = timeouts
        self.sslConfig = sslConfig
    }
    
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


public class ESClient {
    
    let transport: Transport
    
    private let logger =  Logger(label: "org.pksprojects.ElasticSwift.ESClient")
    
    private var credentials: ClientCredential?
    
    init(hosts: [Host], credentials: ClientCredential? = nil, clienAdaptor: HTTPClientAdaptor.Type, adaptorConfig: HTTPAdaptorConfiguration) {
        self.transport = Transport(forHosts: hosts, credentials: credentials, clientAdaptor: clienAdaptor, adaptorConfig: adaptorConfig)
        self.credentials = credentials
    }
    
    public final func execute<T: Request>(request: T, options: RequestOptions = .`default`, completionHandler: @escaping (_ response: HTTPResponse?, _ error: Error?) -> Void) -> Void {
        
        let httpRequest = createHTTPRequest(for: request, with: options)
        
        self.transport.performRequest(request: httpRequest, callback: completionHandler)
    }
    
    
    public final func execute<T: Request>(request: T, options: RequestOptions = .`default`, completionHandler: @escaping (_ response: T.ResponseType?, _ error: Error?) -> Void) -> Void {
        
        let httpRequest = createHTTPRequest(for: request, with: options)
        
        self.transport.performRequest(request: httpRequest) { response, error in
            
            guard error == nil else {
                return completionHandler(nil, error)
            }
            if let response = response {
                var data: Data?
                if let bytes = response.body!.readBytes(length: response.body!.readableBytes) {
                    data = Data(bytes)
                }
                
                guard (!response.status.isError()) else {
                    do {
                        let decodedError: ElasticsearchError? = try Serializers.decode(data: data!)
                        if let decoded = decodedError {
                            return completionHandler(nil, decoded)
                        }
                    } catch {
                        return completionHandler(nil, error)
                    }
                    let error = UnsupportedResponseError(response: response)
                    return completionHandler(nil, error)
                }
                do {
                    let decodedResponse: T.ResponseType? = try Serializers.decode(data: data!)
                    if let decoded = decodedResponse {
                        return completionHandler(decoded, nil)
                    }
                } catch {
                    return completionHandler(nil, error)
                }
                let error = UnsupportedResponseError(response: response)
                return completionHandler(nil, error)
            }
        }
    }
    
    public final func execute(request: HTTPRequest, completionHandler: @escaping (_ response: HTTPResponse?, _ error: Error?) -> Void) -> Void {
        return self.transport.performRequest(request: request, callback: completionHandler)
    }
    
    
    private func createHTTPRequest<T: Request>(for request: T, with options: RequestOptions) -> HTTPRequest {
        var headers = HTTPHeaders()
        headers.add(contentsOf: defaultHeaders())
        headers.add(contentsOf: authHeader())
        headers.add(contentsOf: request.headers)
        headers.add(contentsOf: options.headers)
        
        var params = [URLQueryItem]()
        params.append(contentsOf: request.queryParams)
        params.append(contentsOf: options.queryParams)
        
        
        return HTTPRequest(path: request.endPoint, method: request.method, queryParams: params, headers: headers, body: request.body)
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


