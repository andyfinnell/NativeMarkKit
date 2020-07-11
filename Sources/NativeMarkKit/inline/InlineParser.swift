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
    func document(_ block: Block, linkDefs: [LinkLabel: LinkDefinition]) throws -> Document {
        try Document(elements: block.children.map { try element($0, linkDefs: linkDefs) })
    }
    
    func element(_ block: Block, linkDefs: [LinkLabel: LinkDefinition]) throws -> Element {
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
            return paragraph(block, linkDefs: linkDefs)
        case .thematicBreak:
            return .thematicBreak
        case .document,
             .item:
            throw ASTError.unexpectedBlock(block.kind)
        }
    }
    
    func blockQuote(_ block: Block, linkDefs: [LinkLabel: LinkDefinition]) throws -> Element {
        try .blockQuote(block.children.map { try element($0, linkDefs: linkDefs) })
    }
    
    func codeBlock(_ block: Block, infoString: String, linkDefs: [LinkLabel: LinkDefinition]) -> Element {
        let text = block.textLines.map { $0.text }.joined(separator: "\n")
        let suffix = (text.isEmpty || text.hasSuffix("\n")) ? "" : "\n"
        return .codeBlock(infoString: infoString, content: text + suffix)
    }
    
    func heading(_ block: Block, level: Int, linkDefs: [LinkLabel: LinkDefinition]) -> Element {
        let inlineText = InlineBlockParser().parse(block, using: linkDefs)
        return .heading(level: level, text: inlineText)
    }

    func list(_ block: Block, style: ListStyle, linkDefs: [LinkLabel: LinkDefinition]) throws -> Element {
        try .list(listInfo(style), items: block.children.map { try listItem($0, linkDefs: linkDefs) })
    }

    func paragraph(_ block: Block, linkDefs: [LinkLabel: LinkDefinition]) -> Element {
        let inlineText = InlineBlockParser().parse(block, using: linkDefs)
        return .paragraph(inlineText)
    }

    func listItem(_ block: Block, linkDefs: [LinkLabel: LinkDefinition]) throws -> ListItem {
        guard block.kind == .item else {
            throw ASTError.expectedBlock(.item)
        }
        
        return try ListItem(elements: block.children.map { try element($0, linkDefs: linkDefs) })
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
