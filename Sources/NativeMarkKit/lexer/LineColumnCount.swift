import Foundation

struct LineColumnCount: Hashable {
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    static func + (lhs: LineColumnCount, rhs: LineColumnCount) -> LineColumnCount {
        LineColumnCount(lhs.value + rhs.value)
    }
}

extension LineColumnCount: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    
    init(integerLiteral value: Self.IntegerLiteralType) {
        self.value = value
    }
}

extension LineColumnCount: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}
