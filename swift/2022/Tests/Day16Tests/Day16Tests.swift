import XCTest
@testable import Day16

let sample = """
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day16.txt")

final class Day16Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = Day16.part1(input: sample)
        let result = Day16.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 1651)
        XCTAssertEqual(result, 1737)
    }

    func testPart2() throws {
        let sampleResult = Day16.part2(input: sample)
        let result = Day16.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 1707)
        XCTAssertEqual(result, 2216)
    }
}
