import Foundation

struct IndentedCodeBlockStarter: BlockStarter {
    func parseStart(_ line: Line, in container: Block, tip: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        guard line.hasIndent && !line.isBlank && tip.kind != .paragraph else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        let content = line.trimIndent()
        
        closer.close()
        let codeBlock = Block(kind: .codeBlock(infoString: ""), parser: IndentedCodeBlockParser())
        let newContainer = container.addChild(codeBlock)
        
        return LineResult(remainingLine: content, value: .leaf(newContainer))
    }
}
