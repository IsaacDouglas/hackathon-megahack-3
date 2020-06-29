// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hackathon-megahack-3",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(name: "PerfectHTTPServer", url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(name: "ControllerSwift", url: "https://github.com/IsaacDouglas/ControllerSwift.git", from: "0.0.0"),
        .package(name: "PerfectSQLite", url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", from: "5.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "hackathon-megahack-3",
            dependencies: ["PerfectHTTPServer", "ControllerSwift", "PerfectSQLite"]),
        .testTarget(
            name: "hackathon-megahack-3Tests",
            dependencies: ["hackathon-megahack-3"]),
    ]
)
