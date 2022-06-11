import Foundation

extension String {
    static let escapablePattern = "[!\"#$%&'()*+,.\\/:;<=>?@\\[\\\\\\]^_`{|}~-]"
    static let entityPattern = "&(?:#x[a-f0-9]{1,6}|#[0-9]{1,7}|[a-z][a-z0-9]{1,31});"
    
    init<T>(optional: T?) {
        if let value = optional {
            self = String(describing: value)
        } else {
            self = "nil"
        }
    }
    
    var isNotEmpty: Bool {
        !isEmpty
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
    
    func remove(_ regex: NSRegularExpression) -> String {
        guard let match = firstMatch(of: regex) else {
            return self
        }
        return remove(match)
    }
    
    func remove(_ match: NSTextCheckingResult) -> String {
        guard let replaceRange = Range(match.range, in: self) else {
            return self
        }
        
        var subtext = self
        subtext.removeSubrange(replaceRange)
        return subtext
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
    
    private static let wordRegex = try! NSRegularExpression(pattern: "^\\S+", options: [])
    func firstWord() -> String {
        firstMatch(of: Self.wordRegex).map { matchedText($0) } ?? self
    }
}

private extension String {
    static func unescape(_ string: String) -> String {
        if string.hasPrefix("\\") {
            return String(string[string.index(after: string.startIndex)..<string.endIndex])
        } else if string.hasPrefix("&#x") || string.hasPrefix("&#X") {
            let hexString = string.trimmed(caseInsensitivePrefix: "&#x").trimmed(suffix: ";")
            let number = Int(hexString, radix: 16) ?? 0
            return Self.string(from: number)
        } else if string.hasPrefix("&#") {
            let decimalString = string.trimmed(caseInsensitivePrefix: "&#").trimmed(suffix: ";")
            let number = Int(decimalString, radix: 10) ?? 0
            return Self.string(from: number)
        } else {
            return HtmlEntities.entities[string] ?? string
        }
    }
    
    static func string(from codePoint: Int) -> String {
        guard codePoint != 0 else {
            return ""
        }
        return UnicodeScalar(codePoint).map { String(Character($0)) } ?? ""
    }
    
    func trimmed(caseInsensitivePrefix prefix: String) -> String {
        guard lowercased().hasPrefix(prefix.lowercased()) else {
            return self
        }
        
        let newStart = index(startIndex, offsetBy: prefix.count, limitedBy: endIndex) ?? startIndex
        return String(self[newStart..<endIndex])
    }

    func trimmed(suffix: String) -> String {
        guard hasSuffix(suffix) else {
            return self
        }
        
        let newEnd = index(endIndex, offsetBy: -suffix.count, limitedBy: startIndex) ?? endIndex
        return String(self[startIndex..<newEnd])
    }
    
    func matchedText(_ match: NSTextCheckingResult) -> String {
        guard let textRange = Range(match.range, in: self) else {
            return ""
        }
        return String(self[textRange])
    }
}
