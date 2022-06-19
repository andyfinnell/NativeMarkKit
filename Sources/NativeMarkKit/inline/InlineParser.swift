import Foundation

enum ASTError: Error {
    case unexpectedBlock(BlockKind)
    case expectedBlock(BlockKind)
}

struct InlineParser {
    func parse(_ document: Block) throws -> Document {
        let linkDefs = document.linkDefinitions
        return try self.document(document, linkDefs: linkDefs)
    }
}

private extension InlineParser {
    func document(_ block: Block, linkDefs: [LinkLabel: BlockLinkDefinition]) throws -> Document {
        try Document(elements: block.children.map { try element($0, linkDefs: linkDefs, canHaveTaskItem: false) },
                     linkDefinitions: block.allLinkDefinitions)
    }
    
    func element(_ block: Block, linkDefs: [LinkLabel: BlockLinkDefinition], canHaveTaskItem: Bool) throws -> Element {
        switch block.kind {
        case .blockQuote:
            return try blockQuote(block, linkDefs: linkDefs)
        case let .codeBlock(infoString: info):
            return codeBlock(block, infoString: info, linkDefs: linkDefs)
        case let .heading(level):
            return heading(block, level: level, linkDefs: linkDefs)
        case let .list(listStyle):
            return try list(block, style: listStyle, linkDefs: linkDefs)
        case .paragraph:
            return paragraph(block, linkDefs: linkDefs, canHaveTaskItem: canHaveTaskItem)
        case .thematicBreak:
            return .thematicBreak(ThematicBreak(range: block.range))
        case .document,
             .item:
            throw ASTError.unexpectedBlock(block.kind)
        }
    }
    
    func blockQuote(_ block: Block, linkDefs: [LinkLabel: BlockLinkDefinition]) throws -> Element {
        try .blockQuote(BlockQuote(blocks: block.children.map { try element($0, linkDefs: linkDefs, canHaveTaskItem: false) }, range: block.range))
    }
    
    func codeBlock(_ block: Block, infoString: String, linkDefs: [LinkLabel: BlockLinkDefinition]) -> Element {
        let text = block.textLines.map { $0.text }.joined(separator: "\n")
        let suffix = (text.isEmpty || text.hasSuffix("\n")) ? "" : "\n"
        return .codeBlock(CodeBlock(infoString: infoString, content: text + suffix, range: block.range))
    }
    
    func heading(_ block: Block, level: Int, linkDefs: [LinkLabel: BlockLinkDefinition]) -> Element {
        let inlineText = InlineBlockParser().parse(block, using: linkDefs, canHaveTaskItem: false)
        return .heading(Heading(level: level, text: inlineText.text, range: block.range))
    }

    func list(_ block: Block, style: ListStyle, linkDefs: [LinkLabel: BlockLinkDefinition]) throws -> Element {
        try .list(List(info: listInfo(style), items: block.children.map { try listItem($0, linkDefs: linkDefs) }))
    }

    func paragraph(_ block: Block, linkDefs: [LinkLabel: BlockLinkDefinition], canHaveTaskItem: Bool) -> Element {
        let inlineText = InlineBlockParser().parse(block, using: linkDefs, canHaveTaskItem: canHaveTaskItem)
        return .paragraph(Paragraph(taskListItemMark: inlineText.taskListItemMark, text: inlineText.text, range: block.range))
    }

    func listItem(_ block: Block, linkDefs: [LinkLabel: BlockLinkDefinition]) throws -> ListItem {
        guard block.kind == .item else {
            throw ASTError.expectedBlock(.item)
        }
        
        let elements = try block.children.enumerated().map { try element($1, linkDefs: linkDefs, canHaveTaskItem: $0 == 0) }
        return ListItem(elements: elements, range: block.range)
    }
    
    func listInfo(_ style: ListStyle) -> ListInfo {
        let kind: ListInfoKind
        switch style.kind {
        case .bulleted:
            kind = .bulleted
        case .ordered(start: let start, delimiter: _):
            kind = .ordered(start: start)
        }
        return ListInfo(isTight: style.isTight, kind: kind)
    }
}
