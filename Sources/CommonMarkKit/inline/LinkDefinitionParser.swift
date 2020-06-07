import Foundation

struct LinkDefinitionParser {
    private static let spacesAtEndOfLineRegex = try! NSRegularExpression(pattern: "^ *(?:\\n|$)", options: [])
    
    func parse(input: TextCursor) -> TextResult<LinkDefinition?> {
        let labelResult = LinkLabelParser().parse(input)
        guard labelResult.value.isNotEmpty else {
            return TextResult(remaining: input, value: nil)
        }
        
        let colonResult = labelResult.remaining.parse(":")
        guard colonResult.value.isNotEmpty else {
            return TextResult(remaining: input, value: nil)
        }

        let spacesResult = SpacesAndNewlineParser().parse(colonResult.remaining)
        
        let destinationResult = LinkDestinationParser().parse(spacesResult.remaining)
        guard let destination = destinationResult.value else {
            return TextResult(remaining: input, value: nil)
        }
        
        let beforeTitle = destinationResult.remaining
        var titleResult = parseOptionalTitle(destinationResult.remaining)
        
        var isAtEndOfLineResult = isAtEndOfLine(titleResult.remaining)
        if !isAtEndOfLineResult.value {
            if titleResult.value.isEmpty {
                isAtEndOfLineResult = TextResult(remaining: input, value: false)
            } else {
                titleResult = TextResult(remaining: beforeTitle, value: "")
                isAtEndOfLineResult = isAtEndOfLine(beforeTitle)
            }
        }

        guard isAtEndOfLineResult.value else {
            return TextResult(remaining: input, value: nil)
        }
        
        let definition = LinkDefinition(label: labelResult.value,
                                        url: destination,
                                        title: titleResult.value)
        guard definition.key.isNotEmpty else {
            return TextResult(remaining: input, value: nil)
        }
        
        return TextResult(remaining: isAtEndOfLineResult.remaining, value: definition)
    }
}

private extension LinkDefinitionParser {
    func parseOptionalTitle(_ input: TextCursor) -> TextResult<String> {
        let spacesResult = SpacesAndNewlineParser().parse(input)
        
        // If spaces, then could be a title
        guard spacesResult.value.isNotEmpty else {
            return TextResult(remaining: input, value: "")
        }
        
        let titleResult = LinkTitleParser().parse(spacesResult.remaining)
        guard titleResult.value.isNotEmpty else {
            return TextResult(remaining: input, value: "")
        }
        return titleResult
    }
    
    func parseSpacesAtEndOfLine(_ input: TextCursor) -> TextResult<String> {
        input.parse(Self.spacesAtEndOfLineRegex)
    }
    
    func isAtEndOfLine(_ input: TextCursor) -> TextResult<Bool> {
        return parseSpacesAtEndOfLine(input).map { $0.isNotEmpty }
    }
    
    func reparseTitle(_ input: TextCursor, titleResult: TextResult<String>) {
        
    }
}
