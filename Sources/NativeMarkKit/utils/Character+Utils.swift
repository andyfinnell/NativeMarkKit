import Foundation

extension Character {
    var isSpaceOrTab: Bool {
        self == " " || self == "\t"
    }
    
    var isAsciiSpaceOrControl: Bool {
        isASCII && (isWhitespace || isControl)
    }
    
    var isControl: Bool {
        guard let value = asciiValue else {
            return false
        }
        return value < 32
    }
}
