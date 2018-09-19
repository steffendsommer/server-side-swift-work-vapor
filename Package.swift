// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "server-side-swift-work-vapor",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.1"),

        .package(url: "https://github.com/nodes-vapor/flash.git", from: "3.0.0"),
        .package(url: "https://github.com/nodes-vapor/sugar.git", from: "3.0.0-beta"),
        .package(url: "https://github.com/nodes-vapor/submissions.git", from: "1.0.0-beta"),
        .package(url: "https://github.com/nodes-vapor/paginator.git", from: "3.0.0-beta"),
        .package(url: "https://github.com/nodes-vapor/bootstrap.git", from: "2.0.0"),
        .package(url: "https://github.com/steffendsommer/server-side-swift-work-shared.git", .branch("master")),
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            "FluentMySQL",
            "Leaf",
            "Flash",
            "Sugar",
            "Submissions",
            "Paginator",
            "Bootstrap",
            "ServerSideSwiftWorkShared"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
