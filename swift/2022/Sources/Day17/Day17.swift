import Foundation

import Util

let rock0 = ["####"]

let rock1 = [".#.",
             "###",
             ".#."]

let rock2 = Array(
            ["..#",
             "..#",
             "###"].reversed())

let rock3 = ["#",
             "#",
             "#",
             "#"]

let rock4 = ["##",
             "##"]

let rocks = [rock0, rock1, rock2, rock3, rock4]

public struct Day17 {
    private static func extendChamber(_ chamber: [[String]], by: Int) -> [[String]] {
        let ext = [[String]](repeating: [String](repeating: ".", count: 7), count: by)
        return chamber + ext
    }

    private static func getHighestPoint(in chamber: [[String]]) -> Int {
        chamber.firstIndex(where : { $0.allSatisfy { $0 == "." } })!
    }

    private static func rockOverlaps(in chamber: [[String]], _ rockX: Int, _ rockY: Int, _ rock: [String]) -> Bool {
        let rockWidth = rock[0].count
        let rockHeight = rock.count

        if rockX < 0 || rockX + rockWidth > chamber[0].count {
            return true
        }

        if rockY < 0 {
            return true
        }

        for y in 0..<rockHeight {
            let chamberLine = chamber[rockY + y]
            let rockLine = rock[y]

            for x in 0..<rockWidth {
                let rockIndex = rockLine.index(rockLine.startIndex, offsetBy: x)
                if chamberLine[x + rockX] == "#" && rockLine[rockIndex] == "#" {
                    return true
                }
            }
        }

        return false
    }

    public static func simulateRock(in chamber: [[String]], _ rockX: Int, _ rockY: Int, _ rock: [String], _ jet: String) -> (x: Int, y: Int, stopped: Bool) {
        var innerRockX = rockX
        var innerRockY = rockY
        switch jet {
        case ">":
            if !rockOverlaps(in: chamber, rockX + 1, rockY, rock) {
                innerRockX += 1
            }
        default:
            if !rockOverlaps(in: chamber, rockX - 1, rockY, rock) {
                innerRockX -= 1
            }
        }

        if !rockOverlaps(in: chamber, innerRockX, innerRockY - 1, rock) {
            innerRockY -= 1
        }

        let stopped = rockY == innerRockY
        return (x: innerRockX, y: innerRockY, stopped: stopped)
    }

    public static func drawRock(on chamber: [[String]], _ rockX: Int, _ rockY: Int, _ rock: [String], using: String = "#") -> [[String]] {
        let rockWidth = rock[0].count
        let rockHeight = rock.count
        var innerChamber = chamber

        for y in 0..<rockHeight {
            let rockLine = rock[y]
            for x in 0..<rockWidth {
                let rockLineIndex = rockLine.index(rockLine.startIndex, offsetBy: x)
                if innerChamber[y + rockY][x + rockX] != "#" {
                    let char = String(rockLine[rockLineIndex]) == "." ? "." : using
                    innerChamber[y + rockY][x + rockX] = char
                }
            }
        }

        return innerChamber
    }

    public static func part1(input: String) -> Int {
        let jets = Util.getLines(input)[0]
        print(jets)
        print(rocks)

        var chamber = [[String]](repeating: [String](repeating: ".", count: 7), count: 4)

        var jetOffset = -1
        var rockOffset = -1
        for _ in 0..<2022 {
            rockOffset += 1
            let currentRock = rocks[rockOffset % rocks.count]
            let highestPoint = getHighestPoint(in: chamber)
            let spaceLeft = (chamber.count - highestPoint)
            let spaceNeeded = currentRock.count + 3
            let spaceToAdd = spaceNeeded - spaceLeft
            if spaceToAdd > 0 {
                chamber = extendChamber(chamber, by: spaceToAdd)
            }

            var currentX = 2
            var currentY = highestPoint + 3

            var stop = false
            while !stop {
                jetOffset += 1
                let currentJetIndex = jets.index(jets.startIndex, offsetBy: jetOffset % jets.count)
                let currentJet = String(jets[currentJetIndex])
                let (x, y, stopped) = simulateRock(in: chamber, currentX, currentY, currentRock, currentJet)
                if stopped {
                    chamber = drawRock(on: chamber, x, y, currentRock)
                    stop = true
                } else {
                    currentX = x
                    currentY = y
                }
            }
        }

        let highestPoint = getHighestPoint(in: chamber)

        return highestPoint
    }

    public static func detectCycle(_ chamber: [[String]], _ start: Int = 0) -> (start: Int, end: Int)? {
        let startLine = chamber[start]
        let matchingLineIndex = chamber[(start + 10)...].firstIndex(where: { $0 == startLine })

        guard let start2 = matchingLineIndex else {
            if start < chamber.count - 3 {
                return detectCycle(chamber, start + 1)
            } else {
                return nil
            }
        }

        if chamber.count - start2 < start2 - start {
            return nil
        }

        let chunk1 = chamber[start..<start2]
        let chunk2 = chamber[start2..<start2 + (start2 - start)]

        if chunk1 == chunk2 {
            return (start: start, end: start2)
        } else {
            return detectCycle(chamber, start + 1)
        }
    }

    public static func part2(input: String) -> Int {
        let jets = Util.getLines(input)[0]

        var chamber = [[String]](repeating: [String](repeating: ".", count: 7), count: 4)
        var rocksList: [Int] = []

        var jetOffset = -1
        var rockOffset = -1
        for i in 0..<1_000_000_000_000 {
            rockOffset += 1
            let currentRock = rocks[rockOffset % rocks.count]
            let highestPoint = getHighestPoint(in: chamber)
            let spaceLeft = (chamber.count - highestPoint)
            let spaceNeeded = currentRock.count + 3
            let spaceToAdd = spaceNeeded - spaceLeft
            if spaceToAdd > 0 {
                chamber = extendChamber(chamber, by: spaceToAdd)
            }

            var currentX = 2
            var currentY = highestPoint + 3

            var stop = false
            while !stop {
                if jetOffset % jets.count == 0 && jetOffset > 50 {
                    print("Detecting Cycle. Round: \(i). Chamber size: \(chamber.count). Rocks dropped: \(rockOffset)")
                    let foundCycle = detectCycle(chamber)
                    print("Done detecting cycle. Found: \(String(describing: foundCycle))")
                    if let found = foundCycle {
                        let tryAgain = detectCycle(chamber, found.end)
                        print("Tried again, and found: \(String(describing: tryAgain))")
                        if let again = tryAgain {
                            let andDen = detectCycle(chamber, again.end)
                            print("Tried a third time, and found: \(String(describing: andDen))")

                            if let den = andDen {
                                let firstAmountOfRocks = rocksList.firstIndex(where: { $0 > found.end })
                                print("Highest point at first cycle:", rocksList[firstAmountOfRocks!])
                                let secondAmountOfRocks = rocksList.firstIndex(where: { $0 > again.end })
                                let thirdAmountOfRocks = rocksList.firstIndex(where: { $0 > den.end })
                                print("Highest point at third cycle:", rocksList[thirdAmountOfRocks!])

                                print("First: ", firstAmountOfRocks! + 1)
                                print("Second: ", secondAmountOfRocks! + 1)
                                print("Third: ", thirdAmountOfRocks! + 1)
                                let interval = den.end - den.start
                                let rocksPerInterval = thirdAmountOfRocks! - secondAmountOfRocks!
                                print("Interval: \(interval); RocksPerInterval: \(rocksPerInterval)")
                                var currentHeight = den.end
                                var currentRocks = thirdAmountOfRocks! + 1
                                while currentRocks < 1_000_000_000_000 - firstAmountOfRocks! - 1 {
                                    currentRocks += rocksPerInterval
                                    currentHeight += interval
                                    if currentRocks % (thirdAmountOfRocks! * 1000) == 0 {
                                        print("Current Rocks: \(currentRocks); At: \(currentHeight)")
                                    }
                                }
                                print("End rocks: \(currentRocks); At: \(currentHeight)")
                                currentHeight += rocksList[thirdAmountOfRocks!] - den.end
                                print("After adjusting currentHeight:", currentHeight)
                                let difference = 1_000_000_000_000 - currentRocks
                                print("Difference:", difference)
                                let heightSinceDifference = rocksList[firstAmountOfRocks! + difference] - rocksList[firstAmountOfRocks!]
                                return currentHeight + heightSinceDifference
                            }
                        }
                    }
                }


                jetOffset += 1
                let currentJetIndex = jets.index(jets.startIndex, offsetBy: jetOffset % jets.count)
                let currentJet = String(jets[currentJetIndex])
                let (x, y, stopped) = simulateRock(in: chamber, currentX, currentY, currentRock, currentJet)
                if stopped {
                    chamber = drawRock(on: chamber, x, y, currentRock)
                    rocksList.append(getHighestPoint(in: chamber))
                    stop = true
                } else {
                    currentX = x
                    currentY = y
                }
            }
        }

        let highestPoint = getHighestPoint(in: chamber)
        print("Highest point:", highestPoint)
        print("Chamber size", chamber.count)
        for line in chamber.reversed() {
            print(line)
        }

        return highestPoint
    }
}
