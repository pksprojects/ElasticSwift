//
//  InnerHits.swift
//
//
//  Created by Prafull Kumar Soni on 8/1/20.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import Foundation

// MARK: - Inner Hit

public struct InnerHit {
    public var name: String?
    public var ignoreUnmapped: Bool?
    public var from: Int?
    public var size: Int?
    public var explain: Bool?
    public var version: Bool?
    public var trackScores: Bool?
    public var sort: [Sort]?
    public var query: Query?
    public var sourceFilter: SourceFilter?
    public var scriptFields: [ScriptField]?
    public var storedFields: [String]?
    public var docvalueFields: [DocValueField]?
    public var highlight: Highlight?
    public var collapse: Collapse?

    public init(name: String? = nil, ignoreUnmapped: Bool? = nil, from: Int? = nil, size: Int? = nil, explain: Bool? = nil, version: Bool? = nil, trackScores: Bool? = nil, sort: [Sort]? = nil, query: Query? = nil, sourceFilter: SourceFilter? = nil, scriptFields: [ScriptField]? = nil, storedFields: [String]? = nil, docvalueFields: [DocValueField]? = nil, highlight: Highlight? = nil, collapse: Collapse? = nil) {
        self.name = name
        self.ignoreUnmapped = ignoreUnmapped
        self.from = from
        self.size = size
        self.explain = explain
        self.version = version
        self.trackScores = trackScores
        self.sort = sort
        self.query = query
        self.sourceFilter = sourceFilter
        self.scriptFields = scriptFields
        self.storedFields = storedFields
        self.docvalueFields = docvalueFields
        self.highlight = highlight
        self.collapse = collapse
    }
}

extension InnerHit: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeStringIfPresent(forKey: .name)
        ignoreUnmapped = try container.decodeBoolIfPresent(forKey: .ignoreUnmapped)
        from = try container.decodeIntIfPresent(forKey: .from)
        size = try container.decodeIntIfPresent(forKey: .size)
        explain = try container.decodeBoolIfPresent(forKey: .explain)
        version = try container.decodeBoolIfPresent(forKey: .version)
        trackScores = try container.decodeBoolIfPresent(forKey: .trackScores)
        sort = try container.decodeIfPresent([Sort].self, forKey: .sort)
        query = try container.decodeQueryIfPresent(forKey: .query)
        sourceFilter = try container.decodeIfPresent(SourceFilter.self, forKey: .sourceFilter)
        docvalueFields = try container.decodeIfPresent([DocValueField].self, forKey: .docvalueFields)
        highlight = try container.decodeIfPresent(Highlight.self, forKey: .highlight)
        collapse = try container.decodeIfPresent(Collapse.self, forKey: .collapse)
        if container.contains(.scriptFields) {
            do {
                let scriptedField = try container.decode(ScriptField.self, forKey: .scriptFields)
                scriptFields = [scriptedField]
            } catch {
                let nested = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .scriptFields)
                var fields = [ScriptField]()
                for key in nested.allKeys {
                    let scriptContainer = try nested.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
                    let script = try scriptContainer.decode(Script.self, forKey: .key(named: ScriptField.CodingKeys.script.stringValue))
                    fields.append(ScriptField(field: key.stringValue, script: script))
                }
                scriptFields = fields
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(ignoreUnmapped, forKey: .ignoreUnmapped)
        try container.encodeIfPresent(from, forKey: .from)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(explain, forKey: .explain)
        try container.encodeIfPresent(version, forKey: .version)
        try container.encodeIfPresent(trackScores, forKey: .trackScores)
        try container.encodeIfPresent(sort, forKey: .sort)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(sourceFilter, forKey: .sourceFilter)
        try container.encodeIfPresent(storedFields, forKey: .storedFields)
        try container.encodeIfPresent(docvalueFields, forKey: .docvalueFields)
        try container.encodeIfPresent(highlight, forKey: .highlight)
        try container.encodeIfPresent(collapse, forKey: .collapse)

        if let scriptFields = self.scriptFields, !scriptFields.isEmpty {
            if scriptFields.count == 1 {
                try container.encode(scriptFields[0], forKey: .scriptFields)
            } else {
                var nested = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .scriptFields)
                for scriptField in scriptFields {
                    var scriptContainer = nested.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .key(named: scriptField.field))
                    try scriptContainer.encode(scriptField.script, forKey: .key(named: ScriptField.CodingKeys.script.stringValue))
                }
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case name
        case ignoreUnmapped = "ignore_unmapped"
        case from
        case size
        case explain
        case version
        case trackScores = "track_scores"
        case sort
        case query
        case sourceFilter = "_source"
        case scriptFields = "script_fields"
        case storedFields = "stored_fields"
        case docvalueFields = "docvalue_fields"
        case highlight
        case collapse
    }
}

extension InnerHit: Equatable {
    public static func == (lhs: InnerHit, rhs: InnerHit) -> Bool {
        return lhs.name == rhs.name
            && lhs.ignoreUnmapped == rhs.ignoreUnmapped
            && lhs.from == rhs.from
            && lhs.size == rhs.size
            && lhs.explain == rhs.explain
            && lhs.version == rhs.version
            && lhs.trackScores == rhs.trackScores
            && lhs.sort == rhs.sort
            && lhs.sourceFilter == rhs.sourceFilter
            && lhs.scriptFields == rhs.scriptFields
            && lhs.docvalueFields == rhs.docvalueFields
            && lhs.highlight == rhs.highlight
    }
}

// MARK: - Source Filtering

public enum SourceFilter {
    case fetchSource(Bool)
    case filter(String)
    case filters([String])
    case source(includes: [String], excludes: [String])
}

extension SourceFilter: Codable {
    enum CodingKeys: String, CodingKey {
        case includes
        case excludes
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .fetchSource(value):
            var contianer = encoder.singleValueContainer()
            try contianer.encode(value)
        case let .filter(value):
            var contianer = encoder.singleValueContainer()
            try contianer.encode(value)
        case let .filters(values):
            var contianer = encoder.unkeyedContainer()
            try contianer.encode(contentsOf: values)
        case let .source(includes, excludes):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(includes, forKey: .includes)
            try container.encode(excludes, forKey: .excludes)
        }
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            let includes: [String] = try container.decodeArray(forKey: .includes)
            let excludes: [String] = try container.decodeArray(forKey: .excludes)
            self = .source(includes: includes, excludes: excludes)
        } else if var contianer = try? decoder.unkeyedContainer() {
            var values = [String]()
            repeat {
                let val = try contianer.decodeString()
                values.append(val)
            } while !contianer.isAtEnd
            self = .filters(values)
        } else {
            let container = try decoder.singleValueContainer()
            if let value = try? container.decodeString() {
                self = .filter(value)
            } else {
                let value = try container.decodeBool()
                self = .fetchSource(value)
            }
        }
    }
}

extension SourceFilter: Equatable {}

// MARK: - Collapsing

public struct Collapse {
    public let field: String
    public let innerHits: [InnerHit]?
    public let maxConcurrentGroupRequests: Int?
}

extension Collapse: Codable {
    enum CodingKeys: String, CodingKey {
        case field
        case innerHits = "inner_hits"
        case maxConcurrentGroupRequests = "max_concurrent_group_searches"
    }
}

extension Collapse: Equatable {}

// MARK: - Script Field

public struct ScriptField {
    public let field: String
    public let script: Script
}

extension ScriptField: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        try nested.encode(script, forKey: .script)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(ScriptField.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        field = container.allKeys.first!.stringValue
        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: field))
        script = try nested.decode(Script.self, forKey: .script)
    }

    enum CodingKeys: String, CodingKey {
        case script
    }
}

extension ScriptField: Equatable {}

// MARK: - Doc value Field

public struct DocValueField: Codable {
    public let field: String
    public let format: String
}

extension DocValueField: Equatable {}

// MARK: - Highlighting

public class HighlightBuilder {
    private var _fields: [Highlight.Field]?
    private var _globalOptions: Highlight.FieldOptions?

    @discardableResult
    public func set(fields: [Highlight.Field]) -> Self {
        _fields = fields
        return self
    }

    @discardableResult
    public func set(globalOptions: Highlight.FieldOptions) -> Self {
        _globalOptions = globalOptions
        return self
    }

    @discardableResult
    public func add(field: Highlight.Field) -> Self {
        if _fields != nil {
            _fields?.append(field)
        } else {
            _fields = [field]
        }
        return self
    }

    public var fields: [Highlight.Field]? {
        return _fields
    }

    public var globalOptions: Highlight.FieldOptions? {
        return _globalOptions
    }

    public func build() throws -> Highlight {
        return try Highlight(withBuilder: self)
    }
}

public class FieldOptionsBuilder {
    private var _fragmentSize: Int?
    private var _numberOfFragments: Int?
    private var _fragmentOffset: Int?
    private var _encoder: Highlight.EncoderType?
    private var _preTags: [String]?
    private var _postTags: [String]?
    private var _scoreOrdered: Bool?
    private var _requireFieldMatch: Bool?
    private var _highlighterType: Highlight.HighlighterType?
    private var _forceSource: Bool?
    private var _fragmenter: String?
    private var _boundaryScannerType: Highlight.BoundaryScannerType?
    private var _boundaryMaxScan: Int?
    private var _boundaryChars: [Character]?
    private var _boundaryScannerLocale: String?
    private var _highlightQuery: Query?
    private var _noMatchSize: Int?
    private var _matchedFields: [String]?
    private var _phraseLimit: Int?
    private var _tagScheme: String?
    private var _termVector: String?
    private var _indexOptions: String?

    public init() {}

    @discardableResult
    public func set(fragmentSize: Int) -> Self {
        _fragmentSize = fragmentSize
        return self
    }

    @discardableResult
    public func set(numberOfFragments: Int) -> Self {
        _numberOfFragments = numberOfFragments
        return self
    }

    @discardableResult
    public func set(fragmentOffset: Int) -> Self {
        _fragmentOffset = fragmentOffset
        return self
    }

    @discardableResult
    public func set(encoder: Highlight.EncoderType) -> Self {
        _encoder = encoder
        return self
    }

    @discardableResult
    public func set(preTags: [String]) -> Self {
        _preTags = preTags
        return self
    }

    @discardableResult
    public func set(postTags: [String]) -> Self {
        _postTags = postTags
        return self
    }

    @discardableResult
    public func set(scoreOrdered: Bool) -> Self {
        _scoreOrdered = scoreOrdered
        return self
    }

    @discardableResult
    public func set(requireFieldMatch: Bool) -> Self {
        _requireFieldMatch = requireFieldMatch
        return self
    }

    @discardableResult
    public func set(highlighterType: Highlight.HighlighterType) -> Self {
        _highlighterType = highlighterType
        return self
    }

    @discardableResult
    public func set(forceSource: Bool) -> Self {
        _forceSource = forceSource
        return self
    }

    @discardableResult
    public func set(fragmenter: String) -> Self {
        _fragmenter = fragmenter
        return self
    }

    @discardableResult
    public func set(boundaryScannerType: Highlight.BoundaryScannerType) -> Self {
        _boundaryScannerType = boundaryScannerType
        return self
    }

    @discardableResult
    public func set(boundaryMaxScan: Int) -> Self {
        _boundaryMaxScan = boundaryMaxScan
        return self
    }

    @discardableResult
    public func set(boundaryChars: [Character]) -> Self {
        _boundaryChars = boundaryChars
        return self
    }

    @discardableResult
    public func set(boundaryScannerLocale: String) -> Self {
        _boundaryScannerLocale = boundaryScannerLocale
        return self
    }

    @discardableResult
    public func set(highlightQuery: Query) -> Self {
        _highlightQuery = highlightQuery
        return self
    }

    @discardableResult
    public func set(noMatchSize: Int) -> Self {
        _noMatchSize = noMatchSize
        return self
    }

    @discardableResult
    public func set(matchedFields: [String]) -> Self {
        _matchedFields = matchedFields
        return self
    }

    @discardableResult
    public func set(phraseLimit: Int) -> Self {
        _phraseLimit = phraseLimit
        return self
    }

    @discardableResult
    public func set(tagScheme: String) -> Self {
        _tagScheme = tagScheme
        return self
    }

    @discardableResult
    public func set(termVector: String) -> Self {
        _termVector = termVector
        return self
    }

    @discardableResult
    public func set(indexOptions: String) -> Self {
        _indexOptions = indexOptions
        return self
    }

    public var fragmentSize: Int? {
        return _fragmentSize
    }

    public var numberOfFragments: Int? {
        return _numberOfFragments
    }

    public var fragmentOffset: Int? {
        return _fragmentOffset
    }

    public var encoder: Highlight.EncoderType? {
        return _encoder
    }

    public var preTags: [String]? {
        return _preTags
    }

    public var postTags: [String]? {
        return _postTags
    }

    public var scoreOrdered: Bool? {
        return _scoreOrdered
    }

    public var requireFieldMatch: Bool? {
        return _requireFieldMatch
    }

    public var highlighterType: Highlight.HighlighterType? {
        return _highlighterType
    }

    public var forceSource: Bool? {
        return _forceSource
    }

    public var fragmenter: String? {
        return _fragmenter
    }

    public var boundaryScannerType: Highlight.BoundaryScannerType? {
        return _boundaryScannerType
    }

    public var boundaryMaxScan: Int? {
        return _boundaryMaxScan
    }

    public var boundaryChars: [Character]? {
        return _boundaryChars
    }

    public var boundaryScannerLocale: String? {
        return _boundaryScannerLocale
    }

    public var highlightQuery: Query? {
        return _highlightQuery
    }

    public var noMatchSize: Int? {
        return _noMatchSize
    }

    public var matchedFields: [String]? {
        return _matchedFields
    }

    public var phraseLimit: Int? {
        return _phraseLimit
    }

    public var tagScheme: String? {
        return _tagScheme
    }

    public var termVector: String? {
        return _termVector
    }

    public var indexOptions: String? {
        return _indexOptions
    }

    public func build() -> Highlight.FieldOptions {
        return Highlight.FieldOptions(withBuilder: self)
    }
}

public enum HighlightBuilderError: Error {
    case atlestOneElementRequired(String)
}

public struct Highlight {
    public let fields: [Field]
    public let globalOptions: FieldOptions

    public init(fields: [Field], globalOptions: FieldOptions = FieldOptions()) {
        self.fields = fields
        self.globalOptions = globalOptions
    }

    internal init(withBuilder builder: HighlightBuilder) throws {
        guard builder.fields != nil, !builder.fields!.isEmpty else {
            throw HighlightBuilderError.atlestOneElementRequired("fields")
        }

        self.init(fields: builder.fields!, globalOptions: builder.globalOptions ?? FieldOptions())
    }
}

extension Highlight: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fields, forKey: .fields)
        try container.encodeIfPresent(globalOptions.boundaryChars?.map { String($0) }, forKey: .boundaryChars)
        try container.encodeIfPresent(globalOptions.boundaryMaxScan, forKey: .boundaryMaxScan)
        try container.encodeIfPresent(globalOptions.boundaryScannerType, forKey: .boundaryScannerType)
        try container.encodeIfPresent(globalOptions.boundaryScannerLocale, forKey: .boundaryScannerLocale)
        try container.encodeIfPresent(globalOptions.encoder, forKey: .encoder)
        try container.encodeIfPresent(globalOptions.forceSource, forKey: .forceSource)
        try container.encodeIfPresent(globalOptions.fragmenter, forKey: .fragmenter)
        try container.encodeIfPresent(globalOptions.fragmentOffset, forKey: .fragmentOffset)
        try container.encodeIfPresent(globalOptions.fragmentSize, forKey: .fragmentSize)
        try container.encodeIfPresent(globalOptions.highlightQuery, forKey: .highlightQuery)
        try container.encodeIfPresent(globalOptions.matchedFields, forKey: .matchedFields)
        try container.encodeIfPresent(globalOptions.numberOfFragments, forKey: .numberOfFragments)
        try container.encodeIfPresent((globalOptions.scoreOrdered ?? false) ? Highlight.FieldOptions.SCORE_ORDERER_VALUE : nil, forKey: .order)
        try container.encodeIfPresent(globalOptions.phraseLimit, forKey: .phraseLimit)
        try container.encodeIfPresent(globalOptions.preTags, forKey: .preTags)
        try container.encodeIfPresent(globalOptions.postTags, forKey: .postTags)
        try container.encodeIfPresent(globalOptions.requireFieldMatch, forKey: .requireFieldMatch)
        try container.encodeIfPresent(globalOptions.tagScheme, forKey: .tagsSchema)
        try container.encodeIfPresent(globalOptions.highlighterType, forKey: .type)
        try container.encodeIfPresent(globalOptions.termVector, forKey: .termVector)
        try container.encodeIfPresent(globalOptions.indexOptions, forKey: .indexOptions)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let fieldsMap = try container.decode([String: FieldOptions].self, forKey: .fields)
            fields = fieldsMap.map { Field($0.key, options: $0.value) }
        } catch {
            fields = try container.decodeArray(forKey: .fields)
        }
        var options = FieldOptions()
        let chars: [String]? = try container.decodeArrayIfPresent(forKey: .boundaryChars)
        if let chars = chars {
            var charArr = [Character]()
            for char in chars {
                charArr.append(contentsOf: [Character](char))
            }
            options.boundaryChars = charArr
        } else {
            options.boundaryChars = nil
        }
        options.boundaryMaxScan = try container.decodeIntIfPresent(forKey: .boundaryMaxScan)
        options.boundaryScannerType = try container.decodeIfPresent(Highlight.BoundaryScannerType.self, forKey: .boundaryScannerType)
        options.boundaryScannerLocale = try container.decodeStringIfPresent(forKey: .boundaryScannerLocale)
        options.encoder = try container.decodeIfPresent(Highlight.EncoderType.self, forKey: .encoder)
        options.forceSource = try container.decodeBoolIfPresent(forKey: .forceSource)
        options.fragmenter = try container.decodeStringIfPresent(forKey: .fragmenter)
        options.fragmentOffset = try container.decodeIntIfPresent(forKey: .fragmentOffset)
        options.fragmentSize = try container.decodeIntIfPresent(forKey: .fragmentSize)
        options.highlightQuery = try container.decodeQueryIfPresent(forKey: .highlightQuery)
        options.matchedFields = try container.decodeArrayIfPresent(forKey: .matchedFields)
        options.noMatchSize = try container.decodeIntIfPresent(forKey: .noMatchSize)
        options.numberOfFragments = try container.decodeIntIfPresent(forKey: .numberOfFragments)
        let order = try container.decodeStringIfPresent(forKey: .order)
        if let order = order {
            switch order {
            case Highlight.FieldOptions.SCORE_ORDERER_VALUE:
                options.scoreOrdered = true
            default:
                options.scoreOrdered = false
            }
        } else {
            options.scoreOrdered = nil
        }
        options.phraseLimit = try container.decodeIntIfPresent(forKey: .phraseLimit)
        options.preTags = try container.decodeArrayIfPresent(forKey: .preTags)
        options.postTags = try container.decodeArrayIfPresent(forKey: .postTags)
        options.requireFieldMatch = try container.decodeBoolIfPresent(forKey: .requireFieldMatch)
        options.tagScheme = try container.decodeStringIfPresent(forKey: .tagsSchema)
        options.highlighterType = try container.decodeIfPresent(Highlight.HighlighterType.self, forKey: .type)
        options.termVector = try container.decodeStringIfPresent(forKey: .termVector)
        options.indexOptions = try container.decodeStringIfPresent(forKey: .indexOptions)
        globalOptions = options
    }

    enum CodingKeys: String, CodingKey {
        case fields
        case boundaryChars = "boundary_chars"
        case boundaryMaxScan = "boundary_max_scan"
        case boundaryScannerType = "boundary_scanner"
        case boundaryScannerLocale = "boundary_scanner_locale"
        case encoder
        case forceSource = "force_source"
        case fragmenter
        case fragmentOffset = "fragment_offset"
        case fragmentSize = "fragment_size"
        case highlightQuery = "highlight_query"
        case matchedFields = "matched_fields"
        case noMatchSize = "no_match_size"
        case numberOfFragments = "number_of_fragments"
        case order
        case phraseLimit = "phrase_limit"
        case preTags = "pre_tags"
        case postTags = "post_tags"
        case requireFieldMatch = "require_field_match"
        case tagsSchema = "tags_schema"
        case type
        case termVector = "term_vector"
        case indexOptions = "index_options"
    }
}

extension Highlight: Equatable {}

public extension Highlight {
    struct Field {
        public let name: String
        public let options: FieldOptions

        public init(_ name: String, options: FieldOptions = FieldOptions()) {
            self.name = name
            self.options = options
        }
    }

    struct FieldOptions {
        fileprivate static let SCORE_ORDERER_VALUE = "score"

        public var fragmentSize: Int?
        public var numberOfFragments: Int?
        public var fragmentOffset: Int?
        public var encoder: EncoderType?
        public var preTags: [String]?
        public var postTags: [String]?
        public var scoreOrdered: Bool?
        public var requireFieldMatch: Bool?
        public var highlighterType: HighlighterType?
        public var forceSource: Bool?
        public var fragmenter: String?
        public var boundaryScannerType: BoundaryScannerType?
        public var boundaryMaxScan: Int?
        public var boundaryChars: [Character]?
        public var boundaryScannerLocale: String?
        public var highlightQuery: Query?
        public var noMatchSize: Int?
        public var matchedFields: [String]?
        public var phraseLimit: Int?
        public var tagScheme: String?
        public var termVector: String?
        public var indexOptions: String?

        public init() {}

        internal init(withBuilder builder: FieldOptionsBuilder) {
            fragmentSize = builder.fragmentSize
            numberOfFragments = builder.numberOfFragments
            fragmentOffset = builder.fragmentOffset
            encoder = builder.encoder
            preTags = builder.preTags
            postTags = builder.postTags
            scoreOrdered = builder.scoreOrdered
            requireFieldMatch = builder.requireFieldMatch
            highlighterType = builder.highlighterType
            forceSource = builder.forceSource
            fragmenter = builder.fragmenter
            boundaryScannerType = builder.boundaryScannerType
            boundaryMaxScan = builder.boundaryMaxScan
            boundaryChars = builder.boundaryChars
            boundaryScannerLocale = builder.boundaryScannerLocale
            highlightQuery = builder.highlightQuery
            noMatchSize = builder.noMatchSize
            matchedFields = builder.matchedFields
            phraseLimit = builder.phraseLimit
            tagScheme = builder.tagScheme
            termVector = builder.termVector
            indexOptions = builder.indexOptions
        }
    }

    enum BoundaryScannerType: String, Codable {
        case chars
        case word
        case sentence
    }

    enum EncoderType: String, Codable {
        case `default`
        case html
    }

    enum HighlighterType: String, Codable {
        case unified
        case plain
        case fvh
    }
}

extension Highlight.Field: Codable {
    public func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        try container.encodeIfPresent(options, forKey: .key(named: name))
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        guard container.allKeys.count == 1 else {
            throw Swift.DecodingError.typeMismatch(Highlight.Field.self, .init(codingPath: container.codingPath, debugDescription: "Unable to find field name in key(s) expect: 1 key found: \(container.allKeys.count)."))
        }

        let field = container.allKeys.first!.stringValue

        options = try container.decode(Highlight.FieldOptions.self, forKey: .key(named: field))
        name = field
    }
}

extension Highlight.Field: Equatable {}

extension Highlight.FieldOptions: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(boundaryChars?.map { String($0) }, forKey: .boundaryChars)
        try container.encodeIfPresent(boundaryMaxScan, forKey: .boundaryMaxScan)
        try container.encodeIfPresent(boundaryScannerType, forKey: .boundaryScannerType)
        try container.encodeIfPresent(boundaryScannerLocale, forKey: .boundaryScannerLocale)
        try container.encodeIfPresent(self.encoder, forKey: .encoder)
        try container.encodeIfPresent(forceSource, forKey: .forceSource)
        try container.encodeIfPresent(fragmenter, forKey: .fragmenter)
        try container.encodeIfPresent(fragmentOffset, forKey: .fragmentOffset)
        try container.encodeIfPresent(fragmentSize, forKey: .fragmentSize)
        try container.encodeIfPresent(highlightQuery, forKey: .highlightQuery)
        try container.encodeIfPresent(matchedFields, forKey: .matchedFields)
        try container.encodeIfPresent(numberOfFragments, forKey: .numberOfFragments)
        try container.encodeIfPresent((scoreOrdered ?? false) ? Highlight.FieldOptions.SCORE_ORDERER_VALUE : nil, forKey: .order)
        try container.encodeIfPresent(phraseLimit, forKey: .phraseLimit)
        try container.encodeIfPresent(preTags, forKey: .preTags)
        try container.encodeIfPresent(postTags, forKey: .postTags)
        try container.encodeIfPresent(requireFieldMatch, forKey: .requireFieldMatch)
        try container.encodeIfPresent(tagScheme, forKey: .tagsSchema)
        try container.encodeIfPresent(highlighterType, forKey: .type)
        try container.encodeIfPresent(termVector, forKey: .termVector)
        try container.encodeIfPresent(indexOptions, forKey: .indexOptions)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let chars: [String]? = try container.decodeArrayIfPresent(forKey: .boundaryChars)
        if let chars = chars {
            var charArr = [Character]()
            for char in chars {
                charArr.append(contentsOf: [Character](char))
            }
            boundaryChars = charArr
        } else {
            boundaryChars = nil
        }
        boundaryMaxScan = try container.decodeIntIfPresent(forKey: .boundaryMaxScan)
        boundaryScannerType = try container.decodeIfPresent(Highlight.BoundaryScannerType.self, forKey: .boundaryScannerType)
        boundaryScannerLocale = try container.decodeStringIfPresent(forKey: .boundaryScannerLocale)
        encoder = try container.decodeIfPresent(Highlight.EncoderType.self, forKey: .encoder)
        forceSource = try container.decodeBoolIfPresent(forKey: .forceSource)
        fragmenter = try container.decodeStringIfPresent(forKey: .fragmenter)
        fragmentOffset = try container.decodeIntIfPresent(forKey: .fragmentOffset)
        fragmentSize = try container.decodeIntIfPresent(forKey: .fragmentSize)
        highlightQuery = try container.decodeQueryIfPresent(forKey: .highlightQuery)
        matchedFields = try container.decodeArrayIfPresent(forKey: .matchedFields)
        noMatchSize = try container.decodeIntIfPresent(forKey: .noMatchSize)
        numberOfFragments = try container.decodeIntIfPresent(forKey: .numberOfFragments)
        let order = try container.decodeStringIfPresent(forKey: .order)
        if let order = order {
            switch order {
            case Highlight.FieldOptions.SCORE_ORDERER_VALUE:
                scoreOrdered = true
            default:
                scoreOrdered = false
            }
        } else {
            scoreOrdered = nil
        }
        phraseLimit = try container.decodeIntIfPresent(forKey: .phraseLimit)
        preTags = try container.decodeArrayIfPresent(forKey: .preTags)
        postTags = try container.decodeArrayIfPresent(forKey: .postTags)
        requireFieldMatch = try container.decodeBoolIfPresent(forKey: .requireFieldMatch)
        tagScheme = try container.decodeStringIfPresent(forKey: .tagsSchema)
        highlighterType = try container.decodeIfPresent(Highlight.HighlighterType.self, forKey: .type)
        termVector = try container.decodeStringIfPresent(forKey: .termVector)
        indexOptions = try container.decodeStringIfPresent(forKey: .indexOptions)
    }

    enum CodingKeys: String, CodingKey {
        case boundaryChars = "boundary_chars"
        case boundaryMaxScan = "boundary_max_scan"
        case boundaryScannerType = "boundary_scanner"
        case boundaryScannerLocale = "boundary_scanner_locale"
        case encoder
        case forceSource = "force_source"
        case fragmenter
        case fragmentOffset = "fragment_offset"
        case fragmentSize = "fragment_size"
        case highlightQuery = "highlight_query"
        case matchedFields = "matched_fields"
        case noMatchSize = "no_match_size"
        case numberOfFragments = "number_of_fragments"
        case order
        case phraseLimit = "phrase_limit"
        case preTags = "pre_tags"
        case postTags = "post_tags"
        case requireFieldMatch = "require_field_match"
        case tagsSchema = "tags_schema"
        case type
        case termVector = "term_vector"
        case indexOptions = "index_options"
    }
}

extension Highlight.FieldOptions: Equatable {
    public static func == (lhs: Highlight.FieldOptions, rhs: Highlight.FieldOptions) -> Bool {
        return lhs.boundaryChars == rhs.boundaryChars
            && lhs.boundaryMaxScan == rhs.boundaryMaxScan
            && lhs.boundaryScannerType == rhs.boundaryScannerType
            && lhs.boundaryScannerLocale == rhs.boundaryScannerLocale
            && lhs.encoder == rhs.encoder
            && lhs.forceSource == rhs.forceSource
            && lhs.fragmenter == rhs.fragmenter
            && lhs.fragmentOffset == rhs.fragmentOffset
            && lhs.fragmentSize == rhs.fragmentSize
            && lhs.matchedFields == rhs.matchedFields
            && lhs.noMatchSize == rhs.noMatchSize
            && lhs.numberOfFragments == rhs.numberOfFragments
            && lhs.scoreOrdered == rhs.scoreOrdered
            && lhs.phraseLimit == rhs.phraseLimit
            && lhs.preTags == rhs.preTags
            && lhs.postTags == rhs.postTags
            && lhs.requireFieldMatch == rhs.requireFieldMatch
            && lhs.tagScheme == rhs.tagScheme
            && lhs.highlighterType == rhs.highlighterType
            && isEqualQueries(lhs.highlightQuery, rhs.highlightQuery)
    }
}
