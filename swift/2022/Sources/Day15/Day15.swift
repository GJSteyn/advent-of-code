import Foundation

import Util

extension Point {
    func manhattanDistanceTo(another: Point) -> Int {
        abs(self.x - another.x) + abs(self.y - another.y)
    }
}

public struct Day15 {
    typealias Device = (sensor: Point, beacon: Point, range: Int)

    private static func devicesFromInput(_ input: String) -> [Device] {
        let lines = Util.getLines(input)
        let sensorRegex = #/Sensor at x=(-?[0-9]\d*), y=(-?[0-9]\d*): closest beacon is at x=(-?[0-9]\d*), y=(-?[0-9]\d*)/#
        return lines.map {
            if let match = try? sensorRegex.firstMatch(in: $0) {
                let sensor = Point(x: Int(match.1)!, y: Int(match.2)!)
                let beacon = Point(x: Int(match.3)!, y: Int(match.4)!)
                let distance = sensor.manhattanDistanceTo(another: beacon)
                return Optional((sensor: sensor, beacon: beacon, range: distance))
            }
            return nil
        }.compactMap { $0 }
    }

    private static func rangeWhereItCannotBeFor(device: Device, y: Int) -> Optional<ClosedRange<Int>> {
        let yDistanceFromSensor = abs(device.sensor.y - y)
        let howManyToAppend = device.range - yDistanceFromSensor
        if howManyToAppend < 0 {
            return nil
        }
        return device.sensor.x-howManyToAppend...device.sensor.x+howManyToAppend
    }

    private static func mergeInto(_ ranges: [ClosedRange<Int>], _ range: ClosedRange<Int>) -> [ClosedRange<Int>] {
        let canMerge = ranges.map { $0.overlaps(range) }.filter { $0 }.count > 0
        if canMerge {
            return ranges.map { $0.overlaps(range) || rangesAreAdjacent($0, range) ? combineRanges($0, range) : $0 }
        } else {
            return ranges + [range]
        }
    }

    private static func reduceRanges(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        ranges.reduce([], { (acc: [ClosedRange<Int>], current: ClosedRange<Int>) in
            mergeInto(acc, current)
        })
    }

    private static func coveredRanges(devices: [Device], onLine: Int) -> [ClosedRange<Int>] {
        let devicesInRange = devices.filter { abs($0.sensor.y - onLine) <= $0.range }
        let emptyRanges = devicesInRange.map { rangeWhereItCannotBeFor(device: $0, y: onLine)}.compactMap { $0 }

        let accumulated = emptyRanges.reduce([], { (acc: [ClosedRange<Int>], current: ClosedRange<Int>) in
            mergeInto(acc, current)
        })
        return reduceRanges(accumulated)
    }

    private static func combineRanges(_ first: ClosedRange<Int>, _ second: ClosedRange<Int>) -> ClosedRange<Int> {
        let min: Int = [first.lowerBound, second.lowerBound].min()!
        let max: Int = [first.upperBound, second.upperBound].max()!
        return min...max
    }

    private static func rangesAreAdjacent(_ first: ClosedRange<Int>, _ second: ClosedRange<Int>) -> Bool {
        first.upperBound == second.lowerBound - 1 || first.lowerBound - 1 == second.upperBound
    }

    private static func hasOneDifference(_ first: ClosedRange<Int>, _ second: ClosedRange<Int>) -> Bool {
        abs(first.upperBound - second.lowerBound) == 2 || abs(first.lowerBound - second.upperBound) == 2
    }

    public static func part1(input: String, onLine: Int) -> Int {
        let devices = devicesFromInput(input)

        let coveredRanges = coveredRanges(devices: devices, onLine: onLine)
        let beaconsOnLine = Set(devices
            .map { $0.beacon }
            .filter { $0.y == onLine }
            .filter { (beacon: Point) in
                coveredRanges.contains(where: { beacon.x >= $0.lowerBound && beacon.x <= $0.upperBound})
            })
        return coveredRanges.map { $0.count }.reduce(0, +) - beaconsOnLine.count
    }

    public static func part2(input: String, searchSpace: Int) -> Optional<Int> {
        let devices = devicesFromInput(input)

        for i in 0...searchSpace {
            let coveredRanges = coveredRanges(devices: devices, onLine: i)
            if coveredRanges.count > 1 {
                if hasOneDifference(coveredRanges[0], coveredRanges[1]) {
                    return (coveredRanges[0].upperBound + 1) * 4_000_000 + i
                }
            }
        }

        return nil
    }
}
