//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

import Foundation

//MARK:- Serializer Protocol

public protocol Serializer {
    
    func decode<T>(data: Data) -> Result<T, DecodingError> where T: Decodable
    
    func encode<T>(_ value: T) -> Result<Data, EncodingError> where T: Encodable
    
}

//MARK:- HTTPSettings

public enum HTTPSettings {
    
    case managed(adaptorConfig: HTTPAdaptorConfiguration)
    case independent(adaptor: HTTPClientAdaptor)
    
}

//MARK:- ClientCredential

public protocol ClientCredential {
    
    var token: String { get }
    
}

//MARK:- QueryParams enums

/// Enum QueryParams represent all the query params supported by ElasticSearch.
public enum QueryParams: String {
    case format
    case h
    case help
    case local
    case masterTimeout = "master_timeout"
    case s
    case v
    case ts
    case bytes
    case health
    case pri
    case fullId = "full_id"
    case size
    case ignoreUnavailable = "ignore_unavailable"
    case actions
    case detailed
    case nodeId = "node_id"
    case parentNode = "parent_node"
    case version
    case versionType = "version_type"
    case refresh
    case parentTask = "parent_task"
    case waitForActiveShards = "wait_for_active_shards"
    case waitForCompletion = "wait_for_completion"
    case opType = "op_type"
    case routing
    case timeout
    case ifSeqNo = "if_seq_no"
    case ifPrimaryTerm = "if_primary_term"
    case pipeline
    case includeTypeName = "include_type_name"
    case parent
    case retryOnConflict = "retry_on_conflict"
    case fields
    case lang
    case source = "_source"
    case sourceIncludes = "_source_includes"
    case sourceExcludes = "_source_excludes"
    case conflicts
    case requestsPerSecond = "requests_per_second"
    case slices
    case requestCache = "request_cache"
    case stats
    case from
    case scrollSize = "scroll_size"
}

enum EndPointCategory: String {
    case cat = "_cat"
    case cluster = "_cluster"
    case ingest = "_ingest"
    case nodes = "_nodes"
    case snapshots = "_snapshots"
    case tasks = "_tasks"
}

enum EndPointPath: String {
    case aliases = "aliases"
    case allocation = "allocation"
    case count = "count"
    case health = "health"
    case indices = "indices"
    case master = "master"
    case nodes = "nodes"
    case recovery = "recovery"
    case shards = "shards"
    case segments = "segments"
    case pendingTasks = "pending_tasks"
    case threadPool = "thread_pool"
    case fieldData = "fielddata"
    case plugins = "plugins"
    case nodeAttributes = "nodeattrs"
    case repositories = "repositories"
    case snapshots = "snapshots"
    case tasks = "tasks"
    case templates = "templates"
    case state = "state"
    case stats = "stats"
    case reroute = "reroute"
    case settings = "settings"
    case allocationExplain = "allocation/explain"
    case pipeline = "pipeline"
    case simulate = "simulate"
    case hotThreads = "hotthreads"
    case restore = "_recovery"
    case status = "_status"
    case verify = "_verify"
    case `default` = ""
}

/// Enum representing URLScheme
public enum URLScheme: String {
    case http
    case https
}
