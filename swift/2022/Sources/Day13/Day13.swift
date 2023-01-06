import Foundation

import Util

public struct Day13 {
    // Returns true if valid, false if invalid, nil if equal
    private static func compare(_ leftArr: [Any], _ rightArr: [Any], index: Int = 0) -> Bool? {
        if index == leftArr.endIndex && index < rightArr.endIndex {
            return true
        } else if index < leftArr.endIndex && index == rightArr.endIndex {
            return false
        } else if index == leftArr.endIndex && index == rightArr.endIndex {
            return nil
        }

        let result: Bool?

        switch (leftArr[index], rightArr[index]) {
        case let (l, r) as (Int, Int):
            if l == r {
                result = compare(leftArr, rightArr, index: index + 1)
            } else {
                result = l < r
            }
        case let (l, r) as (Int, [Any]):
            result = compare([l], r)
        case let (l, r) as ([Any], Int):
            result = compare(l, [r])
        case let (l, r) as ([Any], [Any]):
            result = compare(l, r)
        default:
            return false
        }

        if let res = result {
            return res
        } else {
            return compare(leftArr, rightArr, index: index + 1)
        }
    }

    public static func part1(input: String) -> Int {
        let jsonPairs = Util.getLines(input)
            .split(separator: "")
            .map { Array($0).map {
                try? JSONSerialization.jsonObject(with: $0.data(using: .utf8)!)
            }}

        let result = jsonPairs.map { compare($0[0] as! [Any], $0[1] as! [Any]) }

        return result.enumerated()
            .filter { $0.element != false }
            .reduce(0, { $0 + $1.offset + 1 })
    }

    public static func part2(input: String) -> Int {
        let packets = Util.getLines(input)
            .filter { $0 != "" }
            .map {
                try? JSONSerialization.jsonObject(with: $0.data(using: .utf8)!)
            }

        let divider1 = try? JSONSerialization.jsonObject(with: "[[2]]".data(using: .utf8)!)
        let divider2 = try? JSONSerialization.jsonObject(with: "[[6]]".data(using: .utf8)!)

        let sorted = (packets + [divider1, divider2]).sorted(by: { compare($0 as! [Any], $1 as! [Any]) ?? true })
        let div1Index = sorted.firstIndex(where: { compare($0 as! [Any], divider1 as! [Any]) == nil })
        let div2Index = sorted.firstIndex(where: { compare($0 as! [Any], divider2 as! [Any]) == nil })

        return (div1Index! + 1) * (div2Index! + 1)
    }
}
