//
//  SuggestionTests.swift
//
//
//  Created by Prafull Kumar Soni on 11/26/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwift
@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftNetworkingNIO
@testable import ElasticSwiftQueryDSL

class SuggestionTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftTests.Requests.SuggestionTests", factory: logFactory)

    private let client = elasticClient

    private let indexName = "\(TEST_INDEX_PREFIX)_\(SuggestionTests.self)".lowercased()

    override func setUp() {
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<CreateIndexResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false)
            case let .success(response):
                XCTAssert(response.acknowledged, "\(response.acknowledged)")
                XCTAssert(response.index == indexName, "\(response.index)")
                XCTAssert(response.shardsAcknowledged, "\(response.shardsAcknowledged)")
            }
            e.fulfill()
        }
        let createIndexRequest = CreateIndexRequest(indexName)

        client.indices.create(createIndexRequest, completionHandler: handler)

        waitForExpectations(timeout: 10)
//        let cred = ClientCredential(username: "elastic", password: "elastic")
//        let ssl = SSLConfiguration(certPath: "/usr/local/Cellar/kibana/6.1.2/config/certs/elastic-certificates.der", isSelf: true)
//        let settings = Settings(forHosts: ["https://localhost:9200"], withCredentials: cred, withSSL: true, sslConfig: ssl)
//        self.client = RestClient(settings: settings)
    }

    override func tearDown() {
        super.tearDown()
        let e = expectation(description: "execution complete")
        func handler(_ result: Result<AcknowledgedResponse, Error>) {
            switch result {
            case let .failure(error):
                logger.error("Error: \(error)")
                XCTAssert(false, error.localizedDescription)
            case let .success(response):
                XCTAssert(response.acknowledged, "Acknowleged: \(response.acknowledged)")
            }
            e.fulfill()
        }
        let request = DeleteIndexRequest(indexName)

        client.indices.delete(request, completionHandler: handler)

        waitForExpectations(timeout: 10)
        logger.info("====================TEST=END===============================")
    }

    func test_01_termSuggestionBuilder() throws {
        let termSuggestion = try TermSuggestionBuilder()
            .set(text: "text")
            .set(size: 10)
            .set(sort: .frequency)
            .set(field: "field")
            .set(regex: "regex")
            .set(prefix: "prefix")
            .set(analyzer: "analyzer")
            .set(accuracy: 1.0)
            .set(maxEdits: 10)
            .set(maxInspections: 2)
            .set(shardSize: 5)
            .set(prefixLength: 3)
            .set(stringDistance: .damerauLevenshtein)
            .set(suggestMode: .always)
            .set(minDocFreq: 10)
            .set(maxTermFreq: 10)
            .set(minWordLength: 3)
            .build()

        XCTAssertEqual(termSuggestion.text, "text")
        XCTAssertEqual(termSuggestion.size, 10)
        XCTAssertEqual(termSuggestion.sort, .frequency)
        XCTAssertEqual(termSuggestion.field, "field")
        XCTAssertEqual(termSuggestion.regex, "regex")
        XCTAssertEqual(termSuggestion.prefix, "prefix")
        XCTAssertEqual(termSuggestion.analyzer, "analyzer")
        XCTAssertEqual(termSuggestion.accuracy, 1.0)
        XCTAssertEqual(termSuggestion.maxEdits, 10)
        XCTAssertEqual(termSuggestion.maxInspections, 2)
        XCTAssertEqual(termSuggestion.shardSize, 5)
        XCTAssertEqual(termSuggestion.prefixLength, 3)
        XCTAssertEqual(termSuggestion.stringDistance, .damerauLevenshtein)
        XCTAssertEqual(termSuggestion.suggestMode, .always)
        XCTAssertEqual(termSuggestion.minDocFreq, 10)
        XCTAssertEqual(termSuggestion.maxTermFreq, 10)
        XCTAssertEqual(termSuggestion.minWordLength, 3)
    }

    func test_02_termSuggestionBuilder_missing_field() throws {
        XCTAssertThrowsError(try TermSuggestionBuilder().build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? SuggestionBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_03_termSuggestionBuilder() throws {
        XCTAssertNoThrow(try TermSuggestionBuilder().set(field: "field").build(), "Should not throw")
    }

    func test_04_termSuggestion_decode() throws {
        let suggestion = try TermSuggestionBuilder()
            .set(field: "message")
            .set(text: "tring out Elasticsearch")
            .build()
        let jsonStr = """
            {
              "text" : "tring out Elasticsearch",
              "term" : {
                "field" : "message"
              }
            }
        """

        let decoded = try JSONDecoder().decode(TermSuggestion.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(suggestion, decoded)
    }

    func test_05_termSuggestion_encode() throws {
        let suggestion = try TermSuggestionBuilder()
            .set(field: "message")
            .set(text: "tring out Elasticsearch")
            .build()

        let data = try JSONEncoder().encode(suggestion)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
          "text" : "tring out Elasticsearch",
          "term" : {
            "field" : "message"
          }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }

    func test_06_phraseSuggestion_missing_field() throws {
        XCTAssertThrowsError(try PhraseSuggestionBuilder().build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? SuggestionBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_07_phraseSuggestion() throws {
        XCTAssertNoThrow(try PhraseSuggestionBuilder().set(field: "field").build(), "Should not throw")
    }

    func test_08_phraseSuggestion() throws {
        let suggestion = try PhraseSuggestionBuilder()
            .set(field: "field")
            .set(text: "text")
            .set(size: 10)
            .set(regex: "regex")
            .set(prefix: "prefix")
            .set(analyzer: "analyzer")
            .set(shardSize: 5)
            .set(collate: PhraseSuggestion.Collate(query: .init("script"), params: nil, purne: false))
            .set(separator: "separator")
            .set(highlight: PhraseSuggestion.Highlight(preTag: "pre-tag", postTag: "post-tag"))
            .set(smoothing: StupidBackoff(discount: 10.0))
            .set(maxErrors: 5)
            .set(confidence: 2.5)
            .set(gramSize: 3)
            .set(tokenLimit: 2)
            .set(forceUnigrams: false)
            .set(realWordErrorLikelihood: 0.5)
            .add(directGenerator: .init(field: "test1", suggestMode: "always"))
            .set(directGenerators: [PhraseSuggestion.DirectCandidateGenerator(field: "test1", suggestMode: "always")])
            .add(directGenerator: .init(field: "test2", suggestMode: "always"))
            .build()

        XCTAssertEqual(suggestion.field, "field")
        XCTAssertEqual(suggestion.text, "text")
        XCTAssertEqual(suggestion.size, 10)
        XCTAssertEqual(suggestion.regex, "regex")
        XCTAssertEqual(suggestion.prefix, "prefix")
        XCTAssertEqual(suggestion.analyzer, "analyzer")
        XCTAssertEqual(suggestion.shardSize, 5)
        XCTAssertEqual(suggestion.collate, PhraseSuggestion.Collate(query: .init("script"), params: nil, purne: false))
        XCTAssertEqual(suggestion.separator, "separator")
        XCTAssertEqual(suggestion.highlight, PhraseSuggestion.Highlight(preTag: "pre-tag", postTag: "post-tag"))
        XCTAssertTrue(suggestion.smoothing!.isEqualTo(StupidBackoff(discount: 10.0)))
        XCTAssertEqual(suggestion.maxErrors, 5)
        XCTAssertEqual(suggestion.confidence, 2.5)
        XCTAssertEqual(suggestion.gramSize, 3)
        XCTAssertEqual(suggestion.tokenLimit, 2)
        XCTAssertEqual(suggestion.forceUnigrams, false)
        XCTAssertEqual(suggestion.realWordErrorLikelihood, 0.5)
        XCTAssertEqual(suggestion.directGenerators, [PhraseSuggestion.DirectCandidateGenerator(field: "test1", suggestMode: "always"), .init(field: "test2", suggestMode: "always")])
    }

    func test_09_phraseSuggestion_decode() throws {
        let suggestion = try PhraseSuggestionBuilder()
            .set(field: "title.trigram")
            .set(highlight: PhraseSuggestion.Highlight(preTag: "<em>", postTag: "</em>"))
            .set(size: 1)
            .set(gramSize: 3)
            .set(directGenerators: [.init(field: "title.trigram", suggestMode: "always")])
            .set(smoothing: Laplace(alpha: 0.7))
            .build()
        let jsonStr = """
            {
              "phrase": {
                "field": "title.trigram",
                "size": 1,
                "gram_size": 3,
                "direct_generator": [
                  {
                    "field": "title.trigram",
                    "suggest_mode": "always"
                  }
                ],
                "highlight": {
                  "pre_tag": "<em>",
                  "post_tag": "</em>"
                },
                "smoothing" : {
                    "laplace" : {
                       "alpha" : 0.7
                    }
                }
              }
            }
        """

        let decoded = try JSONDecoder().decode(PhraseSuggestion.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(suggestion, decoded)
    }

    func test_10_phraseSuggestion_encode() throws {
        let suggestion = try PhraseSuggestionBuilder()
            .set(field: "title.trigram")
            .set(highlight: PhraseSuggestion.Highlight(preTag: "<em>", postTag: "</em>"))
            .set(size: 1)
            .set(gramSize: 3)
            .set(directGenerators: [.init(field: "title.trigram", suggestMode: "always")])
            .set(smoothing: Laplace(alpha: 0.7))
            .build()

        let data = try JSONEncoder().encode(suggestion)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
          "phrase": {
            "field": "title.trigram",
            "size": 1,
            "gram_size": 3,
            "direct_generator": [
              {
                "field": "title.trigram",
                "suggest_mode": "always"
              }
            ],
            "highlight": {
              "pre_tag": "<em>",
              "post_tag": "</em>"
            },
            "smoothing" : {
                "laplace" : {
                   "alpha" : 0.7
                }
            }
          }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_11_completionSuggestion_missing_field() throws {
        XCTAssertThrowsError(try CompletionSuggestionBuilder().build(), "Should not throw") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? SuggestionBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("field", field)
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }
    }

    func test_12_completionSuggestion() throws {
        XCTAssertNoThrow(try CompletionSuggestionBuilder().set(field: "field").build(), "Should not throw")
    }
    
    func test_13_completionSuggestion() throws {
        let suggestion = try CompletionSuggestionBuilder()
            .set(field: "field")
            .set(text: "text")
            .set(size: 10)
            .set(regex: "regex")
            .set(prefix: "prefix")
            .set(analyzer: "analyzer")
            .set(shardSize: 5)
            .set(skipDuplicates: true)
            .set(fuzzyOptions: CompletionSuggestion.FuzzyOptions())
            .set(regexOptions: CompletionSuggestion.RegexOptions())
            .build()

        XCTAssertEqual(suggestion.field, "field")
        XCTAssertEqual(suggestion.text, "text")
        XCTAssertEqual(suggestion.size, 10)
        XCTAssertEqual(suggestion.regex, "regex")
        XCTAssertEqual(suggestion.prefix, "prefix")
        XCTAssertEqual(suggestion.analyzer, "analyzer")
        XCTAssertEqual(suggestion.shardSize, 5)
        XCTAssertEqual(suggestion.skipDuplicates, true)
        XCTAssertEqual(suggestion.fuzzyOptions, .init())
        XCTAssertEqual(suggestion.regexOptions, .init())
    }
    
    func test_14_completionSuggestion_decode() throws {
        let suggestion = try CompletionSuggestionBuilder()
            .set(field: "suggest")
            .set(prefix: "nor")
            .set(skipDuplicates: true)
            .set(fuzzyOptions: CompletionSuggestion.FuzzyOptions(fuzziness: 2))
            .build()
        let jsonStr = """
        {
            "prefix" : "nor",
            "completion" : {
                "field" : "suggest",
                "skip_duplicates": true,
                "fuzzy" : {
                    "fuzziness" : 2
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(CompletionSuggestion.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(suggestion, decoded)
    }

    func test_15_completionSuggestion_encode() throws {
        let suggestion = try CompletionSuggestionBuilder()
            .set(field: "suggest")
            .set(prefix: "nor")
            .set(skipDuplicates: true)
            .set(fuzzyOptions: CompletionSuggestion.FuzzyOptions(fuzziness: 2))
            .build()

        let data = try JSONEncoder().encode(suggestion)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "prefix" : "nor",
            "completion" : {
                "field" : "suggest",
                "skip_duplicates": true,
                "fuzzy" : {
                    "fuzziness" : 2
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
    
    func test_16_completionSuggestion_decode_2() throws {
        let suggestion = try CompletionSuggestionBuilder()
            .set(field: "suggest")
            .set(regex: "n[ever|i]r")
            .set(regexOptions: CompletionSuggestion.RegexOptions(flags: CompletionSuggestion.RegexFlag.intersection))
            .build()
        let jsonStr = """
        {
            "regex" : "n[ever|i]r",
            "completion" : {
                "field" : "suggest",
                "regex" : {
                    "flags" : "INTERSECTION"
                }
            }
        }
        """

        let decoded = try JSONDecoder().decode(CompletionSuggestion.self, from: jsonStr.data(using: .utf8)!)

        XCTAssertEqual(suggestion, decoded)
    }

    func test_17_completionSuggestion_encode_2() throws {
        let suggestion = try CompletionSuggestionBuilder()
            .set(field: "suggest")
            .set(regex: "n[ever|i]r")
            .set(regexOptions: CompletionSuggestion.RegexOptions(flags: CompletionSuggestion.RegexFlag.intersection))
            .build()

        let data = try JSONEncoder().encode(suggestion)

        let encodedStr = String(data: data, encoding: .utf8)!

        logger.debug("Script Encode test: \(encodedStr)")

        let dic = try JSONDecoder().decode([String: CodableValue].self, from: data)

        let expectedDic = try JSONDecoder().decode([String: CodableValue].self, from: """
        {
            "regex" : "n[ever|i]r",
            "completion" : {
                "field" : "suggest",
                "regex" : {
                    "flags" : "INTERSECTION"
                }
            }
        }
        """.data(using: .utf8)!)
        XCTAssertEqual(expectedDic, dic)
    }
}
