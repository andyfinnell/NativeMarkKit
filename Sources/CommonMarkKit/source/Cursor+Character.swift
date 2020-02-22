import Foundation

extension Cursor where S.Element == Character {
    var isAtStartOfLine: Bool {
        return isStart || regress().isNewline
    }
    
    var isNewline: Bool {
        guard case .value(let ch) = element else {
            return false
        }
        return ch.value.isNewline
    }

    var notNewline: Bool {
        guard case .value(let ch) = element else {
            return true
        }
        return !ch.value.isNewline
    }

    var isWhitespace: Bool {
        guard case .value(let ch) = element else {
            return false
        }
        return ch.value.isWhitespace
    }

    var notWhitespace: Bool {
        guard case .value(let ch) = element else {
            return true
        }
        return !ch.value.isWhitespace
    }
       
    func not(in set: Set<Character>) -> Bool {
        guard case .value(let ch) = element else {
            return true
        }
        return !set.contains(ch.value)
    }
    
    func `in`(_ set: Set<Character>) -> Bool {
        guard case .value(let ch) = element else {
            return false
        }
        return set.contains(ch.value)
    }
    
    func scan(into output: inout String) -> Cursor {
        guard case .value(let ch) = element else {
            return self
        }
        output.append(ch.value)
        return advance()
    }
}
