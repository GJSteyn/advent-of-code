import XCTest
@testable import Day01

let sample = """
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day01.txt")

final class Day01Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day01.part1(input: sample)
        let result = Day01.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 24000)
        XCTAssertEqual(result, 67622)
    }
    
    func testPart2() throws {
        let sampleResult = Day01.part2(input: sample)
        let result = Day01.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 45000)
        XCTAssertEqual(result, 201491)
    }
}
