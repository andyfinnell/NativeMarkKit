import Foundation

struct Link: Equatable {
    let title: InlineString?
    let url: InlineString?
}

extension Link: CustomStringConvertible {
    var description: String { "link { \(String(optional: url)); \(String(optional: title)) }" }
}
