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
        let sampleResult = Day02.part1(input: sample)
        let result = Day02.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 15)
        XCTAssertEqual(result, 10310)
    }
    
    func testPart2() throws {
        let sampleResult = Day02.part2(input: sample)
        let result = Day02.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 12)
        XCTAssertEqual(result, 14859)
    }
}
