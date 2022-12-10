import Foundation

import Util

// TODO: Clean up

public struct Day09 {
    enum MoveError: Error {
        case unexpected(String)
    }

    enum Direction: String {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"
    }

    private static func moveTail(from tail: Point, head: Point) throws -> Point {
        let xDistance = abs(tail.x - head.x)
        let yDistance = abs(tail.y - head.y)
        let distance = Int(sqrt(pow(Double(tail.x - head.x), 2) + pow(Double(tail.y - head.y), 2)))

        let xSign = xDistance == 0 ? 0 : (head.x - tail.x) / xDistance
        let ySign = yDistance == 0 ? 0 : (head.y - tail.y) / yDistance

        if distance <= 1 {
            return tail
        } else if yDistance > 1 && xDistance == 0 {
            return Point(x: tail.x, y: tail.y + ySign)
        } else if xDistance > 1 && yDistance == 0 {
            return Point(x: tail.x + xSign, y: tail.y)
        } else if yDistance > 1 && xDistance == 1 {
            return Point(x: head.x, y: tail.y + ySign)
        } else if xDistance > 1 && yDistance == 1 {
            return Point(x: tail.x + xSign, y: head.y)
        } else if xDistance == 2 && yDistance == 2 {
            return Point(x: tail.x + xSign, y: tail.y + ySign)
        } else {
            throw MoveError.unexpected("We got into a weird position - head(\(head)), tail(\(tail)), distance: \(distance), xSign: \(xSign), ySign: \(ySign)")
        }
    }

    private static func moveRope(direction: Direction, distance: Int, rope: [Point], effect: ((Point) -> Void)?) -> [Point] {
        let range: [Int]
        switch direction {
        case .up:
            range = Array(rope[0].y+1...(rope[0].y + distance))
        case .down:
            range = ((rope[0].y - distance)...rope[0].y-1).reversed()
        case .left:
            range = ((rope[0].x - distance)...rope[0].x-1).reversed()
        case .right:
            range = Array(rope[0].x+1...(rope[0].x + distance))
        }

        func getHead(direction: Direction, previousHead: Point, next: Int) -> Point {
            switch direction {
            case .up, .down:
                return Point(x: previousHead.x, y: next)
            case .left, .right:
                return Point(x: next, y: previousHead.y)
            }
        }

        return range.reduce(rope, { (prevPositions: [Point], next: Int) in
            let head = getHead(direction: direction, previousHead: prevPositions[0], next: next)
            let rest = Array(prevPositions[1...])
            let after = rest.enumerated().reduce([head], { (acc: [Point], current: (offset: Int, element: Point)) in
                let previous = acc[current.offset]
                let next = try! moveTail(from: rest[current.offset], head: previous)
                return acc + [next]
            })
            effect?(after[after.count - 1])
            return after
        })
    }

    public static func part1(input: String) throws -> Int {
        let instructions = Util.getLines(input)
            .map { $0.components(separatedBy: " ") }
            .map { (direction: Direction(rawValue: $0[0])!, distance: Int($0[1])!) }

        let startingPositions = Array(repeating: Point(x: 0, y: 0), count: 2)
        var pointsVisited: [Point] = []
        var currentPositions: [Point] = startingPositions

        for instruction in instructions {
            currentPositions = moveRope(direction: instruction.direction, distance: instruction.distance, rope: currentPositions, effect: { pointsVisited.append($0) })
        }

//        // Alternative accumulator. But I should find a better way to avoid the side-effect.
//        let _ = instructions.reduce(startingpositions, { (positions: [point], instr: (direction: direction, distance: int)) in
//            moverope(direction: instr.direction, distance: instr.distance, rope: positions, effect: { pointsvisited.append($0) })
//        })

        return Set(pointsVisited).count
    }

    public static func part2(input: String) throws -> Int {
        let instructions = Util.getLines(input)
            .map { $0.components(separatedBy: " ") }
            .map { (direction: Direction(rawValue: $0[0])!, distance: Int($0[1])!) }

        let startingPositions = Array(repeating: Point(x: 0, y: 0), count: 10)
        var pointsVisited: [Point] = []

        let _ = instructions.reduce(startingPositions, { (positions: [Point], instr: (direction: Direction, distance: Int)) in
            moveRope(direction: instr.direction,
                     distance: instr.distance,
                     rope: positions,
                     effect: { pointsVisited.append($0) })
        })

        return Set(pointsVisited).count
    }
}
