// swift-tools-version:5.1

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
    ]
)
