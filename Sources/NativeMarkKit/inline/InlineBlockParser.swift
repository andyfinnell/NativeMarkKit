import Foundation

struct InlineBlockParser {
    struct Result {
        let taskListItemMark: TaskListItemMark?
        let text: [InlineText]
    }
    
    func parse(_ block: Block, using linkDefs: [LinkLabel: BlockLinkDefinition], canHaveTaskItem: Bool) -> Result {
        var trimmedLines = [Line]()
        var taskListItemMark: TaskListItemMark?
        for (i, line) in block.textLines.enumerated() {
            var newLine = line
            if i == 0 {
                newLine = newLine.trimStartWhitespace()
                if let result = parseTaskListItemMark(newLine, canHaveTaskItem: canHaveTaskItem) {
                    taskListItemMark = result.value
                    newLine = result.remainingLine
                    newLine = newLine.trimStartWhitespace()
                }
            }
            if i == (block.textLines.count - 1) {
                newLine = newLine.trimEndWhitespace()
            }
            trimmedLines.append(newLine)
        }
        
        let delimiterStack = DelimiterStack()
        var current = parseInline(TextCursor(lines: trimmedLines), into: delimiterStack, using: linkDefs)

        while current.value {
            current = parseInline(current.remaining, into: delimiterStack, using: linkDefs)
        }
        
        delimiterStack.processEmphasis()
        
        return Result(taskListItemMark: taskListItemMark, text: delimiterStack.inlineText)
    }
}

private extension InlineBlockParser {
    static let startTaskRegex = try! NSRegularExpression(pattern: "^\\[([\\sxX])\\]", options: [])

    func parseTaskListItemMark(_ line: Line, canHaveTaskItem: Bool) -> LineResult<TaskListItemMark>? {
        guard canHaveTaskItem else {
            return nil
        }
        
        guard let match = line.firstMatch(Self.startTaskRegex) else {
            return nil
        }
        let remainingLine = line.skip(match)
        
        // Has to be at least one whitespace character after
        guard remainingLine.text.first?.isWhitespace == true else {
            return nil
        }
        
        let outerText = line.matchedText(match, at: 0)
        let innerText = line.matchedText(match, at: 1)
        let textRange = TextRange(start: line.startPosition,
                                  end: remainingLine.startPosition.retreatColumn(by: 1))
            
        let taskItem = TaskListItemMark(text: String(outerText),
                                        contentText: String(innerText),
                                        range: textRange)
        
        return LineResult(remainingLine: remainingLine,
                          value: taskItem)
    }
    
    func parseInline(_ input: TextCursor, into delimiterStack: DelimiterStack, using linkDefs: [LinkLabel: BlockLinkDefinition]) -> TextResult<Bool> {
        guard let char = input.character else {
            return input.noMatch(false)
        }
        
        let wasParsed: TextResult<Bool>
        switch char {
        case "\n":
            let newlines = NewlineParser().parse(input, previous: delimiterStack.popLast())
            delimiterStack.push(newlines.value)
            wasParsed = newlines.map { !$0.isEmpty }
        case "\\":
            let backslash = BackslashPaser().parse(input)
            delimiterStack.push(backslash.value)
            wasParsed = backslash.map { $0 != nil }
        case "`":
            let backticks = BackticksParser().parse(input)
            delimiterStack.push(backticks.value)
            wasParsed = backticks.map { $0 != nil }
        case "*", "_", "'", "\"", "~":
            let delimiter = DelimiterParser(delimiter: String(char)).parse(input)
            delimiterStack.push(delimiter.value)
            wasParsed = delimiter.map { $0 != nil }
        case "[":
            let bracket = OpenBracketParser().parse(input)
            delimiterStack.push(bracket.value)
            wasParsed = bracket.map { $0 != nil }
        case "!":
            let bang = BangParser().parse(input)
            delimiterStack.push(bang.value)
            wasParsed = bang.map { $0 != nil }
        case "]":
            let closeBracket = CloseBracketParser().parse(input, with: delimiterStack, linkDefs: linkDefs)
            delimiterStack.push(closeBracket.value)
            wasParsed = closeBracket.map { $0 != nil }
        case "<":
            let autolink = AutolinkParser().parse(input)
            delimiterStack.push(autolink.value)
            wasParsed = autolink.map { $0 != nil }
        case "&":
            let entity = EntityParser().parse(input)
            delimiterStack.push(entity.value)
            wasParsed = entity.map { $0 != nil }
        default:
            let string = StringParser().parse(input)
            delimiterStack.push(string.value)
            wasParsed = string.map { $0 != nil }
        }
        
        if wasParsed.value {
            return wasParsed
        } else {
            let unhandled = input.parse(String(char))
                .map { InlineText.text(InlineString(text: $0, range: TextRange(start: input, end: input.advance()))) }
            delimiterStack.push(unhandled.value)
            return unhandled.map { _ in true }
        }
    }
}
