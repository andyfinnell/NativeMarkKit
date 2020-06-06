import Foundation

struct FencedCodeBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^`{3,}(?!.*`)|^~{3,}", options: [])
    
    func parseStart(_ line: Line, in container: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.nonIndentedStart
        guard let startMatch = realLine.firstMatch(Self.startRegex) else {
            return LineResult(remainingLine: line, value: .none)
        }

        let remainingLine = realLine.replace(startMatch, with: "")
        let fence = realLine.text.matchedText(startMatch)
        
        let parser = FencedCodeBlockParser(fenceOffset: realLine.startColumn - line.startColumn,
                                           fence: fence)
        closer.close()
        let codeBlock = Block(kind: .codeBlock(infoString: ""), parser: parser)
        let newContainer = container.addChild(codeBlock)
        
        return LineResult(remainingLine: remainingLine, value: .leaf(newContainer))
    }
}
