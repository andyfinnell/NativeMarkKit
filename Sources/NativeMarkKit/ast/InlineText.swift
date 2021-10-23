import Foundation

indirect enum InlineText: Equatable {
    case code(InlineCode)
    case text(InlineString)
    case linebreak(InlineLinebreak)
    case link(InlineLink)
    case image(InlineImage)
    case emphasis(InlineEmphasis)
    case strong(InlineStrong)
    case softbreak(InlineSoftbreak)
}

extension InlineText {
    var range: TextRange? {
        switch self {
        case let .code(code): return code.range
        case let .text(text): return text.range
        case let .linebreak(linebreak): return linebreak.range
        case let .link(link): return link.range
        case let .image(image): return image.range
        case let .emphasis(emphasis): return emphasis.range
        case let .strong(strong): return strong.range
        case let .softbreak(softbreak): return softbreak.range
        }
    }
}

extension InlineText: CustomStringConvertible {
    var description: String {
        switch self {
        case let .code(code): return code.description
        case let .text(text): return text.description
        case let .linebreak(linebreak): return linebreak.description
        case let .link(link): return link.description
        case let .image(image): return image.description
        case let .emphasis(emphasis): return emphasis.description
        case let .strong(strong): return strong.description
        case let .softbreak(softbreak): return softbreak.description
        }
    }
}

struct InlineCode: Equatable {
    let code: InlineString
    let range: TextRange?
}

extension InlineCode: CustomStringConvertible {
    var description: String { "code { \"\(code)\" \(String(optional: range)) }" }
}

struct InlineString: Equatable {
    let text: String
    let range: TextRange?
}

extension InlineString: CustomStringConvertible {
    var description: String { "text { \"\(text)\" \(String(optional: range)) }" }
}

struct InlineLinebreak: Equatable {
    let range: TextRange?
}

extension InlineLinebreak: CustomStringConvertible {
    var description: String { "linebreak { \(String(optional: range)) }" }
}

struct InlineLink: Equatable {
    let link: Link?
    let text: [InlineText]
    let range: TextRange?
}

extension InlineLink: CustomStringConvertible {
    var description: String { "link { [\(String(optional: link))](\(text)) \(String(optional: range)) }" }
}

struct InlineImage: Equatable {
    let link: Link?
    let alt: InlineString
    let range: TextRange?
}

extension InlineImage: CustomStringConvertible {
    var description: String { "image { [\(String(optional: link))](\(alt)) \(String(optional: range)) }" }
}

struct InlineEmphasis: Equatable {
    let text: [InlineText]
    let range: TextRange?
}

extension InlineEmphasis: CustomStringConvertible {
    var description: String { "emphasis { \(text); \(String(optional: range)) }" }
}

struct InlineStrong: Equatable {
    let text: [InlineText]
    let range: TextRange?
}

extension InlineStrong: CustomStringConvertible {
    var description: String { "strong { \(text); \(String(optional: range)) }" }
}

struct InlineSoftbreak: Equatable {
    let range: TextRange?
}

extension InlineSoftbreak: CustomStringConvertible {
    var description: String { "softbreak { \(String(optional: range)) }" }
}

extension Array where Element == InlineText {
    var range: TextRange? {
        guard let firstInlineText = first else {
            return nil
        }
        
        return reduce(firstInlineText.range) { partialResults, inlineText -> TextRange? in
            TextRange(start: partialResults?.start, end: inlineText.range?.end)
        }
    }
}
