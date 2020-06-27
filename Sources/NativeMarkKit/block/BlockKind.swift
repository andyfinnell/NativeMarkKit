import Foundation

enum BlockKind: Equatable {
    case document
    case paragraph
    case thematicBreak
    case heading(Int)
    case blockQuote
    case codeBlock(infoString: String)
    case item
    case list(ListStyle)
}
