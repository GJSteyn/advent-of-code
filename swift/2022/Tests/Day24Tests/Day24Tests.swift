import XCTest
@testable import Day24

let sample = """
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day24.txt")

final class Day24Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day24.part1(input: sample)
        let result = Day24.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 18)
        XCTAssertEqual(result, 266)
    }

    func testPart2() throws {
        let sampleResult = Day24.part2(input: sample)
        let result = Day24.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 54)
        XCTAssertEqual(result, 853)
    }
}
