import Foundation

final class Block {
    var kind: BlockKind
    private(set) var isOpen = true
    private(set) var children = [Block]()
    private(set) var textLines = [Line]()
    private(set) var linkDefinitions = [LinkLabel: LinkDefinition]()
    private let parser: BlockParser
    private(set) weak var parent: Block?
    private var startPosition: TextPosition
    private var endPosition: TextPosition?
    
    init(kind: BlockKind, parser: BlockParser, startPosition: TextPosition) {
        self.kind = kind
        self.parser = parser
        self.startPosition = startPosition
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
    
    func addText(_ line: Line, endOfLine: TextPosition) {
        textLines.append(line)
        updateEndPosition(endOfLine)
    }
    
    func updateEndPosition(_ endOfLine: TextPosition) {
        if let current = endPosition {
            endPosition = max(endOfLine, current)
        } else {
            endPosition = endOfLine
        }
    }
    
    func updateText(_ transform: ([Line]) -> [Line]) {
        textLines = transform(textLines)
        
        // We might have stripped off links definition
        if let newStart = textLines.first?.startPosition,
           newStart > startPosition {
            startPosition = newStart
        }
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
    
    var range: TextRange? {
        let possibleEndPositions = [
            startPosition,
            endPosition,
            textLines.last?.endPosition,
            children.last?.range?.end
        ].compactMap { $0 }
        
        let end = possibleEndPositions.max() ?? startPosition
        return TextRange(start: startPosition, end: end)
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
