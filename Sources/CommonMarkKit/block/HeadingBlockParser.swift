import Foundation

struct HeadingBlockParser: BlockParser {
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        false
    }
    
    func attemptContinuation(with line: Line) -> LineResult<Bool> {
        LineResult(remainingLine: line, value: false)
    }

    func close() {
        // nop
    }
}
