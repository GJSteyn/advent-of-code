import Foundation

import Util

public struct Day11 {
    enum Op: String {
        case add = "+"
        case mul = "*"
    }

    private static func numbersFrom(string: String) -> [Int] {
        string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .map { Int($0) }
            .compactMap { $0 }
    }

    enum OperationError: Error {
        case badInput(String)
    }

    struct Monkey {
        var inspected = 0
        var items: [Int] = []
        var operation: (operator: Op, arg: String)
        var divisibleBy: Int
        var ifTrue: Int
        var ifFalse: Int

        init(items: [Int], operation: (operator: Op, arg: String), divisibleBy: Int, ifTrue: Int, ifFalse: Int) {
            self.items = items
            self.operation = operation
            self.divisibleBy = divisibleBy
            self.ifTrue = ifTrue
            self.ifFalse = ifFalse
        }

        static func fromStrings(items: String, operation: String, divisibleBy: String, ifTrue: String, ifFalse: String) throws -> Monkey {
            let items = numbersFrom(string: items)

            let opRegex = #/= old (?<op>\*|\+) (?<arg>\d+|old)/#
            let selfOperation: (operator: Op, arg: String)
            if let op = try? opRegex.firstMatch(in: operation) {
                selfOperation = (operator: Op(rawValue: String(op.op))!, arg: String(op.arg))
            } else {
                throw OperationError.badInput("Unexpected input for operation: \(operation)")
            }

            let divisibleBy = numbersFrom(string: divisibleBy)[0]

            let ifTrue = numbersFrom(string: ifTrue)[0]
            let ifFalse = numbersFrom(string: ifFalse)[0]

            return Monkey(items: items, operation: selfOperation, divisibleBy: divisibleBy, ifTrue: ifTrue, ifFalse: ifFalse)
        }

        func copyWith(
            items: [Int]? = nil,
            operation: (operator: Op, arg: String)? = nil,
            divisibleBy: Int? = nil,
            ifTrue: Int? = nil,
            ifFalse: Int? = nil) -> Monkey {
                return Monkey(
                    items: items ?? self.items,
                    operation: operation ?? self.operation,
                    divisibleBy: divisibleBy ?? self.divisibleBy,
                    ifTrue: ifTrue ?? self.ifTrue,
                    ifFalse: ifFalse ?? self.ifFalse
                )
        }
    }

    private static func modifyMonkeyItems(_ monkey: Monkey, _ divisor: Int = 1, _ lcm: Int? = nil) -> [Int] {
        let modified = monkey.items.map {
            let modifier = monkey.operation.arg == "old" ? $0 : Int(monkey.operation.arg)!
            switch monkey.operation.operator {
            case .add:
                return ($0 + modifier) / divisor
            case .mul:
                return ($0 * modifier) / divisor
            }
        }

        if let lowestCommonMultiple = lcm {
            return modified.map { $0 % lowestCommonMultiple }
        } else {
            return modified
        }
    }

    private static func monkeyPlay(_ index: Int, _ monkeys: [Monkey], _ divisor: Int = 1, _ lcm: Int? = nil) -> [Monkey] {
        let monkey = monkeys[index]
        var innerMonkeys = monkeys

        let newItems = modifyMonkeyItems(monkey, divisor, lcm)
        for item in newItems {
            let indexToModify = item % monkey.divisibleBy == 0 ? monkey.ifTrue : monkey.ifFalse
            var monkeyToModify = innerMonkeys[indexToModify]
            monkeyToModify.items += [item]
            innerMonkeys[indexToModify] = monkeyToModify
        }

        innerMonkeys[index].items = []
        innerMonkeys[index].inspected += newItems.count

        return innerMonkeys
    }

    private static func monkeyBusiness(_ monkeys: [Monkey], divisor: Int = 1, lcm: Int? = nil) -> [Monkey] {
        return (0..<monkeys.count).reduce(monkeys, { (monkeys: [Monkey], i: Int) in
            monkeyPlay(i, monkeys, divisor, lcm)
        })
    }

    private static func parseInput(_ input: String) -> [Monkey] {
        let lines = Util.getLines(input).split(separator: "").map(Array.init)
        return lines.map {
            try! Monkey.fromStrings(items: $0[1], operation: $0[2], divisibleBy: $0[3], ifTrue: $0[4], ifFalse: $0[5])
        }
    }

    public static func part1(input: String) -> Int {
        let monkeys = parseInput(input)
        let lowestCommonMultiple = monkeys.map { $0.divisibleBy }.reduce(1, *)

        let newMonkeys = (0..<20).reduce(monkeys, { (monkeys: [Monkey], _: Int) in
            monkeyBusiness(monkeys, divisor: 3, lcm: lowestCommonMultiple)
        })

        let inspections = newMonkeys.map { $0.inspected }
        return inspections.sorted().reversed()[0..<2].reduce(1, *)
    }

    public static func part2(input: String) -> Int {
        let monkeys = parseInput(input)
        let lowestCommonMultiple = monkeys.map { $0.divisibleBy }.reduce(1, *)

        let newMonkeys = (0..<10000).reduce(monkeys, { (monkeys: [Monkey], _: Int) in
            monkeyBusiness(monkeys, lcm: lowestCommonMultiple)
        })

        let inspections = newMonkeys.map { $0.inspected }
        return inspections.sorted().reversed()[0..<2].reduce(1, *)
    }
}
