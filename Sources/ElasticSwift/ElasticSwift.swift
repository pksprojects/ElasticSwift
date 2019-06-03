import Foundation

public typealias Host = URL


public class RestClient: ESClient {
    
    let admin: Admin
    
    public init(settings: Settings) {
        self.admin = Admin(hosts: settings.hosts, credentials: settings.credentials, sslConfig: settings.sslConfig)
        super.init(hosts: settings.hosts, credentials: settings.credentials, sslConfig: settings.sslConfig)
    }
    
    public convenience init() {
        self.init(settings: Settings.default)
    }
    
    public func makeGet<T: Codable>(fromIndex index: String, id: String) -> GetRequestBuilder<T> {
        return GetRequestBuilder<T>(withClient: self, index: index, id: id)
    }
    
    public func makeIndex<T: Codable>(toIndex index: String, source: T) -> IndexRequestBuilder<T> {
        return IndexRequestBuilder<T>(withClient: self, index: index, source: source)
    }
    
    public func makeDelete(fromIndex index: String, id: String) -> DeleteRequestBuilder {
        return DeleteRequestBuilder(withClient: self, index: index, id: id)
    }
    
    public func makeUpdate<T: Codable>(toIndex index: String, id: String) -> UpdateRequestBuilder<T> {
        return UpdateRequestBuilder(withClient: self, index: index, id: id)
    }

    public func makeSearch<T: Codable>(fromIndex index: String) -> SearchRequestBuilder<T> {
        return SearchRequestBuilder<T>(withClient: self, index: index)
    }
    
    public func makeSearch<T: Codable>(fromIndices indices: String...) -> SearchRequestBuilder<T> {
        return SearchRequestBuilder<T>(withClient: self, indices: indices)
    }
    
}


public class Settings {
    
    var hosts: [Host]
    var credentials: ClientCredential?
    var sslConfig: SSLConfiguration?
    
    private convenience init(withCredentials credentials: ClientCredential? = nil) {
        self.init(forHost: Host(string: "http://localhost:9200")!)
        self.credentials = credentials
    }
    
    public init(forHost host: Host, withCredentials credentials: ClientCredential? = nil) {
        hosts = [host]
        self.credentials = credentials
    }
    
    public init(forHost host: String, withCredentials credentials: ClientCredential? = nil) {
        hosts = [URL(string: host)!]
        self.credentials = credentials
    }
    
    public init(forHosts hosts: [Host], withCredentials credentials: ClientCredential? = nil) {
        self.hosts = hosts
        self.credentials = credentials
    }
    
    public init(forHosts hosts: [String], withCredentials credentials: ClientCredential? = nil, withSSL enableSSL: Bool, sslConfig: SSLConfiguration? = nil) {
        self.hosts = hosts.map({ return URL(string: $0)! })
        self.credentials = credentials
        self.sslConfig = sslConfig
    }
    
    public static var `default`: Settings {
        get {
            return Settings()
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


public class ESClient {
    
    let transport: Transport
    
    init(hosts: [Host], credentials: ClientCredential? = nil, sslConfig: SSLConfiguration? = nil) {
        self.transport = Transport(forHosts: hosts, credentials: credentials, sslConfig: sslConfig)
    }
    
    func execute<R : Request>(request: R, completionHandler: @escaping (_ response: ESResponse) -> ()) throws {
        if request.method == .GET {
            self.transport.performRequest(method: request.method, endPoint: request.endPoint, params: request.parameters, completionHandler: completionHandler)
        } else {
            
            do {
                let body = try request.getBody()
                self.transport.performRequest(method: request.method, endPoint: request.endPoint, params: request.parameters, body: body, completionHandler: completionHandler)
            } catch {
                throw ESClientConstants.Errors.ESClientError.InvalidBody
            }
            
        }
    }
}


