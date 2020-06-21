import Foundation

final class Delimiter {
    let character: String
    let count: Int
    let canOpen: Bool
    let canClose: Bool
    var isActive: Bool
    let inlineText: InlineText
    let startCursor: TextCursor
    var after: [InlineText]
    
    init(character: String, count: Int, canOpen: Bool, canClose: Bool, inlineText: InlineText, startCursor: TextCursor) {
        self.character = character
        self.count = count
        self.canOpen = canOpen
        self.canClose = canClose
        self.inlineText = inlineText
        self.startCursor = startCursor
        isActive = true
        after = []
    }
    
    func push(_ inlineText: InlineText) {
        after = after + [inlineText]
    }
    
    func popLast() -> InlineText? {
        after.popLast()
    }
    
    var isImageOpener: Bool {
        character == "!["
    }
    
    var isLinkOpener: Bool {
        character == "["
    }
}

extension Delimiter {
    static let starting = Delimiter(character: "", count: 0, canOpen: false, canClose: false, inlineText: .linebreak, startCursor: TextCursor(text: ""))
}
