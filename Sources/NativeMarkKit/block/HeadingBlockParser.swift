import Foundation

struct HeadingBlockParser: BlockParser {
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        LineResult(remainingLine: line, value: false)
    }

    func close(_ block: Block) {
        // nop
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
