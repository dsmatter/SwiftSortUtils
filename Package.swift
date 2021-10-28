// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftSortUtils",
    products: [
        .library(name: "SwiftSortUtils", targets: ["SwiftSortUtils"]),
    ],
    targets: [
        .target(
            name: "SwiftSortUtils",
            path: "Pod/Classes"
        )
    ],
    swiftLanguageVersions: [.v5]
)
