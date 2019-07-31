# ElasticSwift

[![Build Status](https://travis-ci.org/pksprojects/ElasticSwift.svg?branch=master)](https://travis-ci.org/pksprojects/ElasticSwift)
[![codecov](https://codecov.io/gh/pksprojects/ElasticSwift/branch/master/graph/badge.svg)](https://codecov.io/gh/pksprojects/ElasticSwift)

## Project Status

This project is actively in developement, more information will be made available as project progresses.

If you'd like to contribute pull requests are welcome.

* Platform support for macOS, iOS & linux.

* Query DSL builders and helpers similar to elasticsearch Java client. Check the table below to see full list of avaiable QueryBuilders

## Project Goal

Our goal is to make a very Swifty and high-performant elasticsearch client.

High-performant means providing end user's response under 100ms not including the time elasticsearch took to process the request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.6.0+ is required to build ElasticSwift.

To integrate Elasticswift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ElasticSwift', '~> 1.0.0-alpha.9'
    pod 'ElasticSwiftCore', '~> 1.0.0-alpha.9'
    pod 'ElasticSwiftQueryDSL', '~> 1.0.0-alpha.9'
    pod 'ElasticSwiftCodableUtils', '~> 1.0.0-alpha.9'
    pod 'ElasticSwiftNetworking', '~> 1.0.0-alpha.9'
end
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but ElasticSwift does support its use on supported platforms.

Once you have your Swift package set up, adding ElasticSwift as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/pksprojects/ElasticSwift.git", from: "1.0.0-alpha.9")
]
```

## Usage

### Client

Creating `ElasticClient`.

```swift
import ElasticSwift

var settings = Settings.default // Creates default settings for client
var client = ElasticClient(settings: settings) // Creates client with specified settings

var client = ElasticClient() // Creates client with default settings

```

Creating `Settings` for specified host.

```swift

// with host address as string
var settings = Settings.default(forHost: "http://samplehost:port")

// with host address
var host = Host(string: "http://samplehost:port")
var settings = Settings(forHost: host, adaptorConfig: HTTPClientAdaptorConfiguration.default)

```

```swift

let cred = BasicClientCredential(username: "elastic", password: "elastic")
let certPath = "/path/to/certificate.der"
let sslConfig = SSLConfiguration(certPath: certPath, isSelf: true)
let adaptorConfig = URLSessionAdaptorConfiguration(sslConfig: sslConfig)
let settings = Settings(forHosts: ["https://samplehost:port"], withCredentials: cred, adaptorConfig: adaptorConfig)
let client = RestClient(settings: settings)

```

When creating default settings it creates settings for `http://localhost:9200`.

### Index

Create and Delete Index

```swift
func createHandler(_ result: Result<CreateIndexResponse, Error>) -> Void {
    switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
    }
}

// creating index
let createIndexRequest = CreateIndexRequest(name: "indexName")
client.indices.create(createIndexRequest, completionHandler: createHandler) // executes request

// delete index
func deleteHandler(_ response: DeleteIndexResponse?, _ error: Error?) -> Void {
    switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
    }
}

let deleteIndexRequest = DeleteIndexRequest(name: "indexName")
client.indices.delete(deleteIndexRequest, completionHandler: deleteHandler) // executes request

```

### Document

Document CRUD

```swift
class MyClass: Codable {
  var myField: String?
}

// index document
func indexHandler(_ result: Result<IndexResponse, Error>) -> Void {
    switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
    }
}

let mySource = MyClass()
mySource.myField = "My value"

let indexRequest = try IndexRequestBuilder<MyClass>() { builder in
            _ = builder.set(index: "indexName")
                .set(type: "type")
                .set(id: "id")
                .set(source: mySource)
        }
        .build()

client.index(indexRequest, completionHandler: indexHandler)

// get document
func getHandler(_ result: Result<GetResponse<MyClass>, Error>) -> Void {
    switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
    }
}

let getRequest = GetRequestBuilder<MyClass>() { builder in
            builder.set(id: "id")
                .set(index: "indexName")
                .set(type: "type")
        }
        .build()

client.get(getRequest, completionHandler: getHandler)

// delete document
func deleteHandler(_ result: Result<DeleteResponse, Error>) -> Void {
    switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
    }
}

let deleteRequest = try DeleteRequestBuilder() { builder in
        builder.set(index: "indexName")
                .set(type: "type")
                .set(id: "id")
    } .build()

client.delete(deleteRequest, completionHandler: deleteHandler)

```

### Query

Currently not all QueryBuilders are available. Future releases will add support for additional QueryBuilders. Check below for details

```swift

let builder = QueryBuilders.boolQuery()
let mustMatch = QueryBuilders.matchQuery().match(field: "fieldName", value: "value")
let mustNotMatch = QueryBuilders.matchQuery().match(field: "fieldName", value: "value")
builder.must(query: mustMatch)
builder.mustNot(query: mustNotMatch)

```

### Search

Creating simple search request.

```swift

func handler(_ result: Result<SearchResponse<Message>, Error>) -> Void {
    switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
    }
}

let queryBuilder = QueryBuilders.boolQuery()
let match = QueryBuilders.matchQuery().match(field: "myField", value: "MySearchValue")
queryBuilder.must(query: match)

let sort =  SortBuilders.fieldSort("msg") // use "msg.keyword" as field name in case of text field
    .set(order: .asc)
    .build()

let request = try SearchRequestBuilder() { builder in
            builder.set(indices: "indexName")
                .set(types: "type")
                .set(query: queryBuilder.query)
                .set(sort: sort)
        } .build()

client.search(request, completionHandler: handler)

```

### QueryDSL 

Below Table lists all the available search queries with their corresponding QueryBuilder class name and helper method name in the QueryBuilders utility class.

| Search Query | QueryBuilder Class | Method in QueryBuilders |
| :---         |     :---      |          :--- |
| ConstantScoreQuery | ConstantScoreQueryBuilder | QueryBuilders.constantScoreQuery() |
| BoolQuery | BoolQueryBuilder | QueryBuilders.boolQuery() |
| DisMaxQuery | DisMaxQueryBuilder | QueryBuilders.disMaxQuery() |
| FunctionScoreQuery | FunctionScoreQueryBuilder | QueryBuilders.functionScoreQuery() |
| BoostingQuery | BoostingQueryBuilder | QueryBuilders.boostingeQuery() |
| MatchQuery | MatchQueryBuilder | QueryBuilders.matchQuery() |
| MatchPhraseQuery | MatchPhraseQueryBuilder | QueryBuilders.matchPhraseQuery() |
| MatchPhrasePrefixQuery | MatchPhrasePrefixQueryBuilder | QueryBuilders.matchPhrasePrefixQuery() |
| MultiMatchQuery | MultiMatchQueryBuilder | QueryBuilders.multiMatchQuery() |
| CommonTermsQuery | CommonTermsQueryBuilder | QueryBuilders.commonTermsQuery() |
| QueryStringQuery | QueryStringQueryBuilder | QueryBuilders.queryStringQuery() |
| SimpleQueryStringQuery | SimpleQueryStringQueryBuilder | QueryBuilders.simpleQueryStringQuery() |
| MatchAllQuery | MatchAllQueryBuilder | QueryBuilders.matchAllQuery() |
| MatchNoneQuery | MatchNoneQueryBuilder | QueryBuilders.matchNoneQuery() |
| TermQuery | TermQueryBuilder | QueryBuilders.termQuery() |
| TermsQuery | TermsQueryBuilder | QueryBuilders.termsQuery() |
| RangeQuery | RangeQueryBuilder | QueryBuilders.rangeQuery() |
| ExistsQuery | ExistsQueryBuilder | QueryBuilders.existsQuery() |
| PrefixQuery | PrefixQueryBuilder | QueryBuilders.prefixQuery() |
| WildCardQuery | WildCardQueryBuilder | QueryBuilders.wildCardQuery() |
| RegexpQuery | RegexpQueryBuilder | QueryBuilders.regexpQuery() |
| FuzzyQuery | FuzzyQueryBuilder | QueryBuilders.fuzzyQuery() |
| TypeQuery | TypeQueryBuilder | QueryBuilders.typeQuery() |
| IdsQuery | IdsQueryBuilder | QueryBuilders.idsQuery() |

#### Note 

An overload for all the helper methods are available which that a closure to set builder properties.

```swift

public static func matchAllQuery() -> MatchAllQueryBuilder

public static func matchAllQuery(_ closure: (MatchAllQueryBuilder) -> Void) -> MatchAllQueryBuilder

let matchAll = QueryBuilders.matchAllQuery { builder in
    builder.boost = 1.2
}

```
