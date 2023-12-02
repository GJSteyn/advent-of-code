import XCTest
@testable import Day19

let sample = """
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day19.txt")

final class Day19Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day19.part1(input: sample)
        let result = Day19.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 33)
        XCTAssertEqual(result, 1081)
    }
    
    func testPart2() throws {
        let result = Day19.part2(input: input)
        print("Part2 Result:", result)
        XCTAssertEqual(result, 2415)
    }
}
