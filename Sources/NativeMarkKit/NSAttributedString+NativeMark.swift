import Foundation

extension NSAttributedString {
    convenience init(nativeMark: String, styleSheet: StyleSheet) throws {
        let lines = Lexer().scan(nativeMark)
        let documentBlock = Block(kind: .document,
                                  parser: DocumentBlockParser(),
                                  startPosition: TextPosition(line: 0, column: 0))
        LineParser().parse(lines, into: documentBlock)
        let document = try InlineParser().parse(documentBlock)
        let renderer = Renderer()
        self.init(attributedString: renderer.render(document, with: styleSheet))
    }
}
