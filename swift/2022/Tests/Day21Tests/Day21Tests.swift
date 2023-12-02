import XCTest
@testable import Day21

let sample = """
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day21.txt")

final class Day21Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day21.part1(input: sample)
//        let result = Day21.part1(input: input)
        print("Part1 Sample:", sampleResult)
//        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 152)
//        XCTAssertEqual(result, 80326079210554)
    }

    func testPart2() throws {
        let sampleResult = Day21.part2(input: input)
//        let result = Day21.part2(input: input)
        print("Part2 Sample:", sampleResult)
//        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 301)
//        XCTAssertEqual(result, 3617613952378)
    }
}
