//
//  SpecializedQuries.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - MoreLikeThis Query

public struct MoreLikeThisQuery: Query {
    public let queryType: QueryType = QueryTypes.moreLikeThis

    public let fields: [String]?
    public let likeTexts: [String]?
    public let likeItems: [Item]?
    public let unlikeTexts: [String]?
    public let unlikeItems: [Item]?

    // term selection parameters
    public var maxQueryTerms: Int?
    public var minTermFreq: Int?

    public var minDocFreq: Int?
    public var maxDocFreq: Int?
    public var minWordLength: Int?
    public var maxWordLength: Int?
    public var stopWords: [String]?
    public var analyzer: String?

    // query formation parameters
    public var minimumShouldMatch: String?
    public var boostTerms: Decimal?
    public var include: Bool?

    // other parameters
    public var failOnUnsupportedField: Bool?

    internal init(fields: [String]? = nil, likeTexts: [String]?, likeItems: [Item]? = nil, unlikeTexts: [String]? = nil, unlikeItems: [Item]? = nil, maxQueryTerms: Int? = nil, minTermFreq: Int? = nil, minDocFreq: Int? = nil, maxDocFreq: Int? = nil, minWordLength: Int? = nil, maxWordLength: Int? = nil, stopWords: [String]? = nil, analyzer: String? = nil, minimumShouldMatch: String? = nil, boostTerms: Decimal? = nil, include: Bool? = nil, failOnUnsupportedField: Bool? = nil) {
        self.fields = fields
        self.likeTexts = likeTexts
        self.likeItems = likeItems
        self.unlikeTexts = unlikeTexts
        self.unlikeItems = unlikeItems
        self.maxQueryTerms = maxQueryTerms
        self.minTermFreq = minTermFreq
        self.minDocFreq = minDocFreq
        self.maxDocFreq = maxDocFreq
        self.minWordLength = minWordLength
        self.maxWordLength = maxWordLength
        self.stopWords = stopWords
        self.analyzer = analyzer
        self.minimumShouldMatch = minimumShouldMatch
        self.boostTerms = boostTerms
        self.include = include
        self.failOnUnsupportedField = failOnUnsupportedField
    }

    public init(_ likeTexts: [String], likeItems: [Item]? = nil, unlikeTexts: [String]? = nil, unlikeItems: [Item]? = nil, fields: [String]? = nil, maxQueryTerms: Int? = nil, minTermFreq: Int? = nil, minDocFreq: Int? = nil, maxDocFreq: Int? = nil, minWordLength: Int? = nil, maxWordLength: Int? = nil, stopWords: [String]? = nil, analyzer: String? = nil, minimumShouldMatch: String? = nil, boostTerms: Decimal? = nil, include: Bool? = nil, failOnUnsupportedField: Bool? = nil) {
        self.init(fields: fields, likeTexts: likeTexts, likeItems: likeItems, unlikeTexts: unlikeTexts, unlikeItems: unlikeItems, maxQueryTerms: maxQueryTerms, minTermFreq: minTermFreq, minDocFreq: minDocFreq, maxDocFreq: maxDocFreq, minWordLength: minWordLength, maxWordLength: maxWordLength, stopWords: stopWords, analyzer: analyzer, minimumShouldMatch: minimumShouldMatch, boostTerms: boostTerms, include: include, failOnUnsupportedField: failOnUnsupportedField)
    }

    public init(withBuilder builder: MoreLikeThisQueryBuilder) throws {
        guard (builder.likeTexts != nil && !builder.likeTexts!.isEmpty) || (builder.likeItems != nil && !builder.likeItems!.isEmpty) else {
            throw QueryBuilderError.atlestOneElementRequired("likeTexts OR likeItems")
        }

        self.init(fields: builder.fields, likeTexts: builder.likeTexts, likeItems: builder.likeItems, unlikeTexts: builder.unlikeTexts, unlikeItems: builder.unlikeItems, maxQueryTerms: builder.maxQueryTerms, minTermFreq: builder.minTermFreq, minDocFreq: builder.minDocFreq, maxDocFreq: builder.maxDocFreq, minWordLength: builder.minWordLength, maxWordLength: builder.maxWordLength, stopWords: builder.stopWords, analyzer: builder.analyzer, minimumShouldMatch: builder.minimumShouldMatch, boostTerms: builder.boostTerms, include: builder.include, failOnUnsupportedField: builder.failOnUnsupportedField)
    }
}

extension MoreLikeThisQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        fields = try nested.decodeArrayIfPresent(forKey: .fields)
        maxQueryTerms = try nested.decodeIntIfPresent(forKey: .maxQueryTerms)
        minTermFreq = try nested.decodeIntIfPresent(forKey: .minTermFreq)
        minDocFreq = try nested.decodeIntIfPresent(forKey: .minDocFreq)
        maxDocFreq = try nested.decodeIntIfPresent(forKey: .maxDocFreq)
        minWordLength = try nested.decodeIntIfPresent(forKey: .minWordLength)
        maxWordLength = try nested.decodeIntIfPresent(forKey: .maxWordLength)
        stopWords = try nested.decodeArrayIfPresent(forKey: .stopWords)
        analyzer = try nested.decodeStringIfPresent(forKey: .analyzer)
        minimumShouldMatch = try nested.decodeStringIfPresent(forKey: .minimumShouldMatch)
        boostTerms = try nested.decodeDecimalIfPresent(forKey: .boostTerms)
        include = try nested.decodeBoolIfPresent(forKey: .include)

        func decodeLikeUnlike(container: KeyedDecodingContainer<CodingKeys>, key _: CodingKeys) throws -> ([String]?, [Item]?) {
            var texts = [String]()
            var items = [Item]()
            if let likeS = try? container.decodeString(forKey: .like) {
                texts.append(likeS)
            } else if let likeI = try? container.decode(Item.self, forKey: .like) {
                items.append(likeI)
            } else {
                var likeAC = try container.nestedUnkeyedContainer(forKey: .like)

                while !likeAC.isAtEnd {
                    if let likeI = try? likeAC.decode(Item.self) {
                        items.append(likeI)
                    } else {
                        let likeT = try likeAC.decodeString()
                        texts.append(likeT)
                    }
                }
            }
            return (texts.isEmpty ? nil : texts, items.isEmpty ? nil : items)
        }

        var (x, y) = try decodeLikeUnlike(container: nested, key: .like)
        let (p, q) = try decodeLikeUnlike(container: nested, key: .unlike)

        let likeText = try nested.decodeStringIfPresent(forKey: .likeText)

        if let likeText = likeText {
            x == nil ? x = [likeText] : x?.append(likeText)
        }

        likeTexts = x
        likeItems = y
        unlikeTexts = p
        unlikeItems = q
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encodeIfPresent(fields, forKey: .fields)
        try nested.encodeIfPresent(likeTexts, forKey: .like)
        try nested.encodeIfPresent(unlikeTexts, forKey: .unlike)
        try nested.encodeIfPresent(maxQueryTerms, forKey: .maxQueryTerms)
        try nested.encodeIfPresent(minTermFreq, forKey: .minTermFreq)
        try nested.encodeIfPresent(minDocFreq, forKey: .minDocFreq)
        try nested.encodeIfPresent(maxDocFreq, forKey: .maxDocFreq)
        try nested.encodeIfPresent(minWordLength, forKey: .minWordLength)
        try nested.encodeIfPresent(maxWordLength, forKey: .maxWordLength)
        try nested.encodeIfPresent(stopWords, forKey: .stopWords)
        try nested.encodeIfPresent(analyzer, forKey: .analyzer)
        try nested.encodeIfPresent(minimumShouldMatch, forKey: .minimumShouldMatch)
        try nested.encodeIfPresent(boostTerms, forKey: .boostTerms)
        try nested.encodeIfPresent(include, forKey: .include)
        try nested.encodeIfPresent(failOnUnsupportedField, forKey: .failOnUnsupportedField)
        var like: [CodableValue] = []
        if let likeTexts = self.likeTexts {
            like.append(contentsOf: likeTexts.map { CodableValue($0) })
        }
        if let likeitems = likeItems {
            like.append(contentsOf: likeitems.map { CodableValue($0) })
        }
        if like.count == 1 {
            try nested.encode(like[0], forKey: .like)
        } else {
            try nested.encode(like, forKey: .like)
        }
        var unlike: [CodableValue] = []
        if let unlikeTexts = self.unlikeTexts {
            unlike.append(contentsOf: unlikeTexts.map { CodableValue($0) })
        }
        if let unlikeitems = unlikeItems {
            unlike.append(contentsOf: unlikeitems.map { CodableValue($0) })
        }
        if !unlike.isEmpty {
            if unlike.count == 1 {
                try nested.encode(unlike[0], forKey: .unlike)
            } else {
                try nested.encode(unlike, forKey: .unlike)
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case fields
        case like
        case unlike
        case likeText = "like_text"
        case maxQueryTerms = "max_query_terms"
        case minTermFreq = "min_term_freq"
        case minDocFreq = "min_doc_freq"
        case maxDocFreq = "max_doc_freq"
        case minWordLength = "min_word_length"
        case maxWordLength = "max_word_length"
        case stopWords = "stop_words"
        case analyzer
        case minimumShouldMatch = "minimum_should_match"
        case boostTerms = "boost_terms"
        case include
        case failOnUnsupportedField = "fail_on_unsupported_field"
    }
}

extension MoreLikeThisQuery {
    public struct Item {
        public var index: String?
        public var type: String?
        public let id: String?
        public let doc: CodableValue?
        public var fields: [String]?
        public var perFieldAnalyzer: [String: String]?
        public var routing: String?
        public var version: Int?
        public var versionType: String?

        public init(index: String? = nil, type: String? = nil, id: String?, doc: CodableValue?, fields: [String]? = nil, perFieldAnalyzer: [String: String]? = nil, routing: String? = nil, version: Int? = nil, versionType: String? = nil) {
            self.index = index
            self.type = type
            self.id = id
            self.doc = doc
            self.fields = fields
            self.perFieldAnalyzer = perFieldAnalyzer
            self.routing = routing
            self.version = version
            self.versionType = versionType
        }

        public init(id: String) {
            self.init(id: id, doc: nil)
        }

        public init(doc: CodableValue) {
            self.init(id: nil, doc: doc)
        }
    }
}

extension MoreLikeThisQuery.Item: Codable {
    enum CodingKeys: String, CodingKey {
        case index = "_index"
        case type = "_type"
        case id = "_id"
        case doc
        case fields
        case perFieldAnalyzer = "per_field_analyzer"
        case routing = "_routing"
        case version = "_version"
        case versionType = "_version_type"
    }
}

extension MoreLikeThisQuery.Item: Equatable {}

extension MoreLikeThisQuery: Equatable {
    public static func == (lhs: MoreLikeThisQuery, rhs: MoreLikeThisQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
    }
}

// MARK: - Script Query

public struct ScriptQuery: Query {
    public let queryType: QueryType = QueryTypes.script

    public let script: Script

    public init(_ script: Script) {
        self.script = script
    }

    public init(withBuilder builder: ScriptQueryBuilder) throws {
        guard let script = builder.script else {
            throw QueryBuilderError.missingRequiredField("script")
        }
        self.init(script)
    }
}

extension ScriptQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        script = try nested.decode(Script.self, forKey: .script)
    }

    public func encode(to encoder: Encoder) throws {
        var contianer = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = contianer.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(script, forKey: .script)
    }

    enum CodingKeys: String, CodingKey {
        case script
    }
}

extension ScriptQuery: Equatable {
    public static func == (lhs: ScriptQuery, rhs: ScriptQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.script == rhs.script
    }
}

// MARK: - Percolate Query

public struct PercolateQuery: Query {
    public let queryType: QueryType = QueryTypes.percolate

    public let field: String
    public let documents: [CodableValue]?
    public let index: String?
    public let type: String?
    public let id: String?
    public var routing: String?
    public var preference: String?
    public var version: Int?

    public init(_ field: String, documents: [CodableValue]) {
        self.field = field
        self.documents = documents
        index = nil
        type = nil
        id = nil
        routing = nil
        preference = nil
        version = nil
    }

    public init(_ field: String, documents: CodableValue...) {
        self.init(field, documents: documents)
    }

    public init(_ field: String, index: String, type: String, id: String, routing: String? = nil, preference: String? = nil, version: Int? = nil) {
        self.field = field
        self.index = index
        self.type = type
        self.id = id
        self.routing = routing
        self.preference = preference
        self.version = version
        documents = nil
    }

    public init(withBuilder builder: PercoloteQueryBuilder) throws {
        guard let field = builder.field else {
            throw QueryBuilderError.missingRequiredField("field")
        }

        guard let documents = builder.documents, !documents.isEmpty else {
            guard let index = builder.index, let type = builder.type, let id = builder.id else {
                throw QueryBuilderError.atleastOneFieldRequired(["documents", "index AND type AND id"])
            }

            self.init(field, index: index, type: type, id: id, routing: builder.routing, preference: builder.preference, version: builder.version)
            return
        }

        self.init(field, documents: documents)
    }
}

extension PercolateQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        field = try nested.decodeString(forKey: .field)
        if nested.allKeys.contains(.documents) || nested.allKeys.contains(.document) {
            if let documents: [CodableValue] = try? nested.decodeArray(forKey: .documents) {
                self.documents = documents
            } else if let document = try? nested.decode(CodableValue.self, forKey: .document) {
                documents = [document]
            } else {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: nested.codingPath, debugDescription: "Unable to decode documents/document in key \(nested.allKeys.count)."))
            }
            index = nil
            type = nil
            id = nil
            routing = nil
            preference = nil
            version = nil
        } else {
            documents = nil
            index = try nested.decodeString(forKey: .index)
            type = try nested.decodeString(forKey: .type)
            id = try nested.decodeString(forKey: .id)
            routing = try nested.decodeStringIfPresent(forKey: .routing)
            preference = try nested.decodeStringIfPresent(forKey: .preference)
            version = try nested.decodeIntIfPresent(forKey: .version)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(field, forKey: .field)
        if let documents = self.documents {
            if documents.count == 1 {
                try nested.encode(documents[0], forKey: .document)
            } else {
                try nested.encode(documents, forKey: .documents)
            }
            return
        } else {
            try nested.encode(index!, forKey: .index)
            try nested.encode(type!, forKey: .type)
            try nested.encode(id!, forKey: .id)
            try nested.encodeIfPresent(routing, forKey: .routing)
            try nested.encodeIfPresent(preference, forKey: .preference)
            try nested.encodeIfPresent(version, forKey: .version)
        }
    }

    enum CodingKeys: String, CodingKey {
        case field
        case document
        case documents
        case index
        case type
        case id
        case routing
        case preference
        case version
    }
}

extension PercolateQuery: Equatable {
    public static func == (lhs: PercolateQuery, rhs: PercolateQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.field == rhs.field
            && lhs.documents == rhs.documents
            && lhs.index == rhs.index
            && lhs.type == rhs.type
            && lhs.id == rhs.id
            && lhs.routing == rhs.routing
            && lhs.preference == rhs.preference
            && lhs.version == rhs.version
    }
}

// MARK: - Wrapper Query

public struct WrapperQuery: Query {
    public let queryType: QueryType = QueryTypes.wrapper

    public let query: String

    public init(_ query: String) {
        self.query = query
    }

    public init(withBuilder builder: WrapperQueryBuilder) throws {
        guard let query = builder.query else {
            throw QueryBuilderError.missingRequiredField("query")
        }
        self.init(query)
    }
}

extension WrapperQuery {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        query = try nested.decodeString(forKey: .query)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: queryType))
        try nested.encode(query, forKey: .query)
    }

    enum CodingKeys: String, CodingKey {
        case query
    }
}

extension WrapperQuery: Equatable {
    public static func == (lhs: WrapperQuery, rhs: WrapperQuery) -> Bool {
        return lhs.queryType.isEqualTo(rhs.queryType)
            && lhs.query == rhs.query
    }
}
