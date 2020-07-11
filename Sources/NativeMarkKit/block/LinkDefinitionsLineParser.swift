import Foundation

struct LinkDefinitionsLineParser {
    func parse(_ lines: [Line]) -> ([LinkDefinition], [Line]) {
        let buffer = lines.map { $0.activeText }.joined(separator: "\n")
        let input = TextCursor(text: buffer)
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
        
        let remainingLines = Lexer().scan(current.remaining.remaining())
        return (definitions, remainingLines)
    }
}
