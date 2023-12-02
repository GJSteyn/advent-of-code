import Foundation

import Util

public struct Day20 {
    private static func moveNumber(in arr: [(offset: Int, element: Int)], origin: (offset: Int, element: Int)) -> [(offset: Int, element: Int)] {
        let elements = arr.map { $0.element }
        var arrCopy = origin.element < 0 ? Array(arr.reversed()) : arr
        let currentOffset = arrCopy.firstIndex(where: { $0.offset == origin.offset })

        let timesCrossedOver = abs(origin.element) / (arr.count - 1)
        let newOffset = (currentOffset! + abs(origin.element) + timesCrossedOver) % arrCopy.count
        arrCopy[currentOffset!] = (offset: 999_999_999, element: 999_999_999)
        arrCopy.insert(origin, at: newOffset + 1)
        arrCopy = arrCopy.filter { $0.offset != 999_999_999 }

        return origin.element < 0 ? Array(arrCopy.reversed()) : arrCopy
    }

    private static func scramble(original: [(offset: Int, element: Int)], premix: [(offset: Int, element: Int)]) -> [(offset: Int, element: Int)] {
        return original.reduce(premix, { (acc: [(offset: Int, element: Int)], el: (offset: Int, element: Int)) in
            return moveNumber(in: acc, origin: el)
        })
    }

    public static func part1(input: String) -> Int {
        let numbers = Util.getLines(input).map { Int($0)! }
        let len = numbers.count

        let numberList = Array(numbers.enumerated())

        let updated = scramble(original: numberList, premix: numberList)

        let startPoint = updated.firstIndex(where: { $0.element == 0 })
        let idx1 = (startPoint! + 1000) % updated.count
        let idx2 = (startPoint! + 2000) % updated.count
        let idx3 = (startPoint! + 3000) % updated.count

        return updated[idx1].element + updated[idx2].element + updated[idx3].element
    }

    public static func part2(input: String) -> Int {
        let decryptionKey = 811589153
        let numbers = Util.getLines(input).map { Int($0)! * decryptionKey }

        let numberList = Array(numbers.enumerated())

        var updated = numberList
        for _ in 0..<10 {
            updated = scramble(original: numberList, premix: updated)
        }
        let startPoint = updated.firstIndex(where: { $0.element == 0 })

        let idx1 = (startPoint! + 1000) % updated.count
        let idx2 = (startPoint! + 2000) % updated.count
        let idx3 = (startPoint! + 3000) % updated.count
        return updated[idx1].element + updated[idx2].element + updated[idx3].element
    }
}
