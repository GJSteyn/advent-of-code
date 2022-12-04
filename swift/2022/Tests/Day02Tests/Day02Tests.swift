import XCTest
@testable import Day02

let sample = """
A Y
B X
C Z
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day02.txt")

final class Day02Tests: XCTestCase {
    func testPart1() throws {
        let part1SampleResult = Day02.part1(input: sample)
        let part1Result = Day02.part1(input: input)
        print("Part1 Sample:", part1SampleResult)
        print("Part1 Result:", part1Result)
        XCTAssertEqual(part1SampleResult, 15)
        XCTAssertEqual(part1Result, 10310)
    }
    
    func testPart2() throws {
        let part2SampleResult = Day02.part2(input: sample)
        let part2Result = Day02.part2(input: input)
        print("Part2 Sample:", part2SampleResult)
        print("Part2 Result:", part2Result)
        XCTAssertEqual(part2SampleResult, 12)
        XCTAssertEqual(part2Result, 14859)
    }
}
