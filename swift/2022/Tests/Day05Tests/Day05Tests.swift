import XCTest
@testable import Day05

// XCode automatically trims trailing whitespace from this input when in multiline form (according to my settings).
// I'd prefer to keep that setting for everything else, so I'm onelining it here.
//    [D]
//[N] [C]
//[Z] [M] [P]
// 1   2   3
//
//move 1 from 2 to 1
//move 3 from 1 to 3
//move 2 from 2 to 1
//move 1 from 1 to 2
let sample = "    [D]    \n[N] [C]    \n[Z] [M] [P]\n1   2   3\n\nmove 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2\n"

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day05.txt")

final class Day05Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day05.part1(input: sample)
        let result = Day05.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, "CMZ")
        XCTAssertEqual(result, "SVFDLGLWV")
    }

    func testPart2() throws {
        let sampleResult = Day05.part2(input: sample)
        let result = Day05.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, "MCD")
        XCTAssertEqual(result, "DCVTCVPCL")
    }
}
