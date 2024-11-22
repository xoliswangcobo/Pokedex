// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Pokedex",
    platforms: [
        .iOS(.v16), .macOS(.v13)
    ],
    products: [
        .library(
            name: "Pokedex",
            targets: ["Pokedex"]
        )
    ],
    dependencies: [
        // Add dependencies here
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Pokedex",
            dependencies: [
                // Add target dependencies here
                "SDWebImageSwiftUI"
            ],
            path: "Pokedex"
        ),
        .testTarget(
            name: "PokedexTests",
            dependencies: ["Pokedex"],
            path: "PokedexTests",
            plugins: [
                .plugin(name: "RunMockoloPlugin")
            ]
        ),
        .plugin(
            name: "RunMockoloPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "mockolo")]
        ),
        .binaryTarget(
            name: "mockolo",
            url: "https://github.com/uber/mockolo/releases/download/2.1.1/mockolo.artifactbundle.zip",
            checksum: "e3aa6e3aacec6b75ee971d7ba1ed326ff22372a8dc60a581cec742441cdbd9db"
        )
    ]
)
