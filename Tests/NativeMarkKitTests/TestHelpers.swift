import Foundation
@testable import NativeMarkKit

func compile(_ markdownText: String) throws -> Document {
    let lines = Lexer().scan(markdownText)
    let documentBlock = Block(kind: .document, parser: DocumentBlockParser(), startPosition: TextPosition(line: 0, column: 0))
    LineParser().parse(lines, into: documentBlock)
    return try InlineParser().parse(documentBlock)
}
