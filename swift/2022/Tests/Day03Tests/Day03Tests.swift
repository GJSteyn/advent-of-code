import XCTest
@testable import Day03

let sample = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day03.txt")

final class Day03Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day03.part1(input: sample)
        let result = Day03.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 157)
        XCTAssertEqual(result, 8349)
    }
    
    func testPart2() throws {
        let sampleResult = Day03.part2(input: sample)
        let result = Day03.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 70)
        XCTAssertEqual(result, 2681)
    }
}
