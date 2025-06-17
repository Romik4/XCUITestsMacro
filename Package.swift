// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ReturnSelfMacro",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Product 1: The library that exposes the macro to client code.
        .library(
            name: "ReturnSelfMacro", // e.g., `import ReturnSelfMacro`
            targets: ["ReturnSelfMacro"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        // Target 1: The actual macro implementation (CompilerPlugin).
        .macro(
            name: "ReturnSelfMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Sources/ReturnSelfMacroMacros"
        ),

        // Target 2: The library target that *re-exports* the macro.
        .target(
            name: "ReturnSelfMacro",
            dependencies: ["ReturnSelfMacroMacros"],
            path: "Sources/ReturnSelfMacro"
        ),

        // Target 3: The test target for the macro implementation.
        .testTarget(
            name: "ReturnSelfMacroTests",
            dependencies: [
                "ReturnSelfMacroMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            path: "Tests/ReturnSelfMacroTests"
        ),
    ]
)
