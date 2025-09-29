// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwipeToPopApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SwipeToPopApp",
            targets: ["SwipeToPopApp"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        .target(
            name: "SwipeToPopApp",
            dependencies: [],
            path: "SwipeToPopApp",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "SwipeToPopAppTests",
            dependencies: ["SwipeToPopApp"],
            path: "Tests"
        ),
    ]
)