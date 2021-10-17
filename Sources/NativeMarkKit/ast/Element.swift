import Foundation

indirect enum Element: Equatable {
    case paragraph(Paragraph)
    case thematicBreak(ThematicBreak)
    case heading(Heading)
    case blockQuote(BlockQuote)
    case codeBlock(CodeBlock)
    case list(List)
}

extension Element: CustomStringConvertible {
    var description: String {
        switch self {
        case let .paragraph(paragraph): return paragraph.description
        case let .thematicBreak(thematicBreak): return thematicBreak.description
        case let .heading(heading): return heading.description
        case let .blockQuote(blockQuote): return blockQuote.description
        case let .codeBlock(codeBlock): return codeBlock.description
        case let .list(list): return list.description
        }
    }
}

struct Paragraph: Equatable {
    let text: [InlineText]
    let range: TextRange?
}

extension Paragraph: CustomStringConvertible {
    var description: String { "paragraph { \(text); \(String(optional: range)) }" }
}

struct ThematicBreak: Equatable {
    let range: TextRange?
}

extension ThematicBreak: CustomStringConvertible {
    var description: String { "thematicBreak { \(String(optional: range)) }" }
}

struct Heading: Equatable {
    let level: Int
    let text: [InlineText]
    let range: TextRange?
}

extension Heading: CustomStringConvertible {
    var description: String { "heading\(level) { \(text) \(String(optional: range)) }" }
}

struct BlockQuote: Equatable {
    let blocks: [Element]
    let range: TextRange?
}

extension BlockQuote: CustomStringConvertible {
    var description: String { "quote { \(blocks) \(String(optional: range)) }" }
}

struct CodeBlock: Equatable {
    let infoString: String
    let content: String
    let range: TextRange?
}

extension CodeBlock: CustomStringConvertible {
    var description: String { "codeBlock { \(infoString); \"\(content)\" \(String(optional: range)) }" }
}

struct List: Equatable {
    let info: ListInfo
    let items: [ListItem]
}

extension List: CustomStringConvertible {
    var description: String { "list { \(info); \(items) }" }
}
