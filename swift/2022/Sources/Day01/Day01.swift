import Foundation

public struct Day01 {
    private static func caloriesFromInput(_ input: String) -> [Int] {
        return input
            .trimmingCharacters(in: .newlines)
            .components(separatedBy: "\n\n").map { (cals) in
            return cals
                .components(separatedBy: "\n")
                .map { Int($0)! }
                .reduce(0, +)
        }
    }

    public static func part1(input: String) -> Int {
        caloriesFromInput(input).max()!
    }
    
    public static func part2(input: String) -> Int {
        return caloriesFromInput(input)
            .sorted()
            .suffix(3)
            .reduce(0, +)
    }
}
