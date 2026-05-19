// swift-tools-version: 6.3.1
/*
 * SPDX-FileCopyrightText: 2026 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: 0BSD
 */

import PackageDescription

let package = Package(
  name: "some",
  products: [
    // Products can be used to vend plugins, making them visible to other packages.
    .plugin(
      name: "some",
      targets: ["some"]
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .plugin(
      name: "some",
      capability: .command(intent: .custom(
        verb: "some",
        description: "prints hello world"
      ))
    ),
    //.executableTarget(name: "executable"),
    //.testTarget(name: "test"),
    //.target(name: "library")
    // kill XCode Version 26.5 (17F42):        .binaryTarget(name: "bin.zip", path: "./bin.zip"),
  ]
)

