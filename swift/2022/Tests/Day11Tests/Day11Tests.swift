import XCTest
@testable import Day11

let sample = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day11.txt")

final class Day11Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day11.part1(input: sample)
        let result = Day11.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 10605)
        XCTAssertEqual(result, 110264)
    }

    func testPart2() throws {
        let sampleResult = Day11.part2(input: sample)
        let result = Day11.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 2713310158)
        XCTAssertEqual(result, 23612457316)
    }
}
