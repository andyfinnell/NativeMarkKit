import Foundation

enum ListInfoKind: Equatable {
    case bulleted
    case ordered(start: Int)
}

extension ListInfoKind: CustomStringConvertible {
    var description: String {
        switch self {
        case .bulleted: return "bulleted"
        case let .ordered(start: n): return "\(n)."
        }
    }
}
