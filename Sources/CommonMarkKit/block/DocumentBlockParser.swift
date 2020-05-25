import Foundation

struct DocumentBlockParser: BlockParser {
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        // TODO: anything but item
        true
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        LineResult(remainingLine: line, value: true)
    }

    func close(_ block: Block) {
        // nop
    }
}
