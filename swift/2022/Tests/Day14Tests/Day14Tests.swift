import XCTest
@testable import Day14

let sample = """
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day14.txt")

final class Day14Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day14.part1(input: sample)
        let result = Day14.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 24)
        XCTAssertEqual(result, 755)
    }

    func testPart2() throws {
        let sampleResult = Day14.part2(input: sample)
        let result = Day14.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 93)
        XCTAssertEqual(result, 29805)
    }
}
