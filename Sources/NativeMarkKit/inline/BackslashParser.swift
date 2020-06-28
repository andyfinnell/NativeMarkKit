import Foundation

struct BackslashPaser {
    private static let escapableRegex = try! NSRegularExpression(pattern: "^\(String.escapablePattern.escapeForRegex())", options: [])
    
    func parse(_ input: TextCursor) -> TextResult<InlineText?> {
        let backslash = input.parse("\\")
        guard backslash.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        let newline = input.parse("\n")
        if newline.value.isNotEmpty {
            return newline.map { _ in .linebreak }
        }
        
        let escapable = input.parse(Self.escapableRegex)
        if escapable.value.isNotEmpty {
            return escapable.map { .text($0) }
        }
        
        return backslash.map { .text($0) }
    }
}
