import Foundation

struct ATXHeadingBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^#{1,6}(?:[ \\t]+|$)", options: [])
    private static let ending1Regex = try! NSRegularExpression(pattern: "^[ \\t]*#+[ \\t]*$", options: [])
    private static let ending2Regex = try! NSRegularExpression(pattern: "[ \\t]+#+[ \\t]*$", options: [])

    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.nonIndentedStart
        guard let startMatch = realLine.firstMatch(Self.startRegex) else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        let startText = realLine.matchedText(startMatch).trimmingCharacters(in: .whitespacesAndNewlines)
        let blockKind = kind(fromCount: startText.count)
        
        let content = realLine
            .trimStart(Self.startRegex)
            .trimEnd(Self.ending1Regex)
            .trimEnd(Self.ending2Regex)
        
        closer.close()
        let heading = Block(kind: blockKind,
                            parser: HeadingBlockParser(),
                            startPosition: line.startPosition)
        heading.addText(content, endOfLine: realLine.endPosition)
        let newContainer = container.addChild(heading)
        
        return LineResult(remainingLine: line.end, value: .leaf(newContainer))
    }
}

private extension ATXHeadingBlockStarter {
    func kind(fromCount count: Int) -> BlockKind {
        .heading(min(count, 6))
    }
}
