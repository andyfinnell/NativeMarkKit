import Foundation

indirect enum Element: Equatable {
    case paragraph([InlineText])
    case thematicBreak
    case heading(level: Int, text: [InlineText])
    case blockQuote([Element])
    case codeBlock(infoString: String, content: String)
    case list(ListInfo, items: [ListItem])
}
