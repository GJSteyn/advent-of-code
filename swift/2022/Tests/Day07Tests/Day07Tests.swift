import XCTest
@testable import Day07

let sample = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

let input = try! String(contentsOfFile: "../../puzzle_input/2022/day07.txt")

final class Day07Tests: XCTestCase {
    func testPart1() throws {
        let sampleResult = try! Day07.part1(input: sample)
        let result = try! Day07.part1(input: input)
        print("Part1 Sample:", sampleResult)
        print("Part1 Result:", result)
        XCTAssertEqual(sampleResult, 95437)
        XCTAssertEqual(result, 1077191)
    }

    func testPart2() throws {
        let sampleResult = try! Day07.part2(input: sample)
        let result = try! Day07.part2(input: input)
        print("Part2 Sample:", sampleResult)
        print("Part2 Result:", result)
        XCTAssertEqual(sampleResult, 24933642)
        XCTAssertEqual(result, 5649896)
    }
}
