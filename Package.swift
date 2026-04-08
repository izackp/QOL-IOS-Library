// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "QOL-iOS-Library",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "QOLiOSLibrary",
            targets: ["QOLiOSLibrary"]
        ),
        .library(
            name: "QOLiOSSwiftly",
            targets: ["QOLiOSSwiftly"]
        ),
    ],
    targets: [
        .target(
            name: "QOLiOSLibrary",
            path: "Sources/QOLiOSLibrary",
            publicHeadersPath: "include"
        ),
        .target(
            name: "QOLiOSSwiftly",
            path: "Sources/QOLiOSSwiftly"
        ),
    ]
)
