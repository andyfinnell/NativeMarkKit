import Foundation

struct SetextHeadingBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^(?:=+|-+)[ \\t]*$", options: [])

    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.nonIndentedStart
        guard let startMatch = realLine.firstMatch(Self.startRegex), container.kind == .paragraph else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        _ = container.parseLinkDefinitions()
        
        guard container.hasText else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        let startText = realLine.matchedText(startMatch).trimmingCharacters(in: .whitespacesAndNewlines)
        let blockKind = kind(from: startText)
                
        closer.close()
        let heading = Block(kind: blockKind,
                            parser: HeadingBlockParser(),
                            startPosition: container.textLines.first?.startPosition ?? realLine.startPosition)
        for line in container.textLines {
            heading.addText(line, endOfLine: line.endPosition)
        }
        heading.updateEndPosition(realLine.endPosition)

        _ = container.parent?.addChild(heading)
        container.removeFromParent()
        
        return LineResult(remainingLine: line.end, value: .leaf(heading))
    }
}

private extension SetextHeadingBlockStarter {
    func kind(from text: String) -> BlockKind {
        text.hasPrefix("=") ? .heading(1) : .heading(2)
    }
}
