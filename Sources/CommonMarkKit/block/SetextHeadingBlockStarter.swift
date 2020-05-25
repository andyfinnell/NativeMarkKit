import Foundation

struct SetextHeadingBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^(?:=+|-+)[ \\t]*$", options: [])

    func parseStart(_ line: Line, in container: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.nonIndentedStart
        guard let startMatch = realLine.firstMatch(Self.startRegex), container.kind == .paragraph else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        // TODO: the paragraph could have a link definition; we need to skip it
        
        guard container.hasText else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        let startText = realLine.text.matchedText(startMatch).trimmingCharacters(in: .whitespacesAndNewlines)
        let blockKind = kind(from: startText)
                
        closer.close()
        let heading = Block(kind: blockKind, parser: HeadingBlockParser())
        for line in container.textLines {
            heading.addText(line)
        }
        _ = container.parent?.addChild(heading)
        container.removeFromParent()
        
        return LineResult(remainingLine: .blank, value: .leaf(heading))
    }
}

private extension SetextHeadingBlockStarter {
    func kind(from text: String) -> BlockKind {
        text.hasPrefix("=") ? .heading1 : .heading2
    }
}
