import Foundation

struct NewlineParser {
    private static let spacesRegex = try! NSRegularExpression(pattern: "^ *", options: [])
    private static let finalSpacesRegex = try! NSRegularExpression(pattern: " *$", options: [])
    
    func parse(_ input: TextCursor, previous: InlineText?) -> TextResult<[InlineText]> {
        let newline = input.parse("\n")
        guard newline.value.isNotEmpty else {
            return input.noMatch(previous.map { [$0] } ?? [])
        }
        
        let linebreak: InlineText
        let updatedPrevious: InlineText?
        if case let .text(previousText) = previous, previousText.hasSuffix("  ") {
            let updatedText = previousText.replacingOccurrences(of: Self.finalSpacesRegex, with: "")
            updatedPrevious = .text(updatedText)
            
            linebreak = .linebreak
        } else {
            updatedPrevious = previous
            linebreak = .softbreak
        }
        
        let spaces = newline.remaining.parse(Self.spacesRegex)
        
        return TextResult(remaining: spaces.remaining,
                          value: updatedPrevious.map { [$0, linebreak] } ?? [linebreak],
                          valueLocation: newline.valueLocation)
    }
}
