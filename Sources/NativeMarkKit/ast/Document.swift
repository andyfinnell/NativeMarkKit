import Foundation

struct Document: Equatable {
    let elements: [Element]
    let linkDefinitions: [LinkDefinition]
    
    init(elements: [Element], linkDefinitions: [LinkDefinition] = []) {
        self.elements = elements
        self.linkDefinitions = linkDefinitions
    }
}

extension Document: CustomStringConvertible {
    var description: String { "doc { \(elements); \(linkDefinitions) }" }
}
