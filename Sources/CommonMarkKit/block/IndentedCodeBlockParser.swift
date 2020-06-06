import Foundation

struct IndentedCodeBlockParser: BlockParser {
    let acceptsLines = true
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        if line.hasIndent {
            return LineResult(remainingLine: line.trimIndent(), value: true)
        } else if line.isBlank {
            return LineResult(remainingLine: line, value: true)
        } else {
            return LineResult(remainingLine: line, value: false)
        }
    }

    func close(_ block: Block) {
        block.removeTrailingBlankLines()
    }
    
    func canHaveLastLineBlank(_ block: Block) -> Bool {
        true
    }
}
