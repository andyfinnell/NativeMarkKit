import Foundation

final class DelimiterStack {
    private var delimiters = [Delimiter.starting]
    
    init() {
        
    }
    
    func openBracket() -> Delimiter? {
        delimiters.last(where: { $0.character == "[" || $0.character == "![" })
    }
    
    func demoteDelimiter(_ delimiter: Delimiter) {
        guard let index = delimiters.firstIndex(where: { $0 === delimiter }),
            let previous = delimiters.at(index - 1) else {
                return
        }
        
        // Treat it like a normal inline. So move it to the previous delimiter
        previous.after = previous.after + [delimiter.inlineText] + delimiter.after
        delimiters.remove(at: index)
    }
    
    func deactivateLinkOpeners() {
        for delimiter in delimiters {
            if delimiter.isLinkOpener {
                delimiter.isActive = false
            }
        }
    }
    
    func popSubstack(starting delimiter: Delimiter) -> DelimiterStack {
        guard let index = delimiters.firstIndex(where: { $0 === delimiter }) else {
            return self
        }
        
        let substack = DelimiterStack()
        substack.delimiters = substack.delimiters + delimiters[index..<delimiters.endIndex]
        
        delimiters = Array(delimiters[delimiters.startIndex..<index])
        
        return substack
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
        delimiters.reduce([]) { $0 + [$1.inlineText] + $1.after }
    }
}
