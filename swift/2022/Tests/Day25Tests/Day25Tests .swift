import XCTest
@testable import Day25

let sample = """
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day25.txt")

final class Day25Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day25.part1(input: sample)
        let result = Day25.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, "2=-1=0")
        XCTAssertEqual(result, "2=0--0---11--01=-100")
    }
}
