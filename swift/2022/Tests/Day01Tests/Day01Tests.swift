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
        let part1SampleResult = Day01.part1(input: sample)
        let part1Result = Day01.part1(input: input)
        print("Part1 Sample:", part1SampleResult)
        print("Part1 Result:", part1Result)
        XCTAssertEqual(part1SampleResult, 24000)
        XCTAssertEqual(part1Result, 67622)
    }
    
    func testPart2() throws {
        let part2SampleResult = Day01.part2(input: sample)
        let part2Result = Day01.part2(input: input)
        print("Part2 Sample:", part2SampleResult)
        print("Part2 Result:", part2Result)
        XCTAssertEqual(part2SampleResult, 45000)
        XCTAssertEqual(part2Result, 201491)
    }
}
