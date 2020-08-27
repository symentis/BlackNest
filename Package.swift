// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlackNest",
    products: [
        .library(
            name: "BlackNest",
            targets: ["BlackNest"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BlackNest",
            dependencies: [],
            path: "BlackNest"
        ),
        .testTarget(
            name: "BlackNestTests",
            dependencies: ["BlackNest"],
            path: "BlackNestTests"
        ),
    ]
)
