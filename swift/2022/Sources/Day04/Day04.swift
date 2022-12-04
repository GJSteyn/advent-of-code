import Foundation

import Util

public struct Day04 {
    private static func lineToRanges(_ str: String) -> [(Int, Int)] {
        func splitRange(range: String) -> [Int] {
            return range.components(separatedBy: "-")
                        .map { Int($0)! }
        }

        return str.components(separatedBy: ",")
            .map(splitRange)
            .map { ($0[0], $0[1]) }
    }

    private static func containedBy(outer: (Int, Int), inner: (Int, Int)) -> Bool {
        return (outer.0 <= inner.0 && outer.1 >= inner.1)
    }

    private static func overlaps(_ first: (Int, Int), _ second: (Int, Int)) -> Bool {
        return (second.0 >= first.0 && second.0 <= first.1) || (second.1 >= first.0 && second.1 <= first.1)
            || (first.0 >= second.0 && first.0 <= second.1 || first.1 >= second.0 && first.1 <= second.1)
    }

    public static func part1(input: String) -> Int {
        return Util.getLines(input)
            .map(lineToRanges)
            .map { containedBy(outer: $0[0], inner: $0[1]) || containedBy(outer: $0[1], inner: $0[0]) }
            .filter { $0 }
            .count
    }

    public static func part2(input: String) -> Int {
        return Util.getLines(input)
            .map(lineToRanges)
            .map { overlaps($0[0], $0[1]) }
            .filter { $0 }
            .count
    }
}
