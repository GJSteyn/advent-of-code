import Foundation
import GameplayKit

import Util

public struct Day12 {
    struct Tile {
        let height: String
        let node: GKGraphNode
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

        if bDist < aDist {
            return true
        } else {
            return abs(aDist - bDist) == 1
        }
    }

    private static func joinNodes(in grid: Grid<Tile>) -> Grid<Tile> {
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                let tile = grid.at(x: x, y: y)!
                if let up = grid.at(x: x, y: y - 1) {
                    if adjacentLetters(tile.height, up.height) {
                        tile.node.addConnections(to: [up.node], bidirectional: false)
                    }
                }
                if let down = grid.at(x: x, y: y + 1) {
                    if adjacentLetters(tile.height, down.height) {
                        tile.node.addConnections(to: [down.node], bidirectional: false)
                    }
                }
                if let left = grid.at(x: x - 1, y: y) {
                    if adjacentLetters(tile.height, left.height) {
                        tile.node.addConnections(to: [left.node], bidirectional: false)
                    }
                }
                if let right = grid.at(x: x + 1, y: y) {
                    if adjacentLetters(tile.height, right.height) {
                        tile.node.addConnections(to: [right.node], bidirectional: false)
                    }
                }
            }
        }

        return grid
    }

    public static func part1(input: String) -> Int {
        let board = Util.getLines(input).enumerated().map { (y: Int, line: String) in
            Array(line).map(String.init).enumerated()
                .map { (x: Int, element: String) in
                    return Tile(height: element, node: GKGridGraphNode(gridPosition: vector_int2(Int32(x), Int32(y))))
                }
            }
        var grid = Grid(elements: Array(board.joined()), width: board[0].count, height: board.count)
        grid = joinNodes(in: grid)

        let start = grid.elements.first(where: { $0.height == "S" })!
        let end = grid.elements.first(where: { $0.height == "E" })!

        let path = start.node.findPath(to: end.node)
        return path.count - 1
    }

    public static func part2(input: String) -> Int {
        let board = Util.getLines(input).enumerated().map { (y: Int, line: String) in
            Array(line).map(String.init).enumerated()
                .map { (x: Int, element: String) in
                    return Tile(height: element, node: GKGridGraphNode(gridPosition: vector_int2(Int32(x), Int32(y))))
                }
            }
        var grid = Grid(elements: Array(board.joined()), width: board[0].count, height: board.count)
        grid = joinNodes(in: grid)

        let starts = grid.elements.filter { $0.height == "a" }
        let end = grid.elements.first(where: { $0.height == "E" })!

        let allPaths = starts.map { $0.node.findPath(to: end.node) }.filter { !$0.isEmpty }
        let shortest = allPaths.min(by: { $0.count < $1.count })!

        return shortest.count - 1
    }
}
