import Foundation

struct LinkDefinitionParser {
    private static let spacesAtEndOfLineRegex = try! NSRegularExpression(pattern: "^ *(?:\\n|$)", options: [])
    
    func parse(input: TextCursor) -> TextResult<LinkDefinition?> {
        let labelResult = LinkLabelParser().parse(input)
        guard labelResult.value.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        let colonResult = labelResult.remaining.parse(":")
        guard colonResult.value.isNotEmpty else {
            return input.noMatch(nil)
        }

        let spacesResult = SpacesAndNewlineParser().parse(colonResult.remaining)
        
        let destinationResult = LinkDestinationParser().parse(spacesResult.remaining)
        guard let destination = destinationResult.value else {
            return input.noMatch(nil)
        }
        
        let beforeTitle = destinationResult.remaining
        var titleResult = parseOptionalTitle(destinationResult.remaining)
        
        var isAtEndOfLineResult = isAtEndOfLine(titleResult.remaining)
        if !isAtEndOfLineResult.value {
            if titleResult.value.isEmpty {
                isAtEndOfLineResult = input.noMatch(false)
            } else {
                titleResult = beforeTitle.noMatch("")
                isAtEndOfLineResult = isAtEndOfLine(beforeTitle)
            }
        }

        guard isAtEndOfLineResult.value else {
            return input.noMatch(nil)
        }
        
        let title = titleResult.value.isEmpty ? nil : titleResult.toInlineString()
        
        let definition = LinkDefinition(label: labelResult.value,
                                        url: InlineString(text: destination, range: destinationResult.valueTextRange),
                                        title: title)
        guard definition.key.isNotEmpty else {
            return input.noMatch(nil)
        }
        
        return TextResult(remaining: isAtEndOfLineResult.remaining,
                          value: definition,
                          valueLocation: input,
                          valueTextRange: TextRange(start: labelResult, end: isAtEndOfLineResult))
    }
}

private extension LinkDefinitionParser {
    func parseOptionalTitle(_ input: TextCursor) -> TextResult<String> {
        let spacesResult = SpacesAndNewlineParser().parse(input)
        
        // If spaces, then could be a title
        guard spacesResult.value.isNotEmpty else {
            return input.noMatch("")
        }
        
        let titleResult = LinkTitleParser().parse(spacesResult.remaining)
        guard titleResult.value.isNotEmpty else {
            return input.noMatch("")
        }
        return titleResult
    }
    
    func parseSpacesAtEndOfLine(_ input: TextCursor) -> TextResult<String> {
        input.parse(Self.spacesAtEndOfLineRegex)
    }
    
    func isAtEndOfLine(_ input: TextCursor) -> TextResult<Bool> {
        if input.isAtEnd {
            return TextResult(remaining: input,
                              value: true,
                              valueLocation: input,
                              valueTextRange: TextRange(start: input, end: input))
        } else {
            return parseSpacesAtEndOfLine(input).map { $0.isNotEmpty }
        }
    }
}
