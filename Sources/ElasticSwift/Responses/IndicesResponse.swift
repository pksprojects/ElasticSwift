//
//  IndicesResponse.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 7/3/19.
//

import ElasticSwiftCodableUtils
import Foundation

// MARK: - Response

// MARK: - Create Index Response

/// A response for create index request
public struct CreateIndexResponse: Codable, Equatable {
    public let acknowledged: Bool
    public let shardsAcknowledged: Bool
    public let index: String

    init(acknowledged: Bool, shardsAcknowledged: Bool, index: String) {
        self.acknowledged = acknowledged
        self.shardsAcknowledged = shardsAcknowledged
        self.index = index
    }

    enum CodingKeys: String, CodingKey {
        case acknowledged
        case shardsAcknowledged = "shards_acknowledged"
        case index
    }
}

// MARK: - Get Index Response

/// A response for a get index request
public struct GetIndexResponse: Codable, Equatable {
    /// index aliases
    public let aliases: [IndexAlias]

    /// index mappings
    public let mappings: [String: MappingMetaData]

    /// index settings
    public let settings: IndexSettings

    init(aliases: [IndexAlias] = [], mappings: [String: MappingMetaData] = [:], settings: IndexSettings) {
        self.aliases = aliases
        self.mappings = mappings
        self.settings = settings
    }

    private struct CK: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue _: Int) {
            return nil
        }
    }

    private struct GI: Codable {
        public let aliases: [IndexAlias]
        public let mappings: Properties
        public let settings: Settings

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            settings = try container.decode(Settings.self, forKey: .settings)
            let dic = try container.decode([String: AliasMetaData].self, forKey: .aliases)
            aliases = dic.map { IndexAlias(name: $0, metaData: $1) }

            do {
                mappings = try container.decode(Properties.self, forKey: .mappings)
            } catch {
                let dic = try container.decode([String: Properties].self, forKey: .mappings)
                if let val = dic.values.first {
                    mappings = val
                } else {
                    mappings = Properties(properties: [:])
                }
            }
        }
    }

    private struct Properties: Codable {
        let properties: [String: MappingMetaData]
    }

    private struct Settings: Codable {
        public let index: IndexSettings
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dic = try container.decode([String: GI].self)
        let val = dic.values.first!
        aliases = val.aliases
        mappings = val.mappings.properties
        settings = val.settings.index
    }
}

/// A response for requests that support acknowledgements.
public struct AcknowledgedResponse: Codable, Equatable {
    /// acknowlegement
    public let acknowledged: Bool

    init(acknowledged: Bool) {
        self.acknowledged = acknowledged
    }
}

/// Mapping configuration for a type
public struct MappingMetaData: Codable {
    public let type: String?
    public let fields: Fields?
    public let analyzer: String?
    public let store: Bool?
    public let termVector: String?
    public var properties: [String: MappingMetaData]?

    public struct Fields: Codable, Equatable {
        public let keyword: Keyword

        public struct Keyword: Codable, Equatable {
            public let type: String
            public let ignoreAbove: Int?

            enum CodingKeys: String, CodingKey {
                case type
                case ignoreAbove = "ignore_above"
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
        case fields
        case analyzer
        case store
        case termVector = "term_vector"
        case properties
    }
}

extension MappingMetaData: Equatable {}

/// index alias meta data
public struct AliasMetaData: Codable {
    public let indexRouting: String?
    public let searchRouting: String?
    public let routing: String?
    public let filter: CodableValue?

    enum CodingKeys: String, CodingKey {
        case indexRouting = "index_routing"
        case searchRouting = "search_routing"
        case routing
        case filter
    }
}

extension AliasMetaData: Equatable {}

/// index settings
public struct IndexSettings: Codable, Equatable {
    public let creationDate: String
    public let numberOfShards: String
    public let numberOfReplicas: String
    public let uuid: String
    public let providedName: String
    public let version: IndexVersion
    public let autoExpandReplicas: String?
    public let codec: String?
    public let format: String?
    public let refreshInterval: String?
    public let mapping: CodableValue?

    init(creationDate: String, numberOfShards: String, numberOfReplicas: String, uuid: String, providedName: String, version: IndexVersion, autoExpandReplicas: String, codec: String?, format: String?, refreshInterval: String?, mapping: CodableValue?) {
        self.creationDate = creationDate
        self.numberOfShards = numberOfShards
        self.numberOfReplicas = numberOfReplicas
        self.uuid = uuid
        self.providedName = providedName
        self.version = version
        self.autoExpandReplicas = autoExpandReplicas
        self.codec = codec
        self.format = format
        self.refreshInterval = refreshInterval
        self.mapping = mapping
    }

    enum CodingKeys: String, CodingKey {
        case creationDate = "creation_date"
        case numberOfShards = "number_of_shards"
        case numberOfReplicas = "number_of_replicas"
        case uuid
        case providedName = "provided_name"
        case autoExpandReplicas = "auto_expand_replicas"
        case version
        case codec
        case format
        case refreshInterval = "refresh_interval"
        case mapping
    }
}

public struct IndexVersion: Codable, Equatable {
    public let created: String
    public let updated: String?

    init(created: String, updated: String?) {
        self.created = created
        self.updated = updated
    }
}

/// A index alias
public struct IndexAlias: Codable {
    public let name: String
    public let routing: String?
    public let indexRouting: String?
    public let searchRouting: String?
    public let filter: CodableValue?

    public init(name: String, indexRouting: String?, searchRouting: String?, routing: String?, filter: CodableValue?) {
        self.name = name
        self.indexRouting = indexRouting
        self.searchRouting = searchRouting
        self.routing = routing
        self.filter = filter
    }

    public init(name: String, metaData: AliasMetaData) {
        self.name = name
        indexRouting = metaData.indexRouting
        routing = metaData.routing
        searchRouting = metaData.searchRouting
        filter = metaData.filter
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dic = try container.decode([String: AliasMetaData].self)
        let entry = dic.first!
        self.init(name: entry.key, indexRouting: entry.value.indexRouting, searchRouting: entry.value.searchRouting, routing: entry.value.routing, filter: entry.value.filter)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try metaData.encode(to: container.superEncoder(forKey: .key(named: name)))
    }

    public var metaData: AliasMetaData {
        return AliasMetaData(indexRouting: indexRouting, searchRouting: searchRouting, routing: routing, filter: filter)
    }

    public struct CodingKeys: CodingKey {
        public var stringValue: String
        public var intValue: Int?
        public init(stringValue: String) {
            self.stringValue = stringValue
        }

        public init?(intValue: Int) {
            self.intValue = intValue
            stringValue = "\(intValue)"
        }

        static func key(named name: String) -> CodingKeys {
            return CodingKeys(stringValue: name)
        }
    }
}

extension IndexAlias: Equatable {}

// MARK: - INDEX Exists Response

/// A wrapper for response for the index exists request
public struct IndexExistsResponse: Codable, Equatable {
    public let exists: Bool

    public init(_ exists: Bool) {
        self.exists = exists
    }
}
