import Foundation

struct BlockQuoteBlockParser: BlockParser {
    private static let continueRegex = try! NSRegularExpression(pattern: "^>[ \\t]?", options: [])
    
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        block.kind != .item
    }
    
    func attemptContinuation(_ block: Block, with line: Line) -> LineResult<Bool> {
        let realLine = line.nonIndentedStart
        guard let match = realLine.firstMatch(Self.continueRegex) else {
            return LineResult(remainingLine: line, value: false)
        }
        
        let remainingLine = realLine.replace(match, with: "")
        return LineResult(remainingLine: remainingLine, value: true)
    }

    func close(_ block: Block) {
        // nop
    }
    
    func canHaveLastLineBlank(_ block: Block) -> Bool {
        false
    }
    
    func parseLinkDefinitions(_ block: Block) {
        // nop
    }
}
