import Foundation

struct ThematicBreakBlockStarter: BlockStarter {
    private static let startRegex = try! NSRegularExpression(pattern: "^(?:(?:\\*[ \\t]*){3,}|(?:_[ \\t]*){3,}|(?:-[ \\t]*){3,})[ \\t]*$", options: [])
    
    func parseStart(_ line: Line, in container: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        let realLine = line.indentedStart
        guard realLine.firstMatch(Self.startRegex) != nil else {
            return LineResult(remainingLine: line, value: .none)
        }

        closer.close()
        let heading = Block(kind: .thematicBreak, parser: ThematicBreakBlockParser())
        let newContainer = container.addChild(heading)
        
        return LineResult(remainingLine: .blank, value: .leaf(newContainer))
    }
}
