import Foundation

import Util

public struct Day16 {
    enum ParseError: Error {
        case failed(String)
    }

    struct Valve: CustomDebugStringConvertible {
        let name: String
        let flowRate: Int
        let tunnels: [String]
        let isOpen: Bool

        var debugDescription: String {
            return "{ [Valve>] name: \(name), isOpen: \(isOpen), flow: \(flowRate) }"
        }

        init(name: String, flowRate: Int, tunnels: [String], isOpen: Bool = false) {
            self.name = name
            self.flowRate = flowRate
            self.tunnels = tunnels
            self.isOpen = isOpen
        }

        public func open() -> Valve {
            Valve(name: self.name, flowRate: self.flowRate, tunnels: self.tunnels, isOpen: true)
        }
    }

    struct State: CustomDebugStringConvertible {
        let valves: [String: Valve]
        let minutesLeft: Int
        let position: String
        let accPressure: Int

        var debugDescription: String {
            return "{ [State>] minutesLeft: \(minutesLeft), position: \(position), accPressure: \(accPressure) }"
        }

        init(valves: [String : Valve], minutesLeft: Int = 30, position: String = "AA", accPressure: Int = 0) {
            self.valves = valves
            self.minutesLeft = minutesLeft
            self.position = position
            self.accPressure = accPressure
        }

        private func nextPressure() -> Int {
            self.accPressure + self.valves
                .values
                .filter { $0.isOpen }
                .map { $0.flowRate }
                .reduce(0, +)
        }

        public func accumulatePressure() -> State {
            return State(valves: self.valves, minutesLeft: self.minutesLeft, position: self.position, accPressure: self.nextPressure())
        }

        public func openValve(_ name: String) -> State {
            let valveToOpen = self.valves[name]!
            var valvesCopy = self.valves
            let openedValve = valveToOpen.open()
            valvesCopy[name] = openedValve
            return State(valves: valvesCopy, minutesLeft: self.minutesLeft, position: self.position, accPressure: self.accPressure)
        }

        public func distance(from: Valve, to: Valve, acc: Int = 0, visited: [String] = []) -> Int {
            if from.name == to.name {
                return 0
            }

            let connectedValves = self.valves.values.filter { from.tunnels.contains($0.name) && !visited.contains($0.name) }

            if connectedValves.count == 0 {
                return 99_999_999
            } else if connectedValves.contains(where: { $0.name == to.name }) {
                return acc + 1
            }

            let innerVisited = visited + [from.name]

            let pathDistances = connectedValves.map { self.distance(from: $0, to: to, acc: acc + 1, visited: innerVisited) }
            return pathDistances.min(by: { $0 < $1 })!
        }

        public func shortestPath(from: Valve, to: Valve, acc: [Valve] = [], visited: [String] = []) -> [Valve]? {
            let connectedValves = self.valves.values.filter { from.tunnels.contains($0.name) && !visited.contains($0.name) }

            if connectedValves.count == 0 {
                return nil
            } else if connectedValves.contains(where: { $0.name == to.name }) {
                return acc + [from, to]
            }

            let innerVisited = visited + [from.name]

            let otherPaths: [[Valve]] = connectedValves
                .map { self.shortestPath(from: $0, to: to, acc: acc + [from], visited: innerVisited) }
                .compactMap { $0 }

            if otherPaths.count == 0 {
                return nil
            } else {
                return otherPaths.min(by: { $0.count < $1.count })!
            }
        }

        public func wait() -> State {
            return State(valves: self.valves, minutesLeft: self.minutesLeft - 1, position: self.position, accPressure: self.nextPressure())
        }
    }

    private static func parseInput(_ input: String) -> Optional<[String: Valve]> {
        let valveRegex = #/Valve ([A-Z]{2}) has flow rate=([0-9]\d*); tunnels? leads? to valves? (.*)/#
        var result: [String: Valve] = [:]

        let valveList = try? Util.getLines(input).map {
            if let match = try? valveRegex.firstMatch(in: $0) {
                return Valve(name: String(match.1), flowRate: Int(match.2)!, tunnels: match.3.components(separatedBy: ", "))
            } else {
                throw ParseError.failed("Failed to parse \($0)")
            }
        }

        guard let valves = valveList else {
            return nil
        }

        for valve in valves {
            result[valve.name] = valve
        }

        return result
    }

    private static func calculateDistances(_ state: State) -> [(from: String, to: String, path: [String])] {
        let valves = state.valves.values
        var result: [(from: String, to: String, path: [String])] = []

        for i in 0..<valves.count - 1 {
            for j in i + 1..<valves.count {
                let iIndex = valves.index(valves.startIndex, offsetBy: i)
                let jIndex = valves.index(valves.startIndex, offsetBy: j)
                let iValve = valves[iIndex]
                let jValve = valves[jIndex]
                let optionalPath = state.shortestPath(from: iValve, to: jValve)
                if let path = optionalPath {
                    result.append((from: iValve.name, to: jValve.name, path: path.map { $0.name }))
                } else {
                    print("Could not find path for \(iValve.name) to \(jValve.name)")
                }
            }
        }

        return result
    }

    private static func processRound(
        _ state: State,
        _ myPos: String,
        _ myTarget: String?,
        _ minutesLeft: Int = 30,
        _ pathsMap: [(from: String, to: String, path: [String])]
    ) -> State {
        if minutesLeft == 0 {
            return state
        }

        let nothingToDo = state.valves.values.filter { !$0.isOpen && $0.flowRate > 0 }.count == 0
        if nothingToDo {
            return (0..<minutesLeft).reduce(state, { (st, _) in st.wait() })
        }

        if let target = myTarget, target == myPos {
            let nextState = state.accumulatePressure().openValve(myPos)
            return processRound(nextState, myPos, nil, minutesLeft - 1, pathsMap)
        } else if let target = myTarget {
            let path = pathsMap.first(where: { $0.from == myPos && $0.to == target || $0.to == myPos && $0.from == target })!
            let realPath = path.from == myPos ? path.path : path.path.reversed()
            let nextState = state.accumulatePressure()
            return processRound(nextState, realPath[1], myTarget, minutesLeft - 1, pathsMap)
        } else {
            let closedValves = Array(state.valves.values
                .filter { !$0.isOpen && !($0.flowRate == 0) && ($0.name != state.position) })

            let allPathResults = closedValves.map { (valve) in
                return processRound(state, myPos, valve.name, minutesLeft, pathsMap)
            }

            return allPathResults.max(by: { $0.accPressure < $1.accPressure })!
        }
    }

    public static func part1(input: String) -> Int {
        guard let valves = parseInput(input) else {
            print("Something went horribly wrong while parsing the input")
            return 0
        }

        let state = State(valves: valves)
        let pathsMap = calculateDistances(state)
        let result = processRound(state, "AA", nil, 30, pathsMap)

        return result.accPressure
    }

    static let DEPTH = 24

    private static func processRound4(
        _ state: State,
        _ myPos: String,
        _ elPos: String,
        _ myTarget: String?,
        _ elTarget: String?,
        _ minutesLeft: Int = 30,
        _ pathsMap: [(from: String, to: String, path: [String])],
        _ pathScores: [(from: String, scores: [(to: String, score: Int)])]
    ) -> (state: State, myPos: String, elPos: String, myTarget: String?, elTarget: String?, minLeft: Int) {
        if minutesLeft == 0 {
            return (state: state, myPos: myPos, elPos: elPos, myTarget: myTarget, elTarget: elTarget, minLeft: 0)
        }

        let nothingToDo = state.valves.values.filter { !$0.isOpen && ($0.flowRate > 0) }.count == 0
        if nothingToDo {
            let nextState = state.wait()
            return processRound4(nextState, myPos, elPos, nil, nil, minutesLeft - 1, pathsMap, pathScores)
        }

        var nextState = state
        if let mTarget = myTarget, mTarget == myPos, let eTarget = elTarget, eTarget == elPos {
            nextState = nextState.accumulatePressure()
            nextState = nextState.openValve(myPos)
            nextState = nextState.openValve(elPos)
            return processRound4(nextState, myPos, elPos, nil, nil, minutesLeft - 1, pathsMap, pathScores)
        } else if let mTarget = myTarget, mTarget == myPos, let eTarget = elTarget {
            nextState = nextState.accumulatePressure().openValve(myPos)
            let elPath = pathsMap.first(where: { $0.from == elPos && $0.to == eTarget || $0.to == elPos && $0.from == eTarget })!
            let realPath = elPath.from == elPos ? elPath.path : elPath.path.reversed()
            return processRound4(nextState, myPos, realPath[1], nil, elTarget, minutesLeft - 1, pathsMap, pathScores)
        } else if let mTarget = myTarget, let eTarget = elTarget, eTarget == elPos {
            nextState = nextState.accumulatePressure().openValve(elPos)
            let myPath = pathsMap.first(where: { $0.from == myPos && $0.to == mTarget || $0.to == myPos && $0.from == mTarget })!
            let realPath = myPath.from == myPos ? myPath.path : myPath.path.reversed()
            return processRound4(nextState, realPath[1], elPos, myTarget, nil, minutesLeft - 1, pathsMap, pathScores)
        } else if let mTarget = myTarget, let eTarget = elTarget {
            nextState = nextState.accumulatePressure()
            let myPath = pathsMap.first(where: { $0.from == myPos && $0.to == mTarget || $0.to == myPos && $0.from == mTarget })!
            let myRealPath = myPath.from == myPos ? myPath.path : myPath.path.reversed()
            let elPath = pathsMap.first(where: { $0.from == elPos && $0.to == eTarget || $0.to == elPos && $0.from == eTarget })!
            let elRealPath = elPath.from == elPos ? elPath.path : elPath.path.reversed()
            return processRound4(nextState, myRealPath[1], elRealPath[1], myTarget, elTarget, minutesLeft - 1, pathsMap, pathScores)
        } else if myTarget == nil && elTarget == nil {
            let closedValves = Array(state.valves.values
                .filter { !$0.isOpen && $0.flowRate > 0 }
                .map { $0.name }
            )

            let myOptions = Array(pathScores
                .first(where: { $0.from == myPos })!
                .scores
                .filter { (score) in
                    let inClosedValves = closedValves.contains { score.to == $0 }
                    let canReach = pathsMap.first(where: { $0.from == myPos && $0.to == score.to || $0.from == score.to && $0.to == myPos })!.path.count < (minutesLeft + 2)
                    return inClosedValves && canReach
                }
                .sorted(by: { $0.score > $1.score })
                .prefix(5)
                .map { $0.to })
            let elOptions = Array(pathScores
                .first(where: { $0.from == elPos })!
                .scores
                .filter { (score) in
                    let inClosedValves = closedValves.contains { score.to == $0 }
                    let canReach = pathsMap.first(where: { $0.from == elPos && $0.to == score.to || $0.from == score.to && $0.to == elPos })!.path.count < (minutesLeft + 2)
                    return inClosedValves && canReach
                }
                .sorted(by: { $0.score > $1.score })
                .prefix(5)
                .map { $0.to })

            var combinations: [(mine: String?, els: String?)] = []
            if myOptions.count == 0 && elOptions.count > 0 {
                combinations = elOptions.map { (mine: nil, els: $0) }
            } else if elOptions.count == 0 && myOptions.count > 0 {
                combinations = myOptions.map { (mine: $0, els: nil) }
            } else if myOptions.count > 0 && elOptions.count > 0 {
                combinations = Array(myOptions.map { (myValve) in
                    return elOptions.map { (elValve) in
                        (mine: myValve, els: elValve)
                    }
                }.joined())
            }

            let depth = min(minutesLeft, DEPTH)
            let bestCombination = combinations.map { (combination) in
                let result = processRound4(state, myPos, elPos, combination.mine, combination.els, depth, pathsMap, pathScores)
                let score = result.state.accPressure
                return (com: combination, state: result.state, myPos: result.myPos, elPos: result.elPos, myTarget: result.myTarget, elTarget: result.elTarget, minLeft: result.minLeft, score: score)
            }.max(by: { $0.score < $1.score })

            if let best = bestCombination {
                return processRound4(best.state, best.myPos, best.elPos, best.myTarget, best.elTarget, minutesLeft - depth, pathsMap, pathScores)
            } else {
                var timeLeft = minutesLeft
                while timeLeft > 0 {
                    nextState = state.wait()
                    timeLeft -= 1
                }
                return (state: nextState, myPos: myPos, elPos: elPos, myTarget: nil, elTarget: nil, minLeft: 0)
            }
        } else if let mTarget = myTarget, elTarget == nil {
            let closedValves = Array(nextState.valves.values
                .filter { !$0.isOpen && !($0.flowRate == 0) && ($0.name != mTarget) }
                .map { $0.name }
            )

            let elOptions = Array(pathScores
                .first(where: { $0.from == elPos })!
                .scores
                .filter { (score) in
                    let inClosedValves = closedValves.contains { score.to == $0 }
                    let canReach = pathsMap.first(where: { $0.from == elPos && $0.to == score.to || $0.from == score.to && $0.to == elPos })!.path.count < (minutesLeft + 2)
                    return inClosedValves && canReach
                }
                .sorted(by: { $0.score > $1.score })
                .prefix(5)
                .map { $0.to })

            let depth = min(minutesLeft, DEPTH)
            let bestOption = elOptions.map { (option) in
                let result = processRound4(state, myPos, elPos, mTarget, option, depth, pathsMap, pathScores)
                let score = result.state.accPressure
                return (opt: option, state: result.state, myPos: result.myPos, elPos: result.elPos, myTarget: result.myTarget, elTarget: result.elTarget, minLeft: result.minLeft, score: score)
            }.max(by: { $0.score < $1.score })

            if let best = bestOption {
                return processRound4(best.state, best.myPos, best.elPos, best.myTarget, best.elTarget, minutesLeft - depth, pathsMap, pathScores)
            } else {
                if myPos == mTarget {
                    nextState = nextState.accumulatePressure().openValve(myPos)
                    return processRound4(nextState, myPos, elPos, nil, nil, minutesLeft - 1, pathsMap, pathScores)
                } else {
                    nextState = nextState.accumulatePressure()
                    let myPath = pathsMap.first(where: { $0.from == myPos && $0.to == mTarget || $0.to == myPos && $0.from == mTarget })!
                    let myRealPath = myPath.from == myPos ? myPath.path : myPath.path.reversed()
                    return processRound4(nextState, myRealPath[1], elPos, myTarget, nil, minutesLeft - 1, pathsMap, pathScores)
                }
            }
        } else if let eTarget = elTarget, myTarget == nil {
            let closedValves = Array(nextState.valves.values
                .filter { !$0.isOpen && $0.flowRate > 0 && ($0.name != eTarget) }
                .map { $0.name }
            )

            let myOptions = Array(pathScores
                .first(where: { $0.from == myPos })!
                .scores
                .filter { (score) in
                    let inClosedValves = closedValves.contains { score.to == $0 }
                    let canReach = pathsMap.first(where: { $0.from == myPos && $0.to == score.to || $0.from == score.to && $0.to == myPos })!.path.count < (minutesLeft + 2)
                    return inClosedValves && canReach
                }
                .sorted(by: { $0.score > $1.score })
                .prefix(5)
                .map { $0.to })

            let depth = min(minutesLeft, DEPTH)
            let bestOption = myOptions.map { (option) in
                let result = processRound4(state, myPos, elPos, option, elTarget, depth, pathsMap, pathScores)
                let score = result.state.accPressure
                return (opt: option, state: result.state, myPos: result.myPos, elPos: result.elPos, myTarget: result.myTarget, elTarget: result.elTarget, minLeft: result.minLeft, score: score)
            }.max(by: { $0.score < $1.score })

            if let best = bestOption {
                return processRound4(best.state, best.myPos, best.elPos, best.myTarget, best.elTarget, minutesLeft - depth, pathsMap, pathScores)
            } else {
                if elPos == eTarget {
                    nextState = nextState.accumulatePressure().openValve(elPos)
                    return processRound4(nextState, myPos, elPos, nil, nil, minutesLeft - 1, pathsMap, pathScores)
                } else {
                    nextState = nextState.accumulatePressure()
                    let elPath = pathsMap.first(where: { $0.from == elPos && $0.to == eTarget || $0.to == elPos && $0.from == eTarget })!
                    let elRealPath = elPath.from == elPos ? elPath.path : elPath.path.reversed()
                    return processRound4(nextState, myPos, elRealPath[1], nil, elTarget, minutesLeft - 1, pathsMap, pathScores)
                }
            }
        } else {
            print("We didn't cover all the cases")
            return (state: state, myPos: myPos, elPos: elPos, myTarget: nil, elTarget: nil, minLeft: minutesLeft)
        }
    }

    public static func part2(input: String) -> Int {
        guard let valves = parseInput(input) else {
            print("Something went horribly wrong while parsing the input")
            return 0
        }

        let state = State(valves: valves, minutesLeft: 30)
        print("Initial:", state)

        print("Generating paths map")
        let pathsMap = calculateDistances(state)
        print("Done")

        print("Generating valve scores")
        var count = 0
        let valveScores = state.valves.keys.map { (valveName) in
            let usefulValves = state.valves.values.filter { $0.flowRate > 0 && $0.name != valveName }
            let scores = usefulValves.map { (valve) in
                let state = processRound(state, valveName, valve.name, 26, pathsMap)
                count += 1
                print("Counting:", count)
                return (to: valve.name, score: state.accPressure)
            }
            return (from: valveName, scores: scores)
        }
        print("Done")

        print("Starting")
        let result = processRound4(state, "AA", "AA", nil, nil, 26, pathsMap, valveScores)
        print("Inner Result:", result)

        return 42
    }
}
