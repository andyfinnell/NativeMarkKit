import Foundation

struct BlockQuoteStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^>", options: [])

    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.nonIndentedStart
        guard let startMatch = realLine.firstMatch(Self.startRegex) else {
            return LineResult(remainingLine: line, value: .none)
        }
                
        let remainingLine = realLine.skip(startMatch).trimIndent(1)
        
        closer.close()
        let blockQuote = Block(kind: .blockQuote, parser: BlockQuoteBlockParser())
        let newContainer = container.addChild(blockQuote)
        
        return LineResult(remainingLine: remainingLine, value: .container(newContainer))
    }
}
