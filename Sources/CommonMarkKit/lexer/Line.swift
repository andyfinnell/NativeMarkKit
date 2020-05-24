import Foundation

struct Line {
    let range: CursorRange<Source>
}

extension Line {
    var indentedStart: Cursor<Source> {
        var current = range.start
        var count = 0
        while current.isSpace && count < 3 {
            count += 1
            current = current.advance()
        }
        return current
    }

    var isBlank: Bool {
        let blankCharacters = Set<Character>([" ", "\t", "\n"])
        return !range.sequence.contains(where: { !blankCharacters.contains($0) })
    }
    
    static let blank: Line = {
        let source = Source(text: "", filename: "<blank>")
        let start = Cursor(source: source, index: source.startIndex)
        let end = Cursor(source: source, index: source.endIndex)
        return Line(range: CursorRange(start: start, end: end))
    }()
}
