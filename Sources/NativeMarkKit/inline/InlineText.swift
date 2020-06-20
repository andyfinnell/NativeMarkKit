import Foundation

indirect enum InlineText {
    case code(String)
    case text(String)
    case linebreak
    case link(Link, text: [InlineText])
    case image(Link)
    case emphasis([InlineText])
    case strong([InlineText])
    case softbreak
}
