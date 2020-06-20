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
            return ticks.map { .text($0) }
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
            .replacingOccurrences(of: "\n", with: " ")
        
        let hasNonSpace = rawText.contains(where: { $0 != " " })
        let hasUntrimmedSpaces = rawText.hasPrefix(" ") && rawText.hasSuffix(" ")
        
        let text: String
        if rawText.isNotEmpty && hasNonSpace && hasUntrimmedSpaces {
            text = rawText.trimmed(by: 1)
        } else {
            text = rawText
        }
        
        return TextResult(remaining: closing.remaining,
                          value: .code(text),
                          valueLocation: opening.valueLocation)
    }
}
