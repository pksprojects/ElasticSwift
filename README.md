# ElasticSwift

## Project Status

This project is very early in developement, more information will be made available as project progresses.

If you'd like to contribute contact me via <support@pksprojects.org>

High level implementation Plan:

* Initial version of Transport Layer (Connections & Connection pool).

* Initial version of elasticsearch Request, Response & Exception Objects.

* Adding support for elasticsearch API's not necessarily in oder:
  * cat
  * cluster
  * indices
  * ingest
  * nodes
  * snapshot
  * task

* Stabilizing package and API's

* Platform support for macOS, iOS & linux.

* Query DSL builders and helpers similar to elasticsearch Java client.

## Project Goal

Our goal is to make a very Swifty and high-performant elasticsearch client.

High-performant means providing end user's response under 100ms not including the time elasticsearch took to process the request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.2.0+ is required to build ElasticSwift.

To integrate Elasticswift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ElasticSwift', '~> 1.0.0-alpha.5'
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
    .package(url: "https://github.com/pksprojects/ElasticSwift.git", "1.0.0-alpha.5")
]
```

## Usage

### Client

Creating `RestClient`.

```swift
import ElasticSwift

var settings = Settings.default // Creates default settings for client
var client = RestClient(settings: settings) // Creates client with specified settings

var client = RestClient() // Creates client with default settings

```

Creating `Settings` for specified host.

```swift

// with host address as string
var settings = Settings(forHost: "http://samplehost:port")

// with host address
var host = Host(string: "http://samplehost:port")
var settings = Settings(forHost: host)

```

```swift

let cred = ClientCredential(username: "elastic", password: "elastic")
let certPath = "/path/to/certificate.der"
let sslConfig = SSLConfiguration(certPath: certPath, isSelf: true)
let settings = Settings(forHosts: ["https://samplehost:port"], withCredentials: cred, withSSL: true, sslConfig: sslConfig)
let client = RestClient(settings: settings)

```

When creating default settings it creates settings for `http://localhost:9200`.

### Index

Create and Delete Index

```swift
func createHandler(_ response: CreateIndexResponse?, _ error: Error?) -> Void {
    if let error = error {
      print("Error", error)
    }
    if let response = response {
        print("Response", response)
    }
}

// creating index
let createRequest = self.client?.indicesAdmin().create()
            .set(name: "indexName")
            .set(completionHandler: createHandler)
            .build()
createRequest?.execute() // executes request

// delete index
func deleteHandler(_ response: DeleteIndexResponse?, _ error: Error?) -> Void {
    if let error = error {
        print("Error", error)
    }
    if let response = response {
        print("Response", response)
    }
}

let deleteRequest = try self.client?.indicesAdmin().delete()
    .set(name: "indexName")
    .set(completionHandler: deleteHandler)
    .build()
deleteRequest?.execute() // executes request

```

### Document

Document CRUD

```swift
class MyClass: Codable {
  var myField: String?
}

// index document
func indexHandler(_ response: IndexResponse?, _ error:  Error?) -> Void {
    if let error = error {
        print(error)
    }
    if let response = response {
        print("Response", response)
    }
}

let mySource = MyClass()
mySource.myField = "My value"

let indexRequest = try self.client?.makeIndex()
    .set(index: "indexName")
    .set(type: "type")
    .set(id: "id")
    .set(source: mySource)
    .set(completionHandler: indexHandler)
    .build()

indexRequest?.execute()

// get document
func getHandler(_ response: GetResponse<MyClass>?, _ error: Error?) -> Void {
    if let error = error {
        print(error)
    }
    if let response = response {
        print("Response", response)
    }
}

let getRequest = self.client?.makeGet()
    .set(index: "indexName")
    .set(type: "type")
    .set(id: "id")
    .set(completionHandler: getHandler)
    .build()

getRequest?.execute()

// delete document
func deleteHandler(_ response: DeleteResponse?, _ error:  Error?) -> Void {
    if let error = error {
        print(error)
    }
    if let response = response {
        print("Response", response)
    }
}

let deleteRequest = self.client?.makeDelete()
    .set(index: "indexName")
    .set(type: "type")
    .set(id: "id")
    .set(completionHandler: deleteHandler)
    .build()

deleteRequest?.execute()

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

func handler(_ response: SearchResponse<MyClass>?, _ error: Error?) -> Void {
    if let error = error {
        print("Error", error)
        return
    }
    print(response?.hits as Any)
}

let builder = QueryBuilders.boolQuery()
let match = QueryBuilders.matchQuery().match(field: "myField", value: "MySearchValue")
builder.must(query: match)

let sort =  SortBuilders.fieldSort("msg") // use "msg.keyword" as field name in case of text field
    .set(order: .asc)
    .build()

let request = try self.client?.makeSearch()
    .set(indices: "indexName")
    .set(types: "type")
    .set(query: builder.query)
    .set(sort: sort)
    .set(completionHandler: handler)
    .build()
request?.execute()

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
