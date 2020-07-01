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
        .package(name: "PerfectSession", url: "https://github.com/PerfectlySoft/Perfect-Session.git", from: "3.0.0"),
        .package(name: "PerfectMySQL", url: "https://github.com/IsaacDouglas/Perfect-MySQL.git", from: "3.5.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "hackathon-megahack-3",
            dependencies: ["PerfectHTTPServer", "ControllerSwift", "PerfectMySQL", "PerfectSession"]),
        .testTarget(
            name: "hackathon-megahack-3Tests",
            dependencies: ["hackathon-megahack-3"]),
    ]
)
