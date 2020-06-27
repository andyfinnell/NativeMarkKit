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
    
    func processEmphasis() {
        var currentIndex = findCloser()
        var openerBottomBounds = [OpenerKey: Delimiter]()
                
        while let closer = delimiters.at(currentIndex) {
            guard closer.canClose else {
                currentIndex += 1
                continue
            }
            
            let opener = findOpener(for: closer, at: currentIndex, openerBottomBounds: openerBottomBounds)
            let closerIndex = currentIndex
            
            switch closer.character {
            case "*", "_":
                currentIndex = processStarAndUnderline(for: closer, at: currentIndex, opener: opener)
            case "''":
                currentIndex = processSingleQuote(for: closer, at: currentIndex, opener: opener)
            case "\"":
                currentIndex = processDoubleQuote(for: closer, at: currentIndex, opener: opener)
            default:
                currentIndex += 1
            }
            
            if opener == nil {
                openerBottomBounds[OpenerKey(closer)] = delimiters.at(closerIndex - 1)
                if !closer.canOpen {
                    demoteDelimiter(closer)
                }
            }
        }
        
        demoteAllDelimiters()
    }
}

private struct OpenerKey: Hashable {
    let length: Int
    let character: String
    
    init(_ delimiter: Delimiter) {
        self.length = delimiter.originalCount % 3
        self.character = delimiter.character
    }
}

private extension DelimiterStack {
    func demoteAllDelimiters() {
        while let delimiter = delimiters.last, delimiter !== delimiters.first {
            demoteDelimiter(delimiter)
        }
    }
    
    func findCloser() -> Int {
        var currentIndex = 0
        while let d = delimiters.at(currentIndex), !d.canClose {
            currentIndex += 1
        }
        return currentIndex
    }
    
    func findOpener(for closer: Delimiter, at closerIndex: Int, openerBottomBounds: [OpenerKey: Delimiter]) -> Delimiter? {
        var currentIndex = closerIndex - 1
        let closerKey = OpenerKey(closer)
        while let opener = delimiters.at(currentIndex), opener !== openerBottomBounds[closerKey] {
            let isOddMatch = (closer.canOpen || opener.canClose)
                && (closer.originalCount % 3 != 0)
                && (opener.originalCount + closer.originalCount) % 3 == 0
            
            if opener.character == closer.character && opener.canOpen && !isOddMatch {
                return opener
            }
            
            currentIndex -= 1
        }
        
        return nil
    }
    
    func processSingleQuote(for closer: Delimiter, at closerIndex: Int, opener: Delimiter?) -> Int {
        closer.character = "\u{2019}"
        opener?.character = "\u{2018}"
        return closerIndex + 1
    }
    
    func processDoubleQuote(for closer: Delimiter, at closerIndex: Int, opener: Delimiter?) -> Int {
        closer.character = "\u{201D}"
        opener?.character = "\u{201C}"
        return closerIndex + 1
    }

    func processStarAndUnderline(for closer: Delimiter, at closerIndex: Int, opener: Delimiter?) -> Int {
        guard let opener = opener else {
            return closerIndex + 1
        }
        
        let usedDelimitersCount = closer.count >= 2 && opener.count >= 2 ? 2 : 1
        closer.count -= usedDelimitersCount
        opener.count -= usedDelimitersCount
        let isEmphasis = usedDelimitersCount == 1
        
        let content = extract(opener, until: closer)
        opener.after = [isEmphasis ? InlineText.emphasis(content) : .strong(content)]
        
        if opener.count == 0 {
            removeDelimiter(opener)
        }
        
        guard let updatedCloserIndex = delimiters.firstIndex(where: { $0 === closer }) else {
            return 0
        }
        
        if closer.count == 0 {
            removeDelimiter(closer)
        }
        
        return updatedCloserIndex
    }
    
    func extract(_ start: Delimiter, until end: Delimiter) -> [InlineText] {
        guard let startIndex = delimiters.firstIndex(where: { $0 === start }),
            let endIndex = delimiters.firstIndex(where: { $0 === end }) else {
                return []
        }
        
        let remainderIndex = min(startIndex + 1, endIndex)
        let remainingDelimiters = (remainderIndex..<endIndex).compactMap { delimiters.at($0) }
        let inlineText = remainingDelimiters.reduce(start.after) { $0 + [$1.inlineText] + $1.after }

        start.after = []
        delimiters.removeSubrange(remainderIndex..<endIndex)
        
        return inlineText
    }
    
    func removeDelimiter(_ delimiter: Delimiter) {
        guard let index = delimiters.firstIndex(where: { $0 === delimiter }) else {
            return
        }
        delimiters.remove(at: index)
    }
}
