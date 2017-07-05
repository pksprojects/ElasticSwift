// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ElasticSwift",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 16)
        ]
)
