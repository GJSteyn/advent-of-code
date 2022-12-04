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
        let part1SampleResult = Day04.part1(input: sample)
        let part1Result = Day04.part1(input: input)
        print("Part1 Sample:", part1SampleResult)
        print("Part1 Result:", part1Result)
        XCTAssertEqual(part1SampleResult, 2)
        XCTAssertEqual(part1Result, 526)
    }
    
    func testPart2() throws {
        let part2SampleResult = Day04.part2(input: sample)
        let part2Result = Day04.part2(input: input)
        print("Part2 Sample:", part2SampleResult)
        print("Part2 Result:", part2Result)
        XCTAssertEqual(part2SampleResult, 4)
        XCTAssertEqual(part2Result, 886)
    }
}
