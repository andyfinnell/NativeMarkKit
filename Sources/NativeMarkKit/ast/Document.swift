import Foundation

struct Document: Equatable {
    let elements: [Element]
}

extension Document: CustomStringConvertible {
    var description: String { "doc { \(elements) }" }
}
