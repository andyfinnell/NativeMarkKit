import Foundation

final class Delimiter {
    var character: String
    let originalCount: Int
    private(set) var count: Int
    let canOpen: Bool
    let canClose: Bool
    var isActive: Bool
    private(set) var startCursor: TextCursor
    private(set) var endCursor: TextCursor
    var after: [InlineText]
            
    init(character: String, count: Int, canOpen: Bool, canClose: Bool, startCursor: TextCursor) {
        self.character = character
        self.count = count
        self.canOpen = canOpen
        self.canClose = canClose
        self.startCursor = startCursor
        self.endCursor = startCursor.advance(by: max(0, count - 1))
        originalCount = count
        isActive = true
        after = []
    }
    
    var inlineText: InlineText {
        .text(InlineString(text: String(repeating: character, count: count),
                           range: TextRange(start: startCursor,
                                            end: endCursor)))
    }

    func usedCloserCount(_ usedCount: Int) {
        // advance start
        startCursor = startCursor.advance(by: usedCount)
        count -= usedCount
    }
    
    func usedOpenerCount(_ usedCount: Int) {
        // retreat end
        endCursor = endCursor.retreat(by: usedCount)
        count -= usedCount
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
    static func starting() -> Delimiter {
        Delimiter(character: "", count: 0, canOpen: false, canClose: false, startCursor: TextCursor(lines: []))
    }
}
