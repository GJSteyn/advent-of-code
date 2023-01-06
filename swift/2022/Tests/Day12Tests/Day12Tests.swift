import XCTest
@testable import Day12
@testable import Day12Custom

let sample = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day12.txt")

final class Day12Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day12.part1(input: sample)
        let result = Day12.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 31)
        XCTAssertEqual(result, 472)
    }

    func testPart2() throws {
        let sampleResult = Day12.part2(input: sample)
        let result = Day12.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 29)
        XCTAssertEqual(result, 465)
    }

    func testPart1Custom() throws {
        let sampleResult = Day12Custom.part1(input: sample)
        let result = Day12Custom.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 31)
        XCTAssertEqual(result, 472)
    }

    func testPart2Custom() throws {
        let sampleResult = Day12Custom.part2(input: sample)
        let result = Day12Custom.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 29)
        XCTAssertEqual(result, 465)
    }
}
