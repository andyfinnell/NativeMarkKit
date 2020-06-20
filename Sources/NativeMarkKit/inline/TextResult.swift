import Foundation

struct TextResult<T> {
    let remaining: TextCursor
    let value: T
    let valueLocation: TextCursor
    
    func map<U>(_ transform: (T) -> U) -> TextResult<U> {
        TextResult<U>(remaining: remaining, value: transform(value), valueLocation: valueLocation)
    }
}

extension TextCursor {
    func noMatch<T>(_ value: T) -> TextResult<T> {
        TextResult(remaining: self, value: value, valueLocation: self)
    }
}
