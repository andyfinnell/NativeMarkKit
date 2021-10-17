import Foundation

struct BackslashPaser {
    private static let escapableRegex = try! NSRegularExpression(pattern: "^\(String.escapablePattern)", options: [])
    private static let spacesRegex = try! NSRegularExpression(pattern: "^ *", options: [])

    func parse(_ input: TextCursor) -> TextResult<InlineText?> {
        let backslash = input.parse("\\")
        guard backslash.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        let newline = backslash.remaining.parse("\n")
        if newline.value.isNotEmpty {
            let spaces = newline.remaining.parse(Self.spacesRegex)
            return TextResult(remaining: spaces.remaining,
                              value: .linebreak(InlineLinebreak(range: TextRange(start: backslash, end: spaces))),
                              valueLocation: newline.valueLocation,
                              valueTextRange: TextRange(start: backslash, end: spaces))
        }
        
        let escapable = backslash.remaining.parse(Self.escapableRegex)
        if escapable.value.isNotEmpty {
            return escapable.map { .text(InlineString(text: $0, range: TextRange(start: backslash, end: escapable))) }
        }
        
        return backslash.map { .text(InlineString(text: $0, range: backslash.valueTextRange)) }
    }
}
