import Foundation

struct LinkDefinition {
    private static let whitespaceRun = try! NSRegularExpression(pattern: "[ \\t\\r\\n]+", options: [])
    
    let key: String
    let url: URL
    let title: String
    
    init(label: String, url: URL, title: String) {
        self.key = label.trimmed(by: 1)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: Self.whitespaceRun, with: "")
            .lowercased()
            .uppercased()
        self.url = url
        self.title = title
    }
}
