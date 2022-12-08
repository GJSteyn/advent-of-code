import XCTest
@testable import Day08

let sample = """
30373
25512
65332
33549
35390
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day08.txt")

final class Day08Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day08.part1(input: sample)
        let result = Day08.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 21)
        XCTAssertEqual(result, 1829)
    }

    func testPart2() throws {
        let sampleResult = Day08.part2(input: sample)
        let result = Day08.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 8)
        XCTAssertEqual(result, 291840)
    }
}
