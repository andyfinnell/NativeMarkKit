import Foundation

enum BlockStartOp {
    case addTextLine(Line, to: Block)
    case addChild(Block, to: Block)
    case none
}

protocol IsBlockStart {
    func isStart(_ line: Line) -> LineResult<BlockStartOp>
}

class BlockStartParser {
    private let starters: [IsBlockStart] = []
    
    init() {
        
    }
    
    func parse(_ line: Line) -> [BlockStartOp] {
        var remainingLine = line
        var ops = [BlockStartOp]()
        while !remainingLine.isBlank {
            let start = parseLine(remainingLine)
            if case .none = start.value {
                continue
            }
            ops.append(start.value)
            remainingLine = start.remainingLine
        }
        return ops
    }
}

private extension BlockStartParser {
    func parseLine(_ line: Line) -> LineResult<BlockStartOp> {
        for parser in starters {
            let start = parser.isStart(line)
            if case .none = start.value {
                continue
            } else {
                return start
            }
        }

        return LineResult(remainingLine: line, value: .none)
    }
}
