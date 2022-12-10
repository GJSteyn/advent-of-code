import Foundation

import Util

// TODO: Clean up

extension String {
    var isNumber: Bool {
        return self.allSatisfy { $0.isNumber }
    }
}

public struct Day07 {
    enum CommandError: Error {
        case invalid(String)
    }

    enum LineError: Error {
        case unexpected(String)
    }

    public static func part1(input: String) throws -> Int {
        let lines = Util.getLines(input).map { $0.components(separatedBy: " ") }

        var cwdArray: [String] = []
        var dirs: [String: Int] = [:]

        for line in lines {
            switch line[0] {
            case "$":
                switch line[1] {
                case "ls":
                    continue
                case "cd":
                    if (line[2] == "..") {
                        cwdArray.removeLast()
                    } else {
                        cwdArray.append(line[2])
                        if dirs[cwdArray.joined(separator: "/")] == nil {
                            dirs[cwdArray.joined(separator: "/")] = 0
                        }
                    }
                default:
                    throw CommandError.invalid("\(line[1]) is not a valid command")
                }
            case "dir":
                continue
            case let x where x.isNumber:
                for i in 0..<cwdArray.count {
                    let dir = cwdArray[0...i].joined(separator: "/")
                    if let dirValue = dirs[dir] {
                        dirs.updateValue(dirValue + Int(x)!, forKey: dir)
                    } else {
                        throw LineError.unexpected("Somehow trying to add a value to a directory we haven't visited: \(cwdArray.joined(separator: "/"))")
                    }
                }
            default:
                throw LineError.unexpected("Unexpected line: \(line)")
            }
        }

        return dirs
            .filter { $0.value <= 100_000 }
            .reduce(0, { $0 + $1.value })
    }

    public static func part2(input: String) throws -> Int {
        let lines = Util.getLines(input).map { $0.components(separatedBy: " ") }

        var cwdArray: [String] = []
        var dirs: [String: Int] = [:]

        for line in lines {
            switch line[0] {
            case "$":
                switch line[1] {
                case "ls":
                    continue
                case "cd":
                    if (line[2] == "..") {
                        cwdArray.removeLast()
                    } else {
                        cwdArray.append(line[2])
                        if dirs[cwdArray.joined(separator: "/")] == nil {
                            dirs[cwdArray.joined(separator: "/")] = 0
                        }
                    }
                default:
                    throw CommandError.invalid("\(line[1]) is not a valid command")
                }
            case "dir":
                continue
            case let x where x.isNumber:
                for i in 0..<cwdArray.count {
                    let dir = cwdArray[0...i].joined(separator: "/")
                    if let dirValue = dirs[dir] {
                        dirs.updateValue(dirValue + Int(x)!, forKey: dir)
                    } else {
                        throw LineError.unexpected("Somehow trying to add a value to a directory we haven't visited: \(cwdArray.joined(separator: "/"))")
                    }
                }
            default:
                throw LineError.unexpected("Unexpected line: \(line)")
            }
        }

        // ------------------
        let fullSize = 70_000_000
        let requiredSize = 30_000_000
        let usedSize = dirs["/"]!

        let currentSize = fullSize - usedSize
        let spaceNeeded = requiredSize - currentSize

        let filesLargerThanNeeded = dirs.filter { $0.value >= spaceNeeded }.map { $0.value }

        return filesLargerThanNeeded.sorted().first!
    }
}
