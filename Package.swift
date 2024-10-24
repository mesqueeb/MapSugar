// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MapSugar",
  platforms: [.macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)],
  products: [.library(name: "MapSugar", targets: ["MapSugar"])],
  targets: [
    .target(name: "MapSugar", swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
    .testTarget(name: "MapSugarTests", dependencies: ["MapSugar"]),
  ]
)
