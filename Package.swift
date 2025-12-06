// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Teleprompter",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "Teleprompter", targets: ["Teleprompter"])
    ],
    targets: [
        .executableTarget(
            name: "Teleprompter",
            path: ".",
            exclude: ["README.md"] // Exclude non-swift files if any
        )
    ]
)
