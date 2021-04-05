// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "XCGrapherPluginSupport",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "XCGrapherPluginSupport", type: .dynamic, targets: ["XCGrapherPluginSupport"]),
    ],
    targets: [
        .target(
            name: "XCGrapherPluginSupport"
        ),
        .testTarget(
            name: "XCGrapherPluginSupportTests",
            dependencies: [
                "XCGrapherPluginSupport"
            ]
        ),
    ]
)
