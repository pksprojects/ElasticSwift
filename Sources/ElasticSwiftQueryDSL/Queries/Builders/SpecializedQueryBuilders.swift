//
//  SpecializedQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - MoreLikeThis Query Builder

public class MoreLikeThisQueryBuilder: QueryBuilder {
    private var _fields: [String]?
    private var _likeTexts: [String]?
    private var _likeItems: [MoreLikeThisQuery.Item]?
    private var _unlikeTexts: [String]?
    private var _unlikeItems: [MoreLikeThisQuery.Item]?
    private var _maxQueryTerms: Int?
    private var _minTermFreq: Int?
    private var _minDocFreq: Int?
    private var _maxDocFreq: Int?
    private var _minWordLength: Int?
    private var _maxWordLength: Int?
    private var _stopWords: [String]?
    private var _analyzer: String?
    private var _minimumShouldMatch: String?
    private var _boostTerms: Decimal?
    private var _include: Bool?
    private var _failOnUnsupportedField: Bool?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(fields: [String]) -> Self {
        _fields = fields
        return self
    }

    @discardableResult
    public func set(likeTexts: [String]) -> Self {
        _likeTexts = likeTexts
        return self
    }

    @discardableResult
    public func set(likeItems: [MoreLikeThisQuery.Item]) -> Self {
        _likeItems = likeItems
        return self
    }

    @discardableResult
    public func set(unlikeTexts: [String]) -> Self {
        _unlikeTexts = unlikeTexts
        return self
    }

    @discardableResult
    public func set(unlikeItems: [MoreLikeThisQuery.Item]) -> Self {
        _unlikeItems = unlikeItems
        return self
    }

    @discardableResult
    public func set(maxQueryTerms: Int) -> Self {
        _maxQueryTerms = maxQueryTerms
        return self
    }

    @discardableResult
    public func set(minTermFreq: Int) -> Self {
        _minTermFreq = minTermFreq
        return self
    }

    @discardableResult
    public func set(minDocFreq: Int) -> Self {
        _minDocFreq = minDocFreq
        return self
    }

    @discardableResult
    public func set(maxDocFreq: Int) -> Self {
        _maxDocFreq = maxDocFreq
        return self
    }

    @discardableResult
    public func set(minWordLength: Int) -> Self {
        _minWordLength = minWordLength
        return self
    }

    @discardableResult
    public func set(maxWordLength: Int) -> Self {
        _maxWordLength = maxWordLength
        return self
    }

    @discardableResult
    public func set(stopWords: [String]) -> Self {
        _stopWords = stopWords
        return self
    }

    @discardableResult
    public func set(analyzer: String) -> Self {
        _analyzer = analyzer
        return self
    }

    @discardableResult
    public func set(minimumShouldMatch: String) -> Self {
        _minimumShouldMatch = minimumShouldMatch
        return self
    }

    @discardableResult
    public func set(boostTerms: Decimal) -> Self {
        _boostTerms = boostTerms
        return self
    }

    @discardableResult
    public func set(include: Bool) -> Self {
        _include = include
        return self
    }

    @discardableResult
    public func set(failOnUnsupportedField: Bool) -> Self {
        _failOnUnsupportedField = failOnUnsupportedField
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    @discardableResult
    public func add(field: String) -> Self {
        if _fields != nil {
            _fields?.append(field)
        } else {
            return set(fields: [field])
        }
        return self
    }

    @discardableResult
    public func add(like: String) -> Self {
        if _likeTexts == nil {
            return set(likeTexts: [like])
        }
        _likeTexts?.append(like)
        return self
    }

    @discardableResult
    public func add(like: MoreLikeThisQuery.Item) -> Self {
        if _likeItems == nil {
            return set(likeItems: [like])
        }
        _likeItems?.append(like)
        return self
    }

    @discardableResult
    public func add(unlike: String) -> Self {
        if _unlikeTexts == nil {
            return set(unlikeTexts: [unlike])
        }
        _unlikeTexts?.append(unlike)
        return self
    }

    @discardableResult
    public func add(unlike: MoreLikeThisQuery.Item) -> Self {
        if _unlikeItems == nil {
            return set(likeItems: [unlike])
        }
        _unlikeItems?.append(unlike)
        return self
    }

    @discardableResult
    public func add(stopWord: String) -> Self {
        if _stopWords == nil {
            return set(stopWords: [stopWord])
        }
        _stopWords?.append(stopWord)
        return self
    }

    public var fields: [String]? {
        return _fields
    }

    public var likeTexts: [String]? {
        return _likeTexts
    }

    public var likeItems: [MoreLikeThisQuery.Item]? {
        return _likeItems
    }

    public var unlikeTexts: [String]? {
        return _unlikeTexts
    }

    public var unlikeItems: [MoreLikeThisQuery.Item]? {
        return _unlikeItems
    }

    public var maxQueryTerms: Int? {
        return _maxQueryTerms
    }

    public var minTermFreq: Int? {
        return _minTermFreq
    }

    public var minDocFreq: Int? {
        return _minDocFreq
    }

    public var maxDocFreq: Int? {
        return _maxDocFreq
    }

    public var minWordLength: Int? {
        return _minWordLength
    }

    public var maxWordLength: Int? {
        return _maxWordLength
    }

    public var stopWords: [String]? {
        return _stopWords
    }

    public var analyzer: String? {
        return _analyzer
    }

    public var minimumShouldMatch: String? {
        return _minimumShouldMatch
    }

    public var boostTerms: Decimal? {
        return _boostTerms
    }

    public var include: Bool? {
        return _include
    }

    public var failOnUnsupportedField: Bool? {
        return _failOnUnsupportedField
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> MoreLikeThisQuery {
        return try MoreLikeThisQuery(withBuilder: self)
    }
}

// MARK: - Script Query Builder

public class ScriptQueryBuilder: QueryBuilder {
    private var _script: Script?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(script: Script) -> Self {
        _script = script
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var script: Script? {
        return _script
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> ScriptQuery {
        return try ScriptQuery(withBuilder: self)
    }
}

// MARK: - Percolate Query Builder

public class PercoloteQueryBuilder: QueryBuilder {
    private var _field: String?
    private var _documents: [CodableValue]?
    private var _index: String?
    private var _type: String?
    private var _id: String?
    private var _routing: String?
    private var _preference: String?
    private var _version: Int?
    private var _boost: Decimal?
    private var _name: String?

    public init() {}

    @discardableResult
    public func set(field: String) -> Self {
        _field = field
        return self
    }

    @discardableResult
    public func set(documents: [CodableValue]) -> Self {
        _documents = documents
        return self
    }

    @discardableResult
    public func add(document: CodableValue) -> Self {
        if _documents == nil {
            return set(documents: [document])
        } else {
            _documents?.append(document)
        }
        return self
    }

    @discardableResult
    public func set(index: String) -> Self {
        _index = index
        return self
    }

    @discardableResult
    public func set(type: String) -> Self {
        _type = type
        return self
    }

    @discardableResult
    public func set(id: String) -> Self {
        _id = id
        return self
    }

    @discardableResult
    public func set(routing: String) -> Self {
        _routing = routing
        return self
    }

    @discardableResult
    public func set(preference: String) -> Self {
        _preference = preference
        return self
    }

    @discardableResult
    public func set(version: Int) -> Self {
        _version = version
        return self
    }

    @discardableResult
    public func set(boost: Decimal) -> Self {
        _boost = boost
        return self
    }

    @discardableResult
    public func set(name: String) -> Self {
        _name = name
        return self
    }

    public var field: String? {
        return _field
    }

    public var documents: [CodableValue]? {
        return _documents
    }

    public var index: String? {
        return _index
    }

    public var type: String? {
        return _type
    }

    public var id: String? {
        return _id
    }

    public var routing: String? {
        return _routing
    }

    public var preference: String? {
        return _preference
    }

    public var version: Int? {
        return _version
    }

    public var boost: Decimal? {
        return _boost
    }

    public var name: String? {
        return _name
    }

    public func build() throws -> PercolateQuery {
        return try PercolateQuery(withBuilder: self)
    }
}

// MARK: - Wrapper Query Builder

public class WrapperQueryBuilder: QueryBuilder {
    private var _query: String?

    public init() {}

    @discardableResult
    public func set(query: String) -> Self {
        _query = query
        return self
    }

    public var query: String? {
        return _query
    }

    public func build() throws -> WrapperQuery {
        return try WrapperQuery(withBuilder: self)
    }
}
