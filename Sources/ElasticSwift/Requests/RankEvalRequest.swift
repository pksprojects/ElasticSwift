//
//  RankEvalRequest.swift
//
//
//  Created by Prafull Kumar Soni on 1/26/20.
//

import ElasticSwiftCodableUtils
import ElasticSwiftCore
import ElasticSwiftQueryDSL
import Foundation
import NIOHTTP1

// MARK: - RankEvalRequest Builder

public class RankEvalRequestBuilder: RequestBuilder {
    public typealias RequestType = RankEvalRequest

    private var _indices: [String]?

    private var _ignoreUnavailable: Bool?
    private var _allowNoIndices: Bool?
    private var _expandWildcards: ExpandWildcards?
    private var _rankEvalSpec: RankEvalSpec?

    public init() {}

    @discardableResult
    public func set(indices: String...) -> Self {
        _indices = indices
        return self
    }

    @discardableResult
    public func set(indices: [String]) -> Self {
        _indices = indices
        return self
    }

    @discardableResult
    public func add(index: String) -> Self {
        if _indices != nil {
            _indices?.append(index)
        } else {
            _indices = [index]
        }
        return self
    }

    @discardableResult
    public func set(ignoreUnavailable: Bool) -> Self {
        _ignoreUnavailable = ignoreUnavailable
        return self
    }

    @discardableResult
    public func set(allowNoIndices: Bool) -> Self {
        _allowNoIndices = allowNoIndices
        return self
    }

    @discardableResult
    public func set(expandWildcards: ExpandWildcards) -> Self {
        _expandWildcards = expandWildcards
        return self
    }

    @discardableResult
    public func set(rankEvalSpec: RankEvalSpec) -> Self {
        _rankEvalSpec = rankEvalSpec
        return self
    }

    public var indices: [String]? {
        return _indices
    }

    public var ignoreUnavailable: Bool? {
        return _ignoreUnavailable
    }

    public var allowNoIndices: Bool? {
        return _allowNoIndices
    }

    public var expandWildcards: ExpandWildcards? {
        return _expandWildcards
    }

    public var rankEvalSpec: RankEvalSpec? {
        return _rankEvalSpec
    }

    public func build() throws -> RankEvalRequest {
        return try RankEvalRequest(withBuilder: self)
    }
}

// MARK: - RankEvalRequest

public struct RankEvalRequest: Request {
    /// A list of index names; use `_all` or empty array to perform the operation on all indices
    public let indices: [String]?

    public let rankEvalSpec: RankEvalSpec

    /// Whether specified concrete indices should be ignored when unavailable (missing or closed)
    public var ignoreUnavailable: Bool?
    /// Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
    public var allowNoIndices: Bool?
    /// Whether to expand wildcard expression to concrete indices that are open, closed or both.
    public var expandWildcards: ExpandWildcards?

    public init(indices: [String]?, rankEvalSpec: RankEvalSpec, ignoreUnavailable: Bool? = nil, allowNoIndices: Bool? = nil, expandWildcards: ExpandWildcards? = nil) {
        self.indices = indices
        self.rankEvalSpec = rankEvalSpec
        self.ignoreUnavailable = ignoreUnavailable
        self.allowNoIndices = allowNoIndices
        self.expandWildcards = expandWildcards
    }

    internal init(withBuilder builder: RankEvalRequestBuilder) throws {
        guard builder.rankEvalSpec != nil else {
            throw RequestBuilderError.missingRequiredField("rankEvalSpec")
        }

        self.init(indices: builder.indices, rankEvalSpec: builder.rankEvalSpec!, ignoreUnavailable: builder.ignoreUnavailable, allowNoIndices: builder.allowNoIndices, expandWildcards: builder.expandWildcards)
    }

    public var headers: HTTPHeaders {
        return HTTPHeaders()
    }

    public var queryParams: [URLQueryItem] {
        var params = [URLQueryItem]()
        if let ignoreUnavailable = self.ignoreUnavailable {
            params.append(.init(name: .ignoreUnavailable, value: ignoreUnavailable))
        }
        if let allowNoIndices = self.allowNoIndices {
            params.append(.init(name: .allowNoIndices, value: allowNoIndices))
        }
        if let expandWildcards = self.expandWildcards {
            params.append(.init(name: .expandWildcards, value: expandWildcards.rawValue))
        }
        return params
    }

    public var method: HTTPMethod {
        return .POST
    }

    public var endPoint: String {
        var _endPoint = "_rank_eval"
        if let indices = self.indices, !indices.isEmpty {
            _endPoint = indices.joined(separator: ",") + "/" + _endPoint
        }
        return _endPoint
    }

    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return serializer.encode(rankEvalSpec).mapError { error -> MakeBodyError in
            .wrapped(error)
        }
    }
}

extension RankEvalRequest: Equatable {}

// MARK: - RankEvalSpec

public struct RankEvalSpec {
    public let ratedRequests: [RatedRequest]
    public let metric: EvaluationMetric
    public var maxConcurrentSearches: Int?
    public var templates: [ScriptWithId]?

    public init(request: [RatedRequest], metric: EvaluationMetric, maxConcurrentSearches: Int? = nil, templates: [ScriptWithId]? = nil) {
        ratedRequests = request
        self.metric = metric
        self.maxConcurrentSearches = maxConcurrentSearches
        self.templates = templates
    }
}

extension RankEvalSpec: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ratedRequests = try container.decode([RatedRequest].self, forKey: .ratedRequests)
        templates = try container.decodeIfPresent([ScriptWithId].self, forKey: .templates)
        maxConcurrentSearches = try container.decodeIntIfPresent(forKey: .maxConcurrentSearches)
        metric = try container.decodeEvaluationMetric(forKey: .metric)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ratedRequests, forKey: .ratedRequests)
        try container.encode(metric, forKey: .metric)
        try container.encodeIfPresent(maxConcurrentSearches, forKey: .maxConcurrentSearches)
        if let templates = self.templates, templates.isEmpty {
            try container.encode(templates, forKey: .templates)
        }
    }

    enum CodingKeys: String, CodingKey {
        case ratedRequests = "requests"
        case metric
        case maxConcurrentSearches = "max_concurrent_searches"
        case templates
    }
}

extension RankEvalSpec: Equatable {
    public static func == (lhs: RankEvalSpec, rhs: RankEvalSpec) -> Bool {
        return lhs.ratedRequests == rhs.ratedRequests &&
            isEqualEvaluationMetrics(lhs.metric, rhs.metric)
            && lhs.maxConcurrentSearches == rhs.maxConcurrentSearches
            && lhs.templates == rhs.templates
    }
}

/// Wrapper for Scripts with Id
public struct ScriptWithId {
    public let id: String
    public let script: Script
}

extension ScriptWithId: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case script = "template"
    }
}

extension ScriptWithId: Equatable {}

// MARK: - Rated Request

public struct RatedRequest {
    public let id: String
    public let summaryFields: [String]
    public let ratedDocs: [String]

    public let templateId: String?

    public let params: [String: CodableValue]

    public let evaluationRequest: SearchSource?
}

extension RatedRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case evaluationRequest = "request"
        case ratedDocs = "ratings"
        case templateId = "template_id"
        case params
        case summaryFields = "summary_fields"
    }
}

extension RatedRequest: Equatable {}

// MARK: -  Evaluation Metric

public protocol EvaluationMetric: Codable {
    /// Type of EvaluationMetric
    var type: EvaluationMetricType { get }

    func isEqualTo(_ other: EvaluationMetric) -> Bool
}

public extension EvaluationMetric where Self: Equatable {
    func isEqualTo(_ other: EvaluationMetric) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

public enum EvaluationMetricType: String, Codable {
    case precision
    case meanReciprocalRank = "mean_reciprocal_rank"
    case discountedCumulativeGain = "dcg"
    case expectedReciprocalRank = "expected_reciprocal_rank"

    var metaType: EvaluationMetric.Type {
        switch self {
        case .precision:
            return PrecisionAtK.self
        case .meanReciprocalRank:
            return MeanReciprocalRank.self
        case .discountedCumulativeGain:
            return DiscountedCumulativeGain.self
        case .expectedReciprocalRank:
            return ExpectedReciprocalRank.self
        }
    }

    var detailsMetaType: MetricDetail.Type {
        switch self {
        case .precision:
            return PrecisionAtK.Details.self
        case .meanReciprocalRank:
            return MeanReciprocalRank.Details.self
        case .discountedCumulativeGain:
            return DiscountedCumulativeGain.Details.self
        case .expectedReciprocalRank:
            return ExpectedReciprocalRank.Details.self
        }
    }
}

/// A helper function compares two queries wrapped as optional
public func isEqualEvaluationMetrics(_ lhs: EvaluationMetric?, _ rhs: EvaluationMetric?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    if let lhs = lhs, let rhs = rhs {
        return lhs.isEqualTo(rhs)
    }
    return false
}

// MARK: - Precision@K

/// Metric implementing [Precision@K](https://en.wikipedia.org/wiki/Information_retrieval#Precision_at_K)
///
/// By default documents with a rating equal or bigger than 1 are considered to
/// be "relevant" for this calculation. This value can be changes using the
/// relevant_rating_threshold` parameter.<br>
/// The `ignore_unlabeled` parameter (default to false) controls if unrated
/// documents should be ignored.
/// The `k` parameter (defaults to 10) controls the search window size.
public struct PrecisionAtK: EvaluationMetric {
    public let type: EvaluationMetricType = .precision
    /// Controls how unlabeled documents in the search hits are treated.
    /// Set to 'true', unlabeled documents are ignored and neither count
    /// as true or false positives. Set to 'false', they are treated as false positives.
    public let ignoreUnlabeled: Bool?
    /// ratings equal or above this value will be considered relevant.
    public let relevantRatingThreshhold: Int?
    /// the search window size
    public let k: Int?

    /// Initializes Precision@K Metric
    /// - Parameters:
    ///   - threshold: ratings equal or above this value will be considered relevant.
    ///   - ignoreUnlabeled: Controls how unlabeled documents in the search hits are treated.
    ///                      Set to 'true', unlabeled documents are ignored and neither count
    ///                      as true or false positives. Set to 'false', they are treated as false positives.
    ///   - k: controls the window size for the search results the metric takes into account
    public init(threshold: Int?, ignoreUnlabeled: Bool?, k: Int?) {
        relevantRatingThreshhold = threshold
        self.ignoreUnlabeled = ignoreUnlabeled
        self.k = k
    }
}

public extension PrecisionAtK {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        ignoreUnlabeled = try nested.decodeBoolIfPresent(forKey: .ignoreUnlabeled)
        k = try nested.decodeIntIfPresent(forKey: .k)
        relevantRatingThreshhold = try nested.decodeIntIfPresent(forKey: .relevantRatingThreshhold)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encodeIfPresent(k, forKey: .k)
        try nested.encodeIfPresent(ignoreUnlabeled, forKey: .ignoreUnlabeled)
        try nested.encodeIfPresent(relevantRatingThreshhold, forKey: .relevantRatingThreshhold)
    }

    internal enum CodingKeys: String, CodingKey {
        case ignoreUnlabeled = "ignore_unlabeled"
        case relevantRatingThreshhold = "relevant_rating_threshold"
        case k
    }
}

extension PrecisionAtK: Equatable {}

// MARK: - Mean Reciprocal Rank

/// Metric implementing [Mean Reciprocal Rank](https://en.wikipedia.org/wiki/Mean_reciprocal_rank).
///
/// By default documents with a rating equal or bigger than 1 are considered to be "relevant" for the reciprocal
/// rank calculation. This value can be changes using the relevant_rating_threshold` parameter.
public struct MeanReciprocalRank: EvaluationMetric {
    public let type: EvaluationMetricType = .meanReciprocalRank

    /// the search window size
    public let k: Int?
    /// ratings equal or above this value will be considered relevant
    public let relevantRatingThreshhold: Int?
}

public extension MeanReciprocalRank {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        relevantRatingThreshhold = try nested.decodeIntIfPresent(forKey: .relevantRatingThreshhold)
        k = try nested.decodeIntIfPresent(forKey: .k)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encodeIfPresent(k, forKey: .k)
        try nested.encodeIfPresent(relevantRatingThreshhold, forKey: .relevantRatingThreshhold)
    }

    internal enum CodingKeys: String, CodingKey {
        case k
        case relevantRatingThreshhold = "relevant_rating_threshold"
    }
}

extension MeanReciprocalRank: Equatable {}

// MARK: - Discounted Cumulative Gain (DCG)

/// Metric implementing [Discounted Cumulative Gain] (https://en.wikipedia.org/wiki/Discounted_cumulative_gain#Discounted_Cumulative_Gain)
///
/// The `normalize` parameter can be set to calculate the normalized NDCG (set to {@code false} by default)
/// The optional `unknown_doc_rating` parameter can be used to specify a default rating for unlabeled documents.
public struct DiscountedCumulativeGain: EvaluationMetric {
    public let type: EvaluationMetricType = .discountedCumulativeGain

    /// the search window size all request use
    public let k: Int?
    /// If set to true, the dcg will be normalized (ndcg)
    public let normalize: Bool?
    /// Optional. If set, this will be the rating for docs that are unrated in the ranking evaluation request
    public let unknownDocRating: Int?
}

public extension DiscountedCumulativeGain {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        normalize = try nested.decodeBoolIfPresent(forKey: .normalize)
        k = try nested.decodeIntIfPresent(forKey: .k)
        unknownDocRating = try nested.decodeIntIfPresent(forKey: .unknownDocRating)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encodeIfPresent(k, forKey: .k)
        try nested.encodeIfPresent(normalize, forKey: .normalize)
    }

    internal enum CodingKeys: String, CodingKey {
        case k
        case normalize
        case unknownDocRating = "unknown_doc_rating"
    }
}

extension DiscountedCumulativeGain: Equatable {}

// MARK: - Expected Reciprocal Rank (ERR)

public struct ExpectedReciprocalRank: EvaluationMetric {
    public let type: EvaluationMetricType = .expectedReciprocalRank

    public let k: Int?
    public let maxRelevance: Int
}

public extension ExpectedReciprocalRank {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        maxRelevance = try nested.decodeInt(forKey: .maxRelevance)
        k = try nested.decodeIntIfPresent(forKey: .k)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encodeIfPresent(k, forKey: .k)
        try nested.encode(maxRelevance, forKey: .maxRelevance)
    }

    internal enum CodingKeys: String, CodingKey {
        case k
        case maxRelevance = "maximum_relevance"
    }
}

extension ExpectedReciprocalRank: Equatable {}

// MARK: - Metric Detail

public protocol MetricDetail: Codable {
    var type: EvaluationMetricType { get }

    func isEqualTo(_ other: MetricDetail) -> Bool
}

public extension MetricDetail where Self: Equatable {
    func isEqualTo(_ other: MetricDetail) -> Bool {
        if let o = other as? Self {
            return self == o
        }
        return false
    }
}

/// A helper function compares two queries wrapped as optional
public func isEqualMetricDetails(_ lhs: MetricDetail?, _ rhs: MetricDetail?) -> Bool {
    if lhs == nil, rhs == nil {
        return true
    }
    if let lhs = lhs, let rhs = rhs {
        return lhs.isEqualTo(rhs)
    }
    return false
}

public extension PrecisionAtK {
    struct Details: MetricDetail {
        public let type: EvaluationMetricType = .precision
        public let relevantRetrieved: Int
        public let retrieved: Int
    }
}

public extension PrecisionAtK.Details {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        relevantRetrieved = try nested.decodeInt(forKey: .relevantRetrieved)
        retrieved = try nested.decodeInt(forKey: .retrived)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encode(retrieved, forKey: .retrived)
        try nested.encode(relevantRetrieved, forKey: .relevantRetrieved)
    }

    internal enum CodingKeys: String, CodingKey {
        case retrived = "docs_retrieved"
        case relevantRetrieved = "relevant_docs_retrieved"
    }
}

extension PrecisionAtK.Details: Equatable {}

public extension MeanReciprocalRank {
    struct Details: MetricDetail {
        public let type: EvaluationMetricType = .meanReciprocalRank

        public let firstRelevantRank: Int
    }
}

extension MeanReciprocalRank.Details: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        firstRelevantRank = try nested.decodeInt(forKey: .firstRelevantRank)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encode(firstRelevantRank, forKey: .firstRelevantRank)
    }

    enum CodingKeys: String, CodingKey {
        case firstRelevantRank = "first_relevant"
    }
}

extension MeanReciprocalRank.Details: Equatable {}

public extension DiscountedCumulativeGain {
    struct Details: MetricDetail {
        public var type: EvaluationMetricType = .discountedCumulativeGain

        public let dcg: Decimal
        public let idcg: Decimal?
        public let unratedDocs: Int
    }
}

public extension DiscountedCumulativeGain.Details {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        dcg = try nested.decodeDecimal(forKey: .dcg)
        idcg = try nested.decodeDecimalIfPresent(forKey: .idcg)
        unratedDocs = try nested.decodeInt(forKey: .unratedDocs)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encode(dcg, forKey: .dcg)
        try nested.encode(idcg, forKey: .idcg)
        try nested.encode(unratedDocs, forKey: .unratedDocs)
    }

    internal enum CodingKeys: String, CodingKey {
        case dcg
        case idcg = "ideal_dcg"
        case unratedDocs = "unrated_docs"
    }
}

extension DiscountedCumulativeGain.Details: Equatable {}

public extension ExpectedReciprocalRank {
    struct Details: MetricDetail {
        public let type: EvaluationMetricType = .expectedReciprocalRank
        public let unratedDocs: Int
    }
}

extension ExpectedReciprocalRank.Details: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        let nested = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))

        unratedDocs = try nested.decodeInt(forKey: .unratedDocs)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        var nested = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .key(named: type.rawValue))
        try nested.encode(unratedDocs, forKey: .unratedDocs)
    }

    enum CodingKeys: String, CodingKey {
        case unratedDocs = "unrated_docs"
    }
}

extension ExpectedReciprocalRank.Details: Equatable {}

// MARK: - Codable Extenstions

public extension KeyedEncodingContainer {
    mutating func encode(_ value: EvaluationMetric, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    mutating func encode(_ value: MetricDetail, forKey key: KeyedEncodingContainer<K>.Key) throws {
        try value.encode(to: superEncoder(forKey: key))
    }

    mutating func encode(_ value: [EvaluationMetric], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let metricsEncoder = superEncoder(forKey: key)
        var metricsContainer = metricsEncoder.unkeyedContainer()
        for metric in value {
            let metricEncoder = metricsContainer.superEncoder()
            try metric.encode(to: metricEncoder)
        }
    }

    mutating func encode(_ value: [MetricDetail], forKey key: KeyedEncodingContainer<K>.Key) throws {
        let detailsEncoder = superEncoder(forKey: key)
        var detailsContainer = detailsEncoder.unkeyedContainer()
        for detail in value {
            let detailEncoder = detailsContainer.superEncoder()
            try detail.encode(to: detailEncoder)
        }
    }

    mutating func encodeIfPresent(_ value: EvaluationMetric?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }

    mutating func encodeIfPresent(_ value: MetricDetail?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }

    mutating func encodeIfPresent(_ value: [MetricDetail]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}

public extension KeyedDecodingContainer {
    func decodeEvaluationMetric(forKey key: KeyedDecodingContainer<K>.Key) throws -> EvaluationMetric {
        let mContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for mKey in mContainer.allKeys {
            if let mType = EvaluationMetricType(rawValue: mKey.stringValue) {
                return try mType.metaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(EvaluationMetricType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify evaluation metric type from key(s) \(mContainer.allKeys)"))
    }

    func decodeMetricDetail(forKey key: KeyedDecodingContainer<K>.Key) throws -> MetricDetail {
        let mContainer = try nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
        for mKey in mContainer.allKeys {
            if let mType = EvaluationMetricType(rawValue: mKey.stringValue) {
                return try mType.detailsMetaType.init(from: superDecoder(forKey: key))
            }
        }
        throw Swift.DecodingError.typeMismatch(EvaluationMetricType.self, .init(codingPath: codingPath, debugDescription: "Unable to identify evaluation metric type from key(s) \(mContainer.allKeys)"))
    }

    func decodeEvaluationMetricIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> EvaluationMetric? {
        guard contains(key) else {
            return nil
        }
        return try decodeEvaluationMetric(forKey: key)
    }

    func decodeMetricDetailIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> MetricDetail? {
        guard contains(key) else {
            return nil
        }
        return try decodeMetricDetail(forKey: key)
    }

    func decodeEvaluationMetrics(forKey key: KeyedDecodingContainer<K>.Key) throws -> [EvaluationMetric] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [EvaluationMetric]()
        if let count = arrayContainer.count {
            var iterations = 0
            while !arrayContainer.isAtEnd {
                var copy = arrayContainer
                let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
                for mKey in elementContainer.allKeys {
                    if let mType = EvaluationMetricType(rawValue: mKey.stringValue) {
                        let m = try mType.metaType.init(from: arrayContainer.superDecoder())
                        result.append(m)
                    }
                }
                iterations += 1
                if iterations > count {
                    break
                }
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all EvaluationMetrics expected: \(count) actual: \(result.count). Probable cause: Unable to determine EvaluationMetricType form key(s)"))
            }
        }
        return result
    }

    func decodeMetricDetails(forKey key: KeyedDecodingContainer<K>.Key) throws -> [MetricDetail] {
        var arrayContainer = try nestedUnkeyedContainer(forKey: key)
        var result = [MetricDetail]()
        if let count = arrayContainer.count {
            var iterations = 0
            while !arrayContainer.isAtEnd {
                var copy = arrayContainer
                let elementContainer = try copy.nestedContainer(keyedBy: DynamicCodingKeys.self)
                for mKey in elementContainer.allKeys {
                    if let mType = EvaluationMetricType(rawValue: mKey.stringValue) {
                        let m = try mType.detailsMetaType.init(from: arrayContainer.superDecoder())
                        result.append(m)
                    }
                }
                iterations += 1
                if iterations > count {
                    break
                }
            }
            if result.count != count {
                throw Swift.DecodingError.dataCorrupted(.init(codingPath: arrayContainer.codingPath, debugDescription: "Unable to decode all EvaluationMetrics expected: \(count) actual: \(result.count). Probable cause: Unable to determine EvaluationMetricType form key(s)"))
            }
        }
        return result
    }

    func decodeEvaluationMetricsIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [EvaluationMetric]? {
        guard contains(key) else {
            return nil
        }
        return try decodeEvaluationMetrics(forKey: key)
    }

    func decodeMetricDetailsIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> [MetricDetail]? {
        guard contains(key) else {
            return nil
        }
        return try decodeMetricDetails(forKey: key)
    }
}
