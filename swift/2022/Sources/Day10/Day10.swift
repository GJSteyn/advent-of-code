import Foundation

import Util

public struct Day10 {
    enum Instruction: String {
        case add = "addx"
        case noop = "noop"
    }

    private static func applyInstruction(_ instruction: Instruction, number: Int?, to currentValue: Int) -> [Int] {
        switch instruction {
        case .add:
            if let num = number {
                return [currentValue, currentValue + num]
            } else {
                return [currentValue, currentValue]
            }
        case .noop:
            return [currentValue]
        }
    }

    public static func part1(input: String) -> Int {
        let instructions = Util.getLines(input)
            .map { $0.components(separatedBy: " ") }
            .map { (instruction: Instruction(rawValue: $0[0])!, number: Int($0[safe: 1] ?? "")) }

        let result = instructions.reduce([1], {
            $0 + applyInstruction($1.instruction, number: $1.number, to: $0[safe: $0.count - 1]!)
        })

        func registerProduct(_ index: Int) -> Int {
            return result[index - 1] * index
        }

        return registerProduct(20) + registerProduct(60) + registerProduct(100) + registerProduct(140) + registerProduct(180) + registerProduct(220)
    }

    public static func part2(input: String) -> [[String]] {
        let instructions = Util.getLines(input)
            .map { $0.components(separatedBy: " ") }
            .map { (instruction: Instruction(rawValue: $0[0])!, number: Int($0[safe: 1] ?? "")) }

        let result = instructions.reduce([1], {
            $0 + applyInstruction($1.instruction, number: $1.number, to: $0[safe: $0.count - 1]!)
        })

        let pixels = result.enumerated().map { (offset: Int, element: Int) in
            let index = offset % 40
            if index == element - 1 || index == element || index == element + 1 {
                return "#"
            } else {
                return "."
            }
        }

        return pixels.chunked(into: 40)
    }
}
