import Foundation

final class Delimiter {
    var character: String
    let originalCount: Int
    var count: Int
    let canOpen: Bool
    let canClose: Bool
    var isActive: Bool
    let startCursor: TextCursor
    var after: [InlineText]
    
    init(character: String, count: Int, canOpen: Bool, canClose: Bool, startCursor: TextCursor) {
        self.character = character
        self.count = count
        self.canOpen = canOpen
        self.canClose = canClose
        self.startCursor = startCursor
        originalCount = count
        isActive = true
        after = []
    }
    
    var inlineText: InlineText {
        .text(String(repeating: character, count: count))
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
    static let starting = Delimiter(character: "", count: 0, canOpen: false, canClose: false, startCursor: TextCursor(text: ""))
}
