//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

import Foundation

enum QueryParams: String {
    case format = "format"
    case h = "h"
    case help = "help"
    case local = "local"
    case masterTimeout = "master_timeout"
    case s = "s"
    case v = "v"
    case ts = "ts"
    case bytes = "bytes"
    case health = "health"
    case pri = "pri"
    case fullId = "full_id"
    case size = "size"
    case ignoreUnavailable = "ignore_unavailable"
    case actions = "actions"
    case detailed = "detailed"
    case nodeId = "node_id"
    case parentNode = "parent_node"
    case parentTask = "parent_task"
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

enum URLScheme: String {
    case HTTP = "http"
    case HTTPS = "https"
}

/**
 Helper Enum holding corresponding String value of HTTPMethods
 */
public enum HTTPMethod: String {
    case OPTIONS = "OPTIONS"
    case GET     = "GET"
    case HEAD    = "HEAD"
    case POST    = "POST"
    case PUT     = "PUT"
    case PATCH   = "PATCH"
    case DELETE  = "DELETE"
    case TRACE   = "TRACE"
    case CONNECT = "CONNECT"
}

