// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tremolo",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Tremolo",
            targets: ["Tremolo"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Tremolo",
            dependencies: [],
            path : "Tremolo"),
        .testTarget(
            name: "TremoloTests",
            dependencies: ["Tremolo"]),
    ]
)
