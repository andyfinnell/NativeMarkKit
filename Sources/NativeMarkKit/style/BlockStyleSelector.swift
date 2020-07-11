import Foundation

enum BlockStyleSelector: Hashable {
    case document
    case paragraph
    case thematicBreak
    case heading(level: Int)
    case blockQuote
    case codeBlock
    case list(isTight: Bool)
    case item
}
