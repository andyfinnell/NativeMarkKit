import Foundation

final class DelimiterStack {
    private var delimiters = [Delimiter.starting]
    
    init() {
        
    }
    
    func push(_ inlineText: [InlineText]) {
        for text in inlineText {
            push(text)
        }
    }
    
    func push(_ thing: DelimiterOrInlineText?) {
        switch thing {
        case .none:
            return
        case let .delimiter(delimiter):
            push(delimiter)
        case let .inlineText(inlineText):
            push(inlineText)
        }
    }
    
    func push(_ inlineText: InlineText?) {
        guard let inlineText = inlineText else {
            return
        }
        delimiters.last?.push(inlineText)
    }
    
    func push(_ delimiter: Delimiter?) {
        guard let delimiter = delimiter else {
            return
        }
        if delimiter.canOpen || delimiter.canClose {
            delimiters = delimiters + [delimiter]
        } else {
            push(delimiter.inlineText)
        }
    }
    
    func popLast() -> InlineText? {
        delimiters.last?.popLast()
    }
    
    var inlineText: [InlineText] {
        delimiters.last?.after ?? []
    }
}
