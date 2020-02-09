// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "UI", targets: ["UI"]),
    ],
    targets: [
        .target(name: "UI", dependencies: [], path: "Sources")
    ],
    swiftLanguageVersions: [
        .version("5.2")
    ]
)
