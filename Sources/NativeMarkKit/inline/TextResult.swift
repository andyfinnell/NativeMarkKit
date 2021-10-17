import Foundation

struct TextResult<T> {
    let remaining: TextCursor
    let value: T
    let valueLocation: TextCursor
    let valueTextRange: TextRange?
    
    func map<U>(_ transform: (T) -> U) -> TextResult<U> {
        TextResult<U>(remaining: remaining,
                      value: transform(value),
                      valueLocation: valueLocation,
                      valueTextRange: valueTextRange)
    }
}

extension TextCursor {
    func noMatch<T>(_ value: T) -> TextResult<T> {
        TextResult(remaining: self,
                   value: value,
                   valueLocation: self,
                   valueTextRange: TextRange(start: self.position, end: self.position))
    }
}

extension TextResult where T == String {
    func toInlineString() -> InlineString {
        InlineString(text: value, range: valueTextRange)
    }
}
