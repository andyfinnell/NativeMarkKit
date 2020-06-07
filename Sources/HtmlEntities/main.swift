import Foundation

struct EntityData: Codable {
    let characters: String
}
typealias Entities = [String: EntityData]


let currentDirectoryUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
let sourceJsonUrl = currentDirectoryUrl.appendingPathComponent("entities.json")
let sourceJsonData = try Data(contentsOf: sourceJsonUrl)
let entities = try JSONDecoder().decode(Entities.self, from: sourceJsonData)

var output = """
import Foundation

enum HtmlEntities {
    static let entities = [

"""

for (key, value) in entities {
    let normalizedKey = key.uppercased().lowercased()
    let escapedCharacters: [Character] = value.characters.flatMap { ch -> [Character] in
        switch ch {
        case "\\": return ["\\", "\\"]
        case "\"": return ["\\", "\""]
        case "\n": return ["\\", "n"]
        case "\t": return ["\\", "t"]
        default: return [ch]
        }
    }
    let escapedString = String(escapedCharacters)
    output.append("\t\t\"\(normalizedKey)\": \"\(escapedString)\",\n")
}

output += """
    ]
}
"""

let outputData = output.data(using: .utf8)
let destinationUrl = currentDirectoryUrl.appendingPathComponent("HtmlEntities.swift")
try outputData?.write(to: destinationUrl)
