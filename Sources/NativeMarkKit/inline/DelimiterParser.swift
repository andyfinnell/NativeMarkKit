import Foundation

struct DelimiterParser {
    private let delimiter: String
    
    init(delimiter: String) {
        self.delimiter = delimiter
    }
    
    func parse(_ input: TextCursor) -> TextResult<Delimiter?> {
        let countResult = count(input)
        let hasCorrectCount = (delimiter == "~" && countResult.value == 2) || (delimiter != "~" && countResult.value > 0)
        guard hasCorrectCount else {
            return input.noMatch(nil)
        }
        
        let (canOpen, canClose) = openingAndClosing(countResult)
        
        return countResult.map { count in
            Delimiter(character: delimiter,
                      count: count,
                      canOpen: canOpen,
                      canClose: canClose,
                      startCursor: input)
        }
    }
}

private extension DelimiterParser {
    func count(_ input: TextCursor) -> TextResult<Int> {
        var current = input.parse(delimiter)
        
        guard delimiter != "''" && delimiter != "\"" else {
            return current.map { $0.count }
        }
        
        var count = 0
        while current.value.isNotEmpty {
            count += 1
            current = current.remaining.parse(delimiter)
        }
        
        return TextResult(remaining: current.remaining,
                          value: count,
                          valueLocation: input,
                          valueTextRange: TextRange(start: input, end: current.remaining.retreat()))
    }
    
    func previousCharacter(_ count: TextResult<Int>) -> (isWhitespace: Bool, isPunctuation: Bool) {
        if count.valueLocation.isAtStart {
            return (isWhitespace: true, isPunctuation: false)
        } else {
            let previous = count.valueLocation.retreat()
            return (isWhitespace: previous.isWhitespace, isPunctuation: previous.isPunctuation)
        }
    }
    
    func nextCharacter(_ count: TextResult<Int>) -> (isWhitespace: Bool, isPunctuation: Bool) {
        if count.remaining.isAtEnd {
            return (isWhitespace: true, isPunctuation: false)
        } else {
            return (isWhitespace: count.remaining.isWhitespace, isPunctuation: count.remaining.isPunctuation)
        }
    }
    
    func openingAndClosing(_ count: TextResult<Int>) -> (canOpen: Bool, canClose: Bool) {
        let (isPreviousWhitespace, isPreviousPunctuation) = previousCharacter(count)
        let (isNextWhitespace, isNextPunctuation) = nextCharacter(count)
        
        let isLeftFlanking = !isNextWhitespace
            && (!isNextPunctuation || isPreviousWhitespace || isPreviousPunctuation)
        let isRightFlanking = !isPreviousWhitespace
            && (!isPreviousPunctuation || isNextWhitespace || isNextPunctuation)
        
        let canOpen: Bool
        let canClose: Bool
        switch delimiter {
        case "_":
            canOpen = isLeftFlanking && (!isRightFlanking || isPreviousPunctuation)
            canClose = isRightFlanking && (!isLeftFlanking || isNextPunctuation)
        case "''", "\"":
            canOpen = isLeftFlanking && !isRightFlanking
            canClose = isRightFlanking
        default:
            canOpen = isLeftFlanking
            canClose = isRightFlanking
        }
        
        return (canOpen: canOpen, canClose: canClose)
    }
}
