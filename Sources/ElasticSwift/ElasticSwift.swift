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
    
    public func makeGet<T: Codable>() -> GetRequestBuilder<T> {
        return GetRequestBuilder<T>(withClient: self)
    }
    
    public func makeIndex<T: Codable>() -> IndexRequestBuilder<T> {
        return IndexRequestBuilder<T>(withClient: self)
    }
    
    public func makeDelete() -> DeleteRequestBuilder {
        return DeleteRequestBuilder(withClient: self)
    }
    
    public func makeUpdate() -> UpdateRequestBuilder {
        return UpdateRequestBuilder(withClient: self)
    }

    public func makeSearch<T: Codable>() -> SearchRequestBuilder<T> {
        return SearchRequestBuilder<T>(withClient: self)
    }
    
}

extension RestClient {
    
    public func makeGet<T: Codable>(closure: (GetRequestBuilder<T>) -> Void) -> GetRequestBuilder<T> {
        return GetRequestBuilder<T>(withClient: self, builderClosure: closure)
    }
    
    public func makeIndex<T: Codable>(closure: (IndexRequestBuilder<T>) -> Void) -> IndexRequestBuilder<T> {
        return IndexRequestBuilder<T>(withClient: self, builderClosure: closure)
    }
    
    public func makeSearch<T: Codable>(closure: (SearchRequestBuilder<T>) -> Void) -> SearchRequestBuilder<T> {
        return SearchRequestBuilder<T>(withClient: self, builderClosure: closure)
    }
    
}

extension RestClient {
    
    public func indicesAdmin() -> IndiciesAdmin {
        return admin.indices()
    }
    
    public func clusterAdmin() -> ClusterAdmin {
        return admin.cluster()
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


public class ESClient {
    
    let transport: Transport
    
    init(hosts: [Host], credentials: ClientCredential? = nil, sslConfig: SSLConfiguration? = nil) {
        self.transport = Transport(forHosts: hosts, credentials: credentials, sslConfig: sslConfig)
    }
    
    func execute(request: Request, completionHandler: @escaping (_ response: ESResponse) -> Void) -> Void {
        if request.method == .GET {
            self.transport.performRequest(method: request.method, endPoint: request.endPoint, params: [], completionHandler: completionHandler)
        } else {
            self.transport.performRequest(method: request.method, endPoint: request.endPoint, params: [], body: request.body, completionHandler: completionHandler)
        }
    }
}


