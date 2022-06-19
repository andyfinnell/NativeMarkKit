import Foundation

struct ListItem: Equatable {
    let elements: [Element]
    let range: TextRange?
}

extension ListItem: CustomStringConvertible {
    var description: String {
        "listItem { \(elements); \(String(optional: range)) }"
    }
}
