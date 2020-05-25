//
//  SpecializedQueryBuilders.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 4/14/18.
//

import ElasticSwiftCore
import ElasticSwiftCodableUtils
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
    public func add(field: String) -> Self {
        if _fields != nil {
            _fields?.append(field)
        } else {
            return self.set(fields: [field])
        }
        return self
    }
    
    @discardableResult
    public func add(like: String) -> Self {
        if self._likeTexts == nil {
            return set(likeTexts: [like])
        }
        _likeTexts?.append(like)
        return self
    }
    
    @discardableResult
    public func add(like: MoreLikeThisQuery.Item) -> Self {
        if self._likeItems == nil {
            return set(likeItems: [like])
        }
        _likeItems?.append(like)
        return self
    }
    
    @discardableResult
    public func add(unlike: String) -> Self {
        if self._unlikeTexts == nil {
            return set(unlikeTexts: [unlike])
        }
        _unlikeTexts?.append(unlike)
        return self
    }
    
    @discardableResult
    public func add(unlike: MoreLikeThisQuery.Item) -> Self {
        if self._unlikeItems == nil {
            return set(likeItems: [unlike])
        }
        _unlikeItems?.append(unlike)
        return self
    }
    
    @discardableResult
    public func add(stopWord: String) -> Self {
        if self._stopWords == nil {
            return set(stopWords: [stopWord])
        }
        _stopWords?.append(stopWord)
        return self
    }
    
    public var fields: [String]? {
        return self._fields
    }
    public var likeTexts: [String]? {
        return self._likeTexts
    }
    public var likeItems: [MoreLikeThisQuery.Item]? {
        return self._likeItems
    }
    public var unlikeTexts: [String]? {
        return self._unlikeTexts
    }
    public var unlikeItems: [MoreLikeThisQuery.Item]? {
        return self._unlikeItems
    }
    public var maxQueryTerms: Int? {
        return self._maxQueryTerms
    }
    public var minTermFreq: Int? {
        return self._minTermFreq
    }
    public var minDocFreq: Int? {
        return self._minDocFreq
    }
    public var maxDocFreq: Int? {
        return self._maxDocFreq
    }
    public var minWordLength: Int? {
        return self._minWordLength
    }
    public var maxWordLength: Int? {
        return self._maxWordLength
    }
    public var stopWords: [String]? {
        return self._stopWords
    }
    public var analyzer: String? {
        return self._analyzer
    }
    public var minimumShouldMatch: String? {
        return self._minimumShouldMatch
    }
    public var boostTerms: Decimal? {
        return self._boostTerms
    }
    public var include: Bool? {
        return self._include
    }
    public var failOnUnsupportedField: Bool? {
        return self._failOnUnsupportedField
    }
    
    public func build() throws -> MoreLikeThisQuery {
        return try MoreLikeThisQuery(withBuilder: self)
    }
 }

// MARK: - Script Query Builder

 public class ScriptQueryBuilder: QueryBuilder {
    
    private var _script: Script?
    
    public init() {}
    
    @discardableResult
    public func set(script: Script) -> Self {
        _script = script
        return self
    }
    
    public var script: Script? {
        return self._script
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
        if self._documents == nil {
            return self.set(documents: [document])
        } else {
            _documents?.append(document)
        }
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
    
    public var field: String? {
        return self._field
    }
    public var documents: [CodableValue]? {
        return self._documents
    }
    public var index: String? {
        return self._index
    }
    public var type: String? {
        return self._type
    }
    public var id: String? {
        return self._id
    }
    public var routing: String? {
        return self._routing
    }
    public var preference: String? {
        return self._preference
    }
    public var version: Int? {
        return self._version
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
        self._query = query
        return self
    }
    
    public var query: String? {
        return self._query
    }
    
    public func build() throws -> WrapperQuery {
        return try WrapperQuery(withBuilder: self)
    }
 }
