//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

public enum VersionType: String {
    case `internal`
    case external
    case externalGte = "external_gte"
    case force
}

public enum IndexRefresh: String {
    case `true`
    case `false`
    case waitFor = "wait_for"
}

public enum OpType: String {
    case index
    case create
}
