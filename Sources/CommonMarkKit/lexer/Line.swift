import Foundation

struct Line {
    let text: String
    let startColumn: LineColumn
    
    init(text: String, startColumn: LineColumn) {
        self.text = text
        self.startColumn = startColumn
    }
}

extension Line {
    func hasPrefix(_ string: String) -> Bool {
        text.hasPrefix(string)
    }
    
    func firstMatch(_ regex: NSRegularExpression) -> NSTextCheckingResult? {
        text.firstMatch(of: regex)
    }
    
    func replace(_ match: NSTextCheckingResult, with replacementText: String) -> Line {
        guard let replaceRange = Range(match.range, in: text) else {
            return self
        }
        
        var subtext = text
        subtext.replaceSubrange(replaceRange, with: replacementText)
        return Line(text: subtext, startColumn: startColumn)
    }
    
    func replace(_ regex: NSRegularExpression, with replacementText: String) -> Line {
        guard let match = firstMatch(regex) else {
            return self
        }
        return replace(match, with: replacementText)
    }
    
    var nonIndentedStart: Line {
        var current = text.startIndex
        var column = startColumn
        while current < text.endIndex,
            text[current] == " " && column < LineColumn(3) {
            column = column.space()
            current = text.index(after: current)
        }
        return subrange(current..<text.endIndex, startColumn: column)
    }

    var hasIndent: Bool {
        indent >= LineColumnCount(4)
    }
    
    var indent: LineColumnCount {
        var current = text.startIndex
        var column = startColumn
        while current < text.endIndex, text[current].isSpaceOrTab {
            if text[current] == " " {
                column = column.space()
            } else if text[current] == "\t" {
                column = column.tab()
            }
            current = text.index(after: current)
        }
        return column - startColumn
    }
    
    func trimIndent(_ maxIndent: LineColumnCount = 4) -> Line {
        var current = text.startIndex
        var column = startColumn
        // TODO: this might split a tab, which would throw the column count
        while current < text.endIndex, text[current].isSpaceOrTab && (column - startColumn) < maxIndent {
            if text[current] == " " {
                column = column.space()
            } else if text[current] == "\t" {
                column = column.tab()
            }
            current = text.index(after: current)
        }
        return subrange(current..<text.endIndex, startColumn: column)
    }
    
    var isBlank: Bool {
        let blankCharacters = Set<Character>([" ", "\t", "\n"])
        return text.isEmpty || text.allSatisfy { blankCharacters.contains($0) }
    }
    
    static let blank = Line(text: "", startColumn: LineColumn(0))
}

private extension Line {
    func subrange(_ range: Range<String.Index>, startColumn: LineColumn) -> Line {
        Line(text: String(text[range]), startColumn: startColumn)
    }
}
