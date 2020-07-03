import Foundation

enum ListInfoKind: Equatable {
    case bulleted
    case ordered(start: Int)
}
