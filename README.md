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
    pod 'ElasticSwift', '~> 1.0.0-alpha.1'
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
    .Package(url: "https://github.com/pksprojects/ElasticSwift.git", "1.0.0-alpha.1")
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
var settings = Settings(forHost: "http://eamplehost:port")

// with host address
var host = Host(string: "http://eamplehost:port")
var settings = Settings(forHost: host)

```

When creating default settings it creates settings for `http://localhost:9200`.

### Index

Create and Delete Index

```swift
func handler(_ response: ESResponse) -> Void {
  print(String(data: response.data!, encoding: .utf8 )!)
}

// creating index
let createIndexRequestBuilder = client.admin.indices().create()
            .set(name: "IndexName")
            .set(completionHandler: handler)
createIndexRequestBuilder.execute() // executes request

// delete index
let createIndexRequestBuilder = client.admin.indices().delete()
            .set(name: "IndexName")
            .set(completionHandler: handler)
createIndexRequestBuilder.execute() // executes request

```

### Document

Document CRUD

```swift
func handler(_ response: ESResponse) -> Void {
  print(String(data: response.data!, encoding: .utf8 )!)
}

let body: String = JSON(["test": "test"]).rawString()!

// index document
let indexRequestBuilder = client.prepareIndex()
            .set(index: "IndexName")
            .set(type: "type")
            .set(id: "id")
            .set(source: body)
            .set(completionHandler: handler)
indexRequestBuilder.execute()

// get document
let getRequestBuilder = client.prepareGet()
            .set(index: "IndexName")
            .set(type: "type")
            .set(id: "id")
            .set(completionHandler: handler)
getRequestBuilder.execute()

// delete document
let deleteRequestBuilder = client.prepareDelete()
            .set(index: "IndexName")
            .set(type: "type")
            .set(id: "id")
            .set(completionHandler: handler)
deleteRequestBuilder.execute()

```

### Query

Currently only `bool`, `match`, `match_all` and `match_none` are available. Future releases will support more query types.

```swift

let builder = QueryBuilders.boolQuery()
let mustMatch = QueryBuilders.matchQuery().match(field: "fieldName", value: "value")
let mustNotMatch = QueryBuilders.matchQuery().match(field: "fieldName", value: "value")
builder.must(query: mustMatch)
builder.mustNot(query: match)

```

### Search

Creating simple search request.

```swift

func handler(_ response: ESResponse) -> Void {
  print(String(data: response.data!, encoding: .utf8 )!)
  print(response.httpResponse!)
}
let builder = QueryBuilders.boolQuery()
let match = QueryBuilders.matchQuery().match(field: "fieldName", value: "value")
builder.must(query: match)
let requestBuilder = client.prepareSearch()
            .set(index: "IndexName")
            .set(type: "type")
            .set(builder: builder)
            .set(completionHandler: handler)
requestBuilder.execute()

```
