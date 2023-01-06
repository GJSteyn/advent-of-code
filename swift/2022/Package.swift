// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2022",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.

        // In case you need an executable target. Remember to add the @main annotation and main() method to the class.
        //.executableTarget(
        //    name: "DayXX",
        //    dependencies: []),

        .target(
            name: "Util"),
        .target(
            name: "Day01",
            dependencies: []),
        .testTarget(
            name: "Day01Tests",
            dependencies: ["Day01"]),
        .target(
            name: "Day02",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day02Tests",
            dependencies: ["Day02"]),
        .target(
            name: "Day03",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day03Tests",
            dependencies: ["Day03"]),
        .target(
            name: "Day04",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day04Tests",
            dependencies: ["Day04"]),
        .target(
            name: "Day05",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day05Tests",
            dependencies: ["Day05"]),
        .target(
            name: "Day06",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day06Tests",
            dependencies: ["Day06"]),
        .target(
            name: "Day07",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day07Tests",
            dependencies: ["Day07"]),
        .target(
            name: "Day08",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day08Tests",
            dependencies: ["Day08"]),
        .target(
            name: "Day09",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day09Tests",
            dependencies: ["Day09"]),
        .target(
            name: "Day10",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day10Tests",
            dependencies: ["Day10"]),
        .target(
            name: "Day11",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day11Tests",
            dependencies: ["Day11"]),
        .target(
            name: "Day12",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day12Tests",
            dependencies: ["Day12", "Day12Custom"]),
        .target(
            name: "Day12Custom",
            dependencies: ["Util"]),
        .target(
            name: "Day13",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day13Tests",
            dependencies: ["Day13"]),
        .target(
            name: "Day14",
            dependencies: ["Util"]),
        .testTarget(
            name: "Day14Tests",
            dependencies: ["Day14"]),
    ]
)
