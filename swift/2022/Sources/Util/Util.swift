import Foundation

public struct Util {
    public static func getLines(_ input: String) -> [String] {
        return input
            .trimmingCharacters(in: .newlines)
            .components(separatedBy: .newlines)
    }
}

// Would be cool to extend 2D array collections to index them with Points
public struct Point: Hashable {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    public func left() -> Point {
        Point(self.x - 1, self.y)
    }

    public func right() -> Point {
        Point(self.x + 1, self.y)
    }

    public func up() -> Point {
        Point(self.x, self.y - 1)
    }

    public func down() -> Point {
        Point(self.x, self.y + 1)
    }

    var hashValue: String {
        String(x) + String(y)
    }
}

public class Grid<T> {
    public var elements: [T]
    public let width: Int
    public let height: Int

    public init(elements: [T], width: Int, height: Int) {
        self.elements = elements
        self.width = width
        self.height = height
    }

    public func at(x: Int, y: Int) -> T? {
        self.elements[safe: y * width + x]
    }

    public func at(_ point: Point) -> T? {
        self.at(x: point.x, y: point.y)
    }

    public func set(_ val: T, at point: Point) -> Grid<T> {
        self.elements[point.y * width + point.x] = val
        return self
    }

    public func row(y: Int) -> [T] {
        Array(elements[y * self.width..<((y * self.width) + self.width)])
    }

    public func col(x: Int) -> [T] {
        self.elements.enumerated().filter { (offset: Int, element: T) in
            offset % self.width == x
        }.map { $0.element }
    }

    public func firstLocationWhere(_ predicate: (T) -> Bool) -> Point? {
        let maybeIndex = self.elements.firstIndex(where: predicate)
        if let index = maybeIndex {
            return Point(x: index % self.width, y: index / self.width)
        } else {
            return nil
        }
    }

    public func copy(elements: [T]? = nil) -> Grid<T> {
        Grid(elements: elements ?? self.elements, width: width, height: height)
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
