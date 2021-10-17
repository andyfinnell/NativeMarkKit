import Foundation

struct TextRange: Hashable {
    let start: TextPosition
    let end: TextPosition
}

extension TextRange: CustomStringConvertible {
    var description: String {
        "\(start)-\(end)"
    }
}

extension TextRange {
    init?(start: TextPosition?, end: TextPosition?){
        guard let start = start, let end = end else {
            return nil
        }
        self.start = start
        self.end = end
    }
    
    init?(start: TextCursor?, end: TextCursor?) {
        guard let start = start?.position, let end = end?.position else {
            return nil
        }
        self.start = start
        self.end = end
    }
    
    init?<T, U>(start: TextResult<T>, end: TextResult<U>) {
        guard let start = start.valueTextRange?.start,
              let end = end.valueTextRange?.end else {
            return nil
        }
        self.start = start
        self.end = end
    }
    
    func union(with other: TextRange?) -> TextRange {
        guard let other = other else {
            return self
        }
        return TextRange(start: min(start, end, other.start, other.end),
                         end: max(start, end, other.start, other.end))
    }
}

extension Optional where Wrapped == TextRange {
    func union(with other: TextRange?) -> TextRange? {
        switch self {
        case let .some(range):
            return range.union(with: other)
        case .none:
            return other
        }
    }
}

func -(lhs: (Int, Int), rhs: (Int, Int)) -> TextRange {
    TextRange(start: TextPosition(line: lhs.0, column: lhs.1), end: TextPosition(line: rhs.0, column: rhs.1))
}
