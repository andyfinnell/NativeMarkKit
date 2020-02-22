import Foundation

enum BlockKind {
    case document
    case paragraph
}

class Block {
    let kind: BlockKind
    var isOpen = true
    private(set) var children = [Block]()
    private(set) var textLines = [Line]()
    
    init(kind: BlockKind) {
        self.kind = kind
    }
    
    func addChild(_ block: Block) {
        children.append(block)
    }
    
    func addText(_ line: Line) {
        textLines.append(line)
    }
}
