import Foundation

struct BlockTreeInserter {
    func insert(_ operations: [BlockStartOp], on lastMatchedBlock: Block) -> Bool {
        // TODO: this is blurring two steps: creating new blocks and adding text to existing
        var currentBlock = lastMatchedBlock
        for op in operations {
            switch op {
            case let .addChild(newBlock, to: parentBlock):
                let realParent = findOrCreate(parentBlock, on: currentBlock)
                realParent.addChild(newBlock)
                currentBlock = newBlock
            case let .addTextLine(newLine, to: parentBlock):
                let realParent = findOrCreate(parentBlock, on: currentBlock)
                realParent.addText(newLine)
                currentBlock = realParent
            case .none:
                break
            }
        }
        
        return currentBlock !== lastMatchedBlock // true if we've added a new block
    }
}

private extension BlockTreeInserter {
    func findOrCreate(_ someBlock: Block, on block: Block) -> Block {
        guard someBlock.kind != block.kind else {
            return block // already exists in tree
        }
        
        block.addChild(someBlock)
        
        return someBlock
    }
}
