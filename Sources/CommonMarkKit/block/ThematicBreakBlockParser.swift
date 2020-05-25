import Foundation

struct ThematicBreakBlockParser: BlockParser {
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(with line: Line) -> LineResult<Bool> {
        LineResult(remainingLine: line, value: false)
    }

    func close(_ block: Block) {
        // nop
    }
}
