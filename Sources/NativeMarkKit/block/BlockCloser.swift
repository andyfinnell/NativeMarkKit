import Foundation

final class BlockCloser {
    private let blocks: [Block]
    private var haveBlocksBeenClosed = false
    
    init(blocks: [Block]) {
        self.blocks = blocks
    }
    
    var areAllBlockClosed: Bool {
        blocks.isEmpty || haveBlocksBeenClosed
    }
    
    func close() {
        guard !haveBlocksBeenClosed else {
            return
        }
        for block in blocks.reversed() {
            block.close()
        }
        
        haveBlocksBeenClosed = true
    }
}
