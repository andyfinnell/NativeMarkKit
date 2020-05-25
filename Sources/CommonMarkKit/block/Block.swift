import Foundation

final class Block {
    var kind: BlockKind
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
    
    var hasText: Bool {
        textLines.contains(where: { !$0.isBlank })
    }
    
    func removeFromParent() {
        parent?.children.removeAll(where: { $0 === self })
    }
    
    func removeFirstLine() -> Line {
        guard textLines.count > 0 else {
            return .blank
        }
        return textLines.removeFirst()
    }
    
    func removeTrailingBlankLines() {
        textLines = textLines.reversed()
            .drop(while: { $0.isBlank })
            .reversed()
    }
}

extension Block {
    var acceptsLines: Bool { parser.acceptsLines }

    func attemptContinuation(with line: Line) -> LineResult<Bool> {
        parser.attemptContinuation(self, with: line)
    }

    func close() {
        guard isOpen else {
            return
        }
        parser.close(self)
        isOpen = false
    }
}
