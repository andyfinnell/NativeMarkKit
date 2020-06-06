import Foundation

enum ListKind: Equatable {
    case bulleted(String)
    case ordered(start: Int, delimiter: String)
    
    func isSameKind(_ rhs: ListKind) -> Bool {
        switch (self, rhs) {
        case let (.bulleted(lhsMarker), .bulleted(rhsMarker)):
            return lhsMarker == rhsMarker
        case let (.ordered(start: _, delimiter: lhsDelimiter), .ordered(start: _, delimiter: rhsDelimiter)):
            return lhsDelimiter == rhsDelimiter
        default:
            return false
        }
    }
}
