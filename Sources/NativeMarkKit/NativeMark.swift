import Foundation

enum NativeMark {
    static func compile(_ nativeMark: String) throws -> Document {
        let lines = Lexer().scan(nativeMark)
        let documentBlock = Block(kind: .document,
                                  parser: DocumentBlockParser(),
                                  startPosition: TextPosition(line: 0, column: 0))
        LineParser().parse(lines, into: documentBlock)
        return try InlineParser().parse(documentBlock)
    }
}
