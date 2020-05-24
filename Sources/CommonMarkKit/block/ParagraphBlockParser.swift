import Foundation

struct ParagraphBlockParser: BlockParser {
    let acceptsLines = true
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(with line: Line) -> LineResult<Bool> {
        if line.isBlank {
            return LineResult(remainingLine: line, value: false)
        } else {
            return LineResult(remainingLine: line, value: true)
        }
    }

    func close() {
        // TODO: look for link defs
    }
}
