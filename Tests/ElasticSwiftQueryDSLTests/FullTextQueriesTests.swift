//
//  FullTextQueriesTests.swift
//  ElasticSwiftQueryDSLTests
//
//
//  Created by Prafull Kumar Soni on 3/31/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftQueryDSL

class FullTextQueriesTest: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.FullTextQueriesTest", factory: logFactory)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        logger.info("====================TEST=END===============================")
    }

    func test_01_matchQuery_encode() throws {
        let query = MatchQuery(field: "message", value: "ny city", autoGenSynonymnsPhraseQuery: false)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "match" : {
                "message": {
                    "query" : "ny city",
                    "auto_generate_synonyms_phrase_query" : false
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_02_matchQuery_decode() throws {
        let query = try QueryBuilders.matchQuery().set(field: "message")
            .set(value: "to be or not to be")
            .set(operator: .and)
            .set(zeroTermQuery: .all)
            .build()

        let jsonStr = """
        {
            "match" : {
                "message" : {
                    "query" : "to be or not to be",
                    "operator" : "and",
                    "zero_terms_query": "all"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_03_matchQuery_decode_2() throws {
        let query = try QueryBuilders.matchQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .build()

        let jsonStr = """
        {
            "match" : {
                "message" : "this is a test"
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_04_matchQuery_decode_fail() throws {
        let jsonStr = """
        {
            "match" : {
                "message" : "this is a test",
                "invalid_key" : "random"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(MatchQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(MatchQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }

    func test_05_matchPhraseQuery_encode() throws {
        let query = MatchPhraseQuery(field: "message", value: "this is a test", analyzer: "my_analyzer")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "match_phrase" : {
                "message" : {
                    "query" : "this is a test",
                    "analyzer" : "my_analyzer"
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_06_matchPhraseQuery_decode() throws {
        let query = try QueryBuilders.matchPhraseQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .set(analyzer: "my_analyzer")
            .build()

        let jsonStr = """
        {
            "match_phrase" : {
                "message" : {
                    "query" : "this is a test",
                    "analyzer" : "my_analyzer"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhraseQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_07_matchPhraseQuery_decode_2() throws {
        let query = try QueryBuilders.matchPhraseQuery()
            .set(field: "message")
            .set(value: "this is a test")
            .build()

        let jsonStr = """
        {
            "match_phrase" : {
                "message" : "this is a test"
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhraseQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_08_matchPhraseQuery_decode_fail() throws {
        let jsonStr = """
        {
            "match_phrase" : {
                "message" : "this is a test",
                "invalid_key": "random"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(MatchPhraseQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(MatchPhraseQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }

    func test_09_matchPhrasePrefixQuery_encode() throws {
        let query = MatchPhrasePrefixQuery(field: "message", value: "quick brown f", maxExpansions: 10)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "match_phrase_prefix" : {
                "message" : {
                    "query" : "quick brown f",
                    "max_expansions" : 10
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_10_matchPhrasePrefixQuery_decode() throws {
        let query = try QueryBuilders.matchPhrasePrefixQuery()
            .set(field: "message")
            .set(value: "quick brown f")
            .set(maxExpansions: 10)
            .build()

        let jsonStr = """
        {
            "match_phrase_prefix" : {
                "message" : {
                    "query" : "quick brown f",
                    "max_expansions" : 10
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhrasePrefixQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_11_matchPhrasePrefixQuery_decode_2() throws {
        let query = try QueryBuilders.matchPhrasePrefixQuery()
            .set(field: "message")
            .set(value: "quick brown f")
            .build()

        let jsonStr = """
        {
            "match_phrase_prefix" : {
                "message" : "quick brown f"
            }
        }
        """

        let decoded = try JSONDecoder().decode(MatchPhrasePrefixQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_12_matchPhrasePrefixQuery_decode_fail() throws {
        let jsonStr = """
        {
            "match_phrase_prefix" : {
                "message" : "quick brown f",
                "invalid_key": "random"
            }
        }
        """

        XCTAssertThrowsError(try JSONDecoder().decode(MatchPhrasePrefixQuery.self, from: jsonStr.data(using: .utf8)!), "invalid_key in json") { error in
            if let error = error as? Swift.DecodingError {
                switch error {
                case let .typeMismatch(type, context):
                    XCTAssertEqual("\(MatchPhrasePrefixQuery.self)", "\(type)")
                    XCTAssertEqual(context.debugDescription, "Unable to find field name in key(s) expect: 1 key found: 2.")
                default:
                    XCTAssert(false)
                }
            }
        }
    }

    func test_13_multiMatchQuery_encode() throws {
        let query = MultiMatchQuery(query: "this is a test", fields: ["subject", "message"], tieBreaker: nil, type: nil)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "multi_match" : {
              "query":    "this is a test",
              "fields": [ "subject", "message" ]
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_14_multiMatchQuery_decode() throws {
        let query = try QueryBuilders.multiMatchQuery()
            .set(query: "brown fox")
            .set(fields: "subject", "message")
            .set(tieBreaker: 0.3)
            .set(type: .bestFields)
            .build()

        let jsonStr = """
        {
            "multi_match" : {
              "query":      "brown fox",
              "type":       "best_fields",
              "fields":     [ "subject", "message" ],
              "tie_breaker": 0.3
            }
        }
        """

        let decoded = try JSONDecoder().decode(MultiMatchQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_15_multiMatchQuery_decode_2() throws {
        let query = try QueryBuilders.multiMatchQuery()
            .add(field: "subject^3")
            .add(field: "message")
            .set(query: "this is a test")
            .build()

        let jsonStr = """
        {
            "multi_match" : {
              "query" : "this is a test",
              "fields" : [ "subject^3", "message" ]
            }
        }
        """

        let decoded = try JSONDecoder().decode(MultiMatchQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_16_commonTermsQuery_encode() throws {
        let query = CommonTermsQuery(query: "this is bonsai cool", cutoffFrequency: 0.001)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "common": {
                "body": {
                    "query": "this is bonsai cool",
                    "cutoff_frequency": 0.001
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_17_commonTermsQuery_decode() throws {
        let query = try QueryBuilders.commonTermsQuery()
            .set(query: "nelly the elephant as a cartoon")
            .set(cutoffFrequency: 0.001)
            .set(minimumShouldMatch: 2)
            .build()

        let jsonStr = """
        {
            "common": {
                "body": {
                    "query": "nelly the elephant as a cartoon",
                    "cutoff_frequency": 0.001,
                    "minimum_should_match": 2
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(CommonTermsQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_18_commonTermsQuery_decode_2() throws {
        let query = try QueryBuilders.commonTermsQuery()
            .set(query: "nelly the elephant not as a cartoon")
            .set(cutoffFrequency: 0.001)
            .set(minimumShouldMatchLowFreq: 2)
            .set(minimumShouldMatchHighFreq: 3)
            .build()

        let jsonStr = """
        {
            "common": {
                "body": {
                    "query": "nelly the elephant not as a cartoon",
                    "cutoff_frequency": 0.001,
                    "minimum_should_match": {
                        "low_freq" : 2,
                        "high_freq" : 3
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(CommonTermsQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_19_commonTermsQuery_decode_3() throws {
        let query = try QueryBuilders.commonTermsQuery()
            .set(query: "nelly the elephant not as a cartoon")
            .set(cutoffFrequency: 0.001)
            .set(lowFrequencyOperator: .and)
            .set(highFrequencyOperator: .or)
            .set(minimumShouldMatchLowFreq: 2)
            .set(minimumShouldMatchHighFreq: 3)
            .build()

        let jsonStr = """
        {
            "common": {
                "body": {
                    "query": "nelly the elephant not as a cartoon",
                    "cutoff_frequency": 0.001,
                    "low_freq_operator": "and",
                    "high_freq_operator": "or",
                    "minimum_should_match": {
                        "low_freq" : 2,
                        "high_freq" : 3
                    }
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(CommonTermsQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_20_commonTermsQuery_encode_2() throws {
        let query = CommonTermsQuery(query: "nelly the elephant not as a cartoon", cutoffFrequency: 0.001, minimumShouldMatchLowFreq: 2, minimumShouldMatchHighFreq: 3)

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "common": {
                "body": {
                    "query": "nelly the elephant not as a cartoon",
                    "cutoff_frequency": 0.001,
                    "minimum_should_match": {
                        "low_freq" : 2,
                        "high_freq" : 3
                    }
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_21_queryStringQuery_encode() throws {
        let query = QueryStringQuery("(content:this OR name:this) AND (content:that OR name:that)")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "query_string": {
                "query": "(content:this OR name:this) AND (content:that OR name:that)"
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_22_queryStringQuery_encode_2() throws {
        let query = try QueryBuilders.queryStringQuery()
            .set(query: "this OR that OR thus")
            .set(minimumShouldMatch: 2)
            .set(boost: 1)
            .set(type: .bestFields)
            .set(autoGenerateSynonymsPhraseQuery: false)
            .set(tieBreaker: 0)
            .set(fields: ["title", "content"])
            .set(lenient: false)
            .set(analyzer: "test_analyzer")
            .set(timeZone: "UTC")
            .set(fuzziness: "fuzz")
            .set(phraseSlop: 1)
            .set(defaultField: "test")
            .set(quoteAnalyzer: "quote_analyzer")
            .set(analyzeWildcard: true)
            .set(defaultOperator: "OR")
            .set(quoteFieldSuffix: "s")
            .set(fuzzyTranspositions: false)
            .set(allowLeadingWildcard: true)
            .set(fuzzyPrefixLength: 1)
            .set(fuzzyMaxExpansions: 2)
            .set(maxDeterminizedStates: 4)
            .set(enablePositionIncrements: false)
            .set(autoGeneratePhraseQueries: false)
            .build()

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "query_string": {
                "fields": [
                    "title",
                    "content"
                ],
                "query": "this OR that OR thus",
                "minimum_should_match": 2,
                "type": "best_fields",
                "tie_breaker" : 0,
                "auto_generate_synonyms_phrase_query" : false,
                "boost": 1,
                "lenient": false,
                "analyzer": "test_analyzer",
                "time_zone": "UTC",
                "fuzziness": "fuzz",
                "phrase_slop": 1,
                "default_field": "test",
                "quote_analyzer": "quote_analyzer",
                "analyze_wildcard": true,
                "default_operator": "OR",
                "quote_field_suffix": "s",
                "fuzzy_transpositions": false,
                "allow_leading_wildcard": true,
                "fuzzy_prefix_length": 1,
                "fuzzy_max_expansions": 2,
                "max_determinized_states": 4,
                "enable_position_increments": false,
                "auto_generate_phrase_queries": false
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_23_queryStringQuery_decode() throws {
        let query = try QueryBuilders.queryStringQuery()
            .set(query: "this OR that OR thus")
            .set(fields: ["title", "content"])
            .set(type: .crossFields)
            .set(tieBreaker: 0)
            .set(autoGenerateSynonymsPhraseQuery: false)
            .set(minimumShouldMatch: 2)
            .build()

        let jsonStr = """
        {
            "query_string": {
                "fields": [
                    "title",
                    "content"
                ],
                "query": "this OR that OR thus",
                "minimum_should_match": 2,
                "type": "cross_fields",
                "tie_breaker" : 0,
                "auto_generate_synonyms_phrase_query" : false
            }
        }
        """

        let decoded = try JSONDecoder().decode(QueryStringQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_24_queryStringQuery_decode_2() throws {
        let query = try QueryBuilders.queryStringQuery()
            .set(query: "this OR that OR thus")
            .set(minimumShouldMatch: 2)
            .set(boost: 1)
            .set(type: .bestFields)
            .set(autoGenerateSynonymsPhraseQuery: false)
            .set(tieBreaker: 0)
            .set(fields: ["title", "content"])
            .set(lenient: false)
            .set(analyzer: "test_analyzer")
            .set(timeZone: "UTC")
            .set(fuzziness: "fuzz")
            .set(phraseSlop: 1)
            .set(defaultField: "test")
            .set(quoteAnalyzer: "quote_analyzer")
            .set(analyzeWildcard: true)
            .set(defaultOperator: "OR")
            .set(quoteFieldSuffix: "s")
            .set(fuzzyTranspositions: false)
            .set(allowLeadingWildcard: true)
            .set(fuzzyPrefixLength: 1)
            .set(fuzzyMaxExpansions: 2)
            .set(maxDeterminizedStates: 4)
            .set(enablePositionIncrements: false)
            .set(autoGeneratePhraseQueries: false)
            .build()

        let jsonStr = """
        {
            "query_string": {
                "fields": [
                    "title",
                    "content"
                ],
                "query": "this OR that OR thus",
                "minimum_should_match": 2,
                "type": "best_fields",
                "tie_breaker" : 0,
                "auto_generate_synonyms_phrase_query" : false,
                "boost": 1,
                "lenient": false,
                "analyzer": "test_analyzer",
                "time_zone": "UTC",
                "fuzziness": "fuzz",
                "phrase_slop": 1,
                "default_field": "test",
                "quote_analyzer": "quote_analyzer",
                "analyze_wildcard": true,
                "default_operator": "OR",
                "quote_field_suffix": "s",
                "fuzzy_transpositions": false,
                "allow_leading_wildcard": true,
                "fuzzy_prefix_length": 1,
                "fuzzy_max_expansions": 2,
                "max_determinized_states": 4,
                "enable_position_increments": false,
                "auto_generate_phrase_queries": false
            }
        }
        """

        let decoded = try JSONDecoder().decode(QueryStringQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_25_simpleQueryStringQuery_encode() throws {
        let query = SimpleQueryStringQuery(query: "foo bar -baz", fields: ["content"], defaultOperator: "and")

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "simple_query_string" : {
                "fields" : ["content"],
                "query" : "foo bar -baz",
                "default_operator" : "and"
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_26_simpleQueryStringQuery_encode_2() throws {
        let query = try QueryBuilders.simpleQueryStringQuery()
            .set(query: "this is a test")
            .set(minimumShouldMatch: 2)
            .set(autoGenerateSynonymsPhraseQuery: false)
            .set(fields: "test", "test2")
            .set(lenient: false)
            .set(flags: "OR|AND|PREFIX")
            .set(analyzer: "test_analyzer")
            .set(defaultOperator: "OR")
            .set(quoteFieldSuffix: "s")
            .set(fuzzyTranspositions: false)
            .set(fuzzyPrefixLength: 1)
            .set(fuzzyMaxExpansions: 2)
            .build()

        let data = try JSONEncoder().encode(query)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "simple_query_string" : {
                "fields" : ["test", "test2"],
                "query" : "this is a test",
                "default_operator" : "OR",
                "minimum_should_match": 2,
                "auto_generate_synonyms_phrase_query": false,
                "lenient": false,
                "flags": "OR|AND|PREFIX",
                "analyzer": "test_analyzer",
                "quote_field_suffix": "s",
                "fuzzy_transpositions": false,
                "fuzzy_prefix_length": 1,
                "fuzzy_max_expansions": 2
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_27_simpleQueryStringQuery_decode() throws {
        let query = SimpleQueryStringQuery(query: "foo bar -baz", fields: ["content"], defaultOperator: "and")

        let jsonStr = """
        {
            "simple_query_string" : {
                "fields" : ["content"],
                "query" : "foo bar -baz",
                "default_operator" : "and"
            }
        }
        """

        let decoded = try JSONDecoder().decode(SimpleQueryStringQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }

    func test_28_simpleQueryStringQuery_decode_2() throws {
        let query = try QueryBuilders.simpleQueryStringQuery()
            .set(query: "this is a test")
            .set(minimumShouldMatch: 2)
            .set(autoGenerateSynonymsPhraseQuery: false)
            .set(fields: "test", "test2")
            .set(lenient: false)
            .set(flags: "OR|AND|PREFIX")
            .set(analyzer: "test_analyzer")
            .set(defaultOperator: "OR")
            .set(quoteFieldSuffix: "s")
            .set(fuzzyTranspositions: false)
            .set(fuzzyPrefixLength: 1)
            .set(fuzzyMaxExpansions: 2)
            .build()

        let jsonStr = """
        {
            "simple_query_string" : {
                "fields" : ["test", "test2"],
                "query" : "this is a test",
                "default_operator" : "OR",
                "minimum_should_match": 2,
                "auto_generate_synonyms_phrase_query": false,
                "lenient": false,
                "flags": "OR|AND|PREFIX",
                "analyzer": "test_analyzer",
                "quote_field_suffix": "s",
                "fuzzy_transpositions": false,
                "fuzzy_prefix_length": 1,
                "fuzzy_max_expansions": 2
            }
        }
        """

        let decoded = try JSONDecoder().decode(SimpleQueryStringQuery.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(query, decoded)
    }
}
