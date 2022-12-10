import Foundation

import Util

// TODO: Clean up

extension String {
    func comp(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}

public struct Day05 {
    private static func stacksFromInput(_ input: [String]) -> [[String]] {
        let brackets = CharacterSet(charactersIn: "[]")
        let parsed = input
            .dropLast(1)
            .map { $0.comp(withMaxLength: 4).map { $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: brackets) } }

        var stacks: [[String]] = []
        for _ in 0..<parsed[0].count {
            stacks.append([])
        }

        for stack in parsed {
            for (index, element) in stack.enumerated() {
                if element != "" {
                    stacks[index].append(element)
                }
            }
        }

        return stacks
    }

    private static func instructionsFromInput(_ input: [String]) -> [[Int]] {
        return input.map {
            $0.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .map { Int($0) }
                .compactMap { $0 }
        }
    }

    public static func part1(input: String) -> String {
        let stuff = Util.getLines(input)
        let more = stuff.split(separator: "").map(Array.init)
        var (stacks, instructions) = (stacksFromInput(more[0]), instructionsFromInput(more[1]))

        for instruction in instructions {
            let (count, from, to) = (instruction[0], instruction[1], instruction[2])

            for _ in 0..<count {
                let moving = stacks[from - 1].removeFirst()
                stacks[to - 1].insert(moving, at: 0)
            }
        }

        return stacks.map { $0.first }.compactMap { $0 }.joined()
    }

    public static func part2(input: String) -> String {
        let stuff = Util.getLines(input)
        let more = stuff.split(separator: "").map(Array.init)
        var (stacks, instructions) = (stacksFromInput(more[0]), instructionsFromInput(more[1]))

        for instruction in instructions {
            let (count, from, to) = (instruction[0], instruction[1], instruction[2])

            let moving = stacks[from - 1].prefix(through: count - 1)
            stacks[from - 1].removeFirst(count)
            stacks[to - 1] = moving + stacks[to - 1]
        }

        return stacks.map { $0.first }.compactMap { $0 }.joined()
    }
}
