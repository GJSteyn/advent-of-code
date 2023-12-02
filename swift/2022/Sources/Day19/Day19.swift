import Foundation

import Util

public struct Day19 {
    enum Resource {
        case ore, clay, obsidian, geode
    }

    struct Blueprint {
        let id: Int
        let oreCost: [(res: Resource, amount: Int)]
        let clayCost: [(res: Resource, amount: Int)]
        let obsCost: [(res: Resource, amount: Int)]
        let geoCost: [(res: Resource, amount: Int)]

        static func fromString(_ str: String) -> Blueprint {
            let nums = str.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .map { Int($0) }
                .compactMap { $0 }

            return Blueprint(
                id: nums[0],
                oreCost: [(res: Resource.ore, amount: nums[1])],
                clayCost: [(res: Resource.ore, amount: nums[2])],
                obsCost: [(res: Resource.ore, amount: nums[3]), (res: Resource.clay, amount: nums[4])],
                geoCost: [(res: Resource.ore, amount: nums[5]), (res: Resource.obsidian, amount: nums[6])]
            )
        }

        func costFor(_ type: Resource) -> [(res: Resource, amount: Int)] {
            switch type {
            case .ore:
                return self.oreCost
            case .clay:
                return self.clayCost
            case .obsidian:
                return self.obsCost
            case .geode:
                return self.geoCost
            }
        }
    }

    class Factory: CustomDebugStringConvertible {
        let blueprint: Blueprint

        var ore: Int
        var clay: Int
        var obs: Int
        var geo: Int

        var oreRobots: Int
        var clayRobots: Int
        var obsRobots: Int
        var geoRobots: Int

        var debugDescription: String {
            "ore: (a: \(self.ore), r: \(self.oreRobots)), clay: (a: \(self.clay), r: \(self.clayRobots)), obs: (a: \(self.obs), r: \(self.obsRobots)), geo: (a: \(self.geo), r: \(self.geoRobots))"
        }

        init(blueprint: Blueprint) {
            self.blueprint = blueprint
            self.ore = 0
            self.clay = 0
            self.obs = 0
            self.geo = 0
            self.oreRobots = 1
            self.clayRobots = 0
            self.obsRobots = 0
            self.geoRobots = 0
        }

        init(blueprint: Blueprint, ore: Int = 0, clay: Int = 0, obs: Int = 0, geo: Int = 0, oreRobots: Int = 1, clayRobots: Int = 0, obsRobots: Int = 0, geoRobots: Int = 0) {
            self.blueprint = blueprint
            self.ore = ore
            self.clay = clay
            self.obs = obs
            self.geo = geo
            self.oreRobots = oreRobots
            self.clayRobots = clayRobots
            self.obsRobots = obsRobots
            self.geoRobots = geoRobots
        }

        private func getResource(type: Resource) -> Int {
            switch type {
            case .ore:
                return self.ore
            case .clay:
                return self.clay
            case .obsidian:
                return self.obs
            case .geode:
                return self.geo
            }
        }

        private func useResource(type: Resource, amount: Int) -> Void {
            switch type {
            case .ore:
                self.ore -= amount
            case .clay:
                self.clay -= amount
            case .obsidian:
                self.obs -= amount
            case .geode:
                self.geo -= amount
            }
        }

        func canBuild(type: Resource) -> Bool {
            let costs = self.blueprint.costFor(type)
            return costs.map {
                return self.getResource(type: $0.res) >= $0.amount
            }.allSatisfy { $0 }
        }

        func buildRobot(type: Resource) -> (() -> Factory) {
            let canBuild = self.canBuild(type: type)

            if canBuild {
                return { () in
                    let costs = self.blueprint.costFor(type)
                    costs.forEach { self.useResource(type: $0.res, amount: $0.amount) }

                    switch type {
                    case .ore:
                        self.oreRobots += 1
                    case .clay:
                        self.clayRobots += 1
                    case .obsidian:
                        self.obsRobots += 1
                    case .geode:
                        self.geoRobots += 1
                    }
                    return self
                }
            } else {
                return { self }
            }
        }

        func accumulateResources() -> Void {
            self.ore += self.oreRobots
            self.clay += self.clayRobots
            self.obs += self.obsRobots
            self.geo += self.geoRobots
        }

        func getActions() -> [Action] {
            Array([
                Action.wait: true,
                Action.bOre: self.canBuild(type: .ore),
                Action.bClay: self.canBuild(type: .clay),
                Action.bObs: self.canBuild(type: .obsidian),
                Action.bGeo: self.canBuild(type: .geode)
            ].filter { $0.value }.keys)
        }

        func copy() -> Factory {
            Factory(blueprint: self.blueprint, ore: self.ore, clay: self.clay, obs: self.obs, geo: self.geo, oreRobots: self.oreRobots, clayRobots: self.clayRobots, obsRobots: self.obsRobots, geoRobots: self.geoRobots)
        }
    }

    enum Action {
        case wait, bOre, bClay, bObs, bGeo
    }

    private static func processAction(factory: Factory, action: Action) -> Factory {
        let copy = factory.copy()
        switch action {
        case .wait:
            copy.accumulateResources()
            return copy
        case .bOre:
            let update = copy.buildRobot(type: .ore)
            copy.accumulateResources()
            return update()
        case .bClay:
            let update = copy.buildRobot(type: .clay)
            copy.accumulateResources()
            return update()
        case .bObs:
            let update = copy.buildRobot(type: .obsidian)
            copy.accumulateResources()
            return update()
        case .bGeo:
            let update = copy.buildRobot(type: .geode)
            copy.accumulateResources()
            return update()
        }
    }

    private static func mostGeodes(factory: Factory, minutesLeft: Int = 24) -> Int? {
        if minutesLeft == 0 {
            return factory.geo
        }

        let actions = factory.getActions()

        if actions.contains(where: { $0 == .bGeo }) {
            let updatedFactory = processAction(factory: factory, action: .bGeo)
            return mostGeodes(factory: updatedFactory, minutesLeft: minutesLeft - 1)
        } else if actions.contains(where: { $0 == .bObs }) {
            let updatedFactory = processAction(factory: factory, action: .bObs)
            return mostGeodes(factory: updatedFactory, minutesLeft: minutesLeft - 1)
        } else if actions.contains(where: { $0 == .bClay }) && actions.contains(where: { $0 == .bOre }) {
            return [Action.bOre, Action.bClay].map { (action) in
                let updatedFactory = processAction(factory: factory, action: action)
                return mostGeodes(factory: updatedFactory, minutesLeft: minutesLeft - 1)
            }.compactMap { $0 }.max()
        }

        let geodesPerAction = actions.map { (action) in
            let updatedFactory = processAction(factory: factory, action: action)
            return mostGeodes(factory: updatedFactory, minutesLeft: minutesLeft - 1)
        }

        return geodesPerAction.compactMap { $0 }.max()
    }

    public static func part1(input: String) -> Int {
        let lines = Util.getLines(input)
        let blueprints = lines.map(Blueprint.fromString)
        let factories = blueprints.map { Factory(blueprint: $0) }

        let qualityLevels = factories.map {
            let most = mostGeodes(factory: $0)
            return most! * $0.blueprint.id
        }

        return qualityLevels.reduce(0, +)
    }

    public static func part2(input: String) -> Int {
        let lines = Util.getLines(input)
        let blueprints = lines.map(Blueprint.fromString)[0..<3]
        let factories = blueprints.map { Factory(blueprint: $0) }

        let most = factories.map {
            return mostGeodes(factory: $0, minutesLeft: 32)
        }.compactMap { $0 }

        return most.reduce(1, *)
    }
}
