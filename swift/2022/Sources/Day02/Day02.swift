import Foundation

import Util

public struct Day02 {
    enum HandError: Error {
        case badHand(String)
    }
    
    enum Hand: Int {
        case rock = 1
        case paper, scissors

        static func fromString(_ input: String) throws -> Hand {
            switch input {
            case "A": return .rock
            case "B": return .paper
            case "C": return .scissors
            default:
                throw HandError.badHand("\(input) is not a valid hand")
            }
        }

        static func fromAlternateString(_ input: String) throws -> Hand {
            switch input {
            case "X": return .rock
            case "Y": return .paper
            case "Z": return .scissors
            default:
                throw HandError.badHand("\(input) is not a valid hand")
            }
        }

        func counterWin() -> Hand {
            switch self {
            case .rock: return .paper
            case .paper: return .scissors
            case .scissors: return .rock
            }
        }

        func counterLose() -> Hand {
            switch self {
            case .rock: return .scissors
            case .paper: return .rock
            case .scissors: return .paper
            }
        }
    }

    enum ResultError: Error {
        case badResult(String)
    }

    enum Result: Int {
        case win = 6
        case draw = 3
        case lose = 0

        static func fromString(_ input: String) throws -> Result {
            switch input {
            case "X": return .lose
            case "Y": return .draw
            case "Z": return .win
            default:
                throw ResultError.badResult("\(input) is not a valid result")
            }
        }
    }

    private static func gameFromString(input: String) -> (Hand, Hand) {
        let result = input.components(separatedBy: " ")
        return (try! Hand.fromString(result[0]), try! Hand.fromAlternateString(result[1]))
    }

    private static func expectedGameFromString(input: String) -> (Hand, Result) {
        let result = input.components(separatedBy: " ")
        return (try! Hand.fromString(result[0]), try! Result.fromString(result[1]))
    }

    private static func handForExpectedResult(opponent: Hand, result: Result) -> Hand {
        switch result {
        case .win: return opponent.counterWin()
        case .lose: return opponent.counterLose()
        case .draw: return opponent
        }
    }

    private static func play(theirs: Hand, mine: Hand) -> Int {
        func compare(_ left: Hand, _ right: Hand) -> Result {
            switch (left, right) {
            case (.rock,     .rock.counterWin()):      return .win
            case (.rock,     .rock.counterLose()):     return .lose
            case (.paper,    .paper.counterWin()):     return .win
            case (.paper,    .paper.counterLose()):    return .lose
            case (.scissors, .scissors.counterWin()):  return .win
            case (.scissors, .scissors.counterLose()): return .lose
            default:
                return .draw
            }
        }

        let result = compare(theirs, mine)
        return result.rawValue + mine.rawValue
    }

    public static func part1(input: String) -> Int {
        return Util.getLines(input)
            .map { gameFromString(input: $0) }
            .map { play(theirs: $0, mine: $1) }
            .reduce(0, +)
    }

    public static func part2(input: String) -> Int {
        return Util.getLines(input)
            .map { expectedGameFromString(input: $0) }
            .map { (hand, result) in
                let reprisal = handForExpectedResult(opponent: hand, result: result)
                return (hand, reprisal)
            }
            .map { play(theirs: $0, mine: $1) }
            .reduce(0, +)
    }
}
