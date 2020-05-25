import Foundation

struct IndentedCodeBlockStarter: BlockStarter {
    func parseStart(_ line: Line, in container: Block, using closer: BlockCloser) -> LineResult<BlockStartMatch> {
        guard line.hasIndent && !line.isBlank && container.kind != .paragraph else {
            return LineResult(remainingLine: line, value: .none)
        }
        
        let content = line.trimIndent()
        
        closer.close()
        let codeBlock = Block(kind: .codeBlock, parser: IndentedCodeBlockParser())
        codeBlock.addText(content)
        let newContainer = container.addChild(codeBlock)
        
        return LineResult(remainingLine: .blank, value: .leaf(newContainer))
    }
}
