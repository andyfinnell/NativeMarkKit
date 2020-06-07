import Foundation

extension String {
    static let escapablePattern = "[!\"#$%&'()*+,./:;<=>?@[\\\\\\]^_`{|}~-]"
    static let entityPattern = "&(?:#x[a-f0-9]{1,6}|#[0-9]{1,7}|[a-z][a-z0-9]{1,31});"
    
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    func matchedText(_ match: NSTextCheckingResult) -> String {
        guard let textRange = Range(match.range, in: self) else {
            return ""
        }
        return String(self[textRange])
    }
    
    func matchedText(_ match: NSTextCheckingResult, at index: Int) -> String {
        guard let textRange = Range(match.range(at: index), in: self) else {
            return ""
        }
        return String(self[textRange])
    }

    func nonmatchedText(_ match: NSTextCheckingResult) -> String {
        guard let replaceRange = Range(match.range, in: self) else {
            return self
        }
        
        var subtext = self
        subtext.replaceSubrange(replaceRange, with: "")
        return subtext
    }
    
    func firstMatch(of regex: NSRegularExpression) -> NSTextCheckingResult? {
        regex.firstMatch(in: self,
                         options: [],
                         range: NSRange(self.startIndex..<self.endIndex, in: self))
    }
    
    func trimmed(by count: Int) -> String {
        let newStart = index(startIndex, offsetBy: count, limitedBy: endIndex) ?? startIndex
        let newEnd = index(endIndex, offsetBy: -count, limitedBy: startIndex) ?? endIndex
        return String(self[newStart..<newEnd])
    }
    
    func replacingOccurrences(of regex: NSRegularExpression, with replacementString: String) -> String {
        regex.stringByReplacingMatches(in: self,
                                       options: [],
                                       range: NSRange(self.startIndex..<self.endIndex, in: self),
                                       withTemplate: replacementString)
    }
    
    func replacingOccurrences(of regex: NSRegularExpression, using transform: (String) -> String) -> String {
        var result = ""
        var lastMatchEndIndex: String.Index?
        regex.enumerateMatches(in: self, options: [], range: NSRange(self.startIndex..<self.endIndex, in: self)) { match, flags, _ in
            guard let match = match, let matchRange = Range(match.range, in: self) else {
                return
            }
            
            let gapStart = lastMatchEndIndex ?? startIndex
            let gapEnd = matchRange.lowerBound
            result.append(contentsOf: self[gapStart..<gapEnd])

            let replacedText = transform(String(self[matchRange]))
            result.append(contentsOf: replacedText)
            
            lastMatchEndIndex = matchRange.upperBound
        }
        
        let gapStart = lastMatchEndIndex ?? startIndex
        if gapStart < endIndex {
            result.append(contentsOf: self[gapStart..<endIndex])
        }
        return result
    }
    
    private static let escapableRegex = try! NSRegularExpression(pattern: "\\\\\(Self.escapablePattern)|\(Self.entityPattern)", options: .caseInsensitive)
    private static let escapableCharacterSet = Set<Character>(["\\", "&"])
    func unescaped() -> String {
        guard contains(where: { Self.escapableCharacterSet.contains($0) }) else {
            return self
        }
        return replacingOccurrences(of: Self.escapableRegex, using: Self.unescape(_:))
    }
}

private extension String {
    static func unescape(_ string: String) -> String {
        if string.hasPrefix("\\") {
            return String(string[string.index(after: string.startIndex)..<string.endIndex])
        } else {
            let key = string.uppercased().lowercased()
            return HtmlEntities.entities[key] ?? string
        }
    }
}
