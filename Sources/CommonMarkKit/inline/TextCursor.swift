import Foundation

struct TextCursor: Equatable {
    private let text: String
    private let index: String.Index
    
    init(text: String) {
        self.text = text
        self.index = text.startIndex
    }
    
    var isNotEnd: Bool {
        index < text.endIndex
    }
    
    var isAtEnd: Bool {
        index >= text.endIndex
    }
    
    var isNewline: Bool {
        character?.isNewline ?? false
    }
    
    var isAsciiSpaceOrControl: Bool {
        character?.isAsciiSpaceOrControl ?? false
    }
    
    func advance() -> TextCursor {
        guard index < text.endIndex else {
            return self
        }
        
        return TextCursor(text: text, index: text.index(after: index))
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
            return TextResult(remaining: self, value: "")
        }
        
        let remaining = TextCursor(text: text, index: prefixRange.upperBound)
        return TextResult(remaining: remaining, value: String(text[prefixRange]))
    }
    
    func parse(_ prefix: NSRegularExpression) -> TextResult<String> {
        guard let match = firstMatch(of: prefix),
            let matchedRange = Range(match.range, in: text) else {
            return TextResult(remaining: self, value: "")
        }
        
        let remaining = TextCursor(text: text, index: matchedRange.upperBound)
        return TextResult(remaining: remaining,
                          value: text.matchedText(match))
    }
    
    func substring(upto stopCursor: TextCursor) -> String {
        String(text[index..<stopCursor.index])
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
    init(text: String, index: String.Index) {
        self.text = text
        self.index = index
    }
    
    func firstMatch(of regex: NSRegularExpression) -> NSTextCheckingResult? {
        regex.firstMatch(in: text,
                         options: [],
                         range: NSRange(index..<text.endIndex, in: text))
    }

}
