import XCTest
import Util
@testable import Day18

let sample = """
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
"""

let sample2 = """
0,0,0
1,0,0
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day18.txt")

final class Day18Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day18.part1(input: sample)
        let result = Day18.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 64)
        XCTAssertEqual(result, 3550)
    }

    func testPart2() throws {
        let sampleResult = Day18.part2(input: sample)
//        let result = Day18.part2(input: input)
        print("Part2 Sample:", sampleResult)
//        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 58)
//        XCTAssertEqual(result, 2028)
    }

}
