import Foundation

struct LinkLabel: Hashable {
    private static let whitespaceRun = try! NSRegularExpression(pattern: "[ \\t\\r\\n]+", options: [])

    let value: String
    
    init(_ string: InlineString) {
        self.value = string.text.trimmed(by: 1)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: Self.whitespaceRun, with: "")
            .lowercased()
            .uppercased()
    }
    
    var isNotEmpty: Bool { value.isNotEmpty }
}
