import Foundation

public struct Util {
    public static func getLines(_ input: String) -> [String] {
        return input
            .trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
    }
}
