// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SynqtSDK",
    defaultLocalization: "en",
    // macOS only so the package builds and its tests run on a Mac; the payment sheet is presented on iOS.
    platforms: [.iOS(.v15), .macOS(.v12)],
    // The module is SynqtSDK, not Synqt, so apps can write SynqtSDK.Money: a module named like its Synqt type can't be qualified.
    products: [.library(name: "SynqtSDK", targets: ["SynqtSDK"])],
    targets: [
        .target(name: "SynqtSDK", resources: [.process("Resources")]),
        .testTarget(name: "SynqtSDKTests", dependencies: ["SynqtSDK"]),
    ]
)
