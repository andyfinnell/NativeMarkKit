import Foundation

// TODO: eventually want emojii support
indirect enum InlineText: Equatable {
    case code(String)
    case text(String)
    case linebreak
    case link(Link?, text: [InlineText])
    case image(Link?, alt: String)
    case emphasis([InlineText])
    case strong([InlineText])
    case softbreak
}
