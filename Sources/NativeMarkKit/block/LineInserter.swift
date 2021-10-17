import Foundation

struct LineInserter {
    func insert(_ line: Line, into container: Block, tip: Block, closer: BlockCloser) -> Block {
        if isLazyParagraphContinuation(line, for: tip, using: closer) {
            tip.addText(line, endOfLine: line.endPosition)
            
            return tip
        } else {
            closer.close(with: line) // this moves us up to container
            
            if container.acceptsLines {
                container.addText(line, endOfLine: line.endPosition)
                
                return container
            } else if !line.isBlank {
                let paragraph = Block(kind: .paragraph,
                                      parser: ParagraphBlockParser(),
                                      startPosition: line.nonIndentedStart.startPosition)
                paragraph.addText(line.nonIndentedStart, endOfLine: line.endPosition)
                return container.addChild(paragraph)
            } else {
                return container
            }
        }
    }
}

private extension LineInserter {
    func isLazyParagraphContinuation(_ line: Line, for block: Block, using closer: BlockCloser) -> Bool {
        !closer.areAllBlockClosed && !line.isBlank && block.kind == .paragraph
    }
}
