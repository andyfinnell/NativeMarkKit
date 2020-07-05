import Foundation

final class Block {
    var kind: BlockKind
    private(set) var isOpen = true
    private(set) var children = [Block]()
    private(set) var textLines = [Line]()
    private(set) var linkDefinitions = [LinkLabel: LinkDefinition]()
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
    
    func updateText(_ transform: ([Line]) -> [Line]) {
        textLines = transform(textLines)
    }
    
    func addLinkDefinitions(_ definitions: [LinkDefinition]) {
        if let parent = self.parent {
            parent.addLinkDefinitions(definitions)
        } else {
            for definition in definitions {
                guard linkDefinitions[definition.key] == nil else {
                    continue
                }
                linkDefinitions[definition.key] = definition
            }
        }
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
    
    private var didEndWithBlankLine = false
    
    var isLastLineBlank: Bool {
        if parser.doesPreventChildrenFromHavingLastLineBlank {
            return false
        }
        return didEndWithBlankLine
            || (children.last?.isLastLineBlank ?? false)
    }
    
    var isLastChild: Bool {
        parent?.children.last === self
    }
}

extension Block {
    var acceptsLines: Bool { parser.acceptsLines }

    func attemptContinuation(with line: Line) -> LineResult<Bool> {
        parser.attemptContinuation(self, with: line)
    }

    func close(with line: Line? = nil) {
        guard isOpen else {
            return
        }
        parser.close(self)
        didEndWithBlankLine = isThisLineBlankForPurposesOfLastLine(line)
        isOpen = false
    }
    
    func parseLinkDefinitions() -> Bool {
        parser.parseLinkDefinitions(self)
    }
}

private extension Block {
    func isThisLineBlankForPurposesOfLastLine(_ line: Line?) -> Bool {
        guard let line = line else {
            return false
        }
        return parser.isThisLineBlankForPurposesOfLastLine(line, block: self)
    }
}
