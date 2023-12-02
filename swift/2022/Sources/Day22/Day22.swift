import Foundation

import Util

public struct Day22 {
    enum Rotation: String {
        case cw = "R"
        case ccw = "L"
    }

    enum Dir: Int {
        case right = 0, down, left, up

        static func rotate(rotation: Rotation, dir: Dir) -> Dir {
            switch rotation {
            case .cw:
                switch dir {
                case .right:
                    return .down
                case .left:
                    return .up
                case .up:
                    return .right
                case .down:
                    return .left
                }
            case .ccw:
                switch dir {
                case .right:
                    return .up
                case .left:
                    return .down
                case .up:
                    return .left
                case .down:
                    return .right
                }
            }
        }
    }

    private static func move(from: Point, dir: Dir, in map: [String]) -> Point {
        let width = map[0].count
        let height = map.count

        let nextPoint: Point
        switch dir {
        case .right:
            if from.x + 1 == width {
                let row = map[from.y]
                let nextX = row.distance(from: row.startIndex, to: row.firstIndex(where: { $0 != " " })!)
                nextPoint = Point(x: nextX, y: from.y)
            } else {
                let nextCharacter = map[from.y][map[from.y].index(map[from.y].startIndex, offsetBy: from.x + 1)]
                if nextCharacter == " " {
                    let row = map[from.y]
                    let nextX = row.distance(from: row.startIndex, to: row.firstIndex(where: { $0 != " " })!)
                    nextPoint = Point(x: nextX, y: from.y)
                } else {
                    nextPoint = Point(x: from.x + 1, y: from.y)
                }
            }
        case .left:
            if from.x - 1 < 0 {
                let row = map[from.y]
                let nextX = row.distance(from: row.startIndex, to: row.lastIndex(where: { $0 != " " })!)
                nextPoint = Point(x: nextX, y: from.y)
            } else {
                let nextCharacter = map[from.y][map[from.y].index(map[from.y].startIndex, offsetBy: from.x - 1)]
                if nextCharacter == " " {
                    let row = map[from.y]
                    let nextX = row.distance(from: row.startIndex, to: row.lastIndex(where: { $0 != " " })!)
                    nextPoint = Point(x: nextX, y: from.y)
                } else {
                    nextPoint = Point(x: from.x - 1, y: from.y)
                }
            }
        case .up:
            if from.y - 1 < 0 {
                let column = map.map { $0[$0.index($0.startIndex, offsetBy: from.x)] }
                let nextY = column.distance(from: column.startIndex, to: column.lastIndex(where: { $0 != " " })!)
                nextPoint = Point(x: from.x, y: nextY)
            } else {
                let nextCharacter = map[from.y - 1][map[from.y - 1].index(map[from.y - 1].startIndex, offsetBy: from.x)]
                if nextCharacter == " " {
                    let column = map.map { $0[$0.index($0.startIndex, offsetBy: from.x)] }
                    let nextY = column.distance(from: column.startIndex, to: column.lastIndex(where: { $0 != " " })!)
                    nextPoint = Point(x: from.x, y: nextY)
                } else {
                    nextPoint = Point(x: from.x, y: from.y - 1)
                }
            }
        case .down:
            if from.y + 1 == height {
                let column = map.map { $0[$0.index($0.startIndex, offsetBy: from.x)] }
                let nextY = column.distance(from: column.startIndex, to: column.firstIndex(where: { $0 != " " })!)
                nextPoint = Point(x: from.x, y: nextY)
            } else {
                let nextCharacter = map[from.y + 1][map[from.y + 1].index(map[from.y + 1].startIndex, offsetBy: from.x)]
                if nextCharacter == " " {
                    let column = map.map { $0[$0.index($0.startIndex, offsetBy: from.x)] }
                    let nextY = column.distance(from: column.startIndex, to: column.firstIndex(where: { $0 != " " })!)
                    nextPoint = Point(x: from.x, y: nextY)
                } else {
                    nextPoint = Point(x: from.x, y: from.y + 1)
                }
            }
        }

        let nextCharacter = map[nextPoint.y][map[nextPoint.y].index(map[nextPoint.y].startIndex, offsetBy: nextPoint.x)]
        if nextCharacter == "#" {
            return from
        }

        return nextPoint
    }

    private static func printMap(_ map: [String], _ pos: Point) -> Void {
        var innerMap = map.map { Array($0) }

        innerMap[pos.y][pos.x] = "X"
        for line in innerMap {
            print(String(line))
        }
    }

    public static func part1(input: String) -> Int {
        let inp = Util.getLines(input)
        let instr = inp.last!
        let baseMap = inp[0..<inp.count - 2]
        let maxWidth = baseMap.reduce(0, { max($0, $1.count) })
        let map = baseMap.map { $0.padding(toLength: maxWidth, withPad: " ", startingAt: 0) }

        let startX = map[0].distance(from: map[0].startIndex, to: map[0].firstIndex(of: ".")!)
        let startY = 0
        let start = Point(x: startX, y: startY)

        let nMoves = instr.components(separatedBy: CharacterSet.decimalDigits.inverted).map { Int($0)! }
        let rotations = instr.components(separatedBy: CharacterSet.decimalDigits).filter { $0 != "" }
        let zipped = Array(zip(nMoves, rotations))

        var pos = start
        var direction = Dir.right
        for i in 0..<zipped.count {
            let (dist, rot) = zipped[i]
            var innerDist = dist
            while innerDist > 0 {
                pos = move(from: pos, dir: direction, in: map)
                innerDist -= 1
            }

            direction = Dir.rotate(rotation: Rotation(rawValue: rot)!, dir: direction)
        }

        var innerDist = nMoves.last!
        while innerDist > 0 {
            pos = move(from: pos, dir: direction, in: map)
            innerDist -= 1
        }

        return (1000 * (pos.y + 1)) + (4 * (pos.x + 1)) + direction.rawValue
    }

    class Face {
        let grid: Grid<Character>
        let idx: Int
        let pos: Point
        var left: Face?
        var right: Face?
        var top: Face?
        var bottom: Face?

        var leftTransform: ((Point) -> (Point, Dir))?
        var rightTransform: ((Point) -> (Point, Dir))?
        var topTransform: ((Point) -> (Point, Dir))?
        var bottomTransform: ((Point) -> (Point, Dir))?

        init(grid: Grid<Character>, idx: Int, pos: Point, left: Face? = nil, right: Face? = nil, top: Face? = nil, bottom: Face? = nil) {
            self.grid = grid
            self.idx = idx
            self.pos = pos
            self.left = left
            self.right = right
            self.top = top
            self.bottom = bottom
        }

        func setSides(left: Face, right: Face, top: Face, bottom: Face) {
            self.left = left
            self.right = right
            self.top = top
            self.bottom = bottom
        }
    }

    private static func printMap(paddedMap: [String], state: (pos: Point, face: Face, dir: Dir)) -> Void {
        let positionX = state.face.pos.x * state.face.grid.width + state.pos.x
        let positionY = state.face.pos.y * state.face.grid.height + state.pos.y
        print("Player POS: (\(state.pos.x), \(state.pos.y)) - face: \(state.face.idx)")
        print("Position: (\(positionX), \(positionY))")
        for y in 0..<paddedMap.count {
            let row = paddedMap[y].enumerated().map { (offset: Int, element: Character) in
                if y == positionY && offset == positionX {
                    return "P"
                } else {
                    return String(element)
                }
            }
            print(row.joined())
        }
    }

    private static func moveCube(from: Point, face: Face, dir: Dir, movesLeft: Int) -> (pos: Point, dir: Dir, face: Face) {
        let width = face.grid.width
        let height = face.grid.height

        let nextPoint: Point
        let nextDir: Dir
        var nextFace = face

        switch dir {
        case .right:
            if from.x + 1 == width {
                nextFace = face.right!
                switch face.idx {
                case nextFace.left!.idx:
                    (nextPoint, nextDir) = nextFace.leftTransform!(from)
                case nextFace.right!.idx:
                    (nextPoint, nextDir) = nextFace.rightTransform!(from)
                case nextFace.top!.idx:
                    (nextPoint, nextDir) = nextFace.topTransform!(from)
                case nextFace.bottom!.idx:
                    (nextPoint, nextDir) = nextFace.bottomTransform!(from)
                default:
                    print("These faces aren't connected properly - \(face.idx) & \(nextFace.idx)")
                    (nextPoint, nextDir) = (from, dir)
                }
            } else {
                (nextPoint, nextDir) = (from.right(), dir)
            }
        case .left:
            if from.x - 1 < 0 {
                nextFace = face.left!
                switch face.idx {
                case nextFace.left!.idx:
                    (nextPoint, nextDir) = nextFace.leftTransform!(from)
                case nextFace.right!.idx:
                    (nextPoint, nextDir) = nextFace.rightTransform!(from)
                case nextFace.top!.idx:
                    (nextPoint, nextDir) = nextFace.topTransform!(from)
                case nextFace.bottom!.idx:
                    (nextPoint, nextDir) = nextFace.bottomTransform!(from)
                default:
                    print("These faces aren't connected properly - \(face.idx) & \(nextFace.idx)")
                    (nextPoint, nextDir) = (from, dir)
                }
            } else {
                (nextPoint, nextDir) = (from.left(), dir)
            }
        case .up:
            if from.y - 1 < 0 {
                nextFace = face.top!
                switch face.idx {
                case nextFace.left!.idx:
                    (nextPoint, nextDir) = nextFace.leftTransform!(from)
                case nextFace.right!.idx:
                    (nextPoint, nextDir) = nextFace.rightTransform!(from)
                case nextFace.top!.idx:
                    (nextPoint, nextDir) = nextFace.topTransform!(from)
                case nextFace.bottom!.idx:
                    (nextPoint, nextDir) = nextFace.bottomTransform!(from)
                default:
                    print("These faces aren't connected properly - \(face.idx) & \(nextFace.idx)")
                    (nextPoint, nextDir) = (from, dir)
                }
            } else {
                (nextPoint, nextDir) = (from.up(), dir)
            }
        case .down:
            if from.y + 1 == height {
                nextFace = face.bottom!
                switch face.idx {
                case nextFace.left!.idx:
                    (nextPoint, nextDir) = nextFace.leftTransform!(from)
                case nextFace.right!.idx:
                    (nextPoint, nextDir) = nextFace.rightTransform!(from)
                case nextFace.top!.idx:
                    (nextPoint, nextDir) = nextFace.topTransform!(from)
                case nextFace.bottom!.idx:
                    (nextPoint, nextDir) = nextFace.bottomTransform!(from)
                default:
                    print("These faces aren't connected properly - \(face.idx) & \(nextFace.idx)")
                    (nextPoint, nextDir) = (from, dir)
                }
            } else {
                (nextPoint, nextDir) = (from.down(), dir)
            }
        }

        let nextCharacter = nextFace.grid.at(nextPoint)
        if nextCharacter == "#" {
            return (pos: from, dir: dir, face: face)
        } else if movesLeft > 1 {
            return moveCube(from: nextPoint, face: nextFace, dir: nextDir, movesLeft: movesLeft - 1)
        } else {
            return (pos: nextPoint, dir: nextDir, face: nextFace)
        }
    }

    public static func part2(input: String) -> Int {
        let inp = Util.getLines(input)
        let instr = inp.last!
        let baseMap = inp[0..<inp.count - 2]
        let maxWidth = baseMap.reduce(0, { max($0, $1.count) })
        let paddedMap = baseMap.map { $0.padding(toLength: maxWidth, withPad: " ", startingAt: 0) }
        let chunkedMap = paddedMap
            .chunked(into: 4)
            .map { $0.map { Array($0).chunked(into: 4).map { String($0) } } }

        let grids = chunkedMap.map { (chunk) in
            (0..<4).map { (x) in
                let elements = chunk.map { $0[x] }.joined()
                return Grid(elements: Array(elements), width: 4, height: 4)
            }
        }.joined().filter { !$0.elements.contains { $0 == " " } }

        let face1 = Face(grid: grids[0], idx: 1, pos: Point(2, 0))
        let face2 = Face(grid: grids[1], idx: 2, pos: Point(0, 1))
        let face3 = Face(grid: grids[2], idx: 3, pos: Point(1, 1))
        let face4 = Face(grid: grids[3], idx: 4, pos: Point(2, 1))
        let face5 = Face(grid: grids[4], idx: 5, pos: Point(2, 2))
        let face6 = Face(grid: grids[5], idx: 6, pos: Point(3, 2))

        face1.setSides(left: face3, right: face6, top: face2, bottom: face4)
        face2.setSides(left: face6, right: face3, top: face1, bottom: face5)
        face3.setSides(left: face2, right: face4, top: face1, bottom: face5)
        face4.setSides(left: face3, right: face6, top: face1, bottom: face5)
        face5.setSides(left: face3, right: face6, top: face4, bottom: face2)
        face6.setSides(left: face5, right: face1, top: face4, bottom: face2)

        face1.topTransform = { (point) in
            (Point(face1.grid.width - point.x - 1, 0), .down)
        }
        face1.leftTransform = { (point) in
            (Point(0, point.x), .right)
        }
        face1.rightTransform = { (point) in
            (Point(face1.grid.width - 1, face1.grid.height - point.y - 1), .left)
        }
        face1.bottomTransform = { (point) in
            (Point(point.x, face1.grid.height - 1), .up)
        }

        face2.topTransform = face1.topTransform
        face2.leftTransform = { (point) in
            (Point(0, face2.grid.height - point.x - 1), .right)
        }
        face2.rightTransform = { (point) in
            (Point(face2.grid.width - 1, point.y), .left)
        }
        face2.bottomTransform = { (point) in
            (Point(face2.grid.width - point.x - 1, face2.grid.height - 1), .up)
        }

        face3.topTransform = { (point) in
            (Point(point.y, 0), .down)
        }
        face3.leftTransform = { (point) in
            (Point(0, point.y), .right)
        }
        face3.rightTransform = { (point) in
            (Point(face3.grid.width - 1, point.y), .left)
        }
        face3.bottomTransform = { (point) in
            (Point(face3.grid.width - point.y - 1, face3.grid.height - 1), .up)
        }

        face4.topTransform = { (point) in
            (Point(point.x, 0), .down)
        }
        face4.leftTransform = { (point) in
            (Point(0, point.y), .right)
        }
        face4.rightTransform = { (point) in
            (Point(face4.grid.width - 1, face4.grid.height - point.x - 1), .left)
        }
        face4.bottomTransform = { (point) in
            (Point(point.x, face4.grid.height - 1), .up)
        }

        face5.topTransform = { (point) in
            (Point(point.x, 0), .down)
        }
        face5.leftTransform = { (point) in
            (Point(0, face5.grid.height - point.x - 1), .right)
        }
        face5.rightTransform = { (point) in
            (Point(face5.grid.width - 1, point.y), .left)
        }
        face5.bottomTransform = { (point) in
            (Point(face5.grid.width - point.x - 1, face5.grid.height - 1), .up)
        }

        face6.topTransform = { (point) in
            (Point(face6.grid.width - point.y - 1, 0), .down)
        }
        face6.leftTransform = { (point) in
            (Point(0, point.y), .right)
        }
        face6.rightTransform = { (point) in
            (Point(face6.grid.width - 1, face6.grid.height - point.y - 1), .left)
        }
        face6.bottomTransform = { (point) in
            (Point(face6.grid.width - point.y - 1, face6.grid.width - 1), .up)
        }

        let nMoves = instr.components(separatedBy: CharacterSet.decimalDigits.inverted).map { Int($0)! }
        let rotations = instr.components(separatedBy: CharacterSet.decimalDigits).filter { $0 != "" }
        let zipped = Array(zip(nMoves, rotations))

        var state = (pos: Point(0, 0), dir: Dir.right, face: face1)
        for i in 0..<zipped.count {
            let (dist, rot) = zipped[i]
            state = moveCube(from: state.pos, face: state.face, dir: state.dir, movesLeft: dist)
            state.dir = Dir.rotate(rotation: Rotation(rawValue: rot)!, dir: state.dir)
        }

        state = moveCube(from: state.pos, face: state.face, dir: state.dir, movesLeft: nMoves.last!)

        let yVal = 1000 * (state.face.pos.y * state.face.grid.height + state.pos.y + 1)
        let xVal = 4 * (state.face.pos.x * state.face.grid.width + state.pos.x + 1)
        return yVal + xVal + state.dir.rawValue
    }

    public static func part2_2(input: String) -> Int {
        let inp = Util.getLines(input)
        let instr = inp.last!
        let baseMap = inp[0..<inp.count - 2]
        let maxWidth = baseMap.reduce(0, { max($0, $1.count) })
        let paddedMap = baseMap.map { $0.padding(toLength: maxWidth, withPad: " ", startingAt: 0) }
        let chunkedMap = paddedMap
            .chunked(into: 50)
            .map { $0.map { Array($0).chunked(into: 50).map { String($0) } } }

        let grids = chunkedMap.map { (chunk) in
            (0..<3).map { (x) in
                let elements = chunk.map { $0[x] }.joined()
                return Grid(elements: Array(elements), width: 50, height: 50)
            }
        }.joined().filter { !$0.elements.contains { $0 == " " } }

        let face1 = Face(grid: grids[0], idx: 1, pos: Point(1, 0))
        let face2 = Face(grid: grids[1], idx: 2, pos: Point(2, 0))
        let face3 = Face(grid: grids[2], idx: 3, pos: Point(1, 1))
        let face4 = Face(grid: grids[3], idx: 4, pos: Point(0, 2))
        let face5 = Face(grid: grids[4], idx: 5, pos: Point(1, 2))
        let face6 = Face(grid: grids[5], idx: 6, pos: Point(0, 3))

        face1.setSides(left: face4, right: face2, top: face6, bottom: face3)
        face2.setSides(left: face1, right: face5, top: face6, bottom: face3)
        face3.setSides(left: face4, right: face2, top: face1, bottom: face5)
        face4.setSides(left: face1, right: face5, top: face3, bottom: face6)
        face5.setSides(left: face4, right: face2, top: face3, bottom: face6)
        face6.setSides(left: face1, right: face5, top: face4, bottom: face2)

        face1.topTransform = { (point) in
            (Point(point.y, 0), .down)
        }
        face1.leftTransform = { (point) in
            (Point(0, face1.grid.height - point.y - 1), .right)
        }
        face1.rightTransform = { (point) in
            (Point(face1.grid.width - 1, point.y), .left)
        }
        face1.bottomTransform = { (point) in
            (Point(point.x, face1.grid.height - 1), .up)
        }

        face2.topTransform = { (point) in
            (Point(point.x, 0), .down)
        }
        face2.leftTransform = { (point) in
            (Point(0, point.y), .right)
        }
        face2.rightTransform = { (point) in
            (Point(face2.grid.width - 1, face2.grid.height - point.y - 1), .left)
        }
        face2.bottomTransform = { (point) in
            (Point(point.y, face2.grid.height - 1), .up)
        }

        face3.topTransform = { (point) in
            (Point(point.x, 0), .down)
        }
        face3.leftTransform = { (point) in
            (Point(0, point.x), .right)
        }
        face3.rightTransform = { (point) in
            (Point(face3.grid.width - 1, point.x), .left)
        }
        face3.bottomTransform = { (point) in
            (Point(point.x, face3.grid.height - 1), .up)
        }

        face4.topTransform = { (point) in
            (Point(point.y, 0), .down)
        }
        face4.leftTransform = { (point) in
            (Point(0, face4.grid.height - point.y - 1), .right)
        }
        face4.rightTransform = { (point) in
            (Point(face4.grid.width - 1, point.y), .left)
        }
        face4.bottomTransform = { (point) in
            (Point(point.x, face4.grid.height - 1), .up)
        }

        face5.topTransform = { (point) in
            (Point(point.x, 0), .down)
        }
        face5.leftTransform = { (point) in
            (Point(0, point.y), .right)
        }
        face5.rightTransform = { (point) in
            (Point(face5.grid.width - 1, face5.grid.height - point.y - 1), .left)
        }
        face5.bottomTransform = { (point) in
            (Point(point.y, face5.grid.height - 1), .up)
        }

        face6.topTransform = { (point) in
            (Point(point.x, 0), .down)
        }
        face6.leftTransform = { (point) in
            (Point(0, point.x), .right)
        }
        face6.rightTransform = { (point) in
            (Point(face6.grid.width - 1, point.x), .left)
        }
        face6.bottomTransform = { (point) in
            (Point(point.x, face6.grid.width - 1), .up)
        }

        let nMoves = instr.components(separatedBy: CharacterSet.decimalDigits.inverted).map { Int($0)! }
        let rotations = instr.components(separatedBy: CharacterSet.decimalDigits).filter { $0 != "" }
        let zipped = Array(zip(nMoves, rotations))

        var state = (pos: Point(0, 0), dir: Dir.right, face: face1)
        for i in 0..<zipped.count {
            let (dist, rot) = zipped[i]
            state = moveCube(from: state.pos, face: state.face, dir: state.dir, movesLeft: dist)
            state.dir = Dir.rotate(rotation: Rotation(rawValue: rot)!, dir: state.dir)
        }

        state = moveCube(from: state.pos, face: state.face, dir: state.dir, movesLeft: nMoves.last!)

        let yVal = 1000 * (state.face.pos.y * state.face.grid.height + state.pos.y + 1)
        let xVal = 4 * (state.face.pos.x * state.face.grid.width + state.pos.x + 1)
        return yVal + xVal + state.dir.rawValue
    }
}
