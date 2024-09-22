// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherSDK",
    platforms: [
        .iOS(.v16) // Minimum iOS version set to 16.0
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WeatherSDK",
            targets: ["WeatherSDK"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WeatherSDK", swiftSettings: [
                .swiftLanguageMode(.v5)
            ]),
        .testTarget(
            name: "WeatherSDKTests",
            dependencies: ["WeatherSDK"]
        ),
    ]
)
