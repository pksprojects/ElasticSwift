//
//  UpdateRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/31/17.
//
//

import Foundation

public class UpdateRequestBuilder: ESRequestBuilder {
    
    init(client: RestClient) {
        super.init(UpdateRequest(), withClient: client)
    }
}

public class UpdateRequest: ESRequest {
    
    init() {
        super.init(method: .PUT)
    }
}
