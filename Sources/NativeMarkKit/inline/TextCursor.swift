import Foundation

struct TextCursor: Equatable {
    private let text: String
    private let index: String.Index
    private let lineMap: [Location]
    let position: TextPosition?
    
    init(lines: [Line]) {
        let source = lines.map { $0.text }.joined(separator: "\n")
        self.text = source
        self.index = text.startIndex
        self.position = lines.first
            .map { TextPosition(line: $0.lineNumber, column: $0.columnNumber) }
        self.lineMap = zip([source.startIndex] + source.indices(of: "\n").map { source.index(after: $0) },
                           lines.map { TextPosition(line: $0.lineNumber, column: $0.columnNumber)})
            .map { Location(index: $0.0, postion: $0.1) }
    }
    
    var isNotEnd: Bool {
        index < text.endIndex
    }
    
    var isAtEnd: Bool {
        index >= text.endIndex
    }
    
    var isAtStart: Bool {
        index == text.startIndex
    }
    
    var isNewline: Bool {
        character?.isNewline ?? false
    }
    
    var isAsciiSpaceOrControl: Bool {
        character?.isAsciiSpaceOrControl ?? false
    }
    
    var isWhitespace: Bool {
        character?.isWhitespace ?? false
    }
    
    var isPunctuation: Bool {
        character?.isPunctuation ?? false
    }
    
    func advance() -> TextCursor {
        guard index < text.endIndex else {
            return self
        }
        
        return TextCursor(text: text,
                          index: text.index(after: index),
                          lineMap: lineMap)
    }

    func advance(by count: Int) -> TextCursor {
        guard let newIndex = text.index(index, offsetBy: count, limitedBy: text.endIndex) else {
            return self
        }
        return TextCursor(text: text,
                          index: newIndex,
                          lineMap: lineMap)
    }

    func retreat() -> TextCursor {
        guard index > text.startIndex else {
            return self
        }
        
        return TextCursor(text: text,
                          index: text.index(before: index),
                          lineMap: lineMap)
    }
    
    func retreat(by count: Int) -> TextCursor {
        guard let newIndex = text.index(index, offsetBy: -count, limitedBy: text.startIndex) else {
            return self
        }
        return TextCursor(text: text,
                          index: newIndex,
                          lineMap: lineMap)
    }

    var character: Character? {
        guard index < text.endIndex else {
            return nil
        }
        return text[index]
    }
    
    func parse(_ prefix: String) -> TextResult<String> {
        guard let prefixRange = text.range(of: prefix, options: [], range: index..<text.endIndex, locale: nil),
            prefixRange.lowerBound == index else {
            return self.noMatch("")
        }
        
        let remaining = TextCursor(text: text,
                                   index: prefixRange.upperBound,
                                   lineMap: lineMap)
        return TextResult(remaining: remaining,
                          value: String(text[prefixRange]),
                          valueLocation: self,
                          valueTextRange: TextRange(start: self, end: remaining.retreat()))
    }
    
    func parse(_ prefix: NSRegularExpression) -> TextResult<String> {
        guard let match = firstMatch(of: prefix),
            let matchedRange = Range(match.range, in: text) else {
                return self.noMatch("")
        }
        
        let remaining = TextCursor(text: text,
                                   index: matchedRange.upperBound,
                                   lineMap: lineMap)
        let valueLocation = TextCursor(text: text,
                                       index: matchedRange.lowerBound,
                                       lineMap: lineMap)
        return TextResult(remaining: remaining,
                          value: String(text[matchedRange]),
                          valueLocation: valueLocation,
                          valueTextRange: TextRange(start: valueLocation, end: remaining.retreat()))
    }
    
    func substring(upto stopCursor: TextCursor) -> TextResult<String> {
        TextResult(remaining: stopCursor,
                   value: String(text[index..<stopCursor.index]),
                   valueLocation: self,
                   valueTextRange: TextRange(start: self, end: stopCursor.retreat()))
    }

    func remaining() -> String {
        String(text[index..<text.endIndex])
    }
    
    static func ==(lhs: TextCursor, rhs: Character) -> Bool {
        lhs.character == rhs
    }
    
    static func !=(lhs: TextCursor, rhs: Character) -> Bool {
        lhs.character != rhs
    }
}

private extension TextCursor {
    struct Location: Hashable {
        let index: String.Index
        let postion: TextPosition
    }
    
    init(text: String, index: String.Index, lineMap: [Location]) {
        self.text = text
        self.index = index
        self.lineMap = lineMap
        
        var lastLocation: Location?
        for location in lineMap {
            if location.index <= index {
                lastLocation = location
            } else {
                break
            }
        }
        
        if let startingLocation = lastLocation {
            var currentPostion = startingLocation.postion
            var current = startingLocation.index
            while current < index && current < text.endIndex {
                currentPostion = currentPostion.advanceColumn()
                current = text.index(after: current)
            }
            
            self.position = currentPostion
        } else {
            self.position = nil
        }
    }
    
    func firstMatch(of regex: NSRegularExpression) -> NSTextCheckingResult? {
        regex.firstMatch(in: text,
                         options: [],
                         range: NSRange(index..<text.endIndex, in: text))
    }
}

private extension String {
    func indices(of ch: Character) -> [String.Index] {
        var indices = [String.Index]()
        var current = startIndex
        while current < endIndex {
            if self[current] == ch {
                indices.append(current)
            }
            current = index(after: current)
        }
        return indices
    }
}
