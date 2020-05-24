import Foundation

struct Line {
    let text: String
}

extension Line {
    func firstMatch(_ regex: NSRegularExpression) -> NSTextCheckingResult? {
        regex.firstMatch(in: text,
                         options: [],
                         range: NSRange(text.startIndex..<text.endIndex, in: text))
    }
    
    func replace(_ match: NSTextCheckingResult, with replacementText: String) -> Line {
        guard let replaceRange = Range(match.range, in: text) else {
            return self
        }
        
        var subtext = text
        subtext.replaceSubrange(replaceRange, with: replacementText)
        return Line(text: subtext)
    }
    
    func replace(_ regex: NSRegularExpression, with replacementText: String) -> Line {
        guard let match = firstMatch(regex) else {
            return self
        }
        return replace(match, with: replacementText)
    }
    
    var indentedStart: Line {
        var current = text.startIndex
        var count = 0
        while current < text.endIndex,
            text[current] == " " && count < 3 {
            count += 1
            current = text.index(after: current)
        }
        return subrange(current..<text.endIndex)
    }

    var isBlank: Bool {
        let blankCharacters = Set<Character>([" ", "\t", "\n"])
        return text.isEmpty || text.allSatisfy { blankCharacters.contains($0) }
    }
    
    static let blank = Line(text: "")
}

private extension Line {
    func subrange(_ range: Range<String.Index>) -> Line {
        Line(text: String(text[range]))
    }
}
