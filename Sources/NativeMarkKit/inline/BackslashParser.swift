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
                              value: .linebreak,
                              valueLocation: newline.valueLocation)
        }
        
        let escapable = backslash.remaining.parse(Self.escapableRegex)
        if escapable.value.isNotEmpty {
            return escapable.map { .text($0) }
        }
        
        return backslash.map { .text($0) }
    }
}
