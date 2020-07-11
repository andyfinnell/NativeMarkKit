import Foundation

struct Line {
    private let source: String
    let column: LineColumn
    private let index: String.Index
    let activeText: Substring
    
    init(text: String) {
        self.source = text
        self.column = LineColumn(0)
        self.index = text.startIndex
        self.activeText = text[text.startIndex..<text.endIndex]
    }
    
    init(source: String, column: LineColumn, index: String.Index) {
        self.source = source
        self.column = column
        self.index = index
        self.activeText = source[index..<source.endIndex]
    }
}

extension Line {
    func hasPrefix(_ string: String) -> Bool {
        activeText.hasPrefix(string)
    }
    
    func firstMatch(_ regex: NSRegularExpression) -> NSTextCheckingResult? {
        regex.firstMatch(in: source,
                         options: [],
                         range: NSRange(self.index..<source.endIndex, in: source))
    }
    
    func matchedText(_ match: NSTextCheckingResult) -> Substring {
        guard let textRange = Range(match.range, in: source) else {
            return ""
        }
        return source[textRange]
    }
    
    func matchedText(_ match: NSTextCheckingResult, at index: Int) -> Substring {
        guard let textRange = Range(match.range(at: index), in: source) else {
            return ""
        }
        return source[textRange]
    }

    func skip(_ match: NSTextCheckingResult) -> Line {
        guard let replaceRange = Range(match.range, in: source),
            replaceRange.lowerBound == index else {
            return self
        }

        return Line(source: source,
                    column: column(of: replaceRange.upperBound),
                    index: replaceRange.upperBound)
    }
    
    func skip(_ regex: NSRegularExpression) -> Line {
        guard let match = firstMatch(regex) else {
            return self
        }
        return skip(match)
    }
        
    var nonIndentedStart: Line {
        var current = index
        var column = self.column
        while current < source.endIndex,
            source[current] == " " && (column - self.column) < LineColumnCount(3) {
            column = column.space()
            current = source.index(after: current)
        }
        return Line(source: source, column: column, index: current)
    }

    var hasIndent: Bool {
        indent >= LineColumnCount(4)
    }
    
    var indent: LineColumnCount {
        var current = index
        var column = self.column
        while current < source.endIndex, source[current].isSpaceOrTab {
            if source[current] == " " {
                column = column.space()
            } else if source[current] == "\t" {
                column = column.tab()
            }
            current = source.index(after: current)
        }
        return column - self.column
    }
    
    func trimIndent(_ maxIndent: LineColumnCount = 4) -> Line {
        var current = index
        var column = self.column
        // TODO: this might split a tab, which would throw the column count
        while current < source.endIndex, source[current].isSpaceOrTab && (column - self.column) < maxIndent {
            if source[current] == " " {
                column = column.space()
            } else if source[current] == "\t" {
                column = column.tab()
            }
            current = source.index(after: current)
        }
        return Line(source: source, column: column, index: current)
    }
        
    var isBlank: Bool {
        Self.isBlank(activeText)
    }
    
    var end: Line {
        Line(source: source,
             column: column(of: source.endIndex),
             index: source.endIndex)
    }
    
    static let blank = Line(text: "")
}

private extension Line {
    static func isBlank<S: StringProtocol>(_ text: S) -> Bool {
        let blankCharacters = Set<Character>([" ", "\t", "\n"])
        return text.isEmpty || text.allSatisfy { blankCharacters.contains($0) }
    }
            
    func column(of endIndex: String.Index) -> LineColumn {
        var current = index
        var column = self.column
        while current < endIndex {
            if source[current] == "\t" {
                column = column.tab()
            } else {
                column = column.space()
            }
            current = source.index(after: current)
        }
        return column
    }
}
