import XCTest
@testable import Day13

let sample = """
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day13.txt")

final class Day13Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day13.part1(input: sample)
        let result = Day13.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 13)
        XCTAssertEqual(result, 6568)
    }

    func testPart2() throws {
        let sampleResult = Day13.part2(input: sample)
        let result = Day13.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 140)
        XCTAssertEqual(result, 19493)
    }
}
