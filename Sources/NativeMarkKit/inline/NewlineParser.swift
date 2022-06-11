import Foundation

struct NewlineParser {
    private static let spacesRegex = try! NSRegularExpression(pattern: "^ *", options: [])
    private static let finalSpacesRegex = try! NSRegularExpression(pattern: " *$", options: [])
    
    func parse(_ input: TextCursor, previous: InlineText?) -> TextResult<[InlineText]> {
        let newline = input.parse("\n")
        guard newline.value.isNotEmpty else {
            return input.noMatch(previous.map { [$0] } ?? [])
        }
        
        let spaces = newline.remaining.parse(Self.spacesRegex)

        let linebreak: InlineText
        let updatedPrevious: InlineText?
        if case let .text(previousText) = previous, previousText.text.hasSuffix(" ") {
            let isHardbreak = previousText.text.hasSuffix("  ")
            let updatedText = previousText.text.replacingOccurrences(of: Self.finalSpacesRegex, with: "")
            let deltaCount = previousText.text.count - updatedText.count
            
            let startOfPreviousSpaces = previousText.range?.end.retreatColumn(by: deltaCount)
            let updatedPreviousRange = TextRange(start: previousText.range?.start,
                                                 end: startOfPreviousSpaces)
            updatedPrevious = .text(InlineString(text: updatedText, range: updatedPreviousRange))
            
            let range = TextRange(start: startOfPreviousSpaces?.advanceColumn(),
                                  end: spaces.valueTextRange?.end)

            linebreak = isHardbreak
                ? .linebreak(InlineLinebreak(range: range))
                : .softbreak(InlineSoftbreak(range: range))
        } else {
            updatedPrevious = previous
            let range = TextRange(start: newline, end: spaces)
            linebreak = .softbreak(InlineSoftbreak(range: range))
        }
        
        
        return TextResult(remaining: spaces.remaining,
                          value: updatedPrevious.map { [$0, linebreak] } ?? [linebreak],
                          valueLocation: newline.valueLocation,
                          valueTextRange: TextRange(start: newline, end: spaces))
    }
}
