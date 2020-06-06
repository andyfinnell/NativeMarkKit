import Foundation

enum BlockKind: Equatable {
    case document
    case paragraph
    case thematicBreak
    case heading1
    case heading2
    case heading3
    case heading4
    case heading5
    case heading6
    case blockQuote
    case codeBlock(infoString: String)
    case item
    case list(ListStyle)
}
