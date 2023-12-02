import XCTest
@testable import Day20

let sample = """
1
2
-3
3
-2
0
4
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day20.txt")

final class Day20Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day20.part1(input: sample)
        let result = Day20.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 3)
        XCTAssertEqual(result, 10763)
    }

    func testPart2() throws {
        let sampleResult = Day20.part2(input: sample)
        let result = Day20.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 1623178306)
        XCTAssertEqual(result, 4979911042808)
    }
}
