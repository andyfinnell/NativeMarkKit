import Foundation

struct StringParser {
    private static let stringRegex = try! NSRegularExpression(pattern: "^[^\\n`\\[\\]\\\\!<&*_'\"]+", options: [])
    private static let ellipsisRegex = try! NSRegularExpression(pattern: "\\.\\.\\.", options: [])
    private static let dashesRegex = try! NSRegularExpression(pattern: "--+", options: [])
    
    func parse(_ input: TextCursor) -> TextResult<InlineText?> {
        let string = input.parse(Self.stringRegex)
        guard string.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        let text = string.value.replacingOccurrences(of: Self.ellipsisRegex, with: "…")
            .replacingOccurrences(of: Self.dashesRegex, using: smartDashes(_:))
        
        return string.map { _ in .text(InlineString(text: text, range: string.valueTextRange)) }
    }
}

private extension StringParser {
    func smartDashes(_ str: String) -> String {
        let (enCount, emCount) = counts(for: str)
        
        return String(repeating: "\u{2014}", count: emCount)
            + String(repeating: "\u{2013}", count: enCount)
    }
    
    func counts(for str: String) -> (enCount: Int, emCount: Int) {
        if str.count % 3 == 0 {
            return (enCount: 0, emCount: str.count / 3)
        } else if str.count % 2 == 0 {
            return (enCount: str.count / 2, emCount: 0)
        } else if str.count % 3 == 2 {
            return (enCount: 1, emCount: (str.count - 2) / 3)
        } else {
            return (enCount: 2, emCount: (str.count - 4) / 3)
        }
    }
}
