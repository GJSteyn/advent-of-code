import Foundation

public struct Util {
    public static func getLines(_ input: String) -> [String] {
        return input
            .trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
    }
}

public struct Point: Hashable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    var hashValue: String {
        String(x) + String(y)
    }
}

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
