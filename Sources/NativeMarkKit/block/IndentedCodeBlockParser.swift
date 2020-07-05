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
            return LineResult(remainingLine: line.trimIndent(), value: true)
        } else {
            return LineResult(remainingLine: line, value: false)
        }
    }

    func close(_ block: Block) {
        block.removeTrailingBlankLines()
    }
    
    func isThisLineBlankForPurposesOfLastLine(_ line: Line, block: Block) -> Bool {
        line.isBlank
    }
    
    let doesPreventChildrenFromHavingLastLineBlank = false

    func parseLinkDefinitions(_ block: Block) -> Bool {
        // nop
        false
    }
}
