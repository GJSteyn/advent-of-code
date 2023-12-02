import Foundation

import Util

public struct Day18 {
    struct Point3D: Equatable, Hashable, Comparable, CustomDebugStringConvertible {
        let x: Int
        let y: Int
        let z: Int

        init(_ x: Int, _ y: Int, _ z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }

        static func == (lhs: Point3D, rhs: Point3D) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
        }

        static func < (lhs: Day18.Point3D, rhs: Day18.Point3D) -> Bool {
            if lhs.x != rhs.x {
                return lhs.x < rhs.x
            } else if lhs.y != rhs.y {
                return lhs.y < rhs.y
            } else {
                return lhs.z < rhs.z
            }
        }

        var hashValue: String {
            String(self.x) + String(self.y) + String(self.z)
        }

        var debugDescription: String {
            "3D(x: \(self.x), y: \(self.y), z: \(self.z))"
        }
    }

    public struct Cube: Equatable {
        let origin: Point3D
        var exposedFaces: Int = 6
        let type: String

        init(_ x: Int, _ y: Int, _ z: Int, _ type: String = "obsidian") {
            self.origin = Point3D(x, y, z)
            self.type = type
        }

        public func isAdjacentTo(_ other: Cube) -> Bool {
            (abs(self.origin.x - other.origin.x) == 1 && self.origin.y == other.origin.y && self.origin.z == other.origin.z)
            || (abs(self.origin.y - other.origin.y) == 1 && self.origin.x == other.origin.x && self.origin.z == other.origin.z)
            || (abs(self.origin.z - other.origin.z) == 1 && self.origin.x == other.origin.x && self.origin.y == other.origin.y)
        }

        public func isAdjacentToWater(_ other: Cube) -> Bool {
            return self.isAdjacentTo(other) && other.type == "water"
        }

        public static func == (lhs: Cube, rhs: Cube) -> Bool {
            lhs.origin == rhs.origin
        }
    }

    public static func part1(input: String) -> Int {
        let cubes = Util.getLines(input)
            .map { $0.components(separatedBy: ",").map { Int($0)! } }
            .map { Cube($0[0], $0[1], $0[2]) }

        let countedFaces = cubes.map { thisCube in
            let cubesWithoutThisOne = cubes.filter { $0 != thisCube }

            let overlappingFaces = cubesWithoutThisOne.map { otherCube in
                if thisCube.isAdjacentTo(otherCube) {
                    return 1
                } else {
                    return 0
                }
            }.reduce(0, +)
            var copyCube = thisCube
            copyCube.exposedFaces = copyCube.exposedFaces - overlappingFaces
            return copyCube
        }

        return countedFaces.reduce(0, { $0 + $1.exposedFaces })
    }

    private static func floodFill(_ map: [[[Cube?]]], from startCube: Cube = Cube(0, 0, 0, "water"), type: String = "water") -> [[[Cube?]]] {
        var mapCopy = map

        let depth = mapCopy.count
        let height = mapCopy[0].count
        let width = mapCopy[0][0].count

        let cOrigin = startCube.origin

        mapCopy[cOrigin.z][cOrigin.y][cOrigin.x] = startCube
        if (cOrigin.x + 1 < width && mapCopy[cOrigin.z][cOrigin.y][cOrigin.x + 1] == nil) {
            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
        }
        if (cOrigin.y + 1 < height && mapCopy[cOrigin.z][cOrigin.y + 1][cOrigin.x] == nil) {
            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x, cOrigin.y + 1, cOrigin.z, type))
        }
        if (cOrigin.z + 1 < depth && mapCopy[cOrigin.z + 1][cOrigin.y][cOrigin.x] == nil) {
            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x, cOrigin.y, cOrigin.z + 1, type))
        }

        if (cOrigin.x > 0) {
            if (mapCopy[cOrigin.z][cOrigin.y][cOrigin.x - 1] == nil) {
                mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x - 1, cOrigin.y, cOrigin.z, type))
            }
        }
        if (cOrigin.y > 0) {
            if (mapCopy[cOrigin.z][cOrigin.y - 1][cOrigin.x] == nil) {
                mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x, cOrigin.y - 1, cOrigin.z, type))
            }
        }
        if (cOrigin.z > 0) {
            if (mapCopy[cOrigin.z - 1][cOrigin.y][cOrigin.x] == nil) {
                mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x, cOrigin.y, cOrigin.z - 1, type))
            }
        }

        return mapCopy
    }

    private static func floodFillAir(_ map: [[[Cube?]]], from startCube: Cube = Cube(0, 0, 0, "tracer"), type: String = "tracer", replaceTracer: Bool = false) -> [[[Cube?]]] {
        var mapCopy = map

        let depth = mapCopy.count
        let height = mapCopy[0].count
        let width = mapCopy[0][0].count

        let cOrigin = startCube.origin

        if cOrigin.x > 0 {
            if let cb = map[cOrigin.z][cOrigin.y][cOrigin.x - 1] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                }
            }
        }
        if cOrigin.y > 0 {
            if let cb = map[cOrigin.z][cOrigin.y - 1][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                }
            }
        }
        if cOrigin.z > 0 {
            if let cb = map[cOrigin.z - 1][cOrigin.y][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                }
            }
        }

        if cOrigin.x + 1 < width {
            if let cb = map[cOrigin.z][cOrigin.y][cOrigin.x + 1] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                }
            }
        }
        if cOrigin.y + 1 < height {
            if let cb = map[cOrigin.z][cOrigin.y + 1][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                }
            }
        }
        if cOrigin.z + 1 < depth {
            if let cb = map[cOrigin.z + 1][cOrigin.y][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                }
            }
        }

        mapCopy[startCube.origin.z][startCube.origin.y][cOrigin.x] = startCube
        if (cOrigin.x + 1 < width && mapCopy[cOrigin.z][cOrigin.y][cOrigin.x + 1] == nil) {
            mapCopy = floodFillAir(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
        } else if (cOrigin.x + 1 < width && mapCopy[cOrigin.z][cOrigin.y][cOrigin.x + 1]!.type == "water") {
            print("WOOOOOOOOOAH!!!!!!", cOrigin)
//            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
        }
        if (cOrigin.y + 1 < height && mapCopy[cOrigin.z][cOrigin.y + 1][cOrigin.x] == nil) {
            mapCopy = floodFillAir(mapCopy, from: Cube(cOrigin.x, cOrigin.y + 1, cOrigin.z, type))
        } else if (cOrigin.y + 1 < width && mapCopy[cOrigin.z][cOrigin.y + 1][cOrigin.x]!.type == "water") {
            print("WOOOOOOOOOAH!!!!!!", cOrigin)
//            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
        }
        if (cOrigin.z + 1 < depth && mapCopy[cOrigin.z + 1][cOrigin.y][cOrigin.x] == nil) {
            mapCopy = floodFillAir(mapCopy, from: Cube(cOrigin.x, cOrigin.y, cOrigin.z + 1, type))
        } else if (cOrigin.z + 1 < width && mapCopy[cOrigin.z + 1][cOrigin.y][cOrigin.x]!.type == "water") {
            print("WOOOOOOOOOAH!!!!!!", cOrigin)
//            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
        }

        if (cOrigin.x > 0) {
            if (mapCopy[cOrigin.z][cOrigin.y][cOrigin.x - 1] == nil) {
                mapCopy = floodFillAir(mapCopy, from: Cube(cOrigin.x - 1, cOrigin.y, cOrigin.z, type))
            } else if (mapCopy[cOrigin.z][cOrigin.y][cOrigin.x - 1]!.type == "water") {
                print("WOOOOOOOOOAH!!!!!!", cOrigin)
                //            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
            }
        }
        if (cOrigin.y > 0) {
            if (mapCopy[cOrigin.z][cOrigin.y - 1][cOrigin.x] == nil) {
                mapCopy = floodFillAir(mapCopy, from: Cube(cOrigin.x, cOrigin.y - 1, cOrigin.z, type))
            } else if (mapCopy[cOrigin.z][cOrigin.y - 1][cOrigin.x]!.type == "water") {
                print("WOOOOOOOOOAH!!!!!!", cOrigin)
                //            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
            }
        }
        if (cOrigin.z > 0) {
            if (mapCopy[cOrigin.z - 1][cOrigin.y][cOrigin.x] == nil) {
                mapCopy = floodFillAir(mapCopy, from: Cube(cOrigin.x, cOrigin.y, cOrigin.z - 1, type))
            } else if (mapCopy[cOrigin.z - 1][cOrigin.y][cOrigin.x]!.type == "water") {
                print("WOOOOOOOOOAH!!!!!!", cOrigin)
                //            mapCopy = floodFill(mapCopy, from: Cube(cOrigin.x + 1, cOrigin.y, cOrigin.z, type))
            }
        }

        return mapCopy
    }

    private static func isTouchingWater(in map: [[[Cube?]]], _ cube: Cube) -> Bool {
        let cOrigin = cube.origin
        let depth = map.count
        let height = map[0].count
        let width = map[0][0].count

        if cOrigin.x > 0 {
            if let cb = map[cOrigin.z][cOrigin.y][cOrigin.x - 1] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                    return true
                }
            }
        }
        if cOrigin.y > 0 {
            if let cb = map[cOrigin.z][cOrigin.y - 1][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                    return true
                }
            }
        }
        if cOrigin.z > 0 {
            if let cb = map[cOrigin.z - 1][cOrigin.y][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                    return true
                }
            }
        }

        if cOrigin.x + 1 < width {
            if let cb = map[cOrigin.z][cOrigin.y][cOrigin.x + 1] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                    return true
                }
            }
        }
        if cOrigin.y + 1 < height {
            if let cb = map[cOrigin.z][cOrigin.y + 1][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                    return true
                }
            }
        }
        if cOrigin.z + 1 < depth {
            if let cb = map[cOrigin.z + 1][cOrigin.y][cOrigin.x] {
                if cb.type == "water" {
                    print("Wooah Nelly", cOrigin)
                    return true
                }
            }
        }

        return false
    }

    public static func part2(input: String) -> Int {
        let cubes = Util.getLines(input)
            .map { $0.components(separatedBy: ",").map { Int($0)! } }
            .map { Cube($0[0], $0[1], $0[2]) }

        let xMax = cubes.reduce(0, { (acc, current) in
            current.origin.x > acc ? current.origin.x : acc
        })
        let yMax = cubes.reduce(0, { (acc, current) in
            current.origin.y > acc ? current.origin.y : acc
        })
        let zMax = cubes.reduce(0, { (acc, current) in
            current.origin.z > acc ? current.origin.z : acc
        })

        let allMax = max(xMax, yMax, zMax) + 3

        var map: [[[Cube?]]] = [[[Cube?]]](repeating: [[Cube?]](repeating: [Cube?](repeating: nil, count: allMax), count: allMax), count: allMax)
        for cube in cubes {
            map[cube.origin.z][cube.origin.y][cube.origin.x] = cube
        }

        print("Cubes count from input:", cubes.count)
        print("Cubes in map:", map.joined().joined().compactMap { $0 }.count)

        print("Flood filling")
        let floodedMap = floodFill(map)
        print("Done")

        var count = 0
        var empties: [Cube] = []
        for z in 0..<floodedMap.count {
            for y in 0..<floodedMap[0].count {
                for x in 0..<floodedMap[0][0].count {
                    let cube = floodedMap[z][y][x]
                    if cube == nil {
                        count += 1
                        empties.append(Cube(x, y, z, "air"))
                    }

                }
            }
        }
        print("Obsidian after flooded:", floodedMap.joined().joined().compactMap { $0 }.filter { $0.type == "obsidian" }.count)
        let touchingWaters = empties.map { isTouchingWater(in: floodedMap, $0)}.filter { $0 }.count
        print("TouchingWaters:", touchingWaters)

        print("Empty spaces:", count)
//        print("Empties:", empties)

        var mapCopy = floodedMap

        for empty in empties {
            mapCopy = floodFillAir(mapCopy, from: Cube(empty.origin.x, empty.origin.y, empty.origin.z, "tracer"))
        }

        empties = []
        var countTracer = 0
        for z in 0..<floodedMap.count {
            for y in 0..<floodedMap[0].count {
                for x in 0..<floodedMap[0][0].count {
                    let cube = mapCopy[z][y][x]
                    if cube == nil {
                        empties.append(Cube(x, y, z, "air"))
                    } else if cube!.type == "tracer" {
                        countTracer += 1
                    }
                }
            }
        }
        print("Empties after filling gaps:", empties.count)
        print("Tracers after filling gaps:", countTracer)


        var countAdjacentWater = 0
        var countAdjacentEmpty = 0
        var countAdjacentObsidian = 0
        for z in 0..<floodedMap.count - 1 {
            for y in 0..<floodedMap[0].count - 1 {
                for x in 0..<floodedMap[0][0].count - 1 {
                    if let cube = floodedMap[z][y][x] {
                        if cube.type == "obsidian" {
                            if x > 0 {
                                if let cubeLeft = floodedMap[z][y][x - 1] {
                                    if cubeLeft.type == "water" {
                                        countAdjacentWater += 1
                                    } else {
                                        countAdjacentObsidian += 1
                                    }
                                } else {
                                    countAdjacentEmpty += 1
                                }
                            }
                            if let cubeRight = floodedMap[z][y][x + 1] {
                                if cubeRight.type == "water" {
                                    countAdjacentWater += 1
                                } else {
                                    countAdjacentObsidian += 1
                                }
                            } else {
                                countAdjacentEmpty += 1
                            }
                            if y > 0 {
                                if let cubeDown = floodedMap[z][y - 1][x] {
                                    if cubeDown.type == "water" {
                                        countAdjacentWater += 1
                                    } else {
                                        countAdjacentObsidian += 1
                                    }
                                } else {
                                    countAdjacentEmpty += 1
                                }
                            }
                            if let cubeUp = floodedMap[z][y + 1][x] {
                                if cubeUp.type == "water" {
                                    countAdjacentWater += 1
                                } else {
                                    countAdjacentObsidian += 1
                                }
                            } else {
                                countAdjacentEmpty += 1
                            }
                            if z > 0 {
                                if let cubeFront = floodedMap[z - 1][y][x] {
                                    if cubeFront.type == "water" {
                                        countAdjacentWater += 1
                                    } else {
                                        countAdjacentObsidian += 1
                                    }
                                } else {
                                    countAdjacentEmpty += 1
                                }
                            }
                            if let cubeBack = floodedMap[z + 1][y][x] {
                                if cubeBack.type == "water" {
                                    countAdjacentWater += 1
                                } else {
                                    countAdjacentObsidian += 1
                                }
                            } else {
                                countAdjacentEmpty += 1
                            }
                        }
                    }
                }
            }
        }

        let onlyObsidian = floodedMap.joined().joined().compactMap { $0 }.filter { $0.type == "obsidian" }
        let countWater = onlyObsidian.map { (cube) in
            let x = cube.origin.x
            let y = cube.origin.y
            let z = cube.origin.z
            var countInner = 0
            if x > 0 {
                if let cubeLeft = floodedMap[z][y][x - 1] {
                    if cubeLeft.type == "water" {
                        countInner += 1
                    }
                }
            } else {
                countInner += 1
            }
            if let cubeRight = floodedMap[z][y][x + 1] {
                if cubeRight.type == "water" {
                    countInner += 1
                }
            }
            if y > 0 {
                if let cubeDown = floodedMap[z][y - 1][x] {
                    if cubeDown.type == "water" {
                        countInner += 1
                    }
                }
            } else {
                countInner += 1
            }
            if let cubeUp = floodedMap[z][y + 1][x] {
                if cubeUp.type == "water" {
                    countInner += 1
                }
            }
            if z > 0 {
                if let cubeFront = floodedMap[z - 1][y][x] {
                    if cubeFront.type == "water" {
                        countInner += 1
                    }
                }
            } else {
                countInner += 1
            }
            if let cubeBack = floodedMap[z + 1][y][x] {
                if cubeBack.type == "water" {
                    countInner += 1
                }
            }

            return countInner
        }.reduce(0, +)

        print("Different Approach:", countWater)

        print()
        let totalObsidian = floodedMap.joined().joined().compactMap { $0 }.filter { $0.type == "obsidian" }.count
        print("Total obsidian:", totalObsidian)
        print("Total sides:", totalObsidian * 6)
        print()
        print("Adjacent Empties:", countAdjacentEmpty)
        print("Adjacent Obsidian:", countAdjacentObsidian)
        print("Adjacent Water", countAdjacentWater)
        print("Total counted sides:", countAdjacentEmpty + countAdjacentObsidian + countAdjacentWater)
        print()

        print("Using subtraction:", (totalObsidian * 6) - countAdjacentObsidian - countAdjacentEmpty)

        return (totalObsidian * 6) - countAdjacentObsidian - countAdjacentEmpty
    }
}
