import Foundation

final class Delimiter {
    let character: String
    let count: Int
    let canOpen: Bool
    let canClose: Bool
    let inlineText: InlineText
    var after: [InlineText]
    
    init(character: String, count: Int, canOpen: Bool, canClose: Bool, inlineText: InlineText) {
        self.character = character
        self.count = count
        self.canOpen = canOpen
        self.canClose = canClose
        self.inlineText = inlineText
        after = []
    }
    
    func push(_ inlineText: InlineText) {
        after = after + [inlineText]
    }
    
    func popLast() -> InlineText? {
        after.popLast()
    }
}

extension Delimiter {
    static let starting = Delimiter(character: "", count: 0, canOpen: false, canClose: false, inlineText: .linebreak)
}
