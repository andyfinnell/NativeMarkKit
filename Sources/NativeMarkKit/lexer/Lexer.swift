import Foundation

struct Lexer {
    func scan(_ source: String) -> [Line] {
        source.split(whereSeparator: { $0.isNewline })
            .map { Line(text: String($0), startColumn: LineColumn(0)) }
    }
}