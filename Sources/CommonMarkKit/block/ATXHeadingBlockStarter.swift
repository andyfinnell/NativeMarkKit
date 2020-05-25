import Foundation

struct ATXHeadingBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^#{1,6}(?:[ \\t]+|$)", options: [])
    private static let ending1Regex = try! NSRegularExpression(pattern: "^[ \t]*#+[ \t]*$", options: [])
    private static let ending2Regex = try! NSRegularExpression(pattern: "[ \t]+#+[ \t]*$", options: [])

    func parseStart(_ line: Line, in container: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.indentedStart
        guard let startMatch = realLine.firstMatch(Self.startRegex) else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        let startText = realLine.text.matchedText(startMatch).trimmingCharacters(in: .whitespacesAndNewlines)
        let blockKind = kind(fromCount: startText.count)
        
        let content = realLine.replace(startMatch, with: "")
            .replace(Self.ending1Regex, with: "")
            .replace(Self.ending2Regex, with: "")
        
        closer.close()
        let heading = Block(kind: blockKind, parser: HeadingBlockParser())
        heading.addText(content)
        let newContainer = container.addChild(heading)
        
        return LineResult(remainingLine: .blank, value: .leaf(newContainer))
    }
}

private extension ATXHeadingBlockStarter {
    func kind(fromCount count: Int) -> BlockKind {
        switch count {
        case 1: return .heading1
        case 2: return .heading2
        case 3: return .heading3
        case 4: return .heading4
        case 5: return .heading5
        case 6: return .heading6
        default:
            return .heading6
        }
    }
}
