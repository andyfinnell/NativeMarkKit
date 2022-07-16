import Foundation

struct RenderParser {
    static func parse(_ nativeMark: String) -> Document {
        let lines = Lexer().scan(nativeMark)
        let documentBlock = Block(kind: .document,
                                  parser: DocumentBlockParser(),
                                  startPosition: TextPosition(line: 0, column: 0))
        LineParser().parse(lines, into: documentBlock)
        
        do {
            return try InlineParser().parse(documentBlock)
        } catch {
            // We always want to render something, so take it unparsed
            return Document(elements: [
                .paragraph(Paragraph(
                    text: [
                        .text(InlineString(
                            text: nativeMark,
                            range: nil))
                    ],
                    range: nil))
            ])
        }
    }
    
}
