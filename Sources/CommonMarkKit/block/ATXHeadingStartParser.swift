import Foundation

/*
struct ATXHeadingStartParser: BlockStarter {
    func isStart(_ line: Line) -> LineResult<BlockStartOp> {
        do {
            let start = line.indentedStart
            let startHeader = header(start)
            let blockKind = try kind(fromCount: startHeader.value)
            let space = try spaceOrEnd(startHeader.remaining)
            let headerBody = body(space.remaining)
            _ = try ending(headerBody.remaining)
            
            return LineResult(remainingLine: .blank, value: .addTextLine(headerBody.value, to: Block(kind: blockKind)))
        } catch {
            return LineResult(remainingLine: line, value: .none)
        }
    }
    
    private static let headerCharacter: Character = "#"
}

private extension ATXHeadingStartParser {
    func kind(fromCount count: Int) throws -> BlockKind {
        switch count {
        case 1: return .heading1
        case 2: return .heading2
        case 3: return .heading3
        case 4: return .heading4
        case 5: return .heading5
        case 6: return .heading6
        default:
            throw ParserError.invalidCharacter
        }
    }
    
    func header(_ cursor: Cursor<Source>) -> ScannerResult<Int> {
        var current = cursor
        var count = 0
        while cursor == Self.headerCharacter {
            count += 1
            current = current.advance()
        }
        return ScannerResult(remaining: current, value: count)
    }
    
    func spaceOrEnd(_ cursor: Cursor<Source>) throws -> ScannerResult<Bool> {
        if cursor.isEnd {
            return ScannerResult(remaining: cursor, value: true)
        } else if cursor == " " {
            return ScannerResult(remaining: cursor.advance(), value: true)
        } else {
            throw ParserError.invalidCharacter
        }
    }
    
    func body(_ cursor: Cursor<Source>) -> ScannerResult<Line> {
        var current = cursor
        while current.notEnd && !current.hasPrefix(" #") {
            current = current.advance()
        }
        return ScannerResult(remaining: current,
                             value: Line(range: CursorRange(start: cursor, end: current)))
    }
    
    func ending(_ cursor: Cursor<Source>) throws -> ScannerResult<Bool> {
        guard !cursor.isEnd else {
            return ScannerResult(remaining: cursor, value: true)
        }
        guard cursor.hasPrefix(" #") else {
            throw ParserError.invalidCharacter
        }
        
        let endingHeader = header(cursor.advance())
        let endingSpaces = spaces(endingHeader.remaining)
        guard endingSpaces.remaining.isEnd else {
            throw ParserError.invalidCharacter
        }
        
        return ScannerResult(remaining: endingSpaces.remaining, value: true)
    }
    
    func spaces(_ cursor: Cursor<Source>) -> ScannerResult<Int> {
        var current = cursor
        var count = 0
        while cursor == " " {
            count += 1
            current = current.advance()
        }
        return ScannerResult(remaining: current, value: count)
    }

}
*/
