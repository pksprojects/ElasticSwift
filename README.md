# ElasticSwift

[![Build Status](https://travis-ci.org/pksprojects/ElasticSwift.svg?branch=master)](https://travis-ci.org/pksprojects/ElasticSwift)
[![codecov](https://codecov.io/gh/pksprojects/ElasticSwift/branch/master/graph/badge.svg)](https://codecov.io/gh/pksprojects/ElasticSwift)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Supported Platforms](https://img.shields.io/badge/platform-iOS%7CmacOS%7CtvOS%7Clinux-lightgrey?style=flat)](https://github.com/pksprojects/ElasticSwift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ElasticSwift.svg)](https://cocoapods.org/pods/ElasticSwift)

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
    pod 'ElasticSwift', '~> 1.0.0-beta.1'
    pod 'ElasticSwiftCore', '~> 1.0.0-beta.1'
    pod 'ElasticSwiftQueryDSL', '~> 1.0.0-beta.1'
    pod 'ElasticSwiftCodableUtils', '~> 1.0.0-beta.1'
    pod 'ElasticSwiftNetworking', '~> 1.0.0-beta.1'
end
```

`Note:- ElasticSwiftNetworkingNIO is not available as a pod`

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but ElasticSwift does support its use on supported platforms.

Once you have your Swift package set up, adding ElasticSwift as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/pksprojects/ElasticSwift.git", from: "1.0.0-beta.1")
]
```

and then adding the appropriate ElasticSwift module(s) to your target dependencies.
The syntax for adding target dependencies differs slightly between Swift
versions. For example, if you want to depend on the `ElasticSwift` and `ElasticSwiftCore`
modules, specify the following dependencies:

#### Swift 5.0 and 5.1 (`swift-tools-version:5.[01]`)

```swift
    dependencies: ["ElasticSwift", "ElasticSwiftCore"]
```

#### Swift 5.2 (`swift-tools-version:5.2`)

```swift
    dependencies: [.product(name: "ElasticSwift", package: "elastic-swift"),
                   .product(name: "ElasticSwiftCore", package: "elastic-swift")]
```

## Usage

### Client

Creating `Settings` & `ElasticClient`.

Using `ElasticSwiftNetworking` (`URLSession` based implementation)

```swift
import ElasticSwift
import ElasticSwiftNetworking

var settings = Settings(forHost: "http://localhost:9200", adaptorConfig: URLSessionAdaptorConfiguration.default) // Creates default settings for client
var client = ElasticClient(settings: settings) // Creates client with specified settings

```
Using `ElasticSwiftNetworkingNIO` (`SwiftNIO/AsyncHTTPClient` based implementation)

```swift
import ElasticSwift
import ElasticSwiftNetworkingNIO

var settings = Settings(forHost: "http://localhost:9200", adaptorConfig: AsyncHTTPClientAdaptorConfiguration.default) // Creates default settings for client
var client = ElasticClient(settings: settings) // Creates client with specified settings

```

Add Elasticsearch credentials 

```swift

let cred = BasicClientCredential(username: "elastic", password: "elastic")
let settings = Settings(forHost: "http://localhost:9200", withCredentials: cred, adaptorConfig: AsyncHTTPClientAdaptorConfiguration.default)

```

Configuring SSL when using `ElasticSwiftNetworking`

```swift

let certPath = "/path/to/certificate.der"
let sslConfig = SSLConfiguration(certPath: certPath, isSelf: true)
let adaptorConfig = URLSessionAdaptorConfiguration(sslConfig: sslConfig)
let settings = Settings(forHosts: ["https://samplehost:port"], withCredentials: cred, adaptorConfig: adaptorConfig)

```

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
let createIndexRequest = CreateIndexRequest("indexName")
client.indices.create(createIndexRequest, completionHandler: createHandler) // executes request

// delete index
func deleteHandler(_ result: Result<AcknowledgedResponse, Error>) -> Void {
    switch result {
        case .failure(let error):
            print("Error", error)
        case .success(let response):
            print("Response", response)
    }
}

let deleteIndexRequest = DeleteIndexRequest("indexName")
client.indices.delete(deleteIndexRequest, completionHandler: deleteHandler) // executes request

```

### Document

Document CRUD

```swift
class MyClass: Codable, Equatable {
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

let indexRequest = try IndexRequestBuilder<MyClass>()
        .set(index: "indexName")
        .set(type: "type")
        .set(id: "id")
        .set(source: mySource)
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

let getRequest = try GetRequestBuilder()
    .set(id: "id")
    .set(index: "indexName")
    .set(type: "type")
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

let deleteRequest = try DeleteRequestBuilder()
    .set(index: "indexName")
    .set(type: "type")
    .set(id: "id")
    .build()

client.delete(deleteRequest, completionHandler: deleteHandler)

```

### Query

Currently not all QueryBuilders are available. Future releases will add support for additional QueryBuilders. Check below for details

```swift

let builder = QueryBuilders.boolQuery()
let mustMatch = try QueryBuilders.matchQuery().set(field: "fieldName").set(value: "value").build()
let mustNotMatch = try QueryBuilders.matchQuery().set(field: "someFieldName").set(value: "value").build()
builder.must(query: mustMatch)
builder.mustNot(query: mustNotMatch)
let boolQuery = try builder.build()
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
let match = try QueryBuilders.matchQuery().set(field: "msg").set(value: "Message").build() 
queryBuilder.must(query: match)

let query =  try queryBuilder.build()

let sort =  SortBuilders.fieldSort("msg") // use "msg.keyword" as field name in case of text field
    .set(order: .asc)
    .build()

let request = try SearchRequestBuilder()
        .set(indices: "indexName")
        .set(types: "type")
        .set(query: query)
        .add(sort: sort)
        .build()

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
| NestedQuery | NestedQueryBuilder | QueryBuilders.nestedQuery() |
| HasChildQuery | HasChildQueryBuilder | QueryBuilders.hasChildQuery() |
| HasParentQuery | HasParentQueryBuilder | QueryBuilders.hasParentQuery() |
| ParentIdQuery | ParentIdQueryBuilder | QueryBuilders.parentIdQuery() |
| GeoShapeQuery | GeoShapeQueryBuilder| QueryBuilders.geoShapeQuery() |
| GeoBoundingBoxQuery | GeoBoundingBoxQueryBuilder | QueryBuilders.geoBoundingBoxQuery() |
| GeoDistanceQuery | GeoDistanceQueryBuilder | QueryBuilders.geoDistanceQuery() |
| GeoPolygonQuery | GeoPolygonQueryBuilder | QueryBuilders.geoPolygonQuery() |
| MoreLikeThisQuery | MoreLikeThisQueryBuilder | QueryBuilders.moreLikeThisQuery() |
| ScriptQuery | ScriptQueryBuilder | QueryBuilders.scriptQuery() |
| PercolateQuery | PercoloteQueryBuilder | QueryBuilders.percolateQuery() |
| WrapperQuery | WrapperQueryBuilder | QueryBuilders.wrapperQuery() |
| SpanTermQuery | SpanTermQueryBuilder | QueryBuilders.spanTermQuery() |
| SpanMultiTermQuery | SpanMultiTermQueryBuilder | sQueryBuilders.panMultiTermQueryBuilder() |
| SpanFirstQuery | SpanFirstQueryBuilder | QueryBuilders.spanFirstQuery() |
| SpanNearQuery | SpanNearQueryBuilder | sQueryBuilders.panNearQuery() |
| SpanOrQuery | SpanOrQueryBuilder | QueryBuilders.spanOrQuery() |
| SpanNotQuery | SpanNotQueryBuilder | QueryBuilders.spanNotQuery() |
| SpanContainingQuery | SpanContainingQueryBuilder | QueryBuilders.spanContainingQuery() |
| SpanWithinQuery | SpanWithinQueryBuilder | QueryBuilders.spanWithinQuery() |
| SpanFieldMaskingQueryBuilder | SpanFieldMaskingQueryBuilder | QueryBuilders.fieldMaskingSpanQuery() |
