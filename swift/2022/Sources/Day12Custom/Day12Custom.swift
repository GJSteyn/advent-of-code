import Foundation

import Util

public struct Day12Custom {
    struct Tile: Equatable {
        let height: String
        var dist: Int

        init(height: String, dist: Int = Int.max) {
            self.height = height
            self.dist = dist
        }
    }

    private static func adjacentLetters(_ a: String, _ b: String) -> Bool {
        let innerA = a == "S" ? "a" : a == "E" ? "z" : a
        let innerB = b == "S" ? "a" : b == "E" ? "z" : b

        if innerA == innerB {
            return true
        }

        let alphabet = "abcdefghijklmnopqrstuvwxyz"

        let aIndex = alphabet.firstIndex(of: Character(innerA))!
        let bIndex = alphabet.firstIndex(of: Character(innerB))!
        let aDist = alphabet.distance(from: alphabet.startIndex, to: aIndex)
        let bDist = alphabet.distance(from: alphabet.startIndex, to: bIndex)

        if bDist > aDist {
            return true
        } else {
            return abs(aDist - bDist) == 1
        }
    }

    private static func getDistances(_ grid: Grid<Tile>, _ start: Point, _ prev: Point? = nil, _ count: Int = 0) -> Grid<Tile> {
        var currentTile = grid.at(start)!
        var gridCopy = grid

        if let previous = prev {
            let previousTile = grid.at(previous)!
            if abs(previousTile.dist - currentTile.dist) > 1 {
                gridCopy = gridCopy.set(Tile(height: currentTile.height, dist: previousTile.dist + 1), at: start)
                currentTile.dist = previousTile.dist + 1
            }
        }

        if let leftTile = gridCopy.at(start.left()) {
            if adjacentLetters(currentTile.height, leftTile.height) && leftTile.dist > currentTile.dist + 1 {
                gridCopy = getDistances(gridCopy, start.left(), start, count + 1)
            }
        }
        if let downTile = gridCopy.at(start.down()) {
            if adjacentLetters(currentTile.height, downTile.height) && downTile.dist > currentTile.dist + 1 {
                gridCopy = getDistances(gridCopy, start.down(), start, count + 1)
            }
        }
        if let upTile = gridCopy.at(start.up()) {
            if adjacentLetters(currentTile.height, upTile.height) && upTile.dist > currentTile.dist + 1 {
                gridCopy = getDistances(gridCopy, start.up(), start, count + 1)
            }
        }
        if let rightTile = gridCopy.at(start.right()) {
            if adjacentLetters(currentTile.height, rightTile.height) && rightTile.dist > currentTile.dist + 1 {
                gridCopy = getDistances(gridCopy, start.right(), start, count + 1)
            }
        }

        return gridCopy
    }

    public static func part1(input: String) -> Int {
        let inp = Util.getLines(input).map { Array($0).map(String.init).map { Tile(height: $0) } }
        let grid = Grid(elements: Array(inp.joined()), width: inp[0].count, height: inp.count)

        let endPos = grid.firstLocationWhere({ $0.height == "E" })!
        let grid2 = grid.set(Tile(height: "E", dist: 0), at: endPos)
        let finalGrid = getDistances(grid2, endPos)
        let startPos = finalGrid.firstLocationWhere({ $0.height == "S" })!

        return finalGrid.at(startPos)!.dist
    }

    public static func part2(input: String) -> Int {
        let inp = Util.getLines(input).map { Array($0).map(String.init).map { Tile(height: $0) } }
        let grid = Grid(elements: Array(inp.joined()), width: inp[0].count, height: inp.count)

        let endPos = grid.firstLocationWhere({ $0.height == "E" })!
        let grid2 = grid.set(Tile(height: "E", dist: 0), at: endPos)
        let finalGrid = getDistances(grid2, endPos)

        let starts = finalGrid.elements.filter { $0.height == "a" }
        return starts.min(by: { $0.dist < $1.dist })!.dist
    }
}
