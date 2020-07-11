// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Tremolo",
    platforms: [
        .iOS(.v14)
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
