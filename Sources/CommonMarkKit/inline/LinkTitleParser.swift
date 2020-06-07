import Foundation

struct LinkTitleParser {
    private static let regex = try! NSRegularExpression(pattern: "^(?:\"(\(String.escapablePattern)|[^\"\\x00])*\"|'(\(String.escapablePattern)|[^'\\x00])*'|\\((\(String.escapablePattern)|[^()\\x00])*\\))", options: [])
    
    func parse(_ input: TextCursor) -> TextResult<String> {
        input.parse(Self.regex)
            .map { $0.trimmed(by: 1).unescaped() }
    }
}

