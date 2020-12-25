//
//  Suggesters.swift
//
//
//  Created by Prafull Kumar Soni on 11/1/20.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

public protocol SuggestionBuilder: ElasticSwiftTypeBuilder where ElasticSwiftType: Suggestion {
    var field: String? { get }
    var text: String? { get }
    var prefix: String? { get }
    var regex: String? { get }
    var analyzer: String? { get }
    var size: Int? { get }
    var shardSize: Int? { get }

    @discardableResult
    func set(field: String) -> Self
    @discardableResult
    func set(text: String) -> Self
    @discardableResult
    func set(prefix: String) -> Self
    @discardableResult
    func set(regex: String) -> Self
    @discardableResult
    func set(analyzer: String) -> Self
    @discardableResult
    func set(size: Int) -> Self
    @discardableResult
    func set(shardSize: Int) -> Self
}

public protocol Suggestion: Codable {
    var suggestionType: SuggestionType { get }

    var field: String { get }
    var text: String? { get set }
    var prefix: String? { get set }
    var regex: String? { get set }
    var analyzer: String? { get set }
    var size: Int? { get set }
    var shardSize: Int? { get set }

    func isEqualTo(_ other: Suggestion) -> Bool
}

public extension Suggestion where Self: Equatable {
    func isEqualTo(_ other: Suggestion) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

public func isEqualSuggestions(_ lhs: Suggestion?, _ rhs: Suggestion?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    if let lhs = lhs, let rhs = rhs {
        return lhs.isEqualTo(rhs)
    }
    return false
}

public enum SuggestionType: String, Codable {
    case term
    case phrase
    case completion
}

public extension SuggestionType {
    var metaType: Suggestion.Type {
        switch self {
        case .term:
            return TermSuggestion.self
        case .phrase:
            return PhraseSuggestion.self
        case .completion:
            return CompletionSuggestion.self
        }
    }
}

public struct SuggestSource {
    public var globalText: String?
    public var suggestions: [String: Suggestion]
}

extension SuggestSource: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var sDic = [String: Suggestion]()
        for key in container.allKeys {
            if key.stringValue == CodingKeys.globalText.rawValue {
                globalText = try container.decodeStringIfPresent(forKey: .key(named: CodingKeys.globalText.rawValue))
            } else {
                let suggestion = try container.decodeSuggestion(forKey: key)
                sDic[key.stringValue] = suggestion
            }
        }
        suggestions = sDic
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encodeIfPresent(globalText, forKey: .key(named: CodingKeys.globalText.rawValue))
        for (k, v) in suggestions {
            try container.encode(v, forKey: .key(named: k))
        }
    }

    internal enum CodingKeys: String, CodingKey {
        case globalText = "text"
    }
}

extension SuggestSource: Equatable {
    public static func == (lhs: SuggestSource, rhs: SuggestSource) -> Bool {
        guard lhs.suggestions.count == rhs.suggestions.count else {
            return false
        }

        return lhs.globalText == rhs.globalText
            && lhs.suggestions.keys.allSatisfy {
                rhs.suggestions.keys.contains($0)
                    && isEqualSuggestions(lhs.suggestions[$0], rhs.suggestions[$0])
            }
    }
}

public class BaseSuggestionBuilder {
    private var _field: String?
    private var _text: String?
    private var _prefix: String?
    private var _regex: String?
    private var _analyzer: String?
    private var _size: Int?
    private var _shardSize: Int?

    fileprivate init() {}

    @discardableResult
    public func set(field: String) -> Self {
        _field = field
        return self
    }

    @discardableResult
    public func set(text: String) -> Self {
        _text = text
        return self
    }

    @discardableResult
    public func set(prefix: String) -> Self {
        _prefix = prefix
        return self
    }

    @discardableResult
    public func set(regex: String) -> Self {
        _regex = regex
        return self
    }

    @discardableResult
    public func set(analyzer: String) -> Self {
        _analyzer = analyzer
        return self
    }

    @discardableResult
    public func set(size: Int) -> Self {
        _size = size
        return self
    }

    @discardableResult
    public func set(shardSize: Int) -> Self {
        _shardSize = shardSize
        return self
    }

    public var field: String? {
        return _field
    }

    public var text: String? {
        return _text
    }

    public var prefix: String? {
        return _prefix
    }

    public var regex: String? {
        return _regex
    }

    public var analyzer: String? {
        return _analyzer
    }

    public var size: Int? {
        return _size
    }

    public var shardSize: Int? {
        return _shardSize
    }
}

public class TermSuggestionBuilder: BaseSuggestionBuilder, SuggestionBuilder {
    public typealias ElasticSwiftType = TermSuggestion

    private var _sort: TermSuggestion.SortBy?
    private var _suggestMode: SuggestMode?
    private var _accuracy: Decimal?
    private var _maxEdits: Int?
    private var _maxInspections: Int?
    private var _maxTermFreq: Decimal?
    private var _prefixLength: Int?
    private var _minWordLength: Int?
    private var _minDocFreq: Decimal?
    private var _stringDistance: TermSuggestion.StringDistance?

    override public init() {
        super.init()
    }

    @discardableResult
    public func set(sort: TermSuggestion.SortBy) -> Self {
        _sort = sort
        return self
    }

    @discardableResult
    public func set(suggestMode: SuggestMode) -> Self {
        _suggestMode = suggestMode
        return self
    }

    @discardableResult
    public func set(accuracy: Decimal) -> Self {
        _accuracy = accuracy
        return self
    }

    @discardableResult
    public func set(maxEdits: Int) -> Self {
        _maxEdits = maxEdits
        return self
    }

    @discardableResult
    public func set(maxInspections: Int) -> Self {
        _maxInspections = maxInspections
        return self
    }

    @discardableResult
    public func set(maxTermFreq: Decimal) -> Self {
        _maxTermFreq = maxTermFreq
        return self
    }

    @discardableResult
    public func set(prefixLength: Int) -> Self {
        _prefixLength = prefixLength
        return self
    }

    @discardableResult
    public func set(minWordLength: Int) -> Self {
        _minWordLength = minWordLength
        return self
    }

    @discardableResult
    public func set(minDocFreq: Decimal) -> Self {
        _minDocFreq = minDocFreq
        return self
    }

    @discardableResult
    public func set(stringDistance: TermSuggestion.StringDistance) -> Self {
        _stringDistance = stringDistance
        return self
    }

    public var sort: TermSuggestion.SortBy? {
        return _sort
    }

    public var suggestMode: SuggestMode? {
        return _suggestMode
    }

    public var accuracy: Decimal? {
        return _accuracy
    }

    public var maxEdits: Int? {
        return _maxEdits
    }

    public var maxInspections: Int? {
        return _maxInspections
    }

    public var maxTermFreq: Decimal? {
        return _maxTermFreq
    }

    public var prefixLength: Int? {
        return _prefixLength
    }

    public var minWordLength: Int? {
        return _minWordLength
    }

    public var minDocFreq: Decimal? {
        return _minDocFreq
    }

    public var stringDistance: TermSuggestion.StringDistance? {
        return _stringDistance
    }

    public func build() throws -> TermSuggestion {
        return try TermSuggestion(withBuilder: self)
    }
}

public struct TermSuggestion: Suggestion {
    public let suggestionType: SuggestionType = .term

    public var field: String

    public var text: String?

    public var prefix: String?

    public var regex: String?

    public var analyzer: String?

    public var size: Int?

    public var shardSize: Int?

    public var sort: SortBy?

    public var suggestMode: SuggestMode?

    public var accuracy: Decimal?

    public var maxEdits: Int?

    public var maxInspections: Int?

    public var maxTermFreq: Decimal?

    public var prefixLength: Int?

    public var minWordLength: Int?

    public var minDocFreq: Decimal?

    public var stringDistance: StringDistance?

    public init(field: String, text: String? = nil, prefix: String? = nil, regex: String? = nil, analyzer: String? = nil, size: Int? = nil, shardSize: Int? = nil, sort: SortBy? = nil, suggestMode: SuggestMode? = nil, accuracy: Decimal? = nil, maxEdits: Int? = nil, maxInspections: Int? = nil, maxTermFreq: Decimal? = nil, prefixLength: Int? = nil, minWordLength: Int? = nil, minDocFreq: Decimal? = nil, stringDistance: StringDistance? = nil) {
        self.field = field
        self.text = text
        self.prefix = prefix
        self.regex = regex
        self.analyzer = analyzer
        self.size = size
        self.shardSize = shardSize
        self.sort = sort
        self.suggestMode = suggestMode
        self.accuracy = accuracy
        self.maxEdits = maxEdits
        self.maxInspections = maxInspections
        self.maxTermFreq = maxTermFreq
        self.prefixLength = prefixLength
        self.minWordLength = minWordLength
        self.minDocFreq = minDocFreq
        self.stringDistance = stringDistance
    }

    internal init(withBuilder builder: TermSuggestionBuilder) throws {
        guard let field = builder.field else {
            throw SuggestionBuilderError.missingRequiredField("field")
        }

        self.init(field: field, text: builder.text, prefix: builder.prefix, regex: builder.regex, analyzer: builder.analyzer, size: builder.size, shardSize: builder.shardSize, sort: builder.sort, suggestMode: builder.suggestMode, accuracy: builder.accuracy, maxEdits: builder.maxEdits, maxInspections: builder.maxInspections, maxTermFreq: builder.maxTermFreq, prefixLength: builder.prefixLength, minWordLength: builder.minWordLength, minDocFreq: builder.minDocFreq, stringDistance: builder.stringDistance)
    }
}

public extension TermSuggestion {
    init(from decoder: Decoder) throws {
        let contianer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let namedContianer = try contianer.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: suggestionType))
        field = try namedContianer.decodeString(forKey: .field)
        text = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.text.rawValue))
        prefix = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.prefix.rawValue))
        regex = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.regex.rawValue))
        analyzer = try namedContianer.decodeStringIfPresent(forKey: .analyzer)
        size = try namedContianer.decodeIntIfPresent(forKey: .size)
        shardSize = try namedContianer.decodeIntIfPresent(forKey: .shardSize)
        sort = try namedContianer.decodeIfPresent(SortBy.self, forKey: .sort)
        suggestMode = try namedContianer.decodeIfPresent(SuggestMode.self, forKey: .suggestMode)
        accuracy = try namedContianer.decodeDecimalIfPresent(forKey: .accuracy)
        maxEdits = try namedContianer.decodeIntIfPresent(forKey: .maxEdits)
        maxInspections = try namedContianer.decodeIntIfPresent(forKey: .maxInspections)
        maxTermFreq = try namedContianer.decodeDecimalIfPresent(forKey: .maxTermFreq)
        prefixLength = try namedContianer.decodeIntIfPresent(forKey: .prefixLength)
        minWordLength = try namedContianer.decodeIntIfPresent(forKey: .minWordLength)
        minDocFreq = try namedContianer.decodeDecimalIfPresent(forKey: .minDocFreq)
        stringDistance = try namedContianer.decodeIfPresent(StringDistance.self, forKey: .stringDistance)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encodeIfPresent(text, forKey: .key(named: CodingKeys.text.rawValue))
        try container.encodeIfPresent(prefix, forKey: .key(named: CodingKeys.prefix.rawValue))
        try container.encodeIfPresent(regex, forKey: .key(named: CodingKeys.regex.rawValue))

        var namedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: suggestionType))
        try namedContainer.encode(field, forKey: .field)
        try namedContainer.encodeIfPresent(analyzer, forKey: .analyzer)
        try namedContainer.encodeIfPresent(size, forKey: .size)
        try namedContainer.encodeIfPresent(shardSize, forKey: .shardSize)
        try namedContainer.encodeIfPresent(sort, forKey: .sort)
        try namedContainer.encodeIfPresent(suggestMode, forKey: .suggestMode)
        try namedContainer.encodeIfPresent(accuracy, forKey: .accuracy)
        try namedContainer.encodeIfPresent(maxEdits, forKey: .maxEdits)
        try namedContainer.encodeIfPresent(maxInspections, forKey: .maxInspections)
        try namedContainer.encodeIfPresent(maxTermFreq, forKey: .maxTermFreq)
        try namedContainer.encodeIfPresent(prefixLength, forKey: .prefixLength)
        try namedContainer.encodeIfPresent(minWordLength, forKey: .minWordLength)
        try namedContainer.encodeIfPresent(minDocFreq, forKey: .minDocFreq)
        try namedContainer.encodeIfPresent(stringDistance, forKey: .stringDistance)
    }

    internal enum CodingKeys: String, CodingKey {
        case field
        case text
        case prefix
        case regex
        case analyzer
        case size
        case shardSize = "shard_size"
        case sort
        case suggestMode = "suggest_mode"
        case accuracy
        case maxEdits = "max_edits"
        case maxInspections = "max_inspections"
        case maxTermFreq = "max_term_freq"
        case prefixLength = "prefix_length"
        case minWordLength = "min_word_length"
        case minDocFreq = "min_doc_freq"
        case stringDistance = "string_distance"
    }
}

public extension TermSuggestion {
    enum SortBy: String, Codable {
        case score
        case frequency
    }

    enum StringDistance: String, Codable {
        case `internal`
        case damerauLevenshtein = "damerau_levenshtein"
        case levenshtein
        case jaroWinkler = "jaro_winkler"
        case ngram
    }
}

extension TermSuggestion: Equatable {}

public enum SuggestMode: String, Codable {
    case missing
    case popular
    case always
}

public enum SuggestionBuilderError: Error {
    case missingRequiredField(String)
}

public class PhraseSuggestionBuilder: BaseSuggestionBuilder, SuggestionBuilder {
    public typealias ElasticSwiftType = PhraseSuggestion

    private var _maxErrors: Decimal?
    private var _separator: String?
    private var _realWordErrorLikelihood: Decimal?
    private var _confidence: Decimal?
    private var _gramSize: Int?
    private var _forceUnigrams: Bool?
    private var _tokenLimit: Int?
    private var _highlight: PhraseSuggestion.Highlight?
    private var _collate: PhraseSuggestion.Collate?
    private var _smoothing: SmoothingModel?
    private var _directGenerators: [PhraseSuggestion.DirectCandidateGenerator]?

    override public init() {
        super.init()
    }

    @discardableResult
    public func set(maxErrors: Decimal) -> Self {
        _maxErrors = maxErrors
        return self
    }

    @discardableResult
    public func set(separator: String) -> Self {
        _separator = separator
        return self
    }

    @discardableResult
    public func set(realWordErrorLikelihood: Decimal) -> Self {
        _realWordErrorLikelihood = realWordErrorLikelihood
        return self
    }

    @discardableResult
    public func set(confidence: Decimal) -> Self {
        _confidence = confidence
        return self
    }

    @discardableResult
    public func set(gramSize: Int) -> Self {
        _gramSize = gramSize
        return self
    }

    @discardableResult
    public func set(forceUnigrams: Bool) -> Self {
        _forceUnigrams = forceUnigrams
        return self
    }

    @discardableResult
    public func set(tokenLimit: Int) -> Self {
        _tokenLimit = tokenLimit
        return self
    }

    @discardableResult
    public func set(highlight: PhraseSuggestion.Highlight) -> Self {
        _highlight = highlight
        return self
    }

    @discardableResult
    public func set(collate: PhraseSuggestion.Collate) -> Self {
        _collate = collate
        return self
    }

    @discardableResult
    public func set(smoothing: SmoothingModel) -> Self {
        _smoothing = smoothing
        return self
    }

    @discardableResult
    public func set(directGenerators: [PhraseSuggestion.DirectCandidateGenerator]) -> Self {
        _directGenerators = directGenerators
        return self
    }

    @discardableResult
    public func add(directGenerator: PhraseSuggestion.DirectCandidateGenerator) -> Self {
        if _directGenerators != nil {
            _directGenerators?.append(directGenerator)
        } else {
            _directGenerators = [directGenerator]
        }
        return self
    }

    public var maxErrors: Decimal? {
        return _maxErrors
    }

    public var separator: String? {
        return _separator
    }

    public var realWordErrorLikelihood: Decimal? {
        return _realWordErrorLikelihood
    }

    public var confidence: Decimal? {
        return _confidence
    }

    public var gramSize: Int? {
        return _gramSize
    }

    public var forceUnigrams: Bool? {
        return _forceUnigrams
    }

    public var tokenLimit: Int? {
        return _tokenLimit
    }

    public var highlight: PhraseSuggestion.Highlight? {
        return _highlight
    }

    public var collate: PhraseSuggestion.Collate? {
        return _collate
    }

    public var smoothing: SmoothingModel? {
        return _smoothing
    }

    public var directGenerators: [PhraseSuggestion.DirectCandidateGenerator]? {
        return _directGenerators
    }

    public func build() throws -> PhraseSuggestion {
        return try PhraseSuggestion(withBuilder: self)
    }
}

public struct PhraseSuggestion: Suggestion {
    public let suggestionType: SuggestionType = .phrase

    public var field: String
    public var text: String?
    public var prefix: String?
    public var regex: String?
    public var analyzer: String?
    public var size: Int?
    public var shardSize: Int?

    public var maxErrors: Decimal?
    public var separator: String?
    public var realWordErrorLikelihood: Decimal?
    public var confidence: Decimal?
    public var gramSize: Int?
    public var forceUnigrams: Bool?
    public var tokenLimit: Int?
    public var highlight: Highlight?
    public var collate: Collate?
    public var smoothing: SmoothingModel?
    public var directGenerators: [DirectCandidateGenerator]?

    public init(field: String, text: String? = nil, prefix: String? = nil, regex: String? = nil, analyzer: String? = nil, size: Int? = nil, shardSize: Int? = nil, maxErrors: Decimal? = nil, separator: String? = nil, realWordErrorLikelihood: Decimal? = nil, confidence: Decimal? = nil, gramSize: Int? = nil, forceUnigrams: Bool? = nil, tokenLimit: Int? = nil, highlight: PhraseSuggestion.Highlight? = nil, collate: Collate? = nil, smoothing: SmoothingModel? = nil, directGenerators: [DirectCandidateGenerator]? = nil) {
        self.field = field
        self.text = text
        self.prefix = prefix
        self.regex = regex
        self.analyzer = analyzer
        self.size = size
        self.shardSize = shardSize
        self.maxErrors = maxErrors
        self.separator = separator
        self.realWordErrorLikelihood = realWordErrorLikelihood
        self.confidence = confidence
        self.gramSize = gramSize
        self.forceUnigrams = forceUnigrams
        self.tokenLimit = tokenLimit
        self.highlight = highlight
        self.collate = collate
        self.smoothing = smoothing
        self.directGenerators = directGenerators
    }

    internal init(withBuilder builder: PhraseSuggestionBuilder) throws {
        guard let field = builder.field else {
            throw SuggestionBuilderError.missingRequiredField("field")
        }
        self.init(field: field, text: builder.text, prefix: builder.prefix, regex: builder.regex, analyzer: builder.analyzer, size: builder.size, shardSize: builder.shardSize, maxErrors: builder.maxErrors, separator: builder.separator, realWordErrorLikelihood: builder.realWordErrorLikelihood, confidence: builder.confidence, gramSize: builder.gramSize, forceUnigrams: builder.forceUnigrams, tokenLimit: builder.tokenLimit, highlight: builder.highlight, collate: builder.collate, smoothing: builder.smoothing, directGenerators: builder.directGenerators)
    }
}

public extension PhraseSuggestion {
    init(from decoder: Decoder) throws {
        let contianer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let namedContianer = try contianer.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: suggestionType))
        field = try namedContianer.decodeString(forKey: .field)
        text = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.text.rawValue))
        prefix = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.prefix.rawValue))
        regex = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.regex.rawValue))
        analyzer = try namedContianer.decodeStringIfPresent(forKey: .analyzer)
        size = try namedContianer.decodeIntIfPresent(forKey: .size)
        shardSize = try namedContianer.decodeIntIfPresent(forKey: .shardSize)

        maxErrors = try namedContianer.decodeDecimalIfPresent(forKey: .maxErrors)
        separator = try namedContianer.decodeStringIfPresent(forKey: .separator)
        realWordErrorLikelihood = try namedContianer.decodeDecimalIfPresent(forKey: .realWordErrorLikelihood)
        confidence = try namedContianer.decodeDecimalIfPresent(forKey: .confidence)
        gramSize = try namedContianer.decodeIntIfPresent(forKey: .gramSize)
        forceUnigrams = try namedContianer.decodeBoolIfPresent(forKey: .forceUnigrams)
        tokenLimit = try namedContianer.decodeIntIfPresent(forKey: .tokenLimit)
        highlight = try namedContianer.decodeIfPresent(PhraseSuggestion.Highlight.self, forKey: .highlight)
        collate = try namedContianer.decodeIfPresent(PhraseSuggestion.Collate.self, forKey: .collate)
        smoothing = try namedContianer.decodeSmoothingModelIfPresent(forKey: .smoothing)
        directGenerators = try namedContianer.decodeIfPresent([DirectCandidateGenerator].self, forKey: .directGenerator)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encodeIfPresent(text, forKey: .key(named: CodingKeys.text.rawValue))
        try container.encodeIfPresent(prefix, forKey: .key(named: CodingKeys.prefix.rawValue))
        try container.encodeIfPresent(regex, forKey: .key(named: CodingKeys.regex.rawValue))

        var namedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: suggestionType))
        try namedContainer.encode(field, forKey: .field)
        try namedContainer.encodeIfPresent(analyzer, forKey: .analyzer)
        try namedContainer.encodeIfPresent(size, forKey: .size)
        try namedContainer.encodeIfPresent(shardSize, forKey: .shardSize)

        try namedContainer.encodeIfPresent(confidence, forKey: .confidence)
        try namedContainer.encodeIfPresent(collate, forKey: .collate)
        try namedContainer.encodeIfPresent(highlight, forKey: .highlight)
        try namedContainer.encodeIfPresent(maxErrors, forKey: .maxErrors)
        try namedContainer.encodeIfPresent(separator, forKey: .separator)
        try namedContainer.encodeIfPresent(gramSize, forKey: .gramSize)
        try namedContainer.encodeIfPresent(forceUnigrams, forKey: .forceUnigrams)
        try namedContainer.encodeIfPresent(tokenLimit, forKey: .tokenLimit)
        try namedContainer.encodeIfPresent(realWordErrorLikelihood, forKey: .realWordErrorLikelihood)
        try namedContainer.encodeIfPresent(smoothing, forKey: .smoothing)
        if let directGenerators = self.directGenerators, directGenerators.count > 0 {
            try namedContainer.encode(directGenerators, forKey: .directGenerator)
        }
    }

    internal enum CodingKeys: String, CodingKey {
        case field
        case text
        case prefix
        case regex
        case analyzer
        case size
        case shardSize = "shard_size"
        case directGenerator = "direct_generator"
        case highlight
        case collate
        case smoothing
        case gramSize = "gram_size"
        case forceUnigrams = "force_unigrams"
        case maxErrors = "max_errors"
        case tokenLimit = "token_limit"
        case realWordErrorLikelihood = "real_word_error_likelihood"
        case separator
        case confidence
    }
}

public extension PhraseSuggestion {
    struct Highlight {
        public let preTag: String
        public let postTag: String

        public init(preTag: String, postTag: String) {
            self.preTag = preTag
            self.postTag = postTag
        }
    }

    struct DirectCandidateGenerator {
        public var field: String
        public var preFilter: String?
        public var postFilter: String?
        public var suggestMode: String?
        public var accuracy: Decimal?
        public var size: Int?
        public var sort: TermSuggestion.SortBy?
        public var stringDistance: TermSuggestion.StringDistance?
        public var maxEdits: Int?
        public var maxInspections: Int?
        public var maxTermFreq: Decimal?
        public var prefixLength: Int?
        public var minWordLength: Int?
        public var minDocFreq: Decimal?

        public init(field: String, preFilter: String? = nil, postFilter: String? = nil, suggestMode: String? = nil, accuracy: Decimal? = nil, size: Int? = nil, sort: TermSuggestion.SortBy? = nil, stringDistance: TermSuggestion.StringDistance? = nil, maxEdits: Int? = nil, maxInspections: Int? = nil, maxTermFreq: Decimal? = nil, prefixLength: Int? = nil, minWordLength: Int? = nil, minDocFreq: Decimal? = nil) {
            self.field = field
            self.preFilter = preFilter
            self.postFilter = postFilter
            self.suggestMode = suggestMode
            self.accuracy = accuracy
            self.size = size
            self.sort = sort
            self.stringDistance = stringDistance
            self.maxEdits = maxEdits
            self.maxInspections = maxInspections
            self.maxTermFreq = maxTermFreq
            self.prefixLength = prefixLength
            self.minWordLength = minWordLength
            self.minDocFreq = minDocFreq
        }
    }

    struct Collate {
        public let query: Script
        public let params: [String: CodableValue]?
        public let purne: Bool
    }
}

extension PhraseSuggestion.Highlight: Codable {
    enum CodingKeys: String, CodingKey {
        case preTag = "pre_tag"
        case postTag = "post_tag"
    }
}

extension PhraseSuggestion.Highlight: Equatable {}

extension PhraseSuggestion.DirectCandidateGenerator: Codable {
    enum CodingKeys: String, CodingKey {
        case field
        case preFilter = "pre_filter"
        case postFilter = "post_filter"
        case suggestMode = "suggest_mode"
        case accuracy
        case size
        case sort
        case stringDistance = "string_distance"
        case maxEdits = "max_edits"
        case maxInspections = "max_inspections"
        case maxTermFreq = "max_term_freq"
        case prefixLength = "prefix_length"
        case minWordLength = "min_word_length"
        case minDocFreq = "min_doc_freq"
    }
}

extension PhraseSuggestion.DirectCandidateGenerator: Equatable {}

extension PhraseSuggestion.Collate: Codable {}

extension PhraseSuggestion.Collate: Equatable {}

extension PhraseSuggestion: Equatable {
    public static func == (lhs: PhraseSuggestion, rhs: PhraseSuggestion) -> Bool {
        return lhs.suggestionType == rhs.suggestionType
            && lhs.field == rhs.field
            && lhs.prefix == rhs.prefix
            && lhs.text == rhs.text
            && lhs.regex == rhs.regex
            && lhs.analyzer == rhs.analyzer
            && lhs.size == rhs.size
            && lhs.shardSize == rhs.shardSize
            && lhs.maxErrors == rhs.maxErrors
            && lhs.separator == rhs.separator
            && lhs.realWordErrorLikelihood == rhs.realWordErrorLikelihood
            && lhs.confidence == rhs.confidence
            && lhs.gramSize == rhs.gramSize
            && lhs.forceUnigrams == rhs.forceUnigrams
            && lhs.tokenLimit == rhs.tokenLimit
            && lhs.highlight == rhs.highlight
            && lhs.collate == rhs.collate
            && isEqualSmoothingModels(lhs.smoothing, rhs.smoothing)
            && lhs.directGenerators == rhs.directGenerators
    }
}

public enum SmoothingModelType: String, Codable {
    case laplace
    case stupidBackoff = "stupid_backoff"
    case linearInterpolation = "linear_interpolation"
}

extension SmoothingModelType {
    var metaType: SmoothingModel.Type {
        switch self {
        case .laplace:
            return Laplace.self
        case .stupidBackoff:
            return StupidBackoff.self
        case .linearInterpolation:
            return LinearInterpolation.self
        }
    }
}

public protocol SmoothingModel: Codable {
    var smoothingModelType: SmoothingModelType { get }

    func isEqualTo(_ other: SmoothingModel) -> Bool
}

public extension SmoothingModel where Self: Equatable {
    func isEqualTo(_ other: SmoothingModel) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

public func isEqualSmoothingModels(_ lhs: SmoothingModel?, _ rhs: SmoothingModel?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    if let lhs = lhs, let rhs = rhs {
        return lhs.isEqualTo(rhs)
    }
    return false
}

public struct StupidBackoff: SmoothingModel {
    public let smoothingModelType: SmoothingModelType = .stupidBackoff

    public let discount: Decimal
}

public extension StupidBackoff {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let namedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: smoothingModelType))
        discount = try namedContainer.decodeDecimal(forKey: .discount)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var namedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: smoothingModelType))
        try namedContainer.encode(discount, forKey: .discount)
    }

    internal enum CodingKeys: String, CodingKey {
        case discount
    }
}

extension StupidBackoff: Equatable {}

public struct Laplace: SmoothingModel {
    public let smoothingModelType: SmoothingModelType = .laplace

    public let alpha: Decimal
}

public extension Laplace {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let namedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: smoothingModelType))
        alpha = try namedContainer.decodeDecimal(forKey: .alpha)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var namedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: smoothingModelType))
        try namedContainer.encode(alpha, forKey: .alpha)
    }

    internal enum CodingKeys: String, CodingKey {
        case alpha
    }
}

extension Laplace: Equatable {}

public struct LinearInterpolation: SmoothingModel {
    public let smoothingModelType: SmoothingModelType = .linearInterpolation

    public let trigramLambda: Decimal
    public let bigramLambda: Decimal
    public let unigramLambda: Decimal
}

public extension LinearInterpolation {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let namedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: smoothingModelType))
        trigramLambda = try namedContainer.decodeDecimal(forKey: .trigramLambda)
        bigramLambda = try namedContainer.decodeDecimal(forKey: .bigramLambda)
        unigramLambda = try namedContainer.decodeDecimal(forKey: .unigramLambda)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var namedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: smoothingModelType))
        try namedContainer.encode(trigramLambda, forKey: .trigramLambda)
        try namedContainer.encode(bigramLambda, forKey: .bigramLambda)
        try namedContainer.encode(unigramLambda, forKey: .unigramLambda)
    }

    internal enum CodingKeys: String, CodingKey {
        case trigramLambda = "trigram_lambda"
        case bigramLambda = "bigram_lambda"
        case unigramLambda = "unigram_lambda"
    }
}

extension LinearInterpolation: Equatable {}

public class CompletionSuggestionBuilder: BaseSuggestionBuilder, SuggestionBuilder {
    public typealias ElasticSwiftType = CompletionSuggestion

    private var _skipDuplicates: Bool?
    private var _fuzzyOptions: CompletionSuggestion.FuzzyOptions?
    private var _regexOptions: CompletionSuggestion.RegexOptions?
    private var _contexts: [String: [CompletionSuggestionQueryContext]]?

    override public init() {
        super.init()
    }

    @discardableResult
    public func set(skipDuplicates: Bool) -> Self {
        _skipDuplicates = skipDuplicates
        return self
    }

    @discardableResult
    public func set(fuzzyOptions: CompletionSuggestion.FuzzyOptions) -> Self {
        _fuzzyOptions = fuzzyOptions
        return self
    }

    @discardableResult
    public func set(regexOptions: CompletionSuggestion.RegexOptions) -> Self {
        _regexOptions = regexOptions
        return self
    }

    @discardableResult
    public func set(contexts: [String: [CompletionSuggestionQueryContext]]) -> Self {
        _contexts = contexts
        return self
    }

    public var skipDuplicates: Bool? {
        return _skipDuplicates
    }

    public var fuzzyOptions: CompletionSuggestion.FuzzyOptions? {
        return _fuzzyOptions
    }

    public var regexOptions: CompletionSuggestion.RegexOptions? {
        return _regexOptions
    }

    public var contexts: [String: [CompletionSuggestionQueryContext]]? {
        return _contexts
    }

    public func build() throws -> CompletionSuggestion {
        return try CompletionSuggestion(withBuilder: self)
    }
}

public struct CompletionSuggestion: Suggestion {
    public let suggestionType: SuggestionType = .completion

    public var field: String

    public var text: String?

    public var prefix: String?

    public var regex: String?

    public var analyzer: String?

    public var size: Int?

    public var shardSize: Int?

    public var skipDuplicates: Bool?

    public var fuzzyOptions: FuzzyOptions?

    public var regexOptions: RegexOptions?

    public var contexts: [String: [CompletionSuggestionQueryContext]]?

    public init(field: String, text: String? = nil, prefix: String? = nil, regex: String? = nil, analyzer: String? = nil, size: Int? = nil, shardSize: Int? = nil, skipDuplicates: Bool? = nil, fuzzyOptions: FuzzyOptions? = nil, regexOptions: RegexOptions? = nil, contexts: [String: [CompletionSuggestionQueryContext]]? = nil) {
        self.field = field
        self.text = text
        self.prefix = prefix
        self.analyzer = analyzer
        self.regex = regex
        self.size = size
        self.shardSize = shardSize
        self.skipDuplicates = skipDuplicates
        self.fuzzyOptions = fuzzyOptions
        self.regexOptions = regexOptions
        self.contexts = contexts
    }

    internal init(withBuilder builder: CompletionSuggestionBuilder) throws {
        guard let field = builder.field else {
            throw SuggestionBuilderError.missingRequiredField("field")
        }
        self.init(field: field, text: builder.text, prefix: builder.prefix, regex: builder.regex, analyzer: builder.analyzer, size: builder.size, shardSize: builder.shardSize, skipDuplicates: builder.skipDuplicates, fuzzyOptions: builder.fuzzyOptions, regexOptions: builder.regexOptions, contexts: builder.contexts)
    }
}

public extension CompletionSuggestion {
    init(from decoder: Decoder) throws {
        let contianer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let namedContianer = try contianer.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: suggestionType))
        field = try namedContianer.decodeString(forKey: .field)
        text = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.text.rawValue))
        prefix = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.prefix.rawValue))
        regex = try contianer.decodeStringIfPresent(forKey: .key(named: CodingKeys.regex.rawValue))
        analyzer = try namedContianer.decodeStringIfPresent(forKey: .analyzer)
        size = try namedContianer.decodeIntIfPresent(forKey: .size)
        shardSize = try namedContianer.decodeIntIfPresent(forKey: .shardSize)
        skipDuplicates = try namedContianer.decodeBoolIfPresent(forKey: .skipDuplicates)
        fuzzyOptions = try namedContianer.decodeIfPresent(FuzzyOptions.self, forKey: .fuzzyOptions)
        regexOptions = try namedContianer.decodeIfPresent(RegexOptions.self, forKey: .regex)
        if namedContianer.contains(.contexts) {
            let contextsContainer = try namedContianer.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .contexts)
            var dic = [String: [CompletionSuggestionQueryContext]]()
            for k in contextsContainer.allKeys {
                do {
                    let contextValues = try contextsContainer.decodeSuggestionQueryContexts(forKey: k)
                    dic[k.stringValue] = contextValues
                } catch {
                    let context = try contextsContainer.decodeSuggestionQueryContext(forKey: k)
                    dic[k.stringValue] = [context]
                }
            }
            contexts = dic
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encodeIfPresent(text, forKey: .key(named: CodingKeys.text.rawValue))
        try container.encodeIfPresent(prefix, forKey: .key(named: CodingKeys.prefix.rawValue))
        try container.encodeIfPresent(regex, forKey: .key(named: CodingKeys.regex.rawValue))

        var namedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: suggestionType))
        try namedContainer.encode(field, forKey: .field)
        try namedContainer.encodeIfPresent(analyzer, forKey: .analyzer)
        try namedContainer.encodeIfPresent(size, forKey: .size)
        try namedContainer.encodeIfPresent(shardSize, forKey: .shardSize)
        try namedContainer.encodeIfPresent(skipDuplicates, forKey: .skipDuplicates)
        try namedContainer.encodeIfPresent(fuzzyOptions, forKey: .fuzzyOptions)
        try namedContainer.encodeIfPresent(regexOptions, forKey: .regex)
        if let contexts = self.contexts {
            var contextContainer = namedContainer.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .contexts)
            for (k, v) in contexts {
                try contextContainer.encode(v, forKey: .key(named: k))
            }
        }
    }

    internal enum CodingKeys: String, CodingKey {
        case field
        case text
        case prefix
        case regex
        case analyzer
        case size
        case shardSize = "shard_size"
        case skipDuplicates = "skip_duplicates"
        case fuzzyOptions = "fuzzy"
        case contexts
    }
}

public extension CompletionSuggestion {
    struct FuzzyOptions {
        public var fuzziness: Int?
        public var transpositions: Bool?
        public var fuzzyMinLength: Int?
        public var fuzzyPrefixLength: Int?
        public var unicodeAware: Bool?
        public var maxDeterminizedStates: Int?

        public init(fuzziness: Int? = nil, transpositions: Bool? = nil, fuzzyMinLength: Int? = nil, fuzzyPrefixLength: Int? = nil, unicodeAware: Bool? = nil, maxDeterminizedStates: Int? = nil) {
            self.fuzziness = fuzziness
            self.transpositions = transpositions
            self.fuzzyMinLength = fuzzyMinLength
            self.fuzzyPrefixLength = fuzzyPrefixLength
            self.unicodeAware = unicodeAware
            self.maxDeterminizedStates = maxDeterminizedStates
        }
    }

    struct RegexOptions {
        public var flags: RegexFlag?
        public var maxDeterminizedStates: Int?

        public init(flags: RegexFlag? = nil, maxDeterminizedStates: Int? = nil) {
            self.flags = flags
            self.maxDeterminizedStates = maxDeterminizedStates
        }
    }

    enum RegexFlag: String, Codable {
        case all = "ALL"
        case anystring = "ANYSTRING"
        case complement = "COMPLEMENT"
        case empty = "EMPTY"
        case intersection = "INTERSECTION"
        case `internal` = "INTERVAL"
        case none = "NONE"
    }
}

extension CompletionSuggestion.FuzzyOptions: Codable {
    enum CodingKeys: String, CodingKey {
        case fuzziness
        case transpositions
        case fuzzyMinLength = "min_length"
        case fuzzyPrefixLength = "prefix_length"
        case unicodeAware = "unicode_aware"
        case maxDeterminizedStates = "max_determinized_states"
    }
}

extension CompletionSuggestion.FuzzyOptions: Equatable {}

extension CompletionSuggestion.RegexOptions: Codable {
    enum CodingKeys: String, CodingKey {
        case flags
        case maxDeterminizedStates = "max_determinized_states"
    }
}

extension CompletionSuggestion.RegexOptions: Equatable {}

extension CompletionSuggestion: Equatable {
    public static func == (lhs: CompletionSuggestion, rhs: CompletionSuggestion) -> Bool {
        return lhs.suggestionType == rhs.suggestionType
            && lhs.field == rhs.field
            && lhs.text == rhs.text
            && lhs.prefix == rhs.prefix
            && lhs.regex == rhs.regex
            && lhs.analyzer == rhs.analyzer
            && lhs.size == rhs.size
            && lhs.shardSize == rhs.shardSize
            && lhs.skipDuplicates == rhs.skipDuplicates
            && lhs.fuzzyOptions == rhs.fuzzyOptions
            && lhs.regexOptions == rhs.regexOptions
            && isEqualContextDictionaries(lhs.contexts, rhs.contexts)
    }
}

public func isEqualContextDictionaries(_ lhs: [String: [CompletionSuggestionQueryContext]]?, _ rhs: [String: [CompletionSuggestionQueryContext]]?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    guard let lhs = lhs, let rhs = rhs, lhs.count == rhs.count else {
        return false
    }
    let result = lhs.map {
        guard let values = rhs[$0.key], values.count == $0.value.count, values.elementsEqual($0.value, by: { $0.isEqualTo($1) }) else {
            return false
        }
        return true
    }.reduce(true) { $0 && $1 }
    return result
}

public enum CompletionSuggestionQueryContextType: String, Codable, CaseIterable {
    case geo
    case category
}

public extension CompletionSuggestionQueryContextType {
    var metaType: CompletionSuggestionQueryContext.Type {
        switch self {
        case .category:
            return CategoryQueryContext.self
        case .geo:
            return GeoQueryContext.self
        }
    }
}

public protocol CompletionSuggestionQueryContext: Codable {
    var queryContextType: CompletionSuggestionQueryContextType { get }

    func isEqualTo(_ other: CompletionSuggestionQueryContext) -> Bool
}

public extension CompletionSuggestionQueryContext where Self: Equatable {
    func isEqualTo(_ other: CompletionSuggestionQueryContext) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

public struct GeoQueryContext: CompletionSuggestionQueryContext {
    public let queryContextType: CompletionSuggestionQueryContextType = .geo

    public let context: GeoPoint
    public var boost: Int?
    public var precision: Int?
    public var neighbours: [Int]?

    public init(context: GeoPoint, boost: Int? = nil, precision: Int? = nil, neighbours: [Int]? = nil) {
        self.context = context
        self.boost = boost
        self.precision = precision
        self.neighbours = neighbours
    }
}

extension GeoQueryContext: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        context = try container.decode(GeoPoint.self, forKey: .context)
        boost = try container.decodeIntIfPresent(forKey: .boost)
        precision = try container.decodeIntIfPresent(forKey: .precision)
        neighbours = try container.decodeArrayIfPresent(forKey: .neighbours)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(context, forKey: .context)
        try container.encodeIfPresent(boost, forKey: .boost)
        try container.encodeIfPresent(precision, forKey: .precision)
        try container.encodeIfPresent(neighbours, forKey: .neighbours)
    }

    enum CodingKeys: String, CodingKey {
        case context
        case boost
        case precision
        case neighbours
    }
}

extension GeoQueryContext: Equatable {}

public struct CategoryQueryContext: CompletionSuggestionQueryContext {
    public let queryContextType: CompletionSuggestionQueryContextType = .category

    public var context: String
    public var prefix: Bool?
    public var boost: Int?

    public init(context: String, prefix: Bool? = nil, boost: Int? = nil) {
        self.context = context
        self.prefix = prefix
        self.boost = boost
    }
}

extension CategoryQueryContext: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        context = try container.decodeString(forKey: .context)
        prefix = try container.decodeBoolIfPresent(forKey: .prefix)
        boost = try container.decodeIntIfPresent(forKey: .boost)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(context, forKey: .context)
        try container.encodeIfPresent(prefix, forKey: .prefix)
        try container.encodeIfPresent(boost, forKey: .boost)
    }

    enum CodingKeys: String, CodingKey {
        case context
        case prefix
        case boost
    }
}

extension CategoryQueryContext: Equatable {}

/// Extention for DynamicCodingKeys
public extension DynamicCodingKeys {
    static func key(named suggestionType: SuggestionType) -> DynamicCodingKeys {
        return .key(named: suggestionType.rawValue)
    }

    static func key(named smoothingModelType: SmoothingModelType) -> DynamicCodingKeys {
        return .key(named: smoothingModelType.rawValue)
    }
}

// MARK: - Codable Extenstions

public extension KeyedEncodingContainer {
    mutating func encode(_ value: Suggestion, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    mutating func encode(_ value: SmoothingModel, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    mutating func encode(_ value: CompletionSuggestionQueryContext, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    mutating func encode(_ value: [Suggestion], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let suggestionsEncoder = superEncoder(forKey: key)
        var suggestionsContainer = suggestionsEncoder.unkeyedContainer()
        for suggestion in value {
            let suggestionEncoder = suggestionsContainer.superEncoder()
            try suggestion.encode(to: suggestionEncoder)
        }
    }

    mutating func encode(_ value: [SmoothingModel], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let smoothingModelEncoder = superEncoder(forKey: key)
        var smoothingModelContainer = smoothingModelEncoder.unkeyedContainer()
        for smoothing in value {
            let smoothingEncoder = smoothingModelContainer.superEncoder()
            try smoothing.encode(to: smoothingEncoder)
        }
    }

    mutating func encode(_ value: [CompletionSuggestionQueryContext], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let queryContextsEncoder = superEncoder(forKey: key)
        var queryContextsContainer = queryContextsEncoder.unkeyedContainer()
        for queryContext in value {
            let queryContextEncoder = queryContextsContainer.superEncoder()
            try queryContext.encode(to: queryContextEncoder)
        }
    }

    mutating func encodeIfPresent(_ value: Suggestion?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try value.encode(to: superEncoder(forKey: key))
        }
    }

    mutating func encodeIfPresent(_ value: SmoothingModel?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try value.encode(to: superEncoder(forKey: key))
        }
    }

    mutating func encodeIfPresent(_ value: CompletionSuggestionQueryContext?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try value.encode(to: superEncoder(forKey: key))
        }
    }

    mutating func encodeIfPresent(_ value: [Suggestion]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }

    mutating func encodeIfPresent(_ value: [SmoothingModel]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }

    mutating func encodeIfPresent(_ value: [CompletionSuggestionQueryContext]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}

public extension KeyedDecodingContainer {
    func decodeSuggestion(forKey key: KeyedDecodingContainer<K>.Key) throws -> Suggestion {
        let qContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for sKey in qContainer.allKeys {
            if let sType = SuggestionType(rawValue: sKey.stringValue) {
                return try sType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(SuggestionType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify suggestion type from key(s) \(qContainer.allKeys)"))
    }

    func decodeSmoothingModel(forKey key: KeyedDecodingContainer<K>.Key) throws -> SmoothingModel {
        let smContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for smKey in smContainer.allKeys {
            if let smType = SmoothingModelType(rawValue: smKey.stringValue) {
                return try smType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(SmoothingModelType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify smoothing mode type from key(s) \(smContainer.allKeys)"))
    }

    func decodeSuggestionQueryContext(forKey key: KeyedDecodingContainer<K>.Key) throws -> CompletionSuggestionQueryContext {
        for type in CompletionSuggestionQueryContextType.allCases {
            let result = try? type.metaType.init(from: superDecoder(forKey: key))
            if let result = result {
                if let result = result as? GeoQueryContext {
                    if let geoHash = result.context.geoHash, geoHash.rangeOfCharacter(from: CharacterSet(charactersIn: "ailo").union(CharacterSet.whitespacesAndNewlines)) != nil {
                        continue
                    }
                }
                return result
            }
        }
        throw Swift.DecodingError.typeMismatch(CompletionSuggestionQueryContextType.self, .init(codingPath: codingPath, debugDescription: "Unable to decode QueryContext for types \(CompletionSuggestionQueryContextType.allCases)"))
    }

    func decodeSuggestionIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Suggestion? {
        guard contains(key) else {
            return nil
        }
        return try decodeSuggestion(forKey: key)
    }

    func decodeSmoothingModelIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> SmoothingModel? {
        guard contains(key) else {
            return nil
        }
        return try decodeSmoothingModel(forKey: key)
    }

    func decodeSuggestions(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Suggestion] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [Suggestion]()
        if let count = arrayContainer.count {
            while !arrayContainer.isAtEnd {
                let query = try arrayContainer.decodeSuggestion()
                result.append(query)
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all Suggestions expected: \(count) actual: \(result.count). Probable cause: Unable to determine SuggestionType form key(s)"))
            }
        }
        return result
    }

    func decodeSuggestionQueryContexts(forKey key: KeyedDecodingContainer<K>.Key) throws -> [CompletionSuggestionQueryContext] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [CompletionSuggestionQueryContext]()
        if let count = arrayContainer.count {
            while !arrayContainer.isAtEnd {
                let query = try arrayContainer.decodeSuggestionQueryContext()
                result.append(query)
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all QueryContexts expected: \(count) actual: \(result.count). Probable cause: Unable to determine CompletionSuggestionQueryContextType form key(s)"))
            }
        }
        return result
    }

    func decodeSuggestionsIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [Suggestion]? {
        guard contains(key) else {
            return nil
        }

        return try decodeSuggestions(forKey: key)
    }

    func decodeSuggestionQueryContextsIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [CompletionSuggestionQueryContext]? {
        guard contains(key) else {
            return nil
        }

        return try decodeSuggestionQueryContexts(forKey: key)
    }
}

extension UnkeyedDecodingContainer {
    mutating func decodeSuggestion() throws -> Suggestion {
        var copy = self
        let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
        for sKey in elementContainer.allKeys {
            if let sType = SuggestionType(rawValue: sKey.stringValue) {
                return try sType.metaType.init(from: superDecoder())
            }
        }
        throw Swift.DecodingError.typeMismatch(SuggestionType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify suggestion type from key(s) \(elementContainer.allKeys)"))
    }

    mutating func decodeSmoothingModel() throws -> SmoothingModel {
        var copy = self
        let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
        for sKey in elementContainer.allKeys {
            if let sType = SmoothingModelType(rawValue: sKey.stringValue) {
                return try sType.metaType.init(from: superDecoder())
            }
        }
        throw Swift.DecodingError.typeMismatch(SmoothingModelType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify smoothing model type from key(s) \(elementContainer.allKeys)"))
    }

    mutating func decodeSuggestionQueryContext() throws -> CompletionSuggestionQueryContext {
        for c in CompletionSuggestionQueryContextType.allCases {
            var copy = self
            let result = try? c.metaType.init(from: copy.superDecoder())
            if let result = result {
                if let result = result as? GeoQueryContext {
                    if let geoHash = result.context.geoHash, geoHash.rangeOfCharacter(from: CharacterSet(charactersIn: "ailo").union(CharacterSet.whitespacesAndNewlines)) != nil {
                        continue
                    }
                }
                return try c.metaType.init(from: superDecoder())
            }
        }
        throw Swift.DecodingError.typeMismatch(CompletionSuggestionQueryContext.self, .init(codingPath: codingPath, debugDescription: "Unable to decode QueryContext types \(CompletionSuggestionQueryContextType.allCases)"))
    }
}
