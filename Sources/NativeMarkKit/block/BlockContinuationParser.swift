import Foundation

struct BlockContinuation {
    let unmatchedBlocks: [Block]
    let openBlock: Block
}

struct BlockContinuationParser {
    func parse(_ line: Line, for root: Block) -> LineResult<BlockContinuation> {
        let (matchedBlocks, remainingLine) = matchBlocks(openBlocks(root), with: line)
        let openBlock = lastMatchedBlock(matchedBlocks) ?? root
        let unmatchedBlocks = matchedBlocks.filter { !$0.matched }.map { $0.block }
        let continuation = BlockContinuation(unmatchedBlocks: unmatchedBlocks,
                                             openBlock: openBlock)
        return LineResult(remainingLine: remainingLine, value: continuation)
    }
}

private extension BlockContinuationParser {
    struct OpenBlock {
        let block: Block
        let matched: Bool
    }

    func lastMatchedBlock(_ matchedBlocks: [OpenBlock]) -> Block? {
        if let nonMatchIndex = matchedBlocks.firstIndex(where: { !$0.matched }) {
            return matchedBlocks.at(nonMatchIndex - 1).map { $0.block }
        } else {
            return matchedBlocks.last.map { $0.block }
        }
    }
    
    func openBlocks(_ root: Block) -> [Block] {
        var blocks = [root]
        while let next = blocks.last?.children.last, next.isOpen {
            blocks.append(next)
        }
        return blocks
    }
    
    func matchBlocks(_ blocks: [Block], with line: Line) -> ([OpenBlock], Line) {
        var currentLine = line
        var matchedBlocks = [OpenBlock]()
        var didParentMatch = true
        for block in blocks {
            if didParentMatch {
                let result = block.attemptContinuation(with: currentLine)
                currentLine = result.remainingLine
                matchedBlocks.append(OpenBlock(block: block, matched: result.value))
                didParentMatch = result.value
            } else {
                matchedBlocks.append(OpenBlock(block: block, matched: false))
            }
        }
        return (matchedBlocks, currentLine)
    }
}
