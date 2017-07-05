import Foundation

public typealias Host = URL


public class RestClient: ESClient {
    
    let admin: Admin
    
    init(settings: Settings) {
        self.admin = Admin(hosts: settings.hosts)
        super.init(hosts: settings.hosts)
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
    
    private convenience init() {
        self.init(forHost: Host(string: "http://localhost:9200")!)
    }
    
    public init(forHost host: Host) {
        hosts = [host]
    }
    
    public init(forHost host: String) {
        hosts = [URL(string: host)!]
    }
    
    public init(forHosts hosts: [Host]) {
        self.hosts = hosts
    }
    
    public init(forHosts hosts: [String], withSSL enableSSL: Bool) {
        self.hosts = hosts.map({ return URL(string: $0)! })
    }
    
    public static var `default`: Settings {
        get {
            return Settings()
        }
    }
    
}


public class ESClient {
    
    let transport: Transport
    
    init(hosts: [Host]) {
        self.transport = Transport(forHosts: hosts)
    }
    
    func execute(request: ESRequest, completionHandler: @escaping (_ response: ESResponse) -> Void) -> Void {
        self.transport.perform_request(method: request.method, endPoint: request.endPoint, params: [], body: request.body, completionHandler: completionHandler)
    }
}


