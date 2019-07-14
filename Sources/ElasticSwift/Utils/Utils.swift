//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

import Foundation

enum QueryParams: String {
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
    case opType = "op_type"
    case routing
    case timeout
    case ifSeqNo = "if_seq_no"
    case ifPrimaryTerm = "if_primary_term"
    case pipeline
    case includeTypeName = "include_type_name"
    case parent
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

public enum URLScheme: String {
    case HTTP = "http"
    case HTTPS = "https"
}

public enum ShapeRelation: String {
    case INTERSECTS = "intersects"
    case DISJOINT = "disjoint"
    case WITHIN = "within"
    case CONTAINS = "contains"
}

public enum RegexFlag: String {
    case INTERSECTION = "INTERSECTION"
    case COMPLEMENT = "COMPLEMENT"
    case EMPTY = "EMPTY"
    case ANYSTRING = "ANYSTRING"
    case INTERVAL = "INTERVAL"
    case NONE = "NONE"
    case ALL = "ALL"
}

public enum ScoreMode: String {
    case FIRST = "first"
    case AVG = "avg"
    case MAX = "max"
    case SUM = "sum"
    case MIN = "min"
    case MULTIPLY = "multiply"
}

public enum BoostMode: String {
    case MULTIPLY = "multiply"
    case REPLACE = "replace"
    case SUM = "sum"
    case AVG = "avg"
    case MIN = "min"
    case MAX = "max"
}

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
