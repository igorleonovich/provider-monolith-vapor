// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ProviderServer",
    products: [
        .library(name: "ProviderServer", targets: ["App"]),
    ],
    dependencies: [
        // 📘 SPM
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0"),
        // 💧 Vapor
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // 🔵 PostgreSQL
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        // 💙 ProviderSDK
        .package(url: "git@github.com:igorleonovich/provider-sdk-swift.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["SPMUtility", "Vapor", "FluentPostgreSQL", "ProviderSDK"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
