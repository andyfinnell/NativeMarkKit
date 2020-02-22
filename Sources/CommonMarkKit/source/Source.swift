import Foundation

class Source {
    private let text: String
    let filename: String
    
    init(text: String, filename: String) {
        self.text = text
        self.filename = filename
    }
    
    struct Index {
        let index: String.Index
        let line: Int
        let column: Int
    }
}

extension Source.Index: Comparable {
    static func ==(lhs: Source.Index, rhs: Source.Index) -> Bool {
        return lhs.index == rhs.index
    }
    
    static func <(lhs: Source.Index, rhs: Source.Index) -> Bool {
        return lhs.index < rhs.index
    }
}

extension Source: CursorSource {
    typealias SourceIndex = Source.Index
    typealias Element = Character
    
    var startIndex: SourceIndex {
        return Source.Index(index: text.startIndex,
                            line: 1,
                            column: 1)
    }
    
    var endIndex: SourceIndex {
        return Source.Index(index: text.endIndex,
                            line: -1,
                            column: -1)
    }
    
    func index(after index: SourceIndex) -> SourceIndex {
        let next = text.index(after: index.index)
        let nextLine: Int
        let nextColumn: Int
        if index.index < text.endIndex && text[index.index].isNewline {
            nextLine = index.line + 1
            nextColumn = 1
        } else {
            nextLine = index.line
            nextColumn = index.column + 1
        }
        return Source.Index(index: next, line: nextLine, column: nextColumn)
    }
    
    func index(before index: SourceIndex) -> SourceIndex {
        let previous = text.index(before: index.index)
        let previousLine: Int
        let previousColumn: Int
        if previous >= text.startIndex && text[previous].isNewline {
            previousLine = index.line - 1
            previousColumn = lengthOfLine(endingAt: previous)
        } else {
            previousLine = index.line
            previousColumn = index.column - 1
        }
        return Source.Index(index: previous, line: previousLine, column: previousColumn)

    }
    
    subscript(_ index: SourceIndex) -> Character {
        return text[index.index]
    }
}

private extension Source {
    func lengthOfLine(endingAt index: String.Index) -> Int {
        var current = text.index(before: index)
        var count = 1
        
        while current >= text.startIndex && !text[current].isNewline {
            count += 1
            current = text.index(before: current)
        }
        
        return count
    }
}
