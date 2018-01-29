import Foundation

public typealias Host = URL


public class RestClient: ESClient {
    
    let admin: Admin
    
    init(settings: Settings) {
        self.admin = Admin(hosts: settings.hosts, credentials: settings.credentials, sslConfig: settings.sslConfig)
        super.init(hosts: settings.hosts, credentials: settings.credentials, sslConfig: settings.sslConfig)
    }
    
    public convenience init() {
        self.init(settings: Settings.default)
    }
    
    public func prepareIndex() -> IndexRequestBuilder {
        return IndexRequestBuilder(client: self)
    }
    
    public func prepareGet() -> GetRequestBuilder {
        return GetRequestBuilder(client: self)
    }
    
    public func prepareUpdate() -> UpdateRequestBuilder {
        return UpdateRequestBuilder(client: self)
    }
    
    public func prepareDelete() -> DeleteRequestbuilder {
        return DeleteRequestbuilder(client: self)
    }
    
    public func prepareSearch() -> SearchRequestBuilder {
        return SearchRequestBuilder(client: self)
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
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
}

public class SSLConfiguration {
    
    let certPath: String
    let isSelfSigned: Bool
    
    init(certPath: String, isSelf isSelfSigned: Bool) {
        self.certPath = certPath
        self.isSelfSigned = isSelfSigned
    }
}


public class ESClient {
    
    let transport: Transport
    
    init(hosts: [Host], credentials: ClientCredential? = nil, sslConfig: SSLConfiguration? = nil) {
        self.transport = Transport(forHosts: hosts, credentials: credentials, sslConfig: sslConfig)
    }
    
    func execute(request: ESRequest, completionHandler: @escaping (_ response: ESResponse) -> Void) -> Void {
        self.transport.perform_request(method: request.method, endPoint: request.endPoint, params: [], body: request.body, completionHandler: completionHandler)
    }
}


