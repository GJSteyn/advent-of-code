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
        let part1SampleResult = Day03.part1(input: sample)
        let part1Result = Day03.part1(input: input)
        print("Part1 Sample:", part1SampleResult)
        print("Part1 Result:", part1Result)
        XCTAssertEqual(part1SampleResult, 157)
        XCTAssertEqual(part1Result, 8349)
    }
    
    func testPart2() throws {
        let part2SampleResult = Day03.part2(input: sample)
        let part2Result = Day03.part2(input: input)
        print("Part2 Sample:", part2SampleResult)
        print("Part2 Result:", part2Result)
        XCTAssertEqual(part2SampleResult, 70)
        XCTAssertEqual(part2Result, 2681)
    }
}
