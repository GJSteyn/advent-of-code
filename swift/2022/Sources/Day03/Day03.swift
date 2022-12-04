import Foundation

import Util

extension String {
    func splitInHalf() -> [String] {
        let halfIndex = self.index(self.startIndex, offsetBy: self.count / 2)
        return [String(self[..<halfIndex]), String(self[halfIndex...])]
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    func head() -> Element {
        return self[0]
    }

    func tail() -> [Element] {
        return Array(self[1...])
    }
}

public struct Day03 {
    static let items = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    private static func priorityOf(_ item: String.Element) -> Int {
        return items.firstIndex(of: item)!.utf16Offset(in: items) + 1
    }

    private static func commonItem(of arr: [String]) -> Character {
        return arr.tail().reduce(Set(arr.head()), { $0.intersection(Set($1)) }).first!
    }

    public static func part1(input: String) -> Int {
        return Util.getLines(input)
            .map { $0.splitInHalf() }
            .map { Set($0[0]).intersection($0[1]).first! }
            .map(priorityOf)
            .reduce(0, +)
    }


    public static func part2(input: String) -> Int {
        return Util.getLines(input)
            .chunked(into: 3)
            .map(commonItem)
            .map(priorityOf)
            .reduce(0, +)
    }
}
