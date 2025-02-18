// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Aegis",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Aegis",
            targets: ["Aegis"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tesseract-one/Blake2.swift.git", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.5.1")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Aegis",
            dependencies: [
                .product(name: "Blake2", package: "Blake2.swift"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "AegisTests",
            dependencies: ["Aegis"]
        )
    ]
)
