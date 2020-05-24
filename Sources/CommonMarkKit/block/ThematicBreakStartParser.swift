import Foundation

/*
struct ThematicBreakStartParser: BlockStarter {
    func isStart(_ line: Line) -> LineResult<BlockStartOp> {
        let start = line.indentedStart
        
        guard start.in(Self.breakCharacters),
            case let .value(startChValue) = start.element else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        var count = 0
        var current = start
        while current.notEnd {
            let separator = characterAndWhitespace(current, character: startChValue.value)
            guard separator.value else {
                return LineResult(remainingLine: line, value: .none)
            }
            count += 1
            current = separator.remaining
        }
        
        guard count >= 3 else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        return LineResult(remainingLine: .blank, value: .addToLastOpen(Block(kind: .thematicBreak)))
    }
    
    private static let breakCharacters = Set<Character>(["*", "-", "_"])
}

private extension ThematicBreakStartParser {
    func characterAndWhitespace(_ cursor: Cursor<Source>, character: Character) -> ScannerResult<Bool> {
        guard cursor == character else {
            return ScannerResult(remaining: cursor, value: false)
        }
        var current = cursor.advance()
        while current.isSpaceOrTab {
            current = current.advance()
        }
        return ScannerResult(remaining: current, value: true)
    }
}
*/

