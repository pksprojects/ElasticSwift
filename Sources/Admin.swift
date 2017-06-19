//
//  Admin.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/19/17.
//
//

import Foundation

internal class Admin: ESClient {
    
    func indices() -> IndiciesAdmin {
        return IndiciesAdmin(withClient: self)
    }
    
    func cluster() -> ClusterAdmin {
        return ClusterAdmin(withClient: self)
    }
    
}
