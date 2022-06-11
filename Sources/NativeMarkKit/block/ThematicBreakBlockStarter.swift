import Foundation

struct ThematicBreakBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^(?:(?:\\*[ \\t]*){3,}|(?:_[ \\t]*){3,}|(?:-[ \\t]*){3,})[ \\t]*$", options: [])
    
    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.nonIndentedStart
        guard realLine.firstMatch(Self.startRegex) != nil else {
            return LineResult(remainingLine: line, value: .none)
        }

        closer.close()
        let heading = Block(kind: .thematicBreak,
                            parser: ThematicBreakBlockParser(),
                            startPosition: line.startPosition)
        heading.updateEndPosition(line.endPosition)
        let newContainer = container.addChild(heading)
        
        return LineResult(remainingLine: line.end, value: .leaf(newContainer))
    }
}
