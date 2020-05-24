import Foundation

extension String {
    func matchedText(_ match: NSTextCheckingResult) -> String {
        guard let textRange = Range(match.range, in: self) else {
            return ""
        }
        return String(self[textRange])
    }
}
