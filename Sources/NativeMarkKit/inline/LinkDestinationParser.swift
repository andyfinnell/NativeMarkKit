import Foundation

struct LinkDestinationParser {
    func parse(_ input: TextCursor) -> TextResult<URL?> {
        if input == "<" {
            return parseQuoted(input)
        } else {
            return parseUnquoted(input)
        }
    }
}

private extension LinkDestinationParser {
    func parseQuoted(_ input: TextCursor) -> TextResult<URL?> {
        let start = input.advance()
        var current = start
        while current.isNotEnd && current != ">" {
            if current.isNewline {
                return input.noMatch(nil)
            }
            
            if current == "\\" {
                current = current.advance()
            }

            current = current.advance()
        }
        
        guard current == ">" else {
            return input.noMatch(nil)
        }
        
        let urlString = start.substring(upto: current).unescaped()
        return TextResult(remaining: current.advance(),
                          value: URL(string: urlString),
                          valueLocation: input)
    }
    
    func parseUnquoted(_ input: TextCursor) -> TextResult<URL?> {
        let start = input
        var current = start
        var openCount = 0
        while current.isNotEnd && (!current.isAsciiSpaceOrControl || openCount > 0) {
            if current == "(" {
                openCount += 1
            } else if current == ")" {
                openCount -= 1
            } else if current == "\\" {
                current = current.advance()
            }
            
            current = current.advance()
        }
        
        let urlString = start.substring(upto: current).unescaped()
        return TextResult(remaining: current,
                          value: URL(string: urlString),
                          valueLocation: input)
    }
}
