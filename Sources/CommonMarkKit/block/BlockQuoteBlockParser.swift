import Foundation

struct BlockQuoteBlockParser: BlockParser {
    private static let continueRegex = try! NSRegularExpression(pattern: "^>[ \\t]?", options: [])
    
    let acceptsLines = false
    
    func acceptsChild(_ block: Block) -> Bool {
        // TODO: everything but item
        true
    }
    
    func attemptContinuation(with line: Line) -> LineResult<Bool> {
        let realLine = line.indentedStart
        guard let match = realLine.firstMatch(Self.continueRegex) else {
            return LineResult(remainingLine: line, value: false)
        }
        
        let remainingLine = realLine.replace(match, with: "")
        return LineResult(remainingLine: remainingLine, value: true)
    }

    func close() {
        // nop
    }
}
