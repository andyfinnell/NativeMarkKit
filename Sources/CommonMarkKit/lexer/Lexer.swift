import Foundation

struct Lexer {
    func scan(_ cursor: Cursor<Source>) -> AnySequence<Line> {
        return AnySequence<Line> { () -> AnyIterator<Line> in
            var current = cursor
            var previous: Line?
            return AnyIterator<Line> { () -> Line? in
                if let p = previous, p.range.end.isEnd {
                    return nil
                }
                let result = self.scanLine(current)
                current = result.remaining
                previous = result.value
                return result.value
            }
        }
    }
}

private extension Lexer {
    func scanLine(_ cursor: Cursor<Source>) -> ScannerResult<Line> {
        var current = cursor
        while current.notEnd && current.notNewline {
            current = current.advance()
        }
        
        if current.isNewline {
            current = current.advance()
        }
        
        let range = CursorRange(start: cursor, end: current)
        let line = Line(range: range)
        return ScannerResult(remaining: current, value: line)
    }
}
