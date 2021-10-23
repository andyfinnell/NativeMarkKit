import Foundation

struct LinkDefinition: Equatable {
    let label: InlineString
    let link: Link
    let range: TextRange?
}

extension LinkDefinition: CustomStringConvertible {
    var description: String { "def { \(label): \(link); \(String(optional: range)) }" }
}
