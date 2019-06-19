//
//  DebugExtensions.swift
//  OBCDemo
//
//  Created by Davide Ramo on 06/06/2019.
//  Copyright © 2019 Davide Ramo. All rights reserved.
//

import Foundation

extension URLSessionDataTask {
    
    func debugDescription() -> String {
        
        return "Current Request: \(String(describing: currentRequest)) Original Request: \(String(describing: originalRequest))"
    }
}

extension URLRequest {
    
    func debugDescription() -> String {
        var bodyString = ""
        if let body = self.httpBody, let string = String(bytes: body, encoding: .utf8){
            bodyString = string
        }
        
        return "Method: \(String(describing: self.httpMethod)) URL: \(String(describing: self.url)) Headers: \(String(describing: self.allHTTPHeaderFields)) Body: \(bodyString)"
    }
}
