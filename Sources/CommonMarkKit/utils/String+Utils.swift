import Foundation

extension String {
    static let escapablePattern = "[!\"#$%&'()*+,./:;<=>?@[\\\\\\]^_`{|}~-]"
    
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
    
    func unescaped() -> String {
        // TODO: implement unescaped strings (entities and backslashes)
        return self
    }
}
