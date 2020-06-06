import Foundation

struct ParagraphBlockParser: BlockParser {
    let acceptsLines = true
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        if line.isBlank {
            return LineResult(remainingLine: line, value: false)
        } else {
            return LineResult(remainingLine: line, value: true)
        }
    }

    func close(_ block: Block) {
        // TODO: look for link defs
    }
    
    func canHaveLastLineBlank(_ block: Block) -> Bool {
        true
    }
}
