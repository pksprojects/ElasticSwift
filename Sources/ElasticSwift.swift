import Foundation

typealias Host = URL


public class RestClient: ESClient {
    
    let admin: Admin
    
    init(settings: Settings) {
        self.admin = Admin(hosts: settings.hosts)
        super.init(hosts: settings.hosts)
    }
    
    convenience init() {
        self.init(settings: Settings.default)
    }
    
    func prepareIndex() -> IndexRequestBuilder {
        return IndexRequestBuilder(client: self)
    }
    
    func prepareGet() -> GetRequestBuilder {
        return GetRequestBuilder(client: self)
    }
    
    func prepareUpdate() -> UpdateRequestBuilder {
        return UpdateRequestBuilder(client: self)
    }
    
    func prepareDelete() -> DeleteRequestbuilder {
        return DeleteRequestbuilder(client: self)
    }
    
    func prepareSearch() -> SearchRequestBuilder {
        return SearchRequestBuilder(client: self)
    }
    
}


public class Settings {
    
    var hosts: [Host]
    
    private convenience init() {
        self.init(forHost: Host(string: "http://localhost:9200")!)
    }
    
    init(forHost host: Host) {
        hosts = [host]
    }
    
    init(forHost host: String) {
        hosts = [URL(string: host)!]
    }
    
    init(forHosts hosts: [Host]) {
        self.hosts = hosts
    }
    
    init(forHosts hosts: [String], withSSL enableSSL: Bool) {
        self.hosts = hosts.map({ return URL(string: $0)! })
    }
    
    static var `default`: Settings {
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


