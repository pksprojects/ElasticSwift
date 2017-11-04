// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ElasticSwift",
    products: [
        .library(name: "ElasticSwift", targets: ["ElasticSwift"]),
    ],
    targets: [
        .target(
            name: "ElasticSwift",
            dependencies: []),
        .testTarget(
            name: "ElasticSwiftTests",
            dependencies: ["ElasticSwift"]),
    ]
)
