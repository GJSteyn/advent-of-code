import XCTest
@testable import Day09

let sample = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""

let sample2 = """
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day09.txt")

final class Day09Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = try! Day09.part1(input: sample)
        let result = try! Day09.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 13)
        XCTAssertEqual(result, 6522)
    }

    func testPart2() throws {
        let sampleResult = try! Day09.part2(input: sample)
        let sample2Result = try! Day09.part2(input: sample2)
        let result = try! Day09.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Sample2:", sample2Result)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 1)
        XCTAssertEqual(sample2Result, 36)
        XCTAssertEqual(result, 2717)
    }
}
