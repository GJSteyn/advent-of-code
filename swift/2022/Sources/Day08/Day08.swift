import Foundation

import Util

extension Array {
    public func takeWhileIncluding(predicate: (Element) -> Bool) -> Array {
        var keep: [Element] = []
        for element in self {
            keep.append(element)
            if !predicate(element) {
                return keep
            }
        }
        return keep
    }
}

public struct Day08 {
    private static func getTreesAbove(_ coordinate: (x: Int, y: Int), in map: [[Int]]) -> [Int] {
        return map[0..<coordinate.y].map { $0[coordinate.x] }
    }

    private static func getTreesBelow(_ coordinate: (x: Int, y: Int), in map: [[Int]]) -> [Int] {
        return map[coordinate.y + 1..<map.count].map { $0[coordinate.x] }
    }

    private static func getTreesLeftOf(_ coordinate: (x: Int, y: Int), in map: [[Int]]) -> [Int] {
        return Array(map[coordinate.y][0..<coordinate.x])
    }

    private static func getTreesRightOf(_ coordinate: (x: Int, y: Int), in map: [[Int]]) -> [Int] {
        return Array(map[coordinate.y][coordinate.x + 1..<map[coordinate.y].count])
    }

    private static func visible(in map: [[Int]], from coordinate: (x: Int, y: Int), rangeSelector: ((Int, Int), [[Int]]) -> [Int]) -> Bool {
        let currentTreeHeight = map[coordinate.y][coordinate.x]
        let range = rangeSelector(coordinate, map)
        if let max = range.max() {
            return max < currentTreeHeight
        } else {
            return true
        }
    }

    public static func part1(input: String) -> Int {
        let map = Util.getLines(input).map { Array($0).map { Int(String($0))! } }
        let (width, height) = (map[0].count, map.count)

        let visibleArr = (0..<height).map { (y: Int) in
            (0..<width).map { (x: Int) in
                visible(in: map, from: (x, y), rangeSelector: getTreesAbove)
                || visible(in: map, from: (x, y), rangeSelector: getTreesBelow)
                || visible(in: map, from: (x, y), rangeSelector: getTreesLeftOf)
                || visible(in: map, from: (x, y), rangeSelector: getTreesRightOf)
            }
        }.joined()

        return visibleArr.filter { $0 }.count
    }

    public static func part2(input: String) -> Int {
        let map = Util.getLines(input).map { Array($0).map { Int(String($0))! } }

        let scores = map.enumerated().map { (y: Int, row: [Int]) in
            row.enumerated().map { (x: Int, treeHeight: Int) in
                let treesAbove = getTreesAbove((x, y), in: map).reversed().takeWhileIncluding { $0 < treeHeight}
                let treesBelow = getTreesBelow((x, y), in: map).takeWhileIncluding { $0 < treeHeight}
                let treesRight = getTreesRightOf((x, y), in: map).takeWhileIncluding { $0 < treeHeight}
                let treesLeft = getTreesLeftOf((x, y), in: map).reversed().takeWhileIncluding { $0 < treeHeight}

                return treesAbove.count * treesBelow.count * treesRight.count * treesLeft.count
            }
        }.joined()

        return scores.max()!
    }
}
