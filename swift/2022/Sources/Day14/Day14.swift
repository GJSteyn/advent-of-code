import Foundation

import Util

public struct Day14 {
    struct Line {
        let xRange: ClosedRange<Int>
        let yRange: ClosedRange<Int>

        init(start: Point, end: Point) {
            let xs = [start.x, end.x]
            let ys = [start.y, end.y]
            let xMin = xs.min()!
            let yMin = ys.min()!
            let xMax = xs.max()!
            let yMax = ys.max()!
            self.xRange = xMin...xMax
            self.yRange = yMin...yMax
        }
    }

    private static func linesFromInput(_ input: String) -> [Line] {
        return Array(Util.getLines(input)
            .map {
                let thing = $0.components(separatedBy: " -> ").map {
                    let components = $0.components(separatedBy: ",")
                    return Point(x: Int(components[0])!, y: Int(components[1])!)
                }
                return overlappingChunks(thing, chunkSize: 2).map { Line(start: $0[0], end: $0[1]) }
            }.joined())
    }

    private static func overlappingChunks<T>(_ arr: [T], chunkSize: Int) -> [[T]] {
        var result: [[T]] = []
        for i in 0...arr.count - chunkSize {
            result.append(Array(arr[i..<i+chunkSize]))
        }
        return result
    }

    // Trying out `inout`, because why not.
    private static func drawLine(on board: inout [[String]], line: Line) -> Void {
        let lineIsHorizontal = line.xRange.count > line.yRange.count

        if lineIsHorizontal {
            let y = line.yRange.first!
            for x in line.xRange {
                board[y][x] = "#"
            }
        } else {
            let x = line.xRange.first!
            for y in line.yRange {
                board[y][x] = "#"
            }
        }
    }

    // The return value indicates whether the grain of sand falls into the abyss.
    private static func dropSand(on board: inout [[String]], from start: Point) -> Bool {
        if board[start.y][start.x] == "o" || start.y >= board.count - 1 {
            return true
        }

        if board[start.y + 1][start.x] == "." {
            return dropSand(on: &board, from: Point(x: start.x, y: start.y + 1))
        } else if board[start.y + 1][start.x - 1] == "." {
            return dropSand(on: &board, from: Point(x: start.x - 1, y: start.y + 1))
        } else if board[start.y + 1][start.x + 1] == "." {
            return dropSand(on: &board, from: Point(x: start.x + 1, y: start.y + 1))
        } else {
            board[start.y][start.x] = "o"
            return false
        }
    }

    public static func part1(input: String) -> Int {
        let lines = linesFromInput(input)
        var board = [[String]](repeating: [String](repeating: ".", count: 1000), count: 1000)
        for line in lines {
            drawLine(on: &board, line: line)
        }

        let sandStartPosition = Point(x: 500, y: 0)
        var result = 0
        while !dropSand(on: &board, from: sandStartPosition) {
            result += 1
        }

        return result
    }

    public static func part2(input: String) -> Int {
        let lines = linesFromInput(input)
        var board = [[String]](repeating: [String](repeating: ".", count: 1000), count: 1000)
        for line in lines {
            drawLine(on: &board, line: line)
        }

        let maxY = lines.map { $0.yRange.max()! }.max()! + 2
        let floor = Line(start: Point(x: 0, y: maxY), end: Point(x: 999, y: maxY))
        drawLine(on: &board, line: floor)

        let sandStartPosition = Point(x: 500, y: 0)
        var result = 0
        while !dropSand(on: &board, from: sandStartPosition) {
            result += 1
        }

        return result
    }
}
