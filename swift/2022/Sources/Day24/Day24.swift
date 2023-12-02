import Foundation

import Util

class Grid<T> {
    var elements: [T]
    let width: Int
    let height: Int

    init(elements: [T], width: Int, height: Int) {
        self.elements = elements
        self.width = width
        self.height = height
    }

    public func at(x: Int, y: Int) -> T? {
        return self.elements[safe: y * width + x]
    }

    public func at(_ point: Point) -> T? {
        return self.at(x: point.x, y: point.y)
    }

    public func set(_ val: T, at point: Point) -> Grid<T> {
        let copy = self
        copy.elements[point.y * width + point.x] = val
        return copy
    }

    public func row(y: Int) -> [T] {
        return Array(elements[y * width..<y * width + width])
    }

    public func col(x: Int) -> [T] {
        return elements.enumerated().filter { (offset: Int, element: T) in
            offset % width == x
        }.map { $0.element }
    }

    public func copy() -> Grid<T> {
        Grid(elements: elements, width: width, height: height)
    }
}

public struct Day24 {
    static let GLOBAL_START = Point(1, 0)
    static var GLOBAL_END = Point(0, 0)
    static var GLOBAL_SHORTEST = 641
    static var DONE_ACTIONS: [RoundAction: Bool] = [:]
    static var BOARDS: [Grid<Tile>] = []

    enum TileType: Character {
        case wall = "#"
        case ground = "."
        case blUp = "^"
        case blDown = "v"
        case blLeft = "<"
        case blRight = ">"
    }

    struct Tile {
        var holding: [TileType]

        init(holding: [TileType] = []) {
            self.holding = holding
        }

        func add(_ tileType: TileType) -> Tile {
            var copy = self
            copy.holding.append(tileType)
            return copy
        }

        func remove(_ tileType: TileType) -> Tile {
            var copy = self
            let maybeFirstIndex = copy.holding.firstIndex(where: { $0 == tileType })
            if let firstIndex = maybeFirstIndex {
                copy.holding.remove(at: firstIndex)
            }
            return copy
        }
    }

    struct MoveProposal {
        let type: TileType
        let from: Point
        let to: Point
    }

    enum Action {
        case up, down, left, right, wait
    }

    struct RoundAction: Hashable {
        let round: Int
        let point: Point
        let action: Action

        var hashValue: String {
            String(round) + String(point.x) + String(point.y) + String(describing: action)
        }
    }

    private static func printGrid(_ grid: Grid<Tile>, player: Point? = nil) -> Void {
        for y in 0..<grid.height {
            let row = grid.row(y: y)
            print(row.enumerated().map { (x: Int, element: Tile) in
                if Point(x, y) == player {
                    return "E"
                } else {
                    return element.holding.count > 1
                    ? String(element.holding.count)
                    : element.holding.count == 0
                    ? "."
                    : String(element.holding[0].rawValue)
                }
            }.joined())
        }
    }

    private static func moveBlizzard(in grid: Grid<Tile>, type: TileType, from: Point) -> MoveProposal {
        var dest: Point
        switch type {
        case .blUp:
            let maybeTile = grid.at(x: from.x, y: from.y - 1)
            if let tile = maybeTile {
                if tile.holding.count > 0 && tile.holding[0] == .wall {
                    dest = Point(from.x, grid.height - 2)
                } else {
                    dest = Point(from.x, from.y - 1)
                }
            } else {
                dest = from
            }
        case .blDown:
            let maybeTile = grid.at(x: from.x, y: from.y + 1)
            if let tile = maybeTile {
                if tile.holding.count > 0 && tile.holding[0] == .wall {
                    dest = Point(from.x, 1)
                } else {
                    dest = Point(from.x, from.y + 1)
                }
            } else {
                dest = from
            }
        case .blLeft:
            let maybeTile = grid.at(x: from.x - 1, y: from.y)
            if let tile = maybeTile {
                if tile.holding.count > 0 && tile.holding[0] == .wall {
                    dest = Point(grid.width - 2, from.y)
                } else {
                    dest = Point(from.x - 1, from.y)
                }
            } else {
                dest = from
            }
        case .blRight:
            let maybeTile = grid.at(x: from.x + 1, y: from.y)
            if let tile = maybeTile {
                if tile.holding.count > 0 && tile.holding[0] == .wall {
                    dest = Point(1, from.y)
                } else {
                    dest = Point(from.x + 1, from.y)
                }
            } else {
                dest = from
            }
        default:
            dest = from
        }

        return MoveProposal(type: type, from: from, to: dest)
    }

    private static func processTile(in grid: Grid<Tile>, at: Point) -> [MoveProposal] {
        let maybeHolding: [TileType]? = grid.at(x: at.x, y: at.y)?.holding

        var result: [MoveProposal?] = []
        if let holding = maybeHolding {
            result = holding.map { (type: TileType) in
                switch type {
                case .blUp, .blDown, .blLeft, .blRight:
                    return moveBlizzard(in: grid, type: type, from: at)
                default:
                    return nil
                }
            }
        }

        return result.compactMap { $0 }
    }

    private static func processProposal(_ proposal: MoveProposal, grid: Grid<Tile>) -> Grid<Tile> {
        let sourceTile = grid.at(proposal.from)
        let destTile = grid.at(proposal.to)

        var innerGrid = grid.copy()
        innerGrid = innerGrid.set(sourceTile!.remove(proposal.type), at: proposal.from)
        innerGrid = innerGrid.set(destTile!.add(proposal.type), at: proposal.to)
        return innerGrid
    }

    private static func moveBlizzards(_ grid: Grid<Tile>) -> Grid<Tile> {
        let innerGrid = grid.copy()
        let proposals = (0..<innerGrid.height).map { (y: Int) in
            (0..<grid.width).map { (x: Int) in
                processTile(in: innerGrid, at: Point(x, y))
            }
        }.joined().filter { !$0.isEmpty }.joined()

        return Array(proposals).reduce(innerGrid, { (acc: Grid<Tile>, curr: MoveProposal) in
            processProposal(curr, grid: acc)
        })
    }

    private static func dist(_ start: Point, _ end: Point) -> Int {
        abs(start.x - end.x) + abs(start.y - end.y)
    }

    private static func shortestPath(_ grid: Grid<Tile>, start: Point, end: Point, acc: Int = 1) -> Int? {
        if Point(start.x, start.y) == end {
            if acc < GLOBAL_SHORTEST {
                GLOBAL_SHORTEST = acc - 1
            }
            return acc - 1
        }
        if acc > GLOBAL_SHORTEST || acc + dist(start, end) > GLOBAL_SHORTEST {
            return nil
        }

        let innerGrid = BOARDS[acc]

        if start == GLOBAL_START {
            if let downHolding = innerGrid.at(x: start.x, y: start.y + 1)?.holding {
                if downHolding.count > 0 {
                    return shortestPath(innerGrid, start: start, end: end, acc: acc + 1)
                } else {
                    return shortestPath(innerGrid, start: Point(start.x, start.y + 1), end: end, acc: acc + 1)
                }
            }
        } else if start == GLOBAL_END {
            if let upHolding = innerGrid.at(x: start.x, y: start.y - 1)?.holding {
                if upHolding.count > 0 {
                    return shortestPath(innerGrid, start: start, end: end, acc: acc + 1)
                } else {
                    return shortestPath(innerGrid, start: Point(start.x, start.y - 1), end: end, acc: acc + 1)
                }
            }
        } else {
            let upHolding = innerGrid.at(x: start.x, y: start.y - 1)!.holding
            let downHolding = innerGrid.at(x: start.x, y: start.y + 1)!.holding
            let leftHolding = innerGrid.at(x: start.x - 1, y: start.y)!.holding
            let rightHolding = innerGrid.at(x: start.x + 1, y: start.y)!.holding
            let currentHolding = innerGrid.at(start)!.holding

            let allDirsInaccessible = [upHolding, downHolding, leftHolding, rightHolding]
                .map { $0.count }.allSatisfy { $0 > 0 }

            if allDirsInaccessible && currentHolding.count > 0 {
                return nil
            } else if allDirsInaccessible && currentHolding.count == 0 {
                return shortestPath(innerGrid, start: start, end: end, acc: acc + 1)
            }

            var up: Int?
            var down: Int?
            var left: Int?
            var right: Int?
            var wait: Int?

            if rightHolding.count == 0 && DONE_ACTIONS[RoundAction(round: acc, point: start, action: .right)] == nil {
                DONE_ACTIONS[RoundAction(round: acc, point: start, action: .right)] = true
                right = shortestPath(innerGrid, start: Point(start.x + 1, start.y), end: end, acc: acc + 1)
            }
            if downHolding.count == 0 && DONE_ACTIONS[RoundAction(round: acc, point: start, action: .down)] == nil {
                DONE_ACTIONS[RoundAction(round: acc, point: start, action: .down)] = true
                down = shortestPath(innerGrid, start: Point(start.x, start.y + 1), end: end, acc: acc + 1)
            }
            if leftHolding.count == 0 && DONE_ACTIONS[RoundAction(round: acc, point: start, action: .left)] == nil {
                DONE_ACTIONS[RoundAction(round: acc, point: start, action: .left)] = true
                left = shortestPath(innerGrid, start: Point(start.x - 1, start.y), end: end, acc: acc + 1)
            }
            if upHolding.count == 0 && DONE_ACTIONS[RoundAction(round: acc, point: start, action: .up)] == nil {
                DONE_ACTIONS[RoundAction(round: acc, point: start, action: .up)] = true
                up = shortestPath(innerGrid, start: Point(start.x, start.y - 1), end: end, acc: acc + 1)
            }
            if currentHolding.count == 0 && DONE_ACTIONS[RoundAction(round: acc, point: start, action: .wait)] == nil {
                DONE_ACTIONS[RoundAction(round: acc, point: start, action: .wait)] = true
                wait = shortestPath(innerGrid, start: Point(start.x, start.y), end: end, acc: acc + 1)
            }

            return [up, down, left, right, wait].compactMap { $0 }.min()
        }

        return Optional(1)
    }

    public static func part1(input: String) -> Int {
        let inp = Util.getLines(input)
        let tiles = inp.map { (line: String) in
            Array(line).map { (char: Character) in
                let tileType = TileType(rawValue: char)!
                let holding = tileType == .ground ? [] : [tileType]
                return Tile(holding: holding)
            }
        }.joined()

        let grid = Grid(elements: Array(tiles), width: inp[0].count, height: inp.count)
        printGrid(grid)

        let start = GLOBAL_START
        let end = Point(
            x: grid.row(y: grid.height - 1).firstIndex(where: { $0.holding.isEmpty })!,
            y: grid.height - 1)
        GLOBAL_END = end

        var tempBoard = grid
        for i in 0..<700 {
            if i % 10 == 0 {
                print(i)
            }
            BOARDS.append(tempBoard)
            tempBoard = moveBlizzards(tempBoard)
        }

        GLOBAL_SHORTEST = 400
        let dist = shortestPath(grid, start: start, end: end)
        print("Distance:", dist as Any)
        return 42
    }

    public static func part2(input: String) -> Int {
        let inp = Util.getLines(input)
        let tiles = inp.map { (line: String) in
            Array(line).map { (char: Character) in
                let tileType = TileType(rawValue: char)!
                let holding = tileType == .ground ? [] : [tileType]
                return Tile(holding: holding)
            }
        }.joined()

        let grid = Grid(elements: Array(tiles), width: inp[0].count, height: inp.count)
        printGrid(grid)

        let start = GLOBAL_START
        let end = Point(
            x: grid.row(y: grid.height - 1).firstIndex(where: { $0.holding.isEmpty })!,
            y: grid.height - 1)
        GLOBAL_END = end

        print("Simulating")
        var tempBoard = grid
        for i in 0..<1000 {
            if i % 10 == 0 {
                print(i)
            }
            BOARDS.append(tempBoard)
            tempBoard = moveBlizzards(tempBoard)
        }

        GLOBAL_SHORTEST = 300
        let dist = shortestPath(grid, start: start, end: end)!
        GLOBAL_SHORTEST = 600
        DONE_ACTIONS = [:]
        let dist2 = shortestPath(grid, start: end, end: start, acc: dist)!
        GLOBAL_SHORTEST = 900
        DONE_ACTIONS = [:]
        let dist3 = shortestPath(grid, start: start, end: end, acc: dist2)!
        print("Result:", String(describing: dist3))

        return dist3
    }

}
