//
//  Connection.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/21/17.
//
//

import Foundation
import Logging
import NIOHTTP1
import ElasticSwiftCore

// MARK:- SessionManager

/**
 Class maintaining URLSession for a Host
 */

class SessionManager: NSObject, URLSessionDelegate {

    private let logger = Logger(label: "org.pksprojects.ElasticSwift.Networking.SessionManager")
    
    private var session: URLSession?
    private let url: URL
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    private var sslConfig: SSLConfiguration?
    
    init(forHost url: URL, sslConfig: SSLConfiguration? = nil) {
        self.url = url
        super.init()
        self.sslConfig = sslConfig
        let config = URLSessionConfiguration.ephemeral
        let queue = OperationQueue()
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
    }
    #else
    init(forHost url: URL) {
        self.url = url
        super.init()
        let config = URLSessionConfiguration.ephemeral
        let queue = OperationQueue()
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: queue)
    }
    #endif
    func createReqeust(_ httpRequest: HTTPRequest) -> URLRequest {
        var components =  URLComponents()
        components.queryItems = httpRequest.queryParams
        components.path = httpRequest.path
        let url = components.url(relativeTo: self.url)
        var request = URLRequest(url: url!)
        request.httpMethod = httpRequest.method.rawValue
        request.httpBody = httpRequest.body
        for header in httpRequest.headers {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        return request
    }
    
    func execute(_ request: URLRequest, onCompletion callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> Void {
        let dataTask = self.session?.dataTask(with: request, completionHandler: callback)
        dataTask?.resume()
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
        self.session?.invalidateAndCancel()
        logger.debug("session invalidated")
    }
}


#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
// URLSession basic SSL support for apple platform
extension SessionManager {
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
}

#endif

// MARK:- Helper extension

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
public extension SecCertificate {
    
    /**
     * Loads a certificate from a DER encoded file. Wraps `SecCertificateCreateWithData`.
     *
     * - parameter file: The DER encoded file from which to load the certificate
     * - returns: A `SecCertificate` if it could be loaded, or `nil`
     */
    static func create(derEncodedFile file: String) -> SecCertificate? {
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
    var data: Data {
        return SecCertificateCopyData(self) as Data
    }
    
    /**
     * Tries to return the public key of this certificate. Wraps `SecTrustCopyPublicKey`.
     * Uses `SecTrustCreateWithCertificates` with `SecPolicyCreateBasicX509()` policy.
     *
     * - returns: the public key if possible
     */
    var publicKey: SecKey? {
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
#endif
