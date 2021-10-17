import Foundation

struct LinkDefinitionsLineParser {
    func parse(_ lines: [Line]) -> ([LinkDefinition], [Line]) {
        let input = TextCursor(lines: lines)
        let parser = LinkDefinitionParser()
        var definitions = [LinkDefinition]()
        
        var current = parser.parse(input: input)
        while let definition = current.value {
            definitions.append(definition)
            
            current = parser.parse(input: current.remaining)
        }
        
        guard !definitions.isEmpty else {
            return ([], lines)
        }
        
        if current.remaining.isAtEnd {
            return (definitions, [])
        }
        
        let lastLine = current.valueTextRange?.end.line ?? 0
        let remainingLines = lines.filter { $0.lineNumber >= lastLine }
        
        return (definitions, remainingLines)
    }
}
