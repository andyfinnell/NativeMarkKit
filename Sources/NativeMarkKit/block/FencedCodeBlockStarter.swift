import Foundation

struct FencedCodeBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^`{3,}(?!.*`)|^~{3,}", options: [])
    
    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.nonIndentedStart
        guard let startMatch = realLine.firstMatch(Self.startRegex) else {
            return LineResult(remainingLine: line, value: .none)
        }

        let remainingLine = realLine.skip(startMatch)
        let fence = realLine.matchedText(startMatch)
        
        let parser = FencedCodeBlockParser(fenceOffset: realLine.column - line.column,
                                           fence: String(fence))
        closer.close()
        let codeBlock = Block(kind: .codeBlock(infoString: ""), parser: parser)
        let newContainer = container.addChild(codeBlock)
        
        return LineResult(remainingLine: remainingLine, value: .leaf(newContainer))
    }
}
