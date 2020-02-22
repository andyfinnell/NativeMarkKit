import Foundation

protocol IsBlockContinuation {
    func isContinuation(_ line: Line) -> LineResult<Bool>
}

struct BlockContinuation {
    let unmatchedBlocks: [Block]
    let openBlock: Block
}

class BlockContinuationParser {
    private let continuations: [BlockKind: IsBlockContinuation] = [:]
    
    init() {
    }
    
    func parse(_ line: Line, for root: Block) -> LineResult<BlockContinuation> {
        let (matchedBlocks, remainingLine) = matchBlocks(openBlocks(root), with: line)
        let openBlock = lastMatchedBlock(matchedBlocks) ?? root
        let unmatchedBlocks = matchedBlocks.filter { !$0.matched }.map { $0.block }
        let continuation = BlockContinuation(unmatchedBlocks: unmatchedBlocks, openBlock: openBlock)
        return LineResult(remainingLine: remainingLine, value: continuation)
    }
}

private extension BlockContinuationParser {
    struct OpenBlock {
        let block: Block
        let matched: Bool
    }

    func lastMatchedBlock(_ matchedBlocks: [OpenBlock]) -> Block? {
        return matchedBlocks.last(where: { $0.matched }).map { $0.block }
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
        for block in blocks {
            let result = isLine(currentLine, aContinuationOfBlock: block.kind)
            currentLine = result.remainingLine
            matchedBlocks.append(OpenBlock(block: block, matched: result.value))
        }
        return (matchedBlocks, currentLine)
    }
    
    private func isLine(_ line: Line, aContinuationOfBlock blockKind: BlockKind) -> LineResult<Bool> {
        guard let continuation = continuations[blockKind] else {
            return LineResult(remainingLine: line, value: true)
        }
        
        return continuation.isContinuation(line)
    }
}
