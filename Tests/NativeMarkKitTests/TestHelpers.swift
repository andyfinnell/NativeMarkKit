import Foundation
@testable import NativeMarkKit

func compile(_ markdownText: String) throws -> Document {
    let lines = Lexer().scan(markdownText)
    let documentBlock = Block(kind: .document, parser: DocumentBlockParser())
    LineParser().parse(lines, into: documentBlock)
    return try InlineParser().parse(documentBlock)
}
