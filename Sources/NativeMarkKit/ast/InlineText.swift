import Foundation

indirect enum InlineText: Equatable {
    case code(String)
    case text(String)
    case linebreak
    case link(Link?, text: [InlineText])
    case image(Link?, text: [InlineText])
    case emphasis([InlineText])
    case strong([InlineText])
    case softbreak
}
