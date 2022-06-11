import Foundation

struct BackticksParser {
    private static let ticksRegex = try! NSRegularExpression(pattern: "`+", options: [])
    private static let ticksAtStartRegex = try! NSRegularExpression(pattern: "^`+", options: [])

    func parse(_ input: TextCursor) -> TextResult<InlineText?> {
        let ticks = input.parse(Self.ticksAtStartRegex)
        guard ticks.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        if let closingTicks = findClosingBackticks(ticks) {
            return makeCode(opening: ticks, closing: closingTicks)
        } else {
            return ticks.map { .text(InlineString(text: $0, range: ticks.valueTextRange)) }
        }
    }
}

private extension BackticksParser {
    func findClosingBackticks(_ ticks: TextResult<String>) -> TextResult<String>? {
        var current = ticks.remaining.parse(Self.ticksRegex)
        while current.value.isNotEmpty {
            if ticks.value == current.value {
                return current
            }
            current = current.remaining.parse(Self.ticksRegex)
        }
        return nil
    }
    
    func makeCode(opening: TextResult<String>, closing: TextResult<String>) -> TextResult<InlineText?> {
        let rawText = opening.remaining.substring(upto: closing.valueLocation)
            .value
            .replacingOccurrences(of: "\n", with: " ")
        
        let hasNonSpace = rawText.contains(where: { $0 != " " })
        let hasUntrimmedSpaces = rawText.hasPrefix(" ") && rawText.hasSuffix(" ")
        
        let text: InlineString
        let rawTextStart = opening.remaining
        let rawTextEnd = closing.valueLocation.retreat()
        
        if rawText.isNotEmpty && hasNonSpace && hasUntrimmedSpaces {
            let rawTextRange = TextRange(start: rawTextStart.advance(),
                                         end: rawTextEnd.retreat())
            text = InlineString(text: rawText.trimmed(by: 1),
                                range: rawTextRange)
        } else {
            let rawTextRange = TextRange(start: rawTextStart, end: rawTextEnd)
            text = InlineString(text: rawText,
                                range: rawTextRange)
        }
        
        return TextResult(remaining: closing.remaining,
                          value: .code(InlineCode(code: text, range: TextRange(start: opening, end: closing))),
                          valueLocation: opening.valueLocation,
                          valueTextRange: TextRange(start: opening, end: closing))
    }
}
