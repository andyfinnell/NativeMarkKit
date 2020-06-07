import Foundation

struct SpacesAndNewlineParser {
    private static let regex = try! NSRegularExpression(pattern: "^ *(?:\\n *)?", options: [])
    
    func parse(_ input: TextCursor) -> TextResult<String> {
        input.parse(Self.regex)
    }
}
