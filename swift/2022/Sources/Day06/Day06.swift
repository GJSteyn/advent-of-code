import Foundation

public struct Day06 {
    private static func firstUniqueSequence(ofLength size: Int, in str: String) -> Int {
        let index = size - 1
        for (start, end) in zip(0..<(str.count-index), index..<str.count) {
            let startIndex = str.index(str.startIndex, offsetBy: start)
            let endIndex = str.index(str.startIndex, offsetBy: end)
            let section = str[startIndex...endIndex]

            if (Set(section).count == section.count) {
                return end + 1
            }
        }

        return -1
    }

    public static func part1(input: String) -> Int {
        return firstUniqueSequence(ofLength: 4, in: input)
    }

    public static func part2(input: String) -> Int {
        return firstUniqueSequence(ofLength: 14, in: input)
    }
}
