import Foundation

indirect enum List<T> {
    case element(data: T, next: List<T>)
    case unit
}

extension List {
    init() {
        self = .unit
    }
    
    func pop() -> List<T> {
        switch self {
        case let .element(data: _, next: next):
            return next
        case .unit:
            return self
        }
    }
    
    func push(_ data: T) -> List<T> {
        return .element(data: data, next: self)
    }
    
    func head() -> T? {
        switch self {
        case let .element(data: data, next: _):
            return data
        case .unit:
            return nil
        }
    }
}

extension List: Sequence {
    typealias Iterator = AnyIterator<T>
    
    func makeIterator() -> Iterator {
        var list = self
        return AnyIterator<T> {
            let head = list.head()
            list = list.pop()
            return head
        }
    }
}

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral: T...) {
        var list = List<T>()
        for element in arrayLiteral.reversed() {
            list = list.push(element)
        }
        self = list
    }
}

