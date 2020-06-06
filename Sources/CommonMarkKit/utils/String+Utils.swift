import Foundation

extension String {
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

}
