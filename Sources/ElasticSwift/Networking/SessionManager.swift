//
//  Connection.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import Foundation

/**
 Class maintaining URLSession for a Host
 */

class SessionManager: NSObject, URLSessionDelegate {

    private var session: URLSession?
    private let url: URL
    private var request: URLRequest?
    private var dataTask: URLSessionDataTask?
    private var credentials: ClientCredential?
    private var sslConfig: SSLConfiguration?
    
    init(forHost url: URL, credentials: ClientCredential? = nil, sslConfig: SSLConfiguration? = nil) {
        self.url = url
        super.init()
        self.credentials = credentials
        self.sslConfig = sslConfig
        let config = URLSessionConfiguration.ephemeral
        var defaultHeader = defaultHeaders()
        let authHeader = authHeaders()
        defaultHeader.merge(authHeader, uniquingKeysWith: {a, b in return a})
        config.httpAdditionalHeaders = defaultHeader
        let queue = OperationQueue()
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let secTrust = challenge.protectionSpace.serverTrust {
                if sslConfig == nil {
                    return completionHandler(.cancelAuthenticationChallenge, nil)
                }
                let derCert = SecCertificate.create(derEncodedFile: (sslConfig?.certPath)!)
                guard matchCerts(trust: secTrust, certificate: derCert!) else {
                    return completionHandler(.cancelAuthenticationChallenge, nil)
                }
                let proposedCredentials = URLCredential(trust: secTrust)
                completionHandler(.useCredential, proposedCredentials)
            }
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func matchCerts(trust: SecTrust, certificate: SecCertificate) -> Bool {
        let cert = SecTrustGetCertificateAtIndex(trust, 0)
        return cert?.data == certificate.data
    }
    
    func createRequest(method: HTTPMethod) -> Self {
        var currRequest = URLRequest(url: self.url)
        currRequest.httpMethod = method.rawValue
        self.request = currRequest
        return self
    }
    
    func createRequest(method: HTTPMethod, forPath pathComponent: String, witParams: Any) -> Self {
        var currRequest = URLRequest(url: self.url.appendingPathComponent(pathComponent))
        currRequest.httpMethod = method.rawValue
        self.request = currRequest
        debugPrint("URLRequest without body created")
        return self
    }
    
    func createRequest(method: HTTPMethod, forPath pathComponent: String, witParams: Any, body: String) -> Self {
        var currRequest = URLRequest(url: self.url.appendingPathComponent(pathComponent))
        currRequest.httpMethod = method.rawValue
        currRequest.httpBody = body.data(using: .utf8)
        self.request = currRequest
        debugPrint("URLRequest with body created")
        return self
    }
    
    func createDataTask(onCompletion callback: @escaping (_ response: ESResponse) -> Void) -> Self {
        self.dataTask = self.session?.dataTask(with: self.request!) { data, response, error in
            let response = ESResponse(data: data, httpResponse: response, error: error)
            return callback(response)
        }
        
        debugPrint("Data Task Created:", self.dataTask!)
        return self
    }
    func execute() {
        self.dataTask?.resume()
        debugPrint("DataTask Resumed")
    }
    
    /**
     Closes current URLSession after finishing any outstanding tasks.
    */
    func close() {
        self.session?.finishTasksAndInvalidate()
    }
    
    /**
     Terminates current URLSession without finishing any outstanding tasks.
     */
    func forceClose() {
        self.session?.invalidateAndCancel()
    }
    
    deinit {
        debugPrint("session invalidated")
        self.session?.invalidateAndCancel()
    }
    
    func defaultHeaders() -> [String: String] {
        return ["Content-Type": "application/json; charset=UTF-8"]
    }
    
    func authHeaders() -> [String: String] {
        if let credentials = self.credentials {
            let token = "\(credentials.username):\(credentials.password)".data(using: .utf8)?.base64EncodedString()
            return ["Authorization" : "Basic \(token!)"]
        }
        return [:]
    }
}

/**
 Class maintaining pool of Connections for Host(s)
 */
class SessionPool {
    
    var pool: [URL: SessionManager]
    
    init(forHosts hosts: [Host], credentials: ClientCredential? = nil, sslConfig: SSLConfiguration? = nil) {
        self.pool = [:]
        for host in hosts {
            self.pool[host] = SessionManager(forHost: host, credentials: credentials, sslConfig: sslConfig)
        }
    }
    
    func getConnection(forHost host: Host) -> SessionManager? {
        return self.pool[host]
    }
    
    func getConnection() -> SessionManager? {
        return self.pool.first?.value
    }
    
}

public extension SecCertificate {
    
    /**
     * Loads a certificate from a DER encoded file. Wraps `SecCertificateCreateWithData`.
     *
     * - parameter file: The DER encoded file from which to load the certificate
     * - returns: A `SecCertificate` if it could be loaded, or `nil`
     */
    static public func create(derEncodedFile file: String) -> SecCertificate? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
            return nil
        }
        let cfData = CFDataCreateWithBytesNoCopy(nil, (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), data.count, kCFAllocatorNull)
        return SecCertificateCreateWithData(kCFAllocatorDefault, cfData!)
    }
    
    /**
     * Returns the data of the certificate by calling `SecCertificateCopyData`.
     *
     * - returns: the data of the certificate
     */
    public var data: Data {
        return SecCertificateCopyData(self) as Data
    }
    
    /**
     * Tries to return the public key of this certificate. Wraps `SecTrustCopyPublicKey`.
     * Uses `SecTrustCreateWithCertificates` with `SecPolicyCreateBasicX509()` policy.
     *
     * - returns: the public key if possible
     */
    public var publicKey: SecKey? {
        let policy: SecPolicy = SecPolicyCreateBasicX509()
        var uTrust: SecTrust?
        let resultCode = SecTrustCreateWithCertificates([self] as CFArray, policy, &uTrust)
        if (resultCode != errSecSuccess) {
            return nil
        }
        let trust: SecTrust = uTrust!
        return SecTrustCopyPublicKey(trust)
    }
    
}
