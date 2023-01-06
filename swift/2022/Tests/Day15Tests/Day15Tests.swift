import XCTest
@testable import Day15

let sample = """
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day15.txt")

final class Day15Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day15.part1(input: sample, onLine: 10)
        let result = Day15.part1(input: input, onLine: 2_000_000)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 26)
        XCTAssertEqual(result, 4951427)
    }

    func testPart2() throws {
        let sampleResult = Day15.part2(input: sample, searchSpace: 20)
        let result = Day15.part2(input: input, searchSpace: 4_000_000)
        print("Part2 Sample:", sampleResult!)
        print("Part2 Result:", result!)
        XCTAssertEqual(sampleResult, .some(56000011))
        XCTAssertEqual(result, .some(13_029_714_573_243))
    }
}
