// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "CryptoNetworking",
    products: [
        .library(
            name: "CryptoNetworking",
            targets: ["CryptoNetworking"]),
    ],
    targets: [
        .target(
            name: "CryptoNetworking"),
        .testTarget(
            name: "CryptoNetworkingTests",
            dependencies: ["CryptoNetworking"]
        ),
    ]
)
