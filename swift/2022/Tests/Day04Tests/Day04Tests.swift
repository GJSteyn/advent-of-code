import XCTest
@testable import Day04

let sample = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day04.txt")

final class Day04Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day04.part1(input: sample)
        let result = Day04.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 2)
        XCTAssertEqual(result, 526)
    }
    
    func testPart2() throws {
        let sampleResult = Day04.part2(input: sample)
        let result = Day04.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 4)
        XCTAssertEqual(result, 886)
    }
}
