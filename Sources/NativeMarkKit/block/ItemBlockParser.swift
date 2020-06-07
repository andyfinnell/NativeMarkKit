import Foundation

struct ItemBlockParser: BlockParser {
    private let markerOffset: LineColumnCount
    private let padding: LineColumnCount
    
    init(markerOffset: LineColumnCount, padding: LineColumnCount) {
        self.markerOffset = markerOffset
        self.padding = padding
    }
    
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        block.kind != .item
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        if line.isBlank {
            if block.children.isEmpty {
                return LineResult(remainingLine: line, value: false)
            } else {
                return LineResult(remainingLine: line.nonIndentedStart, value: true)
            }
        } else if line.indent >= (markerOffset + padding) {
            return LineResult(remainingLine: line.trimIndent(markerOffset + padding), value: true)
        } else {
            return LineResult(remainingLine: line, value: false)
        }
    }

    func close(_ block: Block) {
        // nop
    }
    
    func canHaveLastLineBlank(_ block: Block) -> Bool {
        !block.children.isEmpty
    }
    
    func parseLinkDefinitions(_ block: Block) {
        // nop
    }
}
