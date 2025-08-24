// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HelloExecWeb",
    platforms: [.macOS(.v11)],
    dependencies: [
        .package(path: "../../../elixirkit_swift")
    ],
    targets: [
        .executableTarget(
            name: "HelloExecWeb",
            dependencies: [
                .product(name: "ElixirKit", package: "elixirkit_swift")
            ]
        )
    ]
)
