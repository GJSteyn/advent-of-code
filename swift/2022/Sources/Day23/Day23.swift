import Foundation

import Util

public struct Day23 {
    enum Tile: Character {
        case ground = "."
        case elf = "#"
    }

    enum Dir {
        case N, E, S, W
    }

    struct Proposal: Equatable {
        let from: Point
        let dest: Point
    }

    private static func printGrid(_ grid: [Point: Tile]) -> Void {
        let minX = grid.keys.map { $0.x }.min()!
        let maxX = grid.keys.map { $0.x }.max()!
        let minY = grid.keys.map { $0.y }.min()!
        let maxY = grid.keys.map { $0.y }.max()!

        for y in minY...maxY {
            for x in minX...maxX {
                if let tile = grid[Point(x: x, y: y)] {
                    print(tile.rawValue, terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }
    }

    private static func isClearAbove(in grid: [Point: Tile], from: Point) -> Bool {
        [Point(x: from.x - 1, y: from.y - 1),
         Point(x: from.x, y: from.y - 1),
         Point(x: from.x + 1, y: from.y - 1)].map {
            if let value = grid[$0] {
                return value == .ground
            } else {
                return true
            }
        }.allSatisfy { $0 == true }
    }

    private static func isClearBelow(in grid: [Point: Tile], from: Point) -> Bool {
        [Point(x: from.x - 1, y: from.y + 1),
         Point(x: from.x, y: from.y + 1),
         Point(x: from.x + 1, y: from.y + 1)].map {
            if let value = grid[$0] {
                return value == .ground
            } else {
                return true
            }
        }.allSatisfy { $0 == true }
    }

    private static func isClearLeft(in grid: [Point: Tile], from: Point) -> Bool {
        [Point(x: from.x - 1, y: from.y - 1),
         Point(x: from.x - 1, y: from.y),
         Point(x: from.x - 1, y: from.y + 1)].map {
            if let value = grid[$0] {
                return value == .ground
            } else {
                return true
            }
        }.allSatisfy { $0 == true }
    }

    private static func isClearRight(in grid: [Point: Tile], from: Point) -> Bool {
        [Point(x: from.x + 1, y: from.y - 1),
         Point(x: from.x + 1, y: from.y),
         Point(x: from.x + 1, y: from.y + 1)].map {
            if let value = grid[$0] {
                return value == .ground
            } else {
                return true
            }
        }.allSatisfy { $0 == true }
    }

    private static func allClear(in grid: [Point: Tile], from: Point) -> Bool {
        isClearAbove(in: grid, from: from)
        && isClearBelow(in: grid, from: from)
        && isClearLeft(in: grid, from: from)
        && isClearRight(in: grid, from: from)
    }

    private static func getProposals(_ grid: [Point: Tile], directions: [Dir]) -> [Proposal] {
        let dirChecks: [Dir: ([Point: Tile], Point) -> Bool] = [
            Dir.N: isClearAbove,
            Dir.S: isClearBelow,
            Dir.W: isClearLeft,
            Dir.E: isClearRight
        ]

        return grid.filter { $0.value == .elf }.map { (key: Point, value: Tile) in
            // Duplicating checks. Can be optimised.
            if allClear(in: grid, from: key) {
                return nil
            } else if let dir = directions.first(where: { dirChecks[$0]!(grid, key) == true }) {
                switch dir {
                case .N:
                    return Proposal(from: key, dest: Point(x: key.x, y: key.y - 1))
                case .S:
                    return Proposal(from: key, dest: Point(x: key.x, y: key.y + 1))
                case .W:
                    return Proposal(from: key, dest: Point(x: key.x - 1, y: key.y))
                case .E:
                    return Proposal(from: key, dest: Point(x: key.x + 1, y: key.y))
                }
            } else {
                return nil
            }
        }.compactMap { $0 }
    }

    private static func move(_ grid: [Point: Tile], from: Point, to: Point) -> [Point: Tile] {
        var innerGrid = grid
        innerGrid.updateValue(.ground, forKey: from)
        innerGrid.updateValue(.elf, forKey: to)
        return innerGrid
    }

    private static func processRound(_ grid: [Point: Tile], directions: [Dir]) -> [Point: Tile] {
        let proposals = getProposals(grid, directions: directions)

        let validProposals = proposals.filter { (prop: Proposal) in
            proposals.filter { $0.dest == prop.dest }.count < 2
        }

        let newGrid = validProposals.reduce(grid, { (acc: [Point: Tile], curr: Proposal) in
            move(acc, from: curr.from, to: curr.dest)
        })

        return newGrid
    }

    private static func countGround(in grid: [Point: Tile]) -> Int {
        let minX = grid.keys.map { $0.x }.min()!
        let maxX = grid.keys.map { $0.x }.max()!
        let minY = grid.keys.map { $0.y }.min()!
        let maxY = grid.keys.map { $0.y }.max()!

        var tally = 0
        for y in minY...maxY {
            for x in minX...maxX {
                if let tile = grid[Point(x: x, y: y)] {
                    if tile == .ground {
                        tally += 1
                    }
                } else {
                    tally += 1
                }
            }
        }

        return tally
    }

    public static func part1(input: String) -> Int {
        let inp = Util.getLines(input)
        var grid: [Point: Tile] = [:]
        inp.enumerated().forEach { (y: Int, element: String) in
            let line = Array(element)
            line.enumerated().forEach { (x: Int, element: Character) in
                grid.updateValue(Tile(rawValue: element)!, forKey: Point(x: x, y: y))
            }
        }

        var directions = [Dir.N, Dir.S, Dir.W, Dir.E]
        var processGrid: [Point: Tile] = grid
        for _ in 0..<10 {
            processGrid = processRound(processGrid, directions: directions)
            directions.append(directions[0])
            directions.removeFirst()
        }

        return countGround(in: processGrid)
    }

    public static func part2(input: String) -> Int {
        let inp = Util.getLines(input)
        var grid: [Point: Tile] = [:]
        inp.enumerated().forEach { (y: Int, element: String) in
            let line = Array(element)
            line.enumerated().forEach { (x: Int, element: Character) in
                grid.updateValue(Tile(rawValue: element)!, forKey: Point(x: x, y: y))
            }
        }

        var directions = [Dir.N, Dir.S, Dir.W, Dir.E]
        var processGrid: [Point: Tile] = grid
        var previousGrid: [Point: Tile] = grid
        for i in 0..<1000 {
            processGrid = processRound(processGrid, directions: directions)
            if previousGrid == processGrid {
                return i + 1
            } else {
                previousGrid = processGrid
            }
            directions.append(directions[0])
            directions.removeFirst()
        }

        return 42
    }
}
