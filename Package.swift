// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Hawg",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "Hawg", targets: ["Hawg"]),
        .library(name: "HawgCore", targets: ["HawgCore"]),
    ],
    targets: [
        .executableTarget(
            name: "Hawg",
            dependencies: ["HawgCore"]
        ),
        .target(name: "HawgCore"),
        .testTarget(
            name: "HawgCoreTests",
            dependencies: ["HawgCore"]
        ),
    ]
)
