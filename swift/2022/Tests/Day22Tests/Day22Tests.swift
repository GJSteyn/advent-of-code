import XCTest
@testable import Day22

let sample = """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day22.txt")

final class Day22Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day22.part1(input: sample)
        let result = Day22.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 6032)
        XCTAssertEqual(result, 93226)
    }

    func testPart2() throws {
        let sampleResult = Day22.part2(input: sample)
        let result = Day22.part2_2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 5031)
        XCTAssertEqual(result, 37415)
    }
}
