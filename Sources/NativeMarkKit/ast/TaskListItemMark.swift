import Foundation

struct TaskListItemMark: Equatable {
    let text: String
    let contentText: String
    let range: TextRange?
}

extension TaskListItemMark: CustomStringConvertible {
    var description: String {
        "task { \(text); \(String(optional: range)) }"
    }
}
