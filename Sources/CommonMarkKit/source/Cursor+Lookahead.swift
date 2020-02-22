import Foundation

extension Cursor where S.Element == Character {
    func prefix(_ length: Int) -> String {
        return String(sequence(ofLength: length))
    }
    
    func hasPrefix(_ string: String) -> Bool {
        return prefix(string.count) == string
    }
}
