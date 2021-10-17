import Foundation

struct TextPosition: Hashable {
    let line: Int
    let column: Int
}

extension TextPosition: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs.line != rhs.line else {
            return lhs.column < rhs.column
        }
        return lhs.line < rhs.line
    }
}

extension TextPosition: CustomStringConvertible {
    var description: String {
        "(\(line), \(column))"
    }
}

extension TextPosition {
    func advanceColumn() -> TextPosition {
        TextPosition(line: line,
                     column: column + 1)
    }
    
    func advanceColumn(by amount: Int) -> TextPosition {
        TextPosition(line: line,
                     column: column + amount)
    }
    
    func retreatColumn(by amount: Int) -> TextPosition {
        TextPosition(line: line,
                     column: column - amount)
    }
    
    static let invalid = TextPosition(line: -1, column: -1)
}
