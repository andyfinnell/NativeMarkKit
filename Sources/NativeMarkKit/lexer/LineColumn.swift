import Foundation

struct LineColumn: Hashable {
    private let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    func space() -> LineColumn {
        LineColumn(value + 1)
    }
    
    func tab() -> LineColumn {
        LineColumn(value + 4 - (value % 4))
    }
    
    static func - (lhs: LineColumn, rhs: LineColumn) -> LineColumnCount {
        LineColumnCount(lhs.value - rhs.value)
    }
}

extension LineColumn: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    
    init(integerLiteral value: Self.IntegerLiteralType) {
        self.value = value
    }
}

extension LineColumn: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}
