import Foundation

import Util

public struct Day25 {
    enum Digit: Character {
        case zero = "0"
        case one = "1"
        case two = "2"
        case minus = "-"
        case doubleMinus = "="

        func toValue() -> Int {
            switch self {
            case .zero:
                return 0
            case .one:
                return 1
            case .two:
                return 2
            case .minus:
                return -1
            case .doubleMinus:
                return -2
            }
        }
    }

    private static func stringToNumber(_ str: String) -> Int {
        var tally = 1

        return str.reversed().map {
            let digit = Digit(rawValue: $0)!
            let ret = tally * digit.toValue()
            tally *= 5
            return ret
        }.reduce(0, +)
    }

    private static func addBalancedBase5(
        _ left: String,
        _ right: String,
        _ carry: Int = 0,
        _ acc: String = ""
    ) -> String {
        let values: [Character: Int] = ["=": -2, "-": -1, "0": 0, "1": 1, "2": 2]

        func calc(_ left: Character, _ right: Character?, _ carry: Int) -> (result: Character, carry: Int) {
            let result = values[left]! + (right != nil ? values[right!]! : 0) + carry

            if result > 2 {
                let char = values.first(where: { $0.value == result - 5 })!.key
                return (result: char, carry: 1)
            } else if result < -2 {
                let char = values.first(where: { $0.value == result + 5 })!.key
                return (result: char, carry: -1)
            } else {
                let char = values.first(where: { $0.value == result })!.key
                return (result: char, carry: 0)
            }
        }

        if let firstLeft = left.last, let firstRight = right.last {
            let sum = calc(firstLeft, firstRight, carry)
            return addBalancedBase5(String(left.dropLast()), String(right.dropLast()), sum.carry, String(sum.result) + acc)
        } else if let firstLeft = left.last {
            let sum = calc(firstLeft, nil, carry)
            return addBalancedBase5(String(left.dropLast()), "", sum.carry, String(sum.result) + acc)
        } else if let firstRight = right.last {
            let sum = calc(firstRight, nil, carry)
            return addBalancedBase5("", String(right.dropLast()), sum.carry, String(sum.result) + acc)
        } else {
            if carry == 0 {
                return acc
            } else {
                return String(values.first(where: { $0.value == carry })!.key) + acc
            }
        }
    }

    public static func part1(input: String) -> String {
        let inp = Util.getLines(input)
        return inp.reduce("0", { addBalancedBase5($0, $1) })
    }
}
