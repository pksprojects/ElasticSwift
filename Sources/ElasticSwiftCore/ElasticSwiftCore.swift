//
//  utils.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/18/17.
//
//

import Foundation

public protocol Serializer {
    
    func decode<T>(data: Data) -> Result<T, DecodingError> where T: Decodable
    
    func encode<T>(_ value: T) -> Result<Data, EncodingError> where T: Encodable
    
}

public enum MakeBodyError: Error {
    
    case noBodyForRequest
    case wrapped(Error)
    
}

public class EncodingError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    public let value: Any
    public let error: Error
    
    public init(value: Any, error: Error) {
        self.value = value
        self.error = error
    }
    
    public var description: String {
        get {
            if let val = value as? CustomStringConvertible {
                return "EncodingError: Unable to encode \(val.description) with Error: \(error.localizedDescription)"
            }
            return "EncodingError: Unable to encode \(String(describing: value)) with Error: \(error.localizedDescription)"
        }
    }
    
    public var debugDescription: String {
        get {
            if let val = value as? CustomDebugStringConvertible {
                return "EncodingError: Unable to encode \(val.debugDescription) with Error: \(error.localizedDescription)"
            } else {
                return description
            }
        }
    }
    
}

public class DecodingError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    public let data: Data
    public let error: Error
    public let type: Any.Type
    
    public init(_ type: Any.Type, data: Data, error: Error) {
        self.data = data
        self.error = error
        self.type = type
    }
    
    public var description: String {
        get {
            return "DecodingError: Unable to decode \(String(describing: self.type)) from \(String(describing: self.data)) with Error: \(String(describing: self.error))"
        }
    }
    
    public var debugDescription: String {
        get {
            return "DecodingError: Unable to decode \(self.type) from \(String(reflecting: self.data)) with Error: \(String(reflecting: self.error))"
        }
    }
    
}


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
