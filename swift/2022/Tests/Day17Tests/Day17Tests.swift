import XCTest
@testable import Day17

let sample = """
>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day17.txt")

final class Day17Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day17.part1(input: sample)
        let result = Day17.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 3068)
        XCTAssertEqual(result, 3188)
    }

    func testPart2() throws {
        let sampleResult = Day17.part2(input: sample)
        let result = Day17.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 1_514_285_714_288)
        XCTAssertEqual(result, 1_591_977_077_342)
    }

    func testCycle() throws {
        let chamber = Array([
            [".", "#", "#", "#", "#", ".", "."],
            [".", ".", ".", ".", "#", "#", "."],
            [".", ".", ".", ".", "#", "#", "."],
            [".", ".", ".", ".", "#", ".", "."],
            [".", ".", "#", ".", "#", ".", "."],
            [".", ".", ".", ".", "#", ".", "."],
            [".", "#", "#", "#", "#", ".", "."],
            [".", ".", ".", ".", "#", "#", "."],
            [".", ".", ".", ".", "#", "#", "."],
            [".", ".", ".", ".", "#", ".", "."],
            [".", ".", "#", ".", "#", ".", "."],
            [".", ".", "#", ".", "#", ".", "."],
            ["#", "#", "#", "#", "#", "#", "#"],
            [".", "#", "#", "#", "#", ".", "."],
            [".", ".", ".", ".", "#", "#", "."],
            [".", ".", ".", ".", "#", "#", "."],
            [".", ".", ".", ".", "#", ".", "."],
            [".", ".", "#", ".", "#", ".", "."],
            [".", ".", "#", ".", "#", ".", "."],
            ["#", "#", "#", "#", "#", "#", "#"],
            [".", ".", "#", "#", "#", ".", "."],
            [".", ".", ".", "#", ".", ".", "."],
            [".", ".", "#", "#", "#", "#", "."]].reversed())

        let result = Day17.detectCycle(chamber)
        print("Result:", String(describing: result))
    }
}
