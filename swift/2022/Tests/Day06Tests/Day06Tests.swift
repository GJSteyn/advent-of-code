import XCTest
@testable import Day06

let sample1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
let sample2 = "bvwbjplbgvbhsrlpgdmjqwftvncz"
let sample3 = "nppdvjthqldpwncqszvftbrmjlhg"

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day06.txt")

final class Day06Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult1 = Day06.part1(input: sample1)
        let sampleResult2 = Day06.part1(input: sample2)
        let sampleResult3 = Day06.part1(input: sample3)
        let result = Day06.part1(input: input)
        print("Part1 Sample1:", sampleResult1)
        print("Part1 Sample2:", sampleResult2)
        print("Part1 Sample3:", sampleResult3)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult1, 7)
        XCTAssertEqual(sampleResult2, 5)
        XCTAssertEqual(sampleResult3, 6)
        XCTAssertEqual(result, 1275)
    }

    func testPart2() throws {
        let sampleResult1 = Day06.part2(input: sample1)
        let sampleResult2 = Day06.part2(input: sample2)
        let sampleResult3 = Day06.part2(input: sample3)
        let result = Day06.part2(input: input)
        print("Part2 Sample1:", sampleResult1)
        print("Part2 Sample2:", sampleResult2)
        print("Part2 Sample3:", sampleResult3)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult1, 19)
        XCTAssertEqual(sampleResult2, 23)
        XCTAssertEqual(sampleResult3, 23)
        XCTAssertEqual(result, 3605)
    }
}
