//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

import Foundation

// MARK: - Serializer Protocol

public protocol Serializer {
    func decode<T>(data: Data) -> Result<T, DecodingError> where T: Decodable

    func encode<T>(_ value: T) -> Result<Data, EncodingError> where T: Encodable
}

// MARK: - HTTPSettings

public enum HTTPSettings {
    case managed(adaptorConfig: HTTPAdaptorConfiguration)
    case independent(adaptor: HTTPClientAdaptor)
}

// MARK: - ClientCredential

public protocol ClientCredential {
    var token: String { get }
}

// MARK: - QueryParams enums

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
    case realTime = "realtime"
    case preference
    case storedFields = "stored_fields"
    case termStatistics = "term_statistics"
    case fieldStatistics = "field_statistics"
    case offsets
    case positions
    case payloads
    case scroll
    case restTotalHitsAsInt = "rest_total_hits_as_int"
    case searchType = "search_type"
    case ignoreThrottled = "ignore_throttled"
    case allowNoIndices = "allow_no_indices"
    case expandWildcards = "expand_wildcards"
    case minScore = "min_score"
    case q
    case analyzer
    case analyzeWildcard = "analyze_wildcard"
    case defaultOperator = "default_operator"
    case df
    case lenient
    case terminateAfter = "terminate_after"
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
    case aliases
    case allocation
    case count
    case health
    case indices
    case master
    case nodes
    case recovery
    case shards
    case segments
    case pendingTasks = "pending_tasks"
    case threadPool = "thread_pool"
    case fieldData = "fielddata"
    case plugins
    case nodeAttributes = "nodeattrs"
    case repositories
    case snapshots
    case tasks
    case templates
    case state
    case stats
    case reroute
    case settings
    case allocationExplain = "allocation/explain"
    case pipeline
    case simulate
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
