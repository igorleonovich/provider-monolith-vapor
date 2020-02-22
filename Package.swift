// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ProviderServer",
    products: [
        .library(name: "ProviderServer", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        // 💙 ProviderSDK
        .package(url: "git@github.com:igorleonovich/ProviderSDK.git", from: "1.0.0"),
        // 📘 SPM
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor", "ProviderSDK", "SPMUtility"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
