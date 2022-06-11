import Foundation

struct Lexer {
    func scan(_ source: String) -> [Line] {
        guard source.isNotEmpty else {
            return []
        }
        return source.split(omittingEmptySubsequences: false, whereSeparator: { $0.isNewline })
            .enumerated()
            .map { Line(text: String($1), lineNumber: $0) }
    }
}
