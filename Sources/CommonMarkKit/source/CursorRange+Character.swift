import Foundation

extension CursorRange where S.Element == Character {
    var string: String {
        return String(start.sequence(upTo: end))
    }
}
