import Foundation

final class Block {
    let kind: BlockKind
    private(set) var isOpen = true
    private(set) var children = [Block]()
    private(set) var textLines = [Line]()
    private let parser: BlockParser
    private(set) weak var parent: Block?
    
    init(kind: BlockKind, parser: BlockParser) {
        self.kind = kind
        self.parser = parser
    }
    
    func addChild(_ block: Block) -> Block {
        guard parser.acceptsChild(block) else {
            close()
            return parent?.addChild(block) ?? block
        }
        
        children.append(block)
        block.parent = self
        return block
    }
    
    func addText(_ line: Line) {
        textLines.append(line)
    }
}

extension Block {
    var acceptsLines: Bool { parser.acceptsLines }

    func attemptContinuation(with line: Line) -> LineResult<Bool> {
        parser.attemptContinuation(with: line)
    }

    func close() {
        guard isOpen else {
            return
        }
        parser.close()
        isOpen = false
    }
}
