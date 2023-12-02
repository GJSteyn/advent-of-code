import XCTest
@testable import Day23

let sample = """
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day23.txt")

final class Day23Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day23.part1(input: sample)
        let result = Day23.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 110)
        XCTAssertEqual(result, 4025)
    }

    func testPart2() throws {
        let sampleResult = Day23.part2(input: sample)
        let result = Day23.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 20)
        XCTAssertEqual(result, 935)
    }
}
