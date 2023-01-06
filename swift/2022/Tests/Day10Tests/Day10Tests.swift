import XCTest
@testable import Day10

let sample = """
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

let part2SampleResult = [
    ["#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", ".", "."],
    ["#", "#", "#", ".", ".", ".", "#", "#", "#", ".", ".", ".", "#", "#", "#", ".", ".", ".", "#", "#", "#", ".", ".", ".", "#", "#", "#", ".", ".", ".", "#", "#", "#", ".", ".", ".", "#", "#", "#", "."],
    ["#", "#", "#", "#", ".", ".", ".", ".", "#", "#", "#", "#", ".", ".", ".", ".", "#", "#", "#", "#", ".", ".", ".", ".", "#", "#", "#", "#", ".", ".", ".", ".", "#", "#", "#", "#", ".", ".", ".", "."],
    ["#", "#", "#", "#", "#", ".", ".", ".", ".", ".", "#", "#", "#", "#", "#", ".", ".", ".", ".", ".", "#", "#", "#", "#", "#", ".", ".", ".", ".", ".", "#", "#", "#", "#", "#", ".", ".", ".", ".", "."],
    ["#", "#", "#", "#", "#", "#", ".", ".", ".", ".", ".", ".", "#", "#", "#", "#", "#", "#", ".", ".", ".", ".", ".", ".", "#", "#", "#", "#", "#", "#", ".", ".", ".", ".", ".", ".", "#", "#", "#", "#"],
    ["#", "#", "#", "#", "#", "#", "#", ".", ".", ".", ".", ".", ".", ".", "#", "#", "#", "#", "#", "#", "#", ".", ".", ".", ".", ".", ".", ".", "#", "#", "#", "#", "#", "#", "#", ".", ".", ".", ".", "."],
    ["."]
]

let part2Result = [
    ["#", "#", "#", "#", ".", "#", ".", ".", ".", ".", "#", "#", "#", ".", ".", "#", ".", ".", ".", ".", "#", "#", "#", "#", ".", ".", "#", "#", ".", ".", "#", "#", "#", "#", ".", "#", ".", ".", ".", "."],
    ["#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", "#", ".", ".", ".", ".", ".", ".", ".", "#", ".", "#", ".", ".", "#", ".", ".", ".", ".", "#", ".", "#", ".", ".", ".", "."],
    ["#", "#", "#", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", "#", ".", ".", ".", ".", ".", ".", "#", ".", ".", "#", ".", ".", ".", ".", ".", ".", "#", ".", ".", "#", ".", ".", ".", "."],
    ["#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", "#", "#", ".", ".", "#", ".", ".", ".", ".", ".", "#", ".", ".", ".", "#", ".", "#", "#", ".", ".", "#", ".", ".", ".", "#", ".", ".", ".", "."],
    ["#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", "#", ".", ".", ".", ".", "#", ".", ".", ".", "."],
    ["#", "#", "#", "#", ".", "#", "#", "#", "#", ".", "#", ".", ".", ".", ".", "#", "#", "#", "#", ".", "#", "#", "#", "#", ".", ".", "#", "#", "#", ".", "#", "#", "#", "#", ".", "#", "#", "#", "#", "."],
    ["."]
]

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day10.txt")

final class Day10Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day10.part1(input: sample)
        let result = Day10.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 13140)
        XCTAssertEqual(result, 14780)
    }

    func testPart2() throws {
        let sampleResult = Day10.part2(input: sample)
        let result = Day10.part2(input: input)

        print("Part2 Sample:")
        for row in sampleResult {
            print(row)
        }

        print("Part2 Result:")
        for row in result {
            print(row)
        }
        XCTAssertEqual(sampleResult, part2SampleResult)
        XCTAssertEqual(result, part2Result)
    }
}
