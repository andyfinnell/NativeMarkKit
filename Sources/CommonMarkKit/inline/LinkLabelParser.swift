import Foundation

struct LinkLabelParser {
    private static let regex = try! NSRegularExpression(pattern: "^\\[(?:[^\\\\[\\]]|\\.){0,1000}\\]", options: [])
    
    func parse(_ input: TextCursor) -> TextResult<String> {
        input.parse(Self.regex)
    }
}
