import Foundation

import Util

extension String {
    var isNumber: Bool {
        return self.allSatisfy { $0.isNumber }
    }
}

public struct Day21 {
    enum Op: String {
        case add = "+"
        case sub = "-"
        case mul = "*"
        case div = "/"
    }

    class Monkey {
        let name: String
        let op: String
        var result: Int?
        var leftResult: Int?
        var rightResult: Int?
        var leftMonkey: Monkey?
        var rightMonkey: Monkey?
        var opOp: Op?

        init(name: String,
             op: String,
             result: Int? = nil,
             leftResult: Int? = nil,
             rightResult: Int? = nil,
             leftMonkey: Monkey? = nil,
             rightMonkey: Monkey? = nil,
             opOp: Op? = nil
        ) {
            self.name = name
            self.op = op
            self.result = result
            self.leftResult = leftResult
            self.rightResult = rightResult
            self.leftMonkey = leftMonkey
            self.rightMonkey = rightMonkey
            self.opOp = opOp
        }
    }

    private static func doOp(_ left: Int, _ right: Int, _ op: Op) -> Int {
        switch op {
        case Op.add:
            return left + right
        case Op.sub:
            return left - right
        case Op.mul:
            return left * right
        case Op.div:
            return left / right
        }
    }

    private static func compute(monkeys: [String: Monkey], start: Monkey) -> [String: Monkey] {
        if start.result != nil {
            return monkeys
        }

        if start.op.isNumber {
            var innerMonkeys = monkeys
            innerMonkeys[start.name] = Monkey(name: start.name, op: start.op, result: Int(start.op)!)
            return innerMonkeys
        } else {
            let components = start.op.components(separatedBy: " ")
            let leftMonkeyName = components[0]
            let rightMonkeyName = components[2]
            let op = Op(rawValue: components[1])!

            let leftMonkey = monkeys[leftMonkeyName]!
            let rightMonkey = monkeys[rightMonkeyName]!

            let leftMonkeyResultMap = compute(monkeys: monkeys, start: leftMonkey)
            let leftMonkeyNumber = leftMonkeyResultMap[leftMonkeyName]!.result
            let rightMonkeyResultMap = compute(monkeys: leftMonkeyResultMap, start: rightMonkey)
            let rightMonkeyNumber = rightMonkeyResultMap[rightMonkeyName]!.result

            var innerMonkeys = monkeys

            let innerResult = doOp(leftMonkeyNumber!, rightMonkeyNumber!, op)
            innerMonkeys[start.name] = Monkey(name: start.name, op: start.op, result: innerResult, leftResult: leftMonkeyNumber, rightResult: rightMonkeyNumber)
            return innerMonkeys
        }
    }

    public static func part1(input: String) -> Int {
        let inp = Util.getLines(input)
        let monkeys = inp.map {
            let split = $0.components(separatedBy: ": ")
            return Monkey(name: split[0], op: split[1])
        }

        var monkeyMap: [String: Monkey] = [:]
        for monkey in monkeys {
            monkeyMap[monkey.name] = monkey
        }

        let rootMonkey = monkeyMap["root"]!
        let updatedMonkeys = compute(monkeys: monkeyMap, start: rootMonkey)
        let updatedRootMonkey = updatedMonkeys["root"]!
        return updatedRootMonkey.result!
    }

    private static func compute2(monkeys: [String: Monkey], start: Monkey) -> [String: Monkey] {
        if start.result != nil {
//            print("Start result != nil: \(start.op), \(start.result)")
            return monkeys
        }

        if start.op.isNumber {
//            print()
//            print("Already a number: \(start.name) - \(start.op), result: \(Int(start.op))")
            var innerMonkeys = monkeys
            innerMonkeys[start.name] = Monkey(name: start.name, op: start.op, result: Int(start.op)!)
//            print("After assigning inner: \(innerMonkeys[start.name])")
            return innerMonkeys
        } else {
//            print()
//            print("Not a number: \(start.name) - \(start.op)")

//            print("Getting left and right monkeys")
//            print("Computing left and right monkeys")
            let leftMonkeyResultMap = compute(monkeys: monkeys, start: start.leftMonkey!)
            let leftMonkeyNumber = leftMonkeyResultMap[start.leftMonkey!.name]!.result
//            print("Left result:", leftMonkeyNumber)
            let rightMonkeyResultMap = compute(monkeys: leftMonkeyResultMap, start: start.rightMonkey!)
            let rightMonkeyNumber = rightMonkeyResultMap[start.rightMonkey!.name]!.result
//            print("Right result:", rightMonkeyNumber)


//            print("Assigning inner result: \(start.name) - left: \(leftMonkeyNumber), right: \(rightMonkeyNumber)")
            let innerResult = doOp(leftMonkeyNumber!, rightMonkeyNumber!, start.opOp!)
            var innerMonkeys = monkeys
            innerMonkeys[start.name]!.leftResult = leftMonkeyNumber
            innerMonkeys[start.name]!.rightResult = rightMonkeyNumber
            innerMonkeys[start.name]!.result = innerResult
//            innerMonkeys[start.name] = Monkey(name: start.name, op: start.op, result: innerResult, leftResult: leftMonkeyNumber, rightResult: rightMonkeyNumber)
//            print("Returning the monkeys")
//            print()
            return innerMonkeys
        }
    }

    public static func part2(input: String) -> Int {
        let inp = Util.getLines(input)
        let monkeys = inp.map {
            let split = $0.components(separatedBy: ": ")
            return Monkey(name: split[0], op: split[1])
        }

        var monkeyMap: [String: Monkey] = [:]
        for monkey in monkeys {
            monkeyMap[monkey.name] = monkey
        }

        for (name, monkey) in monkeyMap {
            if monkey.op.isNumber {
                monkeyMap[name]!.result = Int(monkey.op)!
            } else {
                let components = monkey.op.components(separatedBy: " ")
                let leftMonkeyName = components[0]
                let rightMonkeyName = components[2]
                let op = components[1]
                monkeyMap[name]!.leftMonkey = monkeyMap[leftMonkeyName]
                monkeyMap[name]!.rightMonkey = monkeyMap[rightMonkeyName]
                monkeyMap[name]!.opOp = Op(rawValue: op)
            }
        }


        let rootMonkey = monkeyMap["root"]!
//        for i in 3617613952378..<6000000000000 {
        for i in 1617613950378..<6000000000000 {
            monkeyMap["humn"]!.result = i

            let updatedMonkeys = compute(monkeys: monkeyMap, start: rootMonkey)
            let updatedRootMonkey = updatedMonkeys["root"]!

            if let left = updatedRootMonkey.leftResult {
                if let right = updatedRootMonkey.rightResult {
                    if left == right {
                        print("YUP: ", i)
                        return i
                    } else {
                        print("Nope: \(i) - l: \(left), r: \(right)")
                    }
                }
            } else {
                print("Left monkey result is nil")
            }

        }

        return 42
    }
}
