import Foundation

struct TextResult<T> {
    let remaining: TextCursor
    let value: T
    
    func map<U>(_ transform: (T) -> U) -> TextResult<U> {
        TextResult<U>(remaining: remaining, value: transform(value))
    }
}
