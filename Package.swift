// swift-tools-version: 5.6

import PackageDescription

let rswiftRepository = "https://github.com/quentinfasquel/R.swift"
let rswiftTag = "6.0.0-spm"
let checksum = "357e8982f00e17a8d40027a40c1e01cfd90d5345ce0e30ae16fe78cba49704a7"

let package = Package(
  name: "rswift-plugin",
  platforms: [
    .iOS(.v11),
    .macOS(.v10_11)
  ],
  products: [
    .plugin(
      name: "rswift-plugin",
      targets: ["rswift-plugin"]
    )
  ],
  targets: [
    .plugin(
      name: "rswift-plugin",
      capability: .buildTool(),
      dependencies: ["rswift"]
    ),
    .binaryTarget(
      name: "rswift",
      url: "\(rswiftRepository)/releases/download/\(rswiftTag)/rswift.artifactbundle.zip",
      checksum: checksum
    )
  ]
)
